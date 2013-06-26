//
//  AppDelegate.h
//  NibViwer
//
//  Created by fengxing on 6/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NVDragView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NVDragView *dragView;

@end
