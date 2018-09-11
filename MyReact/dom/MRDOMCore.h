//
//  MRDOMCore.h
//  MyReactNative
//
//  Created by kjyu on 2018/8/25.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Yoga.h"

@class MRDOMText;
@class MRDOMAttr;
@class MRView;
@class MRRootView;

#ifndef NIMP
#define NIMP NSLog(@"not implemented: [%@ %@] - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self), (id) nil
#endif

@interface MRDOMObject : NSObject
@end

@interface MRDOMNode : MRDOMObject
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, copy) NSString* nodeValue;
@property (nonatomic, copy) NSString* namespaceURI;
@property (nonatomic) NSMutableArray* childNodes;
@property (nonatomic) MRDOMNode* parentNode;
@property (nonatomic) unsigned short nodeType;
@property (nonatomic, copy) NSString *textContent;
@property (nonatomic) NSNumber* reactTag;

- (id) _initWithName:(NSString *) name namespaceURI:(NSString *) uri;
- (MRDOMNode *) appendChild:(MRDOMNode *) node;
- (MRDOMNode *) insertBefore:(MRDOMNode *) node :(MRDOMNode *) ref;
- (MRDOMNode *) removeChild:(MRDOMNode *) node;
- (MRDOMNode *) replaceChild:(MRDOMNode *) node :(MRDOMNode *) old;

// 节点对应的View
@property (nonatomic) MRView* view;
@end

@interface MRDOMElement : MRDOMNode
@property (nonatomic) NSMutableDictionary* attributes;
@property (nonatomic) NSDictionary *style;
- (void) setAttribute:(NSString *) name :(NSString *) value;
- (MRDOMAttr *) setAttributeNode:(MRDOMAttr *) attr;
@end

@interface MRDOMDocument : MRDOMNode
@property (nonatomic) MRDOMElement* documentElement;
@property (nonatomic, weak) MRRootView* rootView;
- (MRDOMElement *) createElement:(NSString *) tag;
- (MRDOMText *) createTextNode:(NSString *) data;
- (MRDOMElement *) getElementById:(NSString *) element;
@end

@interface MRDOMAttr : MRDOMNode
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* value;
@property (nonatomic) MRDOMElement* ownerElement;

- (id) _initWithName:(NSString *) str value:(NSString *) value;
@end

@interface MRDOMText : MRDOMNode
@property (nonatomic, copy) NSString* data;
@end
