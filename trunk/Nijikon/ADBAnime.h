//
//  ADBAnime.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBObject.h"
#import "ADBMylistEntry.h"


@interface ADBAnime : ADBObject {
	ADBMylistEntry* parent;
}

+ (ADBAnime*)animeWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent;
+ (ADBAnime*)animeWithQuickliteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (ADBMylistEntry*)parent;
- (void)setParent:(ADBMylistEntry*)newParent;

@end
