//
//  MRRootView.m
//  MyReactNative
//
//  Created by kjyu on 2018/8/14.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MRRootView.h"
#import "MREngine.h"

@interface MRRootView ()
@property (nonatomic) MREngine* engine;
@end

@implementation MRRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(MREngine *)engine
{
    if (!_engine) {
        _engine = [[MREngine alloc] init];
    }
    
    [_engine setRootView:self];
    
    return _engine;
}

-(void)loadFromFile:(NSString *)path
{
    [[self engine] loadFromFile:path];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
