//
//  ADBCachedFacade.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBCachedFacade.h"
#define SALT [NSStringFromSelector(_cmd) substringToIndex:8]


@implementation ADBCachedFacade
- (id)init {
	if ([super init])
	{
		//If I use [NSMutableDictionary dictionary], for some reason I get a NSDictionary which cannot handle -setValue:forKey:
		//Same thing with [[NSMutableDictionary alloc] init]
		cache = [NSMutableDictionary dictionaryWithObject:@"test" forKey:@"test"];
	}
	return self;
}

- (void)dealloc {
	[cache release];
	[super dealloc];
}

+ (ADBCachedFacade*)cachedFacadeWithLocalPort:(int)localPort
{
	ADBCachedFacade* temp = [[ADBCachedFacade alloc] init];
	[temp setConnection:[ADBConnection connectionWithLocalPort:localPort]];
	return temp;
}

- (ADBMylistEntry*)findMylistEntryByID:(NSString*)mylistID {
	if ([cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, mylistID]] == nil)
		[cache setValue:[super findMylistEntryByID:mylistID] forKey:[NSString stringWithFormat:@"%@(%@)", SALT, mylistID]];
	return [cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, mylistID]];
}

- (ADBGroup*)findGroupByID:(NSString*)groupID {
	if ([cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, groupID]] == nil)
		[cache setValue:[super findGroupByID:groupID] forKey:[NSString stringWithFormat:@"%@(%@)", SALT, groupID]];
	return [cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, groupID]];
}

- (ADBAnime*)findAnimeByID:(NSString*)animeID {
	if ([cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, animeID]] == nil)
		[cache setValue:[super findAnimeByID:animeID] forKey:[NSString stringWithFormat:@"%@(%@)", SALT, animeID]];
	return [cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, animeID]];
}

- (ADBEpisode*)findEpisodeByID:(NSString*)episodeID {
	if ([cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, episodeID]] == nil)
		[cache setValue:[super findEpisodeByID:episodeID] forKey:[NSString stringWithFormat:@"%@(%@)", SALT, episodeID]];
	return [cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, episodeID]];
}

- (ADBFile*)findFileByID:(NSString*)fileID {
	if ([cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, fileID]] == nil)
		[cache setValue:[super findFileByID:fileID] forKey:[NSString stringWithFormat:@"%@(%@)", SALT, fileID]];
	return [cache valueForKey:[NSString stringWithFormat:@"%@(%@)", SALT, fileID]];
}

- (void)clearCache {
	[cache release];
	//see -init
	cache = [NSMutableDictionary dictionaryWithObject:@"test" forKey:@"test"];
}

@end
