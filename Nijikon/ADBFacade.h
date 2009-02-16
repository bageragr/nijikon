//
//  ADBFacade.h
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBConnection.h"

#import "ADBMylistEntry.h"
#import "ADBAnime.h"
#import "ADBEpisode.h"
#import "ADBFile.h"
#import "ADBGroup.h"

@interface ADBFacade : NSObject {
	ADBConnection* anidb;
}
- (ADBConnection*)connection;

- (BOOL)login:(NSString*)username withPassword:(NSString*)password;
- (BOOL)logout;

- (NSString*)queryAniDB:(NSString*)query appendSessionKey:(BOOL)appendSessionKey;

- (ADBMylistEntry*)findMylistEntryByID:(NSString*)mylistID;
- (ADBMylistEntry*)findMylistEntryByFileID:(NSString*)fileID;
- (ADBMylistEntry*)findMylistEntryBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash;
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber;
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber;
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber;
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber;

- (ADBGroup*)findGroupByID:(NSString*)groupID;
- (ADBGroup*)findGroupByName:(NSString*)name;

- (ADBAnime*)findAnimeByID:(NSString*)animeID;
- (ADBAnime*)findAnimeByName:(NSString*)name;
- (NSString*)findDescriptionForAnimeByID:(NSString*)animeID;

- (ADBEpisode*)findEpisodeByID:(NSString*)episodeID;
- (ADBEpisode*)findEpisodeByAnimeName:(NSString*)animeName andEpNumber:(NSString*)epnumber;
- (ADBEpisode*)findEpisodeByAnimeID:(NSString*)animeID andEpNumber:(NSString*)epnumber;

- (ADBFile*)findFileByID:(NSString*)fileID;
- (ADBFile*)findFileBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash;
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber;
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber;
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber;
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber;

@end
