//
//  SberbankBypass12PreferencesController.m
//  SberbankBypass12Preferences
//
//  Created by Алексей Осипов on 23.12.2019.
//  Copyright (c) 2019 ___GAMZAKOVDEV___. All rights reserved.
//

#import "SberbankBypass12PreferencesController.h"
#import "Preferences.framework/PSListController.h"

#define kSetting_SberbankBypassVersion_Name @"SberbankBypassVersion"
#define kSetting_SberbankBypassVersion_Value @"0.0.3"

#define kSetting_TestedSberbankVersion_Name @"TestedSberbankVersion"
#define kSetting_TestedSberbankVersion_Value @"10.7.0"

#define kSetting_MinOSVersion_Name @"MinOSVersion"
#define kSetting_MinOSVersion_Value @"12.0"

#define kUrl_FollowOnTwitter @"https://twitter.com/Just_Gamzakov"
#define kUrl_VisitWebSite @"https://github.com/Gamzakov/SberbankBypass12/issues/new"
#define kUrl_MakeDonation @"https://paypal.me/GamzakovDev"

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation SberbankBypass12PreferencesController

- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
    if ([specifierKey isEqual:kSetting_TestedSberbankVersion_Name])
    {
        value = kSetting_TestedSberbankVersion_Value;
    }
	// get 'value' with code only
	else if ([specifierKey isEqual:kSetting_SberbankBypassVersion_Name])
	{
		value = kSetting_SberbankBypassVersion_Value;
	}
    else if ([specifierKey isEqual:kSetting_MinOSVersion_Name])
    {
        value = kSetting_MinOSVersion_Value;
    }
	// ...or get 'value' from 'defaults' plist or (optionally as a default value) with code
	else
	{
		// get 'value' from 'defaults' plist (if 'defaults' key and file exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
			
			id objectValue = [dict objectForKey:specifierKey];
			
			if (objectValue)
			{
				value = [NSString stringWithFormat:@"%@", objectValue];
				NSLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
			}
			else
			{
				NSLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
			}
			
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif
		}
	}
	
	return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
{
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];

    // save 'value' to 'defaults' plist (if 'defaults' key exists)
    NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
    #if ! __has_feature(objc_arc)
    plistPath = [plistPath autorelease];
    #endif
    if (plistPath)
    {
        NSMutableDictionary *dict = (NSMutableDictionary*)[self initDictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];
        #if ! __has_feature(objc_arc)
        [dict release];
        #endif

        NSLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
    }
}

- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class class;
	if (asMutable)
		class = [NSMutableDictionary class];
	else
		class = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[class alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[class alloc] init];
	
	return dict;
}

- (void)followOnTwitter:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowOnTwitter]];
}

- (void)visitWebSite:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_VisitWebSite]];
}

- (void)makeDonation:(PSSpecifier *)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}

- (id)specifiers
{
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"SberbankBypass12Preferences" target:self];
		#if ! __has_feature(objc_arc)
		[_specifiers retain];
		#endif
	}
	
	return _specifiers;
}

- (id)init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif

@end
