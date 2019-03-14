include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NotifReplace
NotifReplace_FILES = NTRRootListController.m
NotifReplace_INSTALL_PATH = /Library/PreferenceBundles
NotifReplace_FRAMEWORKS = UIKit
NotifReplace_PRIVATE_FRAMEWORKS = Preferences
NotifReplace_EXTRA_FRAMEWORKS += CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotifReplace.plist$(ECHO_END)
