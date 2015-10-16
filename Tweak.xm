#import <notify.h>

static BOOL isEnabled = YES;

@interface VTPreferences : NSObject
+ (id)sharedPreferences;
- (void)setVoiceTriggerEnabled:(BOOL)arg1;
- (void)setVoiceTriggerEnabledWhenChargerDisconnected:(BOOL)arg1;
@end

%hook SBLockScreenView

- (void)startAnimating {
	%orig;
	// If disabled, disable tweak
	if(!isEnabled) return;
	NSLog(@"[LockScreenHeySiri] Starting...");
	// Enable listening when screen turns on
	[[%c(VTPreferences) sharedPreferences] setVoiceTriggerEnabledWhenChargerDisconnected:YES];
	[[%c(VTPreferences) sharedPreferences] setVoiceTriggerEnabled:YES];
}

- (void)stopAnimating {
	%orig;
	// If disabled, disable tweak
	if(!isEnabled) return;
	NSLog(@"[LockScreenHeySiri] Stopping...");
	// Disable listening when screen shuts off
	[[%c(VTPreferences) sharedPreferences] setVoiceTriggerEnabledWhenChargerDisconnected:NO];
}

%end

static void reloadPrefs() {
	Boolean exists = NO;
	// If enabled in settings, enable tweak
	Boolean enabledRef = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), CFSTR("com.noahsaso.lockscreenheysiri"), &exists);
	isEnabled = (exists ? enabledRef : YES);
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.noahsaso.lockscreenheysiri.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
