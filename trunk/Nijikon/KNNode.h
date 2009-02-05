//
//  KNNode.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KNNode : NSObject {
	NSString* nodeName;
	NSMutableDictionary* nodeProperties;
}

- (NSMutableDictionary*)nodeProperties;
- (void)setNodeProperties:(NSDictionary*)newNodeProperties;
@end
