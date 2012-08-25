//
//  AppDelegate.h
//  ServicesBox
//
//  Created by ratazzi on 8/9/12.
//  Copyright (c) 2012 ratazzi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class PreferencesController;
#import "AFNetworking/AFHTTPClient.h"
#import "AFNetworking/AFJSONRequestOperation.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet WebView *webView;
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) NSTask *backendTask;
@property (strong, nonatomic) PreferencesController *preferencesController;

- (IBAction)openDashboard:(id)sender;
- (IBAction)startAllServices:(id)sender;
- (IBAction)stopAllServices:(id)sender;
- (IBAction)showPreferencesPanel:(id)sender;

@end
