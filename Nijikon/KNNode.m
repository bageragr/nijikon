//
//  KNNode.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KNNode.h"


@implementation KNNode
- (id) init
{
    if (self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"ID", @"name", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"ID", @"name", nil];
        [self setNodeProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
    }
    return self;
}

- (void) dealloc
{
    [nodeProperties release];
    
    [super dealloc];
}

- (NSMutableDictionary *) nodeProperties
{
    return nodeProperties;
}

- (void) setNodeProperties: (NSDictionary *)newNodeProperties
{
    if (nodeProperties != newNodeProperties)
    {
        [nodeProperties autorelease];
        nodeProperties = [[NSMutableDictionary alloc] initWithDictionary: newNodeProperties];
    }
}
@end
