//
//  ADBMylistEntry.h
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBMylistEntry : KNNode {
	NSMutableDictionary* properties;
	NSMutableArray* children;
}

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;

- (NSMutableArray*)children;
- (void)setChildren:(NSArray*)newChildren;

@end
