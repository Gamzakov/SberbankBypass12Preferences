//
//  SberbankBypass12PreferencesController.h
//  SberbankBypass12Preferences
//
//  Created by Алексей Осипов on 23.12.2019.
//  Copyright (c) 2019 ___GAMZAKOVDEV___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Preferences.framework/PSListController.h"

@interface SberbankBypass12PreferencesController : PSListController
{
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
- (void)followOnTwitter:(PSSpecifier*)specifier;
- (void)visitWebSite:(PSSpecifier*)specifier;
- (void)makeDonation:(PSSpecifier*)specifier;

@end
