//
//  NVDragView.m
//  NibViwer
//
//  Created by fengxing on 6/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NVDragView.h"

@interface NVDragView ()
@property BOOL isHighlight;
@end

@implementation NVDragView

@synthesize openerDelegate;
@synthesize isHighlight;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect rect = NSInsetRect([self frame], 5, 5);
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetLineWidth(context, 8);
    CGFloat lengths[] = {55., 25.};
    CGContextSetLineDash(context, 0., lengths, 2);
    CGFloat opaqueGray[] = {0.5, 0.5, 0.5, 1.0}; // red, green, blue, alpha
    CGContextSetStrokeColor(context, opaqueGray);
    CGContextStrokeRect(context, NSRectToCGRect(rect)); 
    
    NSString* text = isHighlight?@"Release and it will be opened by Xcode":@"Drag nib files here";
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSCenterTextAlignment];
    NSMutableDictionary* stringAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [stringAttributes setObject:[NSFont fontWithName:@"Helvetica" size:30] forKey:NSFontAttributeName];
    [stringAttributes setObject:style forKey:NSParagraphStyleAttributeName];
    [stringAttributes setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
    [text drawInRect:NSMakeRect(0, rect.origin.y/2+30, rect.size.width, rect.size.height/2) withAttributes:stringAttributes];
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    self.isHighlight = YES;
    [self setNeedsDisplay:YES];
    return  NSDragOperationGeneric;
}

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender
{
    return NSDragOperationGeneric;
}

- (void)draggingExited:(id < NSDraggingInfo >)sender
{
    self.isHighlight = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
    self.isHighlight = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        // Perform operation using the list of files
        for (id file in files) {
            [openerDelegate performSelector:@selector(openNibFile:) withObject:file];
        }
    }
    return YES;
}

@end
