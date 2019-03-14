static NSMutableDictionary *prefs;
static bool bnrEnabled;
static bool msgEnabled;
static NSMutableArray* tmpArray;
NSMutableAttributedString *mutableAttributedString;

static void loadPrefs() {
  prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.karimo299.notifreplace.plist"];
  bnrEnabled = [prefs objectForKey:@"bnrEnabled"] ? [[prefs objectForKey:@"bnrEnabled"] boolValue] : YES;
  msgEnabled = [prefs objectForKey:@"msgEnabled"] ? [[prefs objectForKey:@"msgEnabled"] boolValue] : YES;
}

%hook CKBalloonTextView
-(void)setAttributedText:(NSAttributedString *)arg1 {
  loadPrefs();
  mutableAttributedString = [arg1 mutableCopy];
  NSLog(@"%d", msgEnabled);
  if (msgEnabled) {
    for (int i = 0; i < [[prefs valueForKey:@"inputs"] intValue] + 1; i++) {
      if ([[[prefs valueForKey:[NSString stringWithFormat:@"text%d", i]] componentsSeparatedByString:@", "] mutableCopy]) tmpArray= [[[prefs valueForKey:[NSString stringWithFormat:@"text%d", i]] componentsSeparatedByString:@", "] mutableCopy];
      if ([mutableAttributedString.mutableString containsString:[tmpArray[0] lowercaseString]]) [mutableAttributedString.mutableString setString:[mutableAttributedString.mutableString stringByReplacingOccurrencesOfString:[tmpArray[0] lowercaseString] withString:[tmpArray[1] lowercaseString]]];
      else if ([mutableAttributedString.mutableString containsString:[tmpArray[0] uppercaseString]]) [mutableAttributedString.mutableString setString:[mutableAttributedString.mutableString stringByReplacingOccurrencesOfString:[tmpArray[0] uppercaseString] withString:[tmpArray[1] uppercaseString]]];
      else if ([mutableAttributedString.mutableString containsString:[tmpArray[0] capitalizedString]]) [mutableAttributedString.mutableString setString:[mutableAttributedString.mutableString stringByReplacingOccurrencesOfString:[tmpArray[0] capitalizedString] withString:[tmpArray[1] capitalizedString]]];
      else {
        NSRange range = [mutableAttributedString.mutableString rangeOfString:tmpArray[0] options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) [mutableAttributedString replaceCharactersInRange:range withString:tmpArray[1]];
      }
    }
    arg1 = mutableAttributedString;
  }
  NSLog(@"%@", tmpArray);
  %orig;
}
%end
