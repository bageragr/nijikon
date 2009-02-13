//
//  ADBFacade.m
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBFacade.h"


@implementation ADBFacade
- (id)init
{
	if ([super init])
	{
		anidb = [[[ADBConnection alloc] init] retain];
	}
	return self;
}

- (void)dealloc
{
	[anidb release];
	[super dealloc];
}

- (ADBConnection*)connection
{
	return anidb;
}

- (BOOL)login:(NSString*)aUsername withPassword:(NSString*)aPassword {
	return NO;
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%@&nat=%@&enc=%@", [aUsername lowercaseString], aPassword, PROTOCOLVER, CLIENT, CLIENTVER, @"1", DEFAULT_ENCODING]];
	for (int i = 0; i < [response count]; i++)
		NSLog([response objectAtIndex:i]);
	
	/*[self setUsername:aUsername];
	[self setPassword:aPassword];
	NSString* command = [NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%d&client=%@&clientver=%d&nat=%d&enc=%@", [username lowercaseString], password, 3, @"nijikon", CLIENTVER, 1, @"UTF8"];
	[self send:command usingEncoding:NSASCIIStringEncoding];
	[connectionLog addObject:[NSString stringWithFormat:@"OUT # %@", command]];
	NSString* response = [self receiveUsingEncoding:DEFAULT_ENCODING];
	NSArray* spaceSeparatedResponse = [response componentsSeparatedByString:@" "];
	[connectionLog addObject:[NSString stringWithFormat:@"IN # %@", response]];
	switch ([[spaceSeparatedResponse objectAtIndex:0] intValue]) {
			//command specific
		case LOGIN_ACCEPTED:
			[self setSessionKey:[spaceSeparatedResponse objectAtIndex:1]];
			[self setStatus:[NSNumber numberWithInt:2]];
			return YES;
		case LOGIN_ACCEPTED_NEW_VER:
			[self setSessionKey:[spaceSeparatedResponse objectAtIndex:1]];
			[self setStatus:[NSNumber numberWithInt:2]];
			return YES;
		case LOGIN_FAILED:
			return NO;
		case LOGIN_FIRST:
			return NO;
		case ACCESS_DENIED:
			return NO;
		case CLIENT_VERSION_OUTDATED:
			return NO;
		case CLIENT_BANNED:
			return NO;
		case INVALID_SESSION:
			return NO;
			//generic
		case ILLEGAL_INPUT_OR_ACCESS_DENIED:
			return NO;
		case BANNED:
			return NO;
		case UNKNOWN_COMMAND:
			return NO;
		case INTERNAL_SERVER_ERROR:
			return NO;
		case ANIDB_OUT_OF_SERVICE:
			return NO;
		case SERVER_BUSY:
			return NO;
		default:
			return NO;
	}*/
}
- (BOOL)logout {
	return NO;
	/*NSString* command = [NSString stringWithFormat:@"LOGOUT s=%@", sessionKey];
	[self send:command usingEncoding:DEFAULT_ENCODING];
	[connectionLog addObject:[NSString stringWithFormat:@"OUT # %@", command]];
	NSString* response = [self receiveUsingEncoding:DEFAULT_ENCODING];
	NSArray* spaceSeparatedResponse = [response componentsSeparatedByString:@" "];
	[connectionLog addObject:[NSString stringWithFormat:@"IN # %@", response]];
	NSLog(@"%@", response);
	switch ([[spaceSeparatedResponse objectAtIndex:0] intValue]) {
			//command specific
		case LOGGED_OUT:
			[self setSessionKey:@""];
			[self setStatus:[NSNumber numberWithInt:1]];
			return YES;
		case NOT_LOGGED_IN:
			return NO;
			//generic
		case ILLEGAL_INPUT_OR_ACCESS_DENIED:
			return NO;
		case BANNED:
			return NO;
		case UNKNOWN_COMMAND:
			return NO;
		case INTERNAL_SERVER_ERROR:
			return NO;
		case ANIDB_OUT_OF_SERVICE:
			return NO;
		case SERVER_BUSY:
			return NO;
		default:
			return NO;
	}*/
}

- (ADBMylistEntry*)findMylistEntryByID:(NSString*)mylistID {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryByFileID:(NSString*)fileID {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	return nil;
}

- (ADBGroup*)findGroupByID:(NSString*)groupID {
	return nil;
}
- (ADBGroup*)findGroupByName:(NSString*)name {
	return nil;
}

- (ADBAnime*)findAnimeByID:(NSString*)animeID {
	return nil;
}
- (ADBAnime*)findAnimeByName:(NSString*)name {
	return nil;
}
- (NSString*)findDescriptionForAnimeByID:(NSString*)animeID {
	return nil;
}

- (ADBEpisode*)findEpisodeByID:(NSString*)episodeID {
	return nil;
}
- (ADBEpisode*)findEpisodeByAnimeName:(NSString*)animeName andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBEpisode*)findEpisodeByAnimeID:(NSString*)animeID andEpNumber:(NSString*)epnumber {
	return nil;
}

- (ADBFile*)findFileByID:(NSString*)fileID {
	return nil;
}
- (ADBFile*)findFileBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash {
	return nil;
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	return nil;
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	return nil;
}
@end
