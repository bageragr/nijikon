//
//  KNNode.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBKeyArrays.h"

@interface KNNode : NSObject {
	BOOL isLeaf;
	NSString* nodeName;
	NSMutableDictionary* nodeProperties;
}

- (BOOL)isLeaf;
- (void)setIsLeaf:(BOOL)newIsLeaf;

- (NSString*)nodeName;
- (void)setNodeName:(NSString*)newNodeName;

- (NSMutableDictionary*)nodeProperties;
- (void)setNodeProperties:(NSDictionary*)newNodeProperties;
@end
