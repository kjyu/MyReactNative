//
//  MRTouchHandler.m
//  MyReactNative
//
//  Created by kjyu on 2018/9/8.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MRTouchHandler.h"
#import "MRView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation MRTouchHandler

-(void)attachToView:(NSView *)view
{
    [view addGestureRecognizer:self];
}

-(void)detachFromView:(NSView *)view
{
    [view removeGestureRecognizer:self];
}

-(void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    NSLog(@"[handler] mouse down...");
}

-(void)mouseUp:(NSEvent *)event
{
    [super mouseUp:event];
    NSLog(@"[handler] mouse up...");
    if ([self.view isKindOfClass:[MRView class]]) {
        NSPoint touchLocation = [event locationInWindow];
        NSNumber* reactTag = [(MRView*)self.view reactTagAtPoint:touchLocation];
        if (reactTag == nil) {
            return;
        }
        
        if (_jsContext) {
            [[_jsContext globalObject] invokeMethod:@"_nativeCallJSEvent" withArguments:@[reactTag, @"onClick", @"{x:1, y:2}"]];
        }
    }
}

-(void)mouseDragged:(NSEvent *)event
{
    [super mouseDragged:event];
    NSLog(@"[handler] mouse dragged...");
}

-(BOOL)canPreventGestureRecognizer:(NSGestureRecognizer *)preventedGestureRecognizer
{
    return NO;
}

-(BOOL)canBePreventedByGestureRecognizer:(NSGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

@end
