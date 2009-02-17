//
//  ADBMylistEntry.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBObject.h"
@class ADBAnime;
@class ADBEpisode;
@class ADBGroup;
@class ADBFile;

@interface ADBMylistEntry : ADBObject {
	ADBAnime* anime;
	ADBEpisode* episode;
	ADBGroup* group;
	ADBFile* file;
}

+ (ADBMylistEntry*)mylistEntryWithAttributes:(NSDictionary*)newAtt;
+ (ADBMylistEntry*)mylistEntryWithQuickliteRow:(QuickLiteRow*)row;

- (void)insertIntoDatabase:(QuickLiteDatabase*)database;

- (ADBAnime*)anime;
- (void)setAnime:(ADBAnime*)newAnime;

- (ADBEpisode*)episode;
- (void)setEpisode:(ADBEpisode*)newEpisode;

- (ADBGroup*)group;
- (void)setGroup:(ADBGroup*)newGroup;

- (ADBFile*)file;
- (void)setFile:(ADBFile*)newFile;

@end
