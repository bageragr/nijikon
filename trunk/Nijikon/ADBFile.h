//
//  ADBFile.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

#import "ADBGroup.h"

@interface ADBFile : KNNode {
	ADBGroup* group;
	NSMutableArray* parents;
	NSMutableDictionary* properties;
}

+ (ADBFile*)fileWithProperties:(NSDictionary*)newProperties group:(ADBGroup*)newGroup andParents:(NSArray*)newParents;
+ (ADBFile*)fileWithQuickLiteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (NSMutableArray*)parents;
- (void)setParents:(NSArray*)newParents;
- (ADBGroup*)group;
- (void)setGroup:(ADBGroup*)newGroup;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;
@end
