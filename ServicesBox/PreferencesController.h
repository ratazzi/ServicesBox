//
//  PreferencesController.h
//  ServicesBox
//
//  Created by ratazzi on 8/25/12.
//  Copyright (c) 2012 ratazzi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LaunchAtLoginController;

@interface PreferencesController : NSWindowController

@property (strong, nonatomic) LaunchAtLoginController *launchController;

@property (strong) IBOutlet NSButton *startAtLogin;

- (IBAction)selectLibraryLocation:(id)sender;
- (IBAction)toggleStartAtLogin:(id)sender;
@end
