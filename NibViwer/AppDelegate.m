//
//  AppDelegate.m
//  NibViwer
//
//  Created by fengxing on 6/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "NVDragView.h"

@interface AppDelegate ()
@property (retain) NSString* openerNib;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize dragView = _dragView;
@synthesize openerNib = _openerNib;

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString* openerZip = [[NSBundle mainBundle] pathForResource:@"Compiled Nib Opener.nib" ofType:@"zip"];
        NSTask* zipTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/unzip" arguments:[NSArray arrayWithObjects:@"-u", openerZip, @"-d", NSTemporaryDirectory(), nil]];
        [zipTask waitUntilExit];
        self.openerNib = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"Compiled Nib Opener.nib"];        
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [_dragView registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    [_dragView setOpenerDelegate:self];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    [self openNibFile:filename];
    return YES;
}

// param nib: the file path
- (void)openNibFile:(NSString*)nib {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    
    // Step1: 拷贝Compiled Nib Opener到临时目录
    NSString* distNib = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), [nib lastPathComponent]];
    [fileManager removeItemAtPath:distNib error:nil];
    if (![fileManager copyItemAtPath:self.openerNib toPath:distNib error:&error]) {
        goto error;
    }
    
    // Step2: 覆盖keyedobjects.nib文件
    NSString* keys = [NSString stringWithFormat:@"%@/%@", distNib, @"keyedobjects.nib"];
    [fileManager removeItemAtPath:keys error:nil];
    if (![fileManager copyItemAtPath:nib toPath:keys error:&error]) {
        goto error;
    }

    // Step3: Xcode打开
    if (![[NSWorkspace sharedWorkspace] openFile:distNib withApplication:@"Xcode"] &&
        ![[NSWorkspace sharedWorkspace] openFile:distNib withApplication:@"Interface Builder"])
    {
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOEXEC userInfo:nil];
    }
error:
    if (error) {
        [[NSAlert alertWithError:error] runModal];
    }
    return;
}

@end
