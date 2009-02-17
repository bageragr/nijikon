//
//  ADBGroup.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBObject.h"
#import "ADBMylistEntry.h"


@interface ADBGroup : ADBObject {
	ADBMylistEntry* parent;
}

+ (ADBGroup*)groupWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent;
+ (ADBGroup*)groupWithQuickliteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (ADBMylistEntry*)parent;
- (void)setParent:(ADBMylistEntry*)newParent;

@end
