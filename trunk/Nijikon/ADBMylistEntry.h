//
//  ADBMylistEntry.h
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBMylistEntry : KNNode {
	NSMutableDictionary* properties;
	NSMutableArray* children;
}

+ (ADBMylistEntry*)mylistEntryWithProperties:(NSDictionary*)properties;
+ (ADBMylistEntry*)mylistEntryWithQuickLiteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
