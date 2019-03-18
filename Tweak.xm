@class BBContent;
@interface BBContent : NSObject
@property (nonatomic,retain) NSString * message;
@end

@interface BBBulletin : NSObject
@property (nonatomic,retain) NSString * sectionID;
@end


static NSUserDefaults *prefs;
static bool bnrEnabled;
static bool msgEnabled;
static NSString *mystring;
static NSMutableArray* tmpArray;

static void loadPrefs() {
  prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.karimo299.notifreplace"];
  bnrEnabled = [prefs objectForKey:@"bnrEnabled"] ? [[prefs objectForKey:@"bnrEnabled"] boolValue] : YES;
  msgEnabled = [prefs objectForKey:@"msgEnabled"] ? [[prefs objectForKey:@"msgEnabled"] boolValue] : YES;
}

%hook BBBulletin
-(void)setContent:(BBContent *)arg1 {
  if (bnrEnabled && [[prefs valueForKey:[NSString stringWithFormat:@"selectApps-%@", self.sectionID]] boolValue]) {
    for (int i = 0; i < [[prefs objectForKey:@"inputs"] intValue]; i++) {
      mystring = [prefs objectForKey:[NSString stringWithFormat:@"text%d", i]];
      if ([[mystring componentsSeparatedByString:@", "] mutableCopy]) tmpArray= [[mystring componentsSeparatedByString:@", "] mutableCopy];
      if ([arg1.message containsString:[tmpArray[0] lowercaseString]])arg1.message = [arg1.message stringByReplacingOccurrencesOfString:[tmpArray[0] lowercaseString] withString:[tmpArray[1] lowercaseString]];
      else if ([arg1.message containsString:[tmpArray[0] uppercaseString]]) arg1.message = [arg1.message stringByReplacingOccurrencesOfString:[tmpArray[0] uppercaseString] withString:[tmpArray[1] uppercaseString]];
      else if ([arg1.message containsString:[tmpArray[0] capitalizedString]]) arg1.message = [arg1.message stringByReplacingOccurrencesOfString:[tmpArray[0] capitalizedString] withString:[tmpArray[1] capitalizedString]];
      else arg1.message = [arg1.message stringByReplacingOccurrencesOfString:tmpArray[0] withString:tmpArray[1] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1.message length])];
    }
  }
	%orig;
}
%end
%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(
	CFNotificationCenterGetDarwinNotifyCenter(), NULL,
	(CFNotificationCallback)loadPrefs,
	CFSTR("com.karimo299.notifreplace/prefChanged"), NULL,
	CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}
