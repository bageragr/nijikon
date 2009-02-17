//
//  KNEpisode.h
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBEpisode : KNNode {
	NSMutableDictionary* properties;
	NSMutableArray* parents;
	NSMutableArray* children;
}

+ (ADBEpisode*)episodeWithProperties:(NSDictionary*)newProperties;
+ (ADBEpisode*)episodeWithQuickLiteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;

- (NSMutableArray*)parents;
- (void)setParents:(NSArray*)newParents;
- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
