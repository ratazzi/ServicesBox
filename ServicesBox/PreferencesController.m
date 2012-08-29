//
//  PreferencesController.m
//  ServicesBox
//
//  Created by ratazzi on 8/25/12.
//  Copyright (c) 2012 ratazzi. All rights reserved.
//

#import "PreferencesController.h"
#import "LaunchAtLoginController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

@synthesize launchController = _launchController;
@synthesize startAtLogin = _startAtLogin;

- (id)init
{
    if (!self.launchController) {
        self.launchController = [[LaunchAtLoginController alloc] init];
    }
    
    if (![super initWithWindowNibName:@"PreferencesController"]) {
        return nil;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if ([self.launchController launchAtLogin] == YES) {
        [self.startAtLogin setState: NSOnState];
    } else {
        [self.startAtLogin setState: NSOffState];
    }
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)selectLibraryLocation:(id)sender {
    
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setAllowsMultipleSelection:NO];
    [openDialog setPrompt:@"Select"];
    
    [openDialog beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *urls = [openDialog URLs];
            NSLog(@"%@", [urls objectAtIndex: 0]);
        }
    }];
}

- (IBAction)toggleStartAtLogin:(id)sender {
    [self.launchController setLaunchAtLogin:[sender state]];
    BOOL launch = [self.launchController launchAtLogin];
    NSLog(@"launch at login: %d", launch);
}
@end
