//
//  KNNode.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNKeyArrays.h"


@interface KNNode : NSObject {
	BOOL isLeaf;
	NSMutableDictionary* att;
	NSMutableArray* children;
}

+ (KNNode*)nodeWithAttributes:(NSDictionary*)newAtt andIsLeaf:(BOOL)newIsLeaf;

- (BOOL)isLeaf;
- (void)setIsLeaf:(BOOL)newIsLeaf;

- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
