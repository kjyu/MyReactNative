//
//  MREngine.h
//  MyReactNative
//
//  Created by kjyu on 2018/8/2.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MRDOMDocument;
@class MRRootView;
@class JSContext;

@interface MREngine : NSObject
@property (nonatomic) JSContext* jsContext;
@property (nonatomic, weak) MRRootView* rootView;
- (void) loadFromFile:(NSString*) path;
@end
