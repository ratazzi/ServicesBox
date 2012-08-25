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

- (id)init
{
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
    if (!self.launchController) {
        self.launchController = [[LaunchAtLoginController alloc] init];
    }
    BOOL launch = [self.launchController launchAtLogin];
    [self.launchController setLaunchAtLogin:[sender state]];
    NSLog(@"launch at login: %d", launch);
}
@end
