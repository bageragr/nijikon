//
//  ADBFile.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KNNode.h"

@interface ADBFile : KNNode {
	NSMutableDictionary* properties;
}

- (NSMutableDictionary*)properties;
- (void)setProperties:(NSDictionary*)newProperties;
@end
