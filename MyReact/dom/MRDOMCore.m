//
//  MRDOMCore.m
//  MyReactNative
//
//  Created by kjyu on 2018/8/25.
//  Copyright © 2018年 kjyu. All rights reserved.
//

#import "MRDOMCore.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MRView.h"
#import "MRRootView.h"
#import "MRDOMNode+React.h"

//自定义协议继承自 <JSExport>
@protocol MRDOMNodeExport <JSExport>
@property (nonatomic, copy) NSString* nodeName;
@property (nonatomic, copy) NSString* nodeValue;
@property (nonatomic, copy) NSString* namespaceURI;
@property (nonatomic) NSMutableArray* childNodes;
@property (nonatomic) MRDOMNode* parentNode;
@property (nonatomic) unsigned short nodeType;
@property (nonatomic, copy) NSString *textContent;
@property (nonatomic) NSNumber* reactTag;

- (MRDOMNode *) appendChild:(MRDOMNode *) node;
JSExportAs(insertBefore, - (MRDOMNode *) insertBefore:(MRDOMNode *) node :(MRDOMNode *) ref);
- (MRDOMNode *) removeChild:(MRDOMNode *) node;
JSExportAs(replaceChild, - (MRDOMNode *) replaceChild:(MRDOMNode *) node :(MRDOMNode *) old);
@end

@interface MRDOMNode () <MRDOMNodeExport>
@end

@protocol MRDOMElementExport <JSExport>
@property (nonatomic) NSMutableDictionary* attributes;
@property (nonatomic) NSDictionary *style;
JSExportAs(setAttribute,- (void) setAttribute:(NSString *) name :(NSString *) value);
- (MRDOMAttr *) setAttributeNode:(MRDOMAttr *) attr;
@end

@interface MRDOMElement () <MRDOMNodeExport, MRDOMElementExport>
@end

@protocol MRDOMDocumentExport <JSExport>
@property (nonatomic) MRDOMElement* documentElement;

- (MRDOMElement *) createElement:(NSString *) tag;
- (MRDOMText *) createTextNode:(NSString *) data;
- (MRDOMElement *) getElementById:(NSString *) element;
@end

@interface MRDOMDocument () <MRDOMDocumentExport, MRDOMNodeExport>
@end

@protocol MRDOMTextExport <JSExport>
@property (nonatomic, copy) NSString* data;
@end

@interface MRDOMText () <MRDOMTextExport, MRDOMNodeExport>
@end

@implementation MRDOMObject
@end

@implementation MRDOMNode

-(id)_initWithName:(NSString *)name namespaceURI:(NSString *)uri
{
    if((self=[self init]))
    {
        _nodeName=[name copy];
        _namespaceURI=[uri copy];
        _parentNode=nil;    // until we get added somewhere
    }
    return self;
}

-(MRDOMNode *)appendChild:(MRDOMNode *)node
{
    if(!_childNodes)
        _childNodes=[[NSMutableArray alloc] init];    // create list
    [_childNodes addObject:node];
    [node setParentNode:self];
//    [[self _visualRepresentation] setNeedsLayout:YES];    // we have been updated
    // 操作View
    [self.view addSubview:node.view];
    return node;
}

-(MRDOMNode *)insertBefore:(MRDOMNode *)node :(MRDOMNode *)ref
{
    NSMutableArray *l;
    if(!_childNodes)
        _childNodes=[[NSMutableArray alloc] init];    // create list
    l=_childNodes;
    [l insertObject:node atIndex:[l indexOfObject:ref]];
    [node setParentNode:self];
//    [[self _visualRepresentation] setNeedsLayout:YES];    // we have been updated
    return node;
}

- (MRDOMNode *) removeChild:(MRDOMNode *) node;
{ // CHECKME: what is the semantics of the return value?
//    [node _orphanize];
    if(_childNodes)
    {
        [_childNodes removeObject:node];
//        [[self _visualRepresentation] setNeedsLayout:YES];    // we have been updated
    }
    return node;
}

- (MRDOMNode *) replaceChild:(MRDOMNode *) node :(MRDOMNode *) old;
{ // CHECKME: what is the semantics of the return value?
    NSMutableArray *l;
    if(!_childNodes)
        _childNodes=[[NSMutableArray alloc] init];    // create list
//    [old _orphanize];
    l=_childNodes;
    [l replaceObjectAtIndex:[l indexOfObject:old] withObject:node];
    [node setParentNode:self];
//    [[self _visualRepresentation] setNeedsLayout:YES];    // we have been updated
    return node;
}

-(NSMutableArray *)childNodes
{
    if (!_childNodes) {
        _childNodes = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _childNodes;
}

-(MRView *)view
{
    if (!_view) {
        _view = [[MRView alloc] initWithFrame:NSMakeRect(arc4random_uniform(20), arc4random_uniform(50), 300, 300)];
        // reactTag
        _view.reactTag = _reactTag;
    }
    
    return _view;
}

@end

@implementation MRDOMElement

-(id)_initWithName:(NSString *)name namespaceURI:(NSString *)uri
{
    self = [super _initWithName:name namespaceURI:uri];
    _style = [[NSMutableDictionary alloc] initWithCapacity:5];
    return self;
}

-(NSMutableDictionary *)attributes
{
    if (!_attributes) {
        _attributes = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _attributes;
}

- (void) setAttribute:(NSString *) name :(NSString *) val;
{
    MRDOMAttr *attr=(MRDOMAttr *)[_attributes objectForKey:name];
    if(attr)
        [attr setValue:val];    // already exists
    else
        [self setAttributeNode:[[MRDOMAttr alloc] _initWithName:name value:val]];    // create new
}

- (MRDOMAttr *) setAttributeNode:(MRDOMAttr *) attr;
{
    if(!_attributes)
        _attributes=[NSMutableDictionary new];
    [_attributes setObject:attr forKey:attr.name];
    return attr;
}

//-(NSDictionary *)style
//{
//    if (!_style) {
//        class_addProtocol(NSClassFromString(@"__NSDictionaryM"), @protocol(MRStyleExport));
//        _style = [[NSMutableDictionary alloc] initWithCapacity:5];
//    }
//
//    return _style;
//}
@end

@implementation MRDOMDocument
-(MRDOMElement *)createElement:(NSString *)tag
{
    MRDOMElement *r=[[MRDOMElement alloc] _initWithName:tag namespaceURI:nil];
    [r setNodeType:1];
    return r;
}

- (MRDOMText *) createTextNode:(NSString *) data
{
    MRDOMText *r=[[MRDOMText alloc] _initWithName:@"#text" namespaceURI:nil];
    [r setNodeType:3];
    [r setData:data];
    return r;
}

-(MRDOMElement *)getElementById:(NSString *)element
{
    if ([element isEqualToString:@"root"]) {
        return [self documentElement];
    }
    return NIMP;
}

-(MRDOMElement *)documentElement
{
    if (!_documentElement) {
        _documentElement = [[MRDOMElement alloc] init];
        if (_rootView) {
            [_rootView addSubview:_documentElement.view];
        }
    }
    
    return _documentElement;
}
@end

@implementation MRDOMAttr
- (id) _initWithName:(NSString *) str value:(NSString *) val;
{ // value can be nil
    if((self=[super init]))
    {
        _name = [str copy];
        _value = [val copy];
    }
    return self;
}
@end

@implementation MRDOMText

@end
