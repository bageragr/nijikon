//
//  KNNode.m
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "PLNode.h"


@implementation PLNode
- (id)init
{
    if(self = [super init])
    {
		[self setRepresentedObject:nil];
		isLeaf = NO;
        [self setAtt:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"type", @"name", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil]
												 forKeys:PLNodeKeyArray]];
		[self setChildren:[NSArray array]];
    }
    return self;
}

- (void)dealloc {
	[reprObject release];
    [att release];
	[children release];
    
    [super dealloc];
}

+ (PLNode*)nodeWithAttributes:(NSDictionary*)newAtt representedObject:(ADBObject*)adbObject andIsLeaf:(BOOL)newIsLeaf {
	PLNode* temp = [[PLNode alloc] init];
	[temp setRepresentedObject:adbObject];
	[temp setAtt:newAtt];
	[temp setIsLeaf:newIsLeaf];
	return temp;
}

- (ADBObject*)representedObject {
	return reprObject;
}

- (void)setRepresentedObject:(ADBObject*)adbObject {
	if (reprObject != adbObject) {
        [reprObject release];
        reprObject = [adbObject retain];
    }
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
