//
//  MREngine.m
//  MyReactNative
//
//  Created by kjyu on 2018/8/2.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MREngine.h"
#import "MRDOMCore.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface MREngine ()
@property (nonatomic) MRDOMDocument* document;
@end

@implementation MREngine

- (void) loadFromFile:(NSString*) path
{
    NSError* error;
    NSString* jsString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    if ([jsString length] > 0) {
        [_jsContext evaluateScript:jsString withSourceURL:[NSURL URLWithString:path]];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        JSContext* jc = self.jsContext;
        jc[@"document"] = self.document;
        [jc setExceptionHandler:^(JSContext *context, JSValue *exception) {
            NSLog(@"js error: %@", exception);
        }];
    }
    return self;
}

-(void)setRootView:(MRRootView *)rootView
{
    if (_rootView != rootView) {
        _rootView = rootView;
    }
    
    [self.document setRootView:rootView];
}

-(JSContext *)jsContext
{
    if (!_jsContext) {
        _jsContext = [[JSContext alloc] init];
    }
    
    return _jsContext;
}

- (MRDOMDocument *)document
{
    if (!_document) {
        _document = [[MRDOMDocument alloc] _initWithName:@"root_document" namespaceURI:nil];
    }
    
    return _document;
}
@end
