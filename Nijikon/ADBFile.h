//
//  ADBFile.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

#import "ADBGroup.h"

@interface ADBFile : KNNode {
	ADBGroup* group;
	NSMutableDictionary* properties;
}

+ (ADBFile*)fileWithProperties:(NSDictionary*)newProperties;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;

- (ADBGroup*)group;
- (void)setGroup:(ADBGroup*)newGroup;
@end
