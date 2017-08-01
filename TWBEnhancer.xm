#import <AppKit/AppKit.h>
#import <substrate.h>
#import "STTwitter/STTwitter.h"
#import "STTwitter/STTwitterOS.h"
#import "STTwitter/STTwitterOAuth.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "DJProgressHUD/DJProgressHUD.h"
#import "DJProgressHUD/AESCrypt.h"
#import "DJProgressHUD/NSString+UAObfuscatedString.h"
// @interface TWBEnhancerMac : NSObject
// + (void)load;
// @end

// @implementation TWBEnhancerMac

// + (void)load
// {
// 	NSLog(@"Loaded TWBEnhancerMac");
// }

// @end

NSBundle *bundle;
NSUserDefaults *userDefaults;

static STTwitterAPI *twbEnhaAPI;
static STTwitterOAuth *twbEnhaAuth;

static NSString *const kTWBEPreferencesSuiteName = @"com.imokhles.TWBEnhancerMac";
static NSString *const kTWBEPreferencesLastVersionKey = @"LastVersion";
// static NSString *const kTWBEPreferencesInvertedKey = @"Inverted";
// static NSString *const kTWBEPreferencesDurationKey = @"OverlayDuration";

@class PTHNavController, PTHNavItem;

@protocol PTHNavControllerDelegate <NSObject>

@optional
- (void)navController:(PTHNavController *)arg1 didShowViewController:(NSViewController *)arg2 animated:(BOOL)arg3;
- (void)navController:(PTHNavController *)arg1 willShowViewController:(NSViewController *)arg2 animated:(BOOL)arg3;
@end

@interface NSButton (PTHNSButtonCategory)
- (void)addTitleShadowColor:(id)arg1 shadowOffset:(struct CGSize)arg2;
@end

@interface PTHNavBarButton : NSButton
{
    BOOL _acceptsFirstMouse;
}

+ (id)nonBorderedButtonWithImage:(id)arg1 alternateImage:(id)arg2 target:(id)arg3 action:(SEL)arg4;
+ (id)buttonWithTitle:(id)arg1 style:(int)arg2 target:(id)arg3 action:(SEL)arg4;
+ (id)addButtonWithTarget:(id)arg1 action:(SEL)arg2;
+ (id)newButtonWithStyle:(int)arg1 target:(id)arg2 action:(SEL)arg3;
+ (id)backButton;
+ (id)spinnerView;
@property(nonatomic) BOOL acceptsFirstMouse; // @synthesize acceptsFirstMouse=_acceptsFirstMouse;
- (BOOL)acceptsFirstMouse:(id)arg1;
- (void)mouseUp:(id)arg1;
- (void)mouseDown:(id)arg1;

@end

@interface PTHNavBar : NSView
{
    NSMutableArray *_items;
    NSView *_titleView;
    NSView *_leftView;
    NSView *_rightView;
    struct CGRect _windowFrameAtMouseDown;
    BOOL _userDidDoubleClick;
    BOOL _useTitleOffsetAlways;
    double _titleOffset;
}

@property(nonatomic) BOOL useTitleOffsetAlways; // @synthesize useTitleOffsetAlways=_useTitleOffsetAlways;
@property(nonatomic) double titleOffset; // @synthesize titleOffset=_titleOffset;
@property(copy, nonatomic) NSArray *items; // @synthesize items=_items;
@property(retain, nonatomic) NSView *rightView; // @synthesize rightView=_rightView;
@property(retain, nonatomic) NSView *titleView; // @synthesize titleView=_titleView;
@property(retain, nonatomic) NSView *leftView; // @synthesize leftView=_leftView;
- (void)dealloc;
- (void)_windowDidBecomeKeyOrMain:(id)arg1;
- (void)_windowDidResignKeyOrMain:(id)arg1;
- (void)viewDidMoveToWindow;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)_adjustNavBarItemsNowActive:(BOOL)arg1;
- (void)setFrame:(struct CGRect)arg1;
@property(readonly, retain, nonatomic) PTHNavItem *backItem;
@property(readonly, retain, nonatomic) PTHNavItem *topItem;
- (id)popToNavigationItem:(id)arg1 animated:(BOOL)arg2;
- (id)popNavigationItemAnimated:(BOOL)arg1;
- (id)_createBackBarButtonForBackItem:(id)arg1;
- (void)pushNavigationItem:(id)arg1 animated:(BOOL)arg2;
- (void)_update;
- (id)_addItem:(id)arg1 removeOld:(BOOL)arg2;
- (void)updatePositions;
- (void)mouseUp:(id)arg1;
- (void)mouseDown:(id)arg1;
- (BOOL)isOpaque;
- (id)initWithFrame:(struct CGRect)arg1;

@end

@interface PTHNavItem : NSObject
{
    BOOL _hidesBackButton;
    BOOL _hideNavBar;
    NSString *_title;
    NSView *_titleView;
    NSTextField *_titleLabel;
    NSView *_leftBarView;
    NSView *_rightBarView;
    NSButton *_backBarButton;
    NSViewController *_controller;
    NSResponder *_firstResponder;
}

+ (id)newTitleLabel;
@property(retain, nonatomic) NSResponder *firstResponder; // @synthesize firstResponder=_firstResponder;
@property(nonatomic) NSViewController *controller; // @synthesize controller=_controller;
@property(nonatomic) BOOL hideNavBar; // @synthesize hideNavBar=_hideNavBar;
@property(nonatomic) BOOL hidesBackButton; // @synthesize hidesBackButton=_hidesBackButton;
@property(retain, nonatomic) NSView *rightBarView; // @synthesize rightBarView=_rightBarView;
@property(retain, nonatomic) NSView *leftBarView; // @synthesize leftBarView=_leftBarView;
@property(retain, nonatomic) NSView *titleView; // @synthesize titleView=_titleView;
@property(copy, nonatomic) NSString *title; // @synthesize title=_title;
- (void)dealloc;
- (void)setHideNavBar:(BOOL)arg1 animated:(BOOL)arg2;
- (void)setHidesBackButton:(BOOL)arg1 animated:(BOOL)arg2;
- (void)setBackBarButton:(id)arg1 animated:(BOOL)arg2;
@property(retain, nonatomic) NSButton *backBarButton; // @synthesize backBarButton=_backBarButton;
- (void)_back;
- (void)setRightBarView:(id)arg1 animated:(BOOL)arg2;
- (void)setLeftBarView:(id)arg1 animated:(BOOL)arg2;
@property(readonly, retain, nonatomic) NSTextField *titleLabel; // @synthesize titleLabel=_titleLabel;
- (id)navBar;
- (id)initWithController:(id)arg1;

@end

@interface PTHNavController : NSViewController
{
    NSMutableArray *_viewControllers;
    NSView *_navBarHolderView;
    NSView *_navContentView;
    BOOL _navBarHidden;
    BOOL _pushActive;
    BOOL _popActive;
    PTHNavBar *_navBar;
    id <PTHNavControllerDelegate> _delegate;
    CAMediaTimingFunction *_timingFunction;
}

+ (void)swoosh;
@property(nonatomic) BOOL popActive; // @synthesize popActive=_popActive;
@property(nonatomic) BOOL pushActive; // @synthesize pushActive=_pushActive;
@property(retain, nonatomic) CAMediaTimingFunction *timingFunction; // @synthesize timingFunction=_timingFunction;
@property(nonatomic) id <PTHNavControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(copy, nonatomic) NSArray *viewControllers; // @synthesize viewControllers=_viewControllers;
@property(nonatomic, getter=isNavBarHidden) BOOL navBarHidden; // @synthesize navBarHidden=_navBarHidden;
@property(readonly, nonatomic) PTHNavBar *navBar; // @synthesize navBar=_navBar;
- (void)dealloc;
- (void)viewDidDisappear:(BOOL)arg1;
- (void)viewWillDisappear:(BOOL)arg1;
- (void)viewDidAppear:(BOOL)arg1;
- (void)viewWillAppear:(BOOL)arg1;
- (void)back:(id)arg1;
@property(readonly, retain, nonatomic) NSViewController *rootViewController;
@property(readonly, retain, nonatomic) NSViewController *topViewController;
- (void)setNavBarHidden:(BOOL)arg1 animated:(BOOL)arg2;
- (id)_popToViewController:(id)arg1 animated:(BOOL)arg2 block:(id)arg3;
- (id)popToRootViewControllerAnimated:(BOOL)arg1 block:(id)arg2;
- (id)popToRootViewControllerAnimated:(BOOL)arg1;
- (id)popViewControllerAnimated:(BOOL)arg1 block:(id)arg2;
- (id)popViewControllerAnimated:(BOOL)arg1;
- (void)pushViewController:(id)arg1 animated:(BOOL)arg2 block:(id)arg3;
- (void)pushViewController:(id)arg1 animated:(BOOL)arg2;
- (void)_sendDidShowControllerToDelegateIfNeeded:(id)arg1 animated:(BOOL)arg2;
- (void)_sendWillShowControllerToDelegateIfNeeded:(id)arg1 animated:(BOOL)arg2;
- (void)_setNewController:(id)arg1 oldController:(id)arg2 transitionOptions:(int)arg3;
- (void)_prepareToSetNewController:(id)arg1 oldController:(id)arg2 transitionOptions:(int)arg3;
- (void)_viewDidChangeFrame:(id)arg1;
- (void)loadView;
- (BOOL)navBarIncludedWithinOurFrame;
- (id)initWithRootViewController:(id)arg1;
- (void)_navBarUserDidDoubleClick:(id)arg1;
- (id)init;
@property(readonly, nonatomic) BOOL pushOrPopActive;

@end

@interface PTHView : NSView
{
    NSColor *_backgroundColor;
    NSImage *_tiledBackgroundImage;
    NSColor *_inactiveBackgroundColor;
}

@property(retain, nonatomic) NSColor *inactiveBackgroundColor; // @synthesize inactiveBackgroundColor=_inactiveBackgroundColor;
@property(retain, nonatomic) NSImage *tiledBackgroundImage; // @synthesize tiledBackgroundImage=_tiledBackgroundImage;
@property(retain, nonatomic) NSColor *backgroundColor; // @synthesize backgroundColor=_backgroundColor;
- (void)dealloc;
- (void)drawRect:(struct CGRect)arg1;
- (void)viewDidMoveToWindow;
- (void)_windowDidResignKey:(id)arg1;
- (void)_windowDidBecomeKey:(id)arg1;
- (void)viewWillMoveToWindow:(id)arg1;
- (BOOL)isOpaque;

@end

@interface NSViewController (PTHNavControllerItem)
- (void)controllerWillBecomeTopController:(BOOL)arg1;
- (void)controllerWillBePoppedFromTop:(BOOL)arg1;
- (void)controllerWillBePushedFromTop:(BOOL)arg1;
- (void)controllerWillBePushedToTop:(BOOL)arg1;
- (void)back:(id)arg1;
@property(readonly, nonatomic) BOOL navAutoresizes;
@property(readonly, nonatomic) PTHNavController *rootNavController;
@property(nonatomic) PTHNavController *navController;
@property(readonly, retain, nonatomic) PTHNavItem *navItem;
@end

@interface NSViewController (PTHTweetbotControllerCategory)
- (void)resignFocusView;
- (void)makeFocusView;
@property(readonly, nonatomic) NSString *userDisplayableColumnName;
- (id)initWithSpawnState:(id)arg1;
- (id)spawnState;
- (BOOL)canBeSpawned;
- (void)presentWithNavigationController:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 contentSize:(struct CGSize)arg4 behavior:(long long)arg5 canBecomeKeyWindow:(BOOL)arg6 contentViewClipping:(BOOL)arg7 calculateMaximumContentSizeBasedOnScreenSize:(BOOL)arg8 completion:(id)arg9;
- (void)presentWithNavigationController:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 contentSize:(struct CGSize)arg4 behavior:(long long)arg5 canBecomeKeyWindow:(BOOL)arg6 contentViewClipping:(BOOL)arg7 completion:(id)arg8;
- (void)presentWithNavigationController:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 contentSize:(struct CGSize)arg4 behavior:(long long)arg5 canBecomeKeyWindow:(BOOL)arg6 completion:(id)arg7;
- (void)presentWithNavigationController:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 contentSize:(struct CGSize)arg4 completion:(id)arg5;
- (void)presentWithNavigationController:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showStockOptionsContextMenuForStock:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showHashtagOptionsContextMenuForHashTag:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (id)_hashtagOptionsActionItemsForHashTag:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showEntityOptionsContextMenuForEntity:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)_showURLOptionsContextMenuForURL:(id)arg1 status:(id)arg2 account:(id)arg3 location:(struct CGPoint)arg4 inView:(id)arg5 completion:(id)arg6;
- (id)_showURLActionItemsForURL:(id)arg1 status:(id)arg2 account:(id)arg3 view:(id)arg4 completion:(id)arg5;
- (void)showStatusLongActionOptionsContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showStatusShareAndActionOptionsContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showStatusShareOptionsContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showStatusActionOptionsForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (id)_statusShareOptionActionItemsForStatus:(id)arg1 completion:(id)arg2;
- (void)_addStatusOptionActionItemsForStatus:(id)arg1 contextMenuController:(id)arg2 completion:(id)arg3;
- (void)showFilterOptionsFromRect:(struct CGRect)arg1 inView:(id)arg2 preferredEdge:(unsigned long long)arg3 filter:(id)arg4 completion:(id)arg5;
- (void)showBlockOptionsFromRect:(struct CGRect)arg1 inView:(id)arg2 preferredEdge:(unsigned long long)arg3 user:(id)arg4 completion:(id)arg5;
- (void)handleTweetbotURLFromRect:(struct CGRect)arg1 inView:(id)arg2 preferredEdge:(unsigned long long)arg3 url:(id)arg4 forAccount:(id)arg5 completion:(id)arg6;
- (void)showListOptionsForList:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showFavoriteContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showRetweetFromContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)showRetweetOptionsFromRect:(struct CGRect)arg1 inView:(id)arg2 statusCell:(id)arg3 preferredEdge:(unsigned long long)arg4 status:(id)arg5 completion:(id)arg6;
- (void)showRetweetContextMenuForStatus:(id)arg1 location:(struct CGPoint)arg2 view:(id)arg3 statusCell:(id)arg4 completion:(id)arg5;
- (void)showProtectedError:(id)arg1;
- (void)showReplyOptionsFromRect:(struct CGRect)arg1 inView:(id)arg2 preferredEdge:(unsigned long long)arg3 user:(id)arg4 completion:(id)arg5;
- (void)showDirectMessageOptionsFromRect:(struct CGRect)arg1 inView:(id)arg2 directMessage:(id)arg3 completion:(id)arg4;
- (void)showUserOptionsContextMenuForUser:(id)arg1 location:(struct CGPoint)arg2 rect:(struct CGRect)arg3 inView:(id)arg4 completion:(id)arg5;
- (id)_userOptionActionItemsForUser:(id)arg1 rect:(struct CGRect)arg2 inView:(id)arg3 completion:(id)arg4;
- (void)_possiblyRemoveExistingMatchingStatusesForFilter:(id)arg1;
- (void)runMentionToUser:(id)arg1 originatingView:(id)arg2 completion:(id)arg3;
- (void)runReplyToFromRect:(struct CGRect)arg1 inView:(id)arg2 preferredEdge:(unsigned long long)arg3 status:(id)arg4 text:(id)arg5 cursorPosition:(long long)arg6 completion:(id)arg7;
- (void)pushListDetail:(id)arg1 completion:(id)arg2;
- (void)pushQuery:(id)arg1 forAccount:(id)arg2 completion:(id)arg3;
- (void)pushDirectMessageToUser:(id)arg1 completion:(id)arg2;
- (void)runPostWithAccount:(id)arg1 text:(id)arg2 cursorPosition:(long long)arg3 originatingView:(id)arg4 completion:(id)arg5;
- (void)runPostWithDraft:(id)arg1 cursorPosition:(long long)arg2 originatingView:(id)arg3 completion:(id)arg4;
- (void)pushEntityFromRect:(struct CGRect)arg1 inView:(id)arg2 entity:(id)arg3 completion:(id)arg4;
- (id)newControllerForTwitterURL:(id)arg1 withAccount:(id)arg2;
- (void)pushStatusDetail:(id)arg1 completion:(id)arg2;
- (void)pushUserProfile:(id)arg1 completion:(id)arg2;
@end

@interface PTHTweetbotUser : NSObject
@property(copy, nonatomic) NSString *screenName; // @synthesize screenName=_screenName;
@property(readonly, nonatomic) BOOL isCurrentUser;
@end

@interface PTHTweetbotDirectMessageThread : NSObject
{
    NSMutableArray *_messagesAndDrafts;
    PTHTweetbotUser *_toUser;
    unsigned long long _unreadItemCount;
    long long _lastReadTID;
}

@property(nonatomic) long long lastReadTID; // @synthesize lastReadTID=_lastReadTID;
@property(readonly, nonatomic) unsigned long long unreadItemCount; // @synthesize unreadItemCount=_unreadItemCount;
@property(copy, nonatomic) NSArray *messagesAndDrafts; // @synthesize messagesAndDrafts=_messagesAndDrafts;
@property(retain, nonatomic) PTHTweetbotUser *toUser; // @synthesize toUser=_toUser;
- (void)dealloc;
- (id)description;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (void)setAccount:(id)arg1;
- (BOOL)hasString:(id)arg1;
@property(readonly, nonatomic, getter=isRead) BOOL read;
- (void)markRead;
- (void)removeMessage:(id)arg1;
- (void)addMessage:(id)arg1;
- (BOOL)updateMessagesAndDrafts:(id)arg1;
- (void)resetUnreadItemCount;
- (unsigned long long)_unreadItemCount;
@end

@interface PTHTweetbotDirectMessagesController : NSViewController
@end

@interface PTHTweetbotStatus : NSObject
@property(readonly, retain, nonatomic) NSString *decodedText;
@property(nonatomic) long long originalTID; // @synthesize originalTID=_originalTID;
@property(retain, nonatomic) PTHTweetbotUser *user; // @synthesize user=_user;
@end

@interface PTHTweetbotStatusView : PTHView
@property(nonatomic) NSViewController *viewController; // @synthesize viewController=_viewController;
@property(retain, nonatomic) PTHTweetbotStatus *status; // @synthesize status=_status;
@end

@interface PTHTweetbotStatusDetailController : NSViewController
@property(retain, nonatomic) NSView *contentView; // @synthesize contentView=_contentView;
@property(retain, nonatomic) PTHTweetbotStatus *status; // @synthesize status=_status;
@end

@interface PTHTweetbotAccount : NSObject
+ (id)accountWithTID:(long long)arg1;
+ (id)accountWithUsername:(id)arg1;
@end

static PTHNavBarButton *naviBarButton;
static PTHNavBarButton *editButton;
void kTWBEShowFirstRunAlert() {
	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = @"Welcome to TWBEnhancer for Mac";
	alert.informativeText = @"Thanks for using TWBEnhancer for Mac, and Cydia's version will be available soon.";

	// if (!IS_OSX_OR_NEWER(10_10)) {
	// 	alert.showsSuppressionButton = YES;
	// 	alert.suppressionButton.title = @"I use a dark menu bar theme";
	// }

	[alert runModal];
        [userDefaults setObject:bundle.infoDictionary[@"CFBundleVersion"] forKey:kTWBEPreferencesLastVersionKey];
	// [userDefaults setObject:bundle.infoDictionary[@"CFBundleVersion"] forKey:kHBTSPreferencesLastVersionKey];
	// [userDefaults setBool:alert.suppressionButton.state == NSOnState forKey:kHBTSPreferencesInvertedKey];
}

void TWBECheckUpdate() {
    NSString *currentVersion = bundle.infoDictionary[@"CFBundleShortVersionString"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *linkString = @"".h.t.t.p.colon.forward_slash.forward_slash.i.d.e.v.t.t.w.e.a.k.s.dot.c.o.m.forward_slash.t.w.b.e.V.e.r.s.i.o.n.C.h.e.c.k.dot.p.h.p.quizMark.t.w.e.a.k.v.e.r.s.i.o.n.equals;
        NSString *myURLStr = [NSString stringWithFormat:@"%@%@", linkString, currentVersion];
        NSURL *myURL = [NSURL URLWithString:myURLStr];
        NSString *result = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:Nil];
        NSArray* wordsResult = [result componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* nospacestringResult = [wordsResult componentsJoinedByString:@""];

        if (![nospacestringResult isEqualToString:currentVersion]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"TWBEnhancer";
                alert.informativeText = [NSString stringWithFormat:@"New version %@ is available for TWBEnhancerMac. \nCurrent Version %@", nospacestringResult, currentVersion];
                [alert addButtonWithTitle:@"Download"];
                [alert addButtonWithTitle:@"Cancel"];

                if ([alert runModal] == NSAlertFirstButtonReturn) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://imokhles.com/twbe/mac/"]];
                }
            });
        }
    });
}
static void twbeAlertStatus(NSString *message, NSString *subMessage) {
	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = message;
	alert.informativeText = subMessage;
	[alert runModal];
}

%hook PTHAppDelegate
- (void)applicationDidFinishLaunching:(id)arg1 {
	twbEnhaAPI = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [twbEnhaAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:username message:@"API Works fine :)" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
        
    } errorBlock:^(NSError *error) {
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TWBEnhancer Checker" message:@"API Doesn't Works fine :(" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
    }];
	%orig;
}
%end

%hook PTHTweetbotStatusDetailController
- (void)viewWillAppear:(BOOL)arg1 {
	twbEnhaAPI = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [twbEnhaAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:username message:@"API Works fine :)" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
        
    } errorBlock:^(NSError *error) {
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TWBEnhancer Checker" message:@"API Doesn't Works fine :(" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
    }];
	%orig;
}
- (void)loadView {
	%orig;
	PTHTweetbotStatus *status = MSHookIvar<PTHTweetbotStatus *>(self, "_status");
	NSView *dateClientView = MSHookIvar<NSView *>(self, "_dateClientView");
	if (status.user.isCurrentUser) {
		Class naviButton = objc_getClass("PTHNavBarButton");
		editButton = [naviButton buttonWithTitle:@"Edit" style:3 target:self action:@selector(editButtonPress)];
		[editButton setFrame:NSMakeRect(10, 10, 50, 28)];
		// [editButton setState:NSOnState];
		[editButton setState:NSOffState];
		[editButton setEnabled:YES];
		[dateClientView addSubview:editButton];
	}
	// if ([scrollView contentOffset].y > 639) {
	// 	Class naviButton = objc_getClass("PTHNavBarButton");
	// 	editButton = [naviButton buttonWithTitle:@"Edit" style:3 target:self action:@selector(editButtonPress)];
	// 	[editButton setFrame:NSMakeRect(10, 70, 50, 28)];
	// 	// [editButton setState:NSOnState];
	// 	[editButton setState:NSOffState];
	// 	[editButton setEnabled:YES];
	// 	[self addSubview:editButton];
	// } else if ([scrollView contentOffset].y > 639) {
	// 	Class naviButton = objc_getClass("PTHNavBarButton");
	// 	editButton = [naviButton buttonWithTitle:@"Edit" style:3 target:self action:@selector(editButtonPress)];
	// 	[editButton setFrame:NSMakeRect(10, 70, 50, 28)];
	// 	// [editButton setState:NSOnState];
	// 	[editButton setState:NSOffState];
	// 	[editButton setEnabled:YES];
	// 	[self addSubview:editButton];
	// } else {
	// 	%orig;
	// }
}
// - (id)initWithFrame:(struct CGRect)arg1 {
// 	id selfORIG = %orig;
// 	if (selfORIG) {
// 		Class naviButton = objc_getClass("PTHNavBarButton");
// 		editButton = [naviButton buttonWithTitle:@"Edit" style:3 target:self action:@selector(editButtonPress)];
// 		[editButton setFrame:NSMakeRect(10, 30, 50, 28)];
// 		// [editButton setState:NSOnState];
// 		[editButton setState:NSOffState];
// 		[editButton setEnabled:YES];
// 		[self addSubview:editButton];
// 	}
// 	return selfORIG;
// }
%new
- (void)editButtonPress {
	PTHTweetbotStatus *statusGET = MSHookIvar<PTHTweetbotStatus *>(self, "_status");
	Class currentAccountClass = objc_getClass("PTHTweetbotAccount");
	PTHTweetbotAccount *currentAccount = [currentAccountClass accountWithUsername:statusGET.user.screenName];
	// Class postViewController = objc_getClass("PTHTweetbotPostViewController");
	// PTHTweetbotPostViewController *postVC = [[postViewController alloc] initWithDraft];
	NSString *statusID = [NSString stringWithFormat:@"%lld", statusGET.originalTID];
	[twbEnhaAPI postStatusesDestroy:statusID trimUser:nil successBlock:^(NSDictionary *status){
		[self runPostWithAccount:currentAccount text:statusGET.decodedText cursorPosition:nil originatingView:editButton completion:nil];
	} errorBlock:^(NSError *error){
		twbeAlertStatus(@"TWBEnhancer", @"Error");
    }];
	
	[editButton setState:NSOffState];
	[editButton setEnabled:YES];
	// twbeAlertStatus(@"TWBEnhancer", @"Test Edit Button");
}

%end

%hook PTHTweetbotDirectMessagesController
- (void)viewWillAppear:(BOOL)arg1 {
	twbEnhaAPI = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [twbEnhaAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:username message:@"API Works fine :)" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
        
    } errorBlock:^(NSError *error) {
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TWBEnhancer Checker" message:@"API Doesn't Works fine :(" delegate:nil cancelButtonTitle:@"OK :)" otherButtonTitles:nil, nil];
        // [alertView show];
    }];
	%orig;
	NSButton *shareButton = MSHookIvar<NSButton *>(self, "_shareButton");

	Class naviButton = objc_getClass("PTHNavBarButton");
	naviBarButton = [naviButton buttonWithTitle:@"TWBE" style:3 target:self action:@selector(buttonPressed)];
	[naviBarButton setFrame:NSMakeRect(0, 0, 50, 28)];
	// [naviBarButton setState:NSOnState];
	[naviBarButton setState:NSOffState];
	[naviBarButton setEnabled:YES];
	[self.navItem setRightBarView:naviBarButton animated:YES];


	// int x = shareButton.frame.origin.x; //possition x
 //    int y = shareButton.frame.origin.y; //possition y

 //    int width = shareButton.frame.size.width;
 //    int height = shareButton.frame.size.height; 
	// NSButton *myButton = [[[NSButton alloc] initWithFrame:shareButton.frame]NSMakeRect(x, y, width, height)] autorelease];
 //    [self.view addSubview: myButton];
 //    [myButton setTitle: @"TWBE!"];
 //    [myButton setButtonType:NSMomentaryLightButton]; //Set what type button You want
 //    [myButton setBezelStyle:NSRoundedBezelStyle]; //Set what style You want

 //    [myButton setTarget:self];
 //    [myButton setAction:@selector(buttonPressed)];
    [shareButton removeFromSuperview];
    [shareButton setHidden:YES];
}
- (void)loadView {
	%orig;
	// NSButton *shareButton = MSHookIvar<NSButton *>(self, "_shareButton");
	// NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	// alert.messageText = @"Welcome to TWBEnhancer for Mac";
	// alert.informativeText = [NSString stringWithFormat:@"Getting %@", NSStringFromRect(shareButton.frame)];

	// // NSLog(@"x = %f\n", myRect.origin.x);
	// // NSLog(@"y = %f\n", myRect.origin.y);
	// // NSLog(@"width = %f\n", myRect.size.width);
	// // NSLog(@"height = %f\n", myRect.size.height);

	// // if (!IS_OSX_OR_NEWER(10_10)) {
	// // 	alert.showsSuppressionButton = YES;
	// // 	alert.suppressionButton.title = @"I use a dark menu bar theme";
	// // }

	// [alert runModal];
}
%new
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {

	 if(returnCode == NSAlertFirstButtonReturn)
	 {
	 NSLog(@"if (returnCode == NSAlertFirstButtonReturn)");
	 [self performSelector:@selector(sendImageDM) withObject:nil afterDelay:0.0];
	 }
	 else if (returnCode == NSAlertSecondButtonReturn)
	 {
	 NSLog(@"else if (returnCode == NSAlertSecondButtonReturn)");
	 [self performSelector:@selector(_emailConversation:) withObject:nil afterDelay:0.0];
	 }
	 else if (returnCode == NSAlertThirdButtonReturn)
	 {
	 NSLog(@"Cancelled");
	 }
	 else
	 {
	 NSLog(@"All Other return code %d",returnCode);
	 }
}
- (void)_share:(id)arg1 {
	%orig;
}
%new
-(void)buttonPressed {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"Send Image"];
	[alert addButtonWithTitle:@"Share Conversation"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"TWBEnhancer"];
	[alert setInformativeText:@"Send images through DM or share your conversation, @iMokhles."];
	// [alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];

	/**********************************************/
	[naviBarButton setState:NSOffState];
	[naviBarButton setEnabled:YES];
}
%new
- (void)sendImageDM {
	NSArray *allowedImageFileExtensions = [NSArray arrayWithObjects:@"png",@"jpg",@"jpeg",nil];
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setAllowedFileTypes:allowedImageFileExtensions];
	[panel setDirectory:NSHomeDirectory()];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
	[panel setResolvesAliases:YES];
	
	[panel beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			// We aren't allowing multiple selection, but NSOpenPanel still returns
			// an array with a single element.
			[DJProgressHUD showStatus:@"Sending Image" FromView:self.view];
			NSURL *imagePath = [[panel URLs] objectAtIndex:0];
			NSImage *image = [[NSImage alloc] initWithContentsOfURL:imagePath];
			NSLog(@"Image: %@", image);
			// twbeAlertStatus(@"TWBEnhancer", [NSString stringWithFormat:@"%@", imagePath]);
			NSData *imageDataOutPut =  [NSData dataWithContentsOfURL:imagePath];//UIImageJPEGRepresentation(image, 0.85f);
			[twbEnhaAPI postMediaUploadData:imageDataOutPut fileName:@"TWB-ImageName.png" uploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
	            //
	        } successBlock:^(NSDictionary *imageDictionary, NSString *mediaID, NSString *size, NSArray *allKeys) {
	            //
	            PTHTweetbotDirectMessageThread *directMessageThread = MSHookIvar<PTHTweetbotDirectMessageThread *>(self, "_directMessageThread");
				PTHTweetbotUser *toUser = MSHookIvar<PTHTweetbotUser *>(directMessageThread, "_toUser");
	            [twbEnhaAPI _postDirectMessage:@"TWBEnhancer-Mac" forScreenName:toUser.screenName orUserID:nil mediaID:mediaID successBlock:^(NSDictionary *message) {
	                //
	                // [DJProgressHUD showStatus:@"Sent ;)" FromView:self.view];
	                [DJProgressHUD dismiss];
	            } errorBlock:^(NSError *error) {
	                //
	                // NSLog(@"******AAA== %@", [error localizedDescription]);

	            }];
	            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.tapbots.Tweetbot3://"]];
	            // imgInProgress = NO;
	            // system("killall -9 TWBDmApp");
	        } errorBlock:^(NSError *error) {
	            //
	            NSLog(@"******AAA== %@", [error localizedDescription]);
	        }];
		} else {
			[panel close];
		}
 
	}];
}
%end

%ctor {
	%init;
	bundle = [NSBundle bundleWithIdentifier:@"com.imokhles.twbenhancermac"];
	userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kTWBEPreferencesSuiteName];

    if (![userDefaults objectForKey:kTWBEPreferencesLastVersionKey]) {
        kTWBEShowFirstRunAlert();
    }
    //TWBECheckUpdate();
}

/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
