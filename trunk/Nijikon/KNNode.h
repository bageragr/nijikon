//
//  KNNode.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNKeyArrays.h"
#import "ADBObject.h"


@interface KNNode : NSObject {
	id reprObject;
	
	BOOL isLeaf;
	NSMutableDictionary* att;
	NSMutableArray* children;
}

+ (KNNode*)nodeWithAttributes:(NSDictionary*)newAtt representedObject:(ADBObject*)adbObject andIsLeaf:(BOOL)newIsLeaf;

- (ADBObject*)representedObject;
- (void)setRepresentedObject:(ADBObject*)adbObject;

- (BOOL)isLeaf;
- (void)setIsLeaf:(BOOL)newIsLeaf;

- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
