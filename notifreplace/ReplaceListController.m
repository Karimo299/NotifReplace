#import <Preferences/PSSpecifier.h>
#include "ReplaceListController.h"


@implementation ReplaceListController
int inputs;
NSUserDefaults *prefs;

- (NSArray *)specifiers {
	prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.karimo299.notifreplace"];
	inputs = [[prefs objectForKey:@"inputs"] intValue];
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"General" target:self] retain];
	}

	for (int i = 0; i < inputs; i++) {
		PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@"Replace"
		target:self
		set:@selector(setPreferenceValue:specifier:)
		get:@selector(readPreferenceValue:)
		detail:nil
		cell:PSEditTextCell
		edit:nil];
		[specifier setProperty:@"com.karimo299.notifreplace" forKey:@"defaults"];
		[specifier setProperty:@"" forKey:@"default"];
		[specifier setProperty:[NSString stringWithFormat:@"text%d", i] forKey:@"key"];
		[specifier setProperty:@"com.karimo299.notifreplace/prefChanged" forKey:@"PostNotification"];
		[_specifiers addObject:specifier];
	}
	return _specifiers;
}

-(void) add {
inputs ++;
[prefs setObject:[NSNumber numberWithInt:inputs] forKey:@"inputs"];
[self reloadSpecifiers];
[prefs synchronize];
}

-(void) remove {
	if (inputs > 0) inputs --;
[[[NSUserDefaults alloc] initWithSuiteName:@"com.karimo299.notifreplace"] removeObjectForKey:[NSString stringWithFormat:@"text%d", inputs]];
[prefs setObject:[NSNumber numberWithInt:inputs] forKey:@"inputs"];
[self reloadSpecifiers];
[prefs synchronize];
}

@end
