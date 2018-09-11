//
//  MRRootView.h
//  MyReactNative
//
//  Created by kjyu on 2018/8/14.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MRView.h"

@class MREngine;
@class MRTouchHandler;

@interface MRRootView : MRView
@property (nonatomic, readonly) MRTouchHandler* touchHandler;
- (void) loadFromFile:(NSString*) path;
@end
