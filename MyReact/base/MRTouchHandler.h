//
//  MRTouchHandler.h
//  MyReactNative
//
//  Created by kjyu on 2018/9/8.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JSContext;

@interface MRTouchHandler : NSGestureRecognizer
@property (nonatomic, weak) JSContext* jsContext;
- (void)attachToView:(NSView *)view;
- (void)detachFromView:(NSView *)view;
@end
