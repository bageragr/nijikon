//
//  ADBGroup.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBGroup : KNNode {
	NSMutableDictionary* files;
	NSMutableDictionary* properties;
}

+ (ADBGroup*)groupWithProperties:(NSDictionary*)newProperties;
+ (ADBGroup*)groupWithQuickLiteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;
@end
