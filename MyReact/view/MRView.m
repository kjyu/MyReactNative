//
//  MRView.m
//  MyReactNative
//
//  Created by kjyu on 2018/8/14.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MRView.h"

@implementation MRView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    _backgroundColor = [NSColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [_backgroundColor setFill];
    NSRectFill(self.bounds);
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event
{
//    [super mouseDown:event];
    NSLog(@"mouse down...%@-%@", self.reactTag, self);
}

- (NSNumber *)reactTagAtPoint:(CGPoint)point
{
    NSView* view = [self hitTest:point];
    while (view && [view isKindOfClass:[MRView class]] && !((MRView*)view).reactTag) {
        view = view.superview;
    }
    
    if (view && [view isKindOfClass:[MRView class]]) {
        return [(MRView*)view reactTag];
    } else {
        return nil;
    }
}

@end
