//
//  ADBEpisode.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBObject.h"
#import "ADBMylistEntry.h"


@interface ADBEpisode : ADBObject {
	ADBMylistEntry* parent;
}

+ (ADBEpisode*)episodeWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent;
+ (ADBEpisode*)episodeWithQuickliteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (BOOL)isSpecial;
- (BOOL)isCredits;
- (BOOL)isTrailer;
- (BOOL)isParody;
- (BOOL)isOther;
- (BOOL)isNormal;

- (ADBMylistEntry*)parent;
- (void)setParent:(ADBMylistEntry*)newParent;

@end
