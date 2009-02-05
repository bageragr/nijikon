//
//  KNNode.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KNNode.h"


@implementation KNNode
- (id)init
{
    if(self = [super init])
    {
        NSArray * keys      = [NSArray arrayWithObjects: @"ID", @"name", nil];
        NSArray * values    = [NSArray arrayWithObjects: @"ID", @"name", nil];
        [self setNodeProperties:[NSDictionary dictionaryWithObjects: values forKeys: keys]];
    }
    return self;
}

- (void)dealloc
{
    [nodeProperties release];
    
    [super dealloc];
}

- (NSString*)description
{
	return [self valueForKeyPath:@"nodeProperties.name"];
}

- (NSString*)nodeName
{
	return nodeName;
}

- (NSString*)setNodeName:(NSString*)newNodeName
{
	if (nodeName != newNodeName)
	{
		[nodeName release];
		nodeName = [NSString stringWithString:newNodeName];
	}
}

- (NSMutableDictionary*)nodeProperties
{
    return nodeProperties;
}

- (void)setNodeProperties:(NSDictionary*)newNodeProperties
{
    if (nodeProperties != newNodeProperties)
    {
        [nodeProperties release];
        nodeProperties = [[NSMutableDictionary alloc] initWithDictionary: newNodeProperties];
    }
}
@end
