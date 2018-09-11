//
//  MRView.h
//  MyReactNative
//
//  Created by kjyu on 2018/8/14.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MRView : NSView
@property (nonatomic) NSColor* backgroundColor;
// js中生成传递过来用于调用
@property (nonatomic) NSNumber* reactTag;
@property (nonatomic) NSNumber* nativeID;

- (NSNumber*)reactTagAtPoint:(CGPoint)point;
@end
