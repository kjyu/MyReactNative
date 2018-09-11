//
//  MRDOMNode+React.h
//  MyReactNative
//
//  Created by kjyu on 2018/8/29.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRDOMCore.h"

@interface MRDOMNode (React)
// layout
@property (nonatomic, assign, readonly) YGNodeRef yogaNode;
@property (nonatomic, assign) YGValue top;
@end
