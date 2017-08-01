GO_EASY_ON_ME = 1
TARGET = macosx:clang:10.8:latest
ARCHS = x86_64
ADDITIONAL_CFLAGS = -fobjc-arc
export MODULES = congruence nahm8

include theos/makefiles/common.mk

SIMBLTWEAK_NAME = TWBEnhancerMac
TWBEnhancerMac_FILES = TWBEnhancer.xm $(wildcard STTwitter/*.m) $(wildcard DJProgressHUD/*.m)
TWBEnhancerMac_FRAMEWORKS = Cocoa AppKit CoreGraphics Accounts Social Security QuartzCore
TWBEnhancerMac_LOGOSFLAGS = -c generator=internal
#TWBEnhancerMac_LIBRARIES = substrate
include $(THEOS_MAKE_PATH)/simbltweak.mk

release: stage
	rm -rf release || true
	mkdir release
	sudo rsync -rav obj/macosx/TWBEnhancerMac.bundle /Users/imokhles/Library/Application\ Support/SIMBL/Plugins/
	killall Tweetbot
	open -a Tweetbot
#	dropdmg obj/macosx/TWBEnhancerMac.bundle