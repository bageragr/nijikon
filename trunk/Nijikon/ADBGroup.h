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
	NSMutableDictionary* properties;
}

+ (ADBGroup*)groupWithProperties:(NSDictionary*)newProperties;

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSArray*)values forKeys:(NSArray*)keys;
- (void)setProperties:(NSDictionary*)newProperties;
@end
