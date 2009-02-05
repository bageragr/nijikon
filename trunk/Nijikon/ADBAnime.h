//
//  KNAnime.h
//  ShowAnime
//
//  Created by Pipelynx on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBAnime : KNNode {
	NSMutableDictionary* properties;
	NSMutableArray* children;
}

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSDictionary*)newProperties;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
