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
        [self setAtt:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"type", @"name", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil]
												 forKeys:KNNodeKeyArray]];
		[self setChildren:[NSArray array]];
    }
    return self;
}

- (void)dealloc {
    [att release];
    
    [super dealloc];
}

+ (KNNode*)nodeWithAttributes:(NSDictionary*)newAtt andIsLeaf:(BOOL)newIsLeaf {
	KNNode* temp = [[KNNode alloc] init];
	[temp setAtt:newAtt];
	[temp setIsLeaf:newIsLeaf];
	return temp;
}

- (BOOL)isLeaf {
	return isLeaf;
}

- (void)setIsLeaf:(BOOL)newIsLeaf {
	isLeaf = newIsLeaf;
}

- (NSMutableDictionary*)att {
    return att;
}

- (void)setAtt:(NSDictionary*)newAtt {
    if (att != newAtt)
    {
        [att release];
        att = [[NSMutableDictionary alloc] initWithDictionary: newAtt];
    }
}

- (NSMutableArray*)children {
	return children;
}

- (void)setChildren:(NSArray*)newChildren {
	if (children != newChildren)
    {
        [children release];
        children = [[NSMutableArray alloc] initWithArray:newChildren];
    }
}
@end
