//
//  AppDelegate.m
//  ServicesBox
//
//  Created by ratazzi on 8/9/12.
//  Copyright (c) 2012 ratazzi. All rights reserved.
//
// http://stackoverflow.com/questions/815063/how-do-you-make-your-app-open-at-login
// http://stackoverflow.com/questions/608963/register-as-login-item-with-cocoa

#import "AppDelegate.h"
#import "PreferencesController.h"
#include <signal.h>

@implementation AppDelegate

@synthesize window;
@synthesize webView = _webView;
@synthesize statusMenu = _statusMenu;
@synthesize statusBar = _statusBar;
@synthesize backendTask = _backendTask;
@synthesize preferencesController = _preferencesController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    if (!self.preferencesController) {
        self.preferencesController = [[PreferencesController alloc] init];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Documents location: %@", documentsDirectory);
    [defaults setObject:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"ServicesBox"] forKey:@"dir_library"];
    NSLog(@"library location: %@", [defaults objectForKey:@"dir_library"]);
    
    // first time init
    if (![defaults objectForKey:@"already_init"]) {
        NSTask *initTask = [[NSTask alloc] init];
        NSArray *args = [NSArray arrayWithObjects: @"repair", nil];
        [initTask setLaunchPath: [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/ctl"]];
        [initTask setArguments: args];
        [initTask launch];
        [initTask waitUntilExit];
        NSLog(@"init done.");
        [defaults setBool:YES forKey:@"already_init"];
    }
    
    self.backendTask = [[NSTask alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/dashboard"];
    NSLog(@"cmd: %@", cmd);
    [self.backendTask setLaunchPath: cmd];
    
//    NSPipe *readPipe = [NSPipe pipe];
//    NSFileHandle *readHandle = [readPipe fileHandleForReading];
//    
//    NSPipe *writePipe = [NSPipe pipe];
//    NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
//    
//    NSPipe *errorPipe = [NSPipe pipe];
//    NSFileHandle *errorHandle = [errorPipe fileHandleForWriting];
//    
//    [self.backendTask setStandardInput: writeHandle];
//    [self.backendTask setStandardOutput: readHandle];
//    [self.backendTask setStandardError: errorHandle];
    
    [self.backendTask launch];
}

- (void)awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    //    NSString *statusBarIconPath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/statusBarIcon.png"];
    //    NSImage *statusBarIcon = [[NSImage alloc] initWithContentsOfFile: statusBarIconPath];
    //    [self.statusBar setImage: statusBarIcon];
    
    self.statusBar.title = @"Box";
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (IBAction)openDashboard:(id)sender {
    NSLog(@"%d", self.window.isVisible);

    if (!self.window.isVisible) {
        NSURL *url = [NSURL URLWithString: @"http://127.0.0.1:8000"];
        NSURLRequest *request = [NSURLRequest requestWithURL: url];
        NSLog(@"loading %@ ...", url);
        [[self.webView mainFrame] loadRequest: request];
    } else {
        [[self.webView mainFrame] reload];
        NSLog(@"reload");
    }
    
    self.window.isVisible = YES;
    [self.window display];
    
    [NSApp activateIgnoringOtherApps: YES];
}

- (IBAction)startAllServices:(id)sender {
    NSLog(@"start all services.");
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"start", @"method",
                            @"all", @"name", nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path: @"/api/service"
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"data: %@", JSON);
        // send notification
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", JSON);
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

- (IBAction)stopAllServices:(id)sender {
    NSLog(@"stop all services.");
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"stop", @"method",
                            @"all", @"name", nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path: @"/api/service"
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"data: %@", JSON);
        // send notification
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", JSON);
        NSLog(@"%@", error);
    }];
    
    [operation start];
}

- (IBAction)showPreferencesPanel:(id)sender {
    [self.preferencesController showWindow:self];
    self.preferencesController.window.isVisible = YES;
    [self.preferencesController.window display];
    [NSApp activateIgnoringOtherApps: YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.backendTask terminate];
//    if ([self.backendTask isRunning] == YES) {
//        NSLog(@"send kill -9");
//        kill(self.backendTask.processIdentifier, SIGKILL);
//    }
    [self.backendTask waitUntilExit];
    int status = [self.backendTask terminationStatus];
    NSLog(@"%d", status);
    NSLog(@"terminate backend task.");
}

@end
