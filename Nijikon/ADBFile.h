//
//  ADBFile.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBObject.h"
#import "ADBMylistEntry.h"


@interface ADBFile : ADBObject {
	ADBMylistEntry* parent;
}

+ (ADBFile*)fileWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent;
+ (ADBFile*)fileWithQuickliteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (ADBMylistEntry*)parent;
- (void)setParent:(ADBMylistEntry*)newParent;

@end
