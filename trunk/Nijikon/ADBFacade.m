//
//  ADBFacade.m
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
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
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%@&nat=%@&enc=%@", [aUsername lowercaseString], aPassword, PROTOCOLVER, CLIENT, CLIENTVER, @"1", DEFAULT_ENCODING]
																   appendSessionKey:NO];
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_LOGIN_ACCEPTED:
			[anidb setSession:[[response objectAtIndex:1] substringToIndex:5] withUsername:aUsername andPassword:aPassword];
			return YES;
		case RC_CLIENT_BANNED:
			NSLog(@"%@", [response objectAtIndex:2]);
			return NO;
		default:
			return NO;
	}
	/*case LOGIN_ACCEPTED_NEW_VER:
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
			return NO;*/
}
- (BOOL)logout {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:@"LOGOUT s="
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_LOGGED_OUT:
			[anidb clearSession];
			return YES;
		case RC_NOT_LOGGED_IN:
			[anidb clearSession];
			return YES;
		default:
			return NO;
	}
	/*case ILLEGAL_INPUT_OR_ACCESS_DENIED:
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
			return NO;*/
}

- (ADBMylistEntry*)findMylistEntryByID:(NSString*)mylistID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_MYLIST:
			return [ADBMylistEntry mylistEntryWithProperties:[NSDictionary dictionaryWithObjects:values
																						 forKeys:ADBMylistEntryKeyArray]];
		case RC_NO_SUCH_ENTRY:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByFileID:(NSString*)fileID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}

- (ADBGroup*)findGroupByID:(NSString*)groupID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBGroup*)findGroupByName:(NSString*)name {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}

- (ADBAnime*)findAnimeByID:(NSString*)animeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBAnime*)findAnimeByName:(NSString*)name {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (NSString*)findDescriptionForAnimeByID:(NSString*)animeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}

- (ADBEpisode*)findEpisodeByID:(NSString*)episodeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBEpisode*)findEpisodeByAnimeName:(NSString*)animeName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBEpisode*)findEpisodeByAnimeID:(NSString*)animeID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}

- (ADBFile*)findFileByID:(NSString*)fileID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBFile*)findFileBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			return nil;
	}
}
@end
