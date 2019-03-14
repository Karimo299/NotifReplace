include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotifReplace
NotifReplace_FILES = Tweak.xm
NotifReplace_EXTRA_FRAMEWORKS += CepheiPrefs
NotifReplace_LIBRARIES = applist


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notifreplace
SUBPROJECTS += notifreplacemssg
include $(THEOS_MAKE_PATH)/aggregate.mk
