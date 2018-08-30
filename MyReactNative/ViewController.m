//
//  ViewController.m
//  MyReactNative
//
//  Created by kjyu on 2018/8/2.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "ViewController.h"
#import "MRRootView.h"

@interface ViewController ()
@property (nonatomic) MRRootView* root;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* testJSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test1.js"];
    
    // 加载文件
    if (!_root) {
        _root = [[MRRootView alloc] init];
        [self.view addSubview:_root];
    }
    
    [_root loadFromFile:testJSPath];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)viewDidLayout
{
    [super viewDidLayout];
    [_root setFrame:NSMakeRect(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
}

@end
