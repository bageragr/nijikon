//
//  KNNode.h
//  iAniDB
//
//  Created by Pipelynx on 1/31/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteRow.h>

#import "ADBKeyArrays.h"
#import "KNKeyArrays.h"

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
