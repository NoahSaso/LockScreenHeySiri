ARCHS = arm64 armv7

include theos/makefiles/common.mk

TWEAK_NAME = LockScreenHeySiri
LockScreenHeySiri_FILES = Tweak.xm
LockScreenHeySiri_FRAMEWORKS = UIKit
LockScreenHeySiri_PRIVATE_FRAMEWORKS = VoiceTrigger

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
