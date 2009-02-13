//
//  KNAnime.h
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBAnime : KNNode {
	NSMutableDictionary* properties;
	NSMutableArray* children;
}

+ (ADBAnime*)animeWithProperties:(NSDictionary*)newProperties;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
