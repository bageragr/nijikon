//
//  KNNode.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "KNNode.h"


@implementation KNNode
- (id)init
{
    if(self = [super init])
    {
		isLeaf = NO;
		
        NSArray * keys      = KNNodeKeyArray;
        NSArray * values    = [NSArray arrayWithObjects: @"ID", [NSNumber numberWithInt:0], @"name", @"epnumber", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
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

- (BOOL)isLeaf
{
	return isLeaf;
}

- (void)setIsLeaf:(BOOL)newIsLeaf
{
	isLeaf = newIsLeaf;
}

- (NSString*)nodeName
{
	return nodeName;
}

- (void)setNodeName:(NSString*)newNodeName
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
