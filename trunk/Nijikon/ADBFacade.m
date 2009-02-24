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

+ (ADBFacade*)facadeWithHost:(NSHost*)host remotePort:(int)remotePort andLocalPort:(int)localPort
{
	ADBFacade* temp = [[ADBFacade alloc] init];
	[temp setConnection:[ADBConnection connectionWithHost:host remotePort:remotePort andLocalPort:localPort]];
	return temp;
}

- (NSString*)queryAniDB:(NSString*)query appendSessionKey:(BOOL)appendSessionKey
{
	return [anidb sendAndReceiveUsingDefaultEncoding:query appendSessionKey:appendSessionKey];
}

- (BOOL)login:(NSString*)aUsername withPassword:(NSString*)aPassword {
	if ([[anidb status] intValue] >= 2)
		return YES;
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%@&nat=%@&enc=%@", [aUsername lowercaseString], aPassword, PROTOCOLVER, CLIENT, CLIENTVER, @"1", DEFAULT_ENCODING]
																   appendSessionKey:NO];
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_LOGIN_ACCEPTED:
			[anidb setSession:[[response objectAtIndex:1] substringToIndex:5]];
			return YES;
		case RC_BANNED:
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
			NSLog(@"Logged out (%@)", [anidb sessionKey]);
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
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"MYLIST lid=%@&s=", mylistID]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_MYLIST:
			return [ADBMylistEntry mylistEntryWithAttributes:[NSDictionary dictionaryWithObjects:values
																						 forKeys:ADBMylistEntryKeyArray]];
		case RC_NO_SUCH_ENTRY:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryByFileID:(NSString*)fileID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"MYLIST fid=%@&s=", fileID]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_MYLIST:
			return [ADBMylistEntry mylistEntryWithAttributes:[NSDictionary dictionaryWithObjects:values
																						 forKeys:ADBMylistEntryKeyArray]];
		case RC_NO_SUCH_ENTRY:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBMylistEntry*)findMylistEntryBySize:(NSString*)sizeInBytes andED2k:(NSString*)hash {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"MYLIST size=%@&ed2k=%@&s=", sizeInBytes, hash]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_MYLIST:
			return [ADBMylistEntry mylistEntryWithAttributes:[NSDictionary dictionaryWithObjects:values
																						 forKeys:ADBMylistEntryKeyArray]];
		case RC_NO_SUCH_ENTRY:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}

- (ADBGroup*)findGroupByID:(NSString*)groupID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"GROUP gid=%@&s=", groupID]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_GROUP:
			return [ADBGroup groupWithAttributes:[NSDictionary dictionaryWithObjects:values
																			 forKeys:ADBGroupKeyArray] andParent:nil];
		case RC_NO_SUCH_GROUP:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBGroup*)findGroupByName:(NSString*)name {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"GROUP gname=%@&s=", name]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_GROUP:
			return [ADBGroup groupWithAttributes:[NSDictionary dictionaryWithObjects:values
																			 forKeys:ADBGroupKeyArray] andParent:nil];
		case RC_NO_SUCH_GROUP:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}

- (ADBAnime*)findAnimeByID:(NSString*)animeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"ANIME aid=%@&amask=%@&s=", animeID, DEFAULT_AMASK]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	[values addObject:@"No description"];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_ANIME:
			return [ADBAnime animeWithAttributes:[NSDictionary dictionaryWithObjects:values
																			 forKeys:ADBAnimeKeyArray] andParent:nil];
		case RC_NO_SUCH_ANIME:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBAnime*)findAnimeByName:(NSString*)name {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"ANIME aname=%@&amask=%@&s=", name, DEFAULT_AMASK]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	[values addObject:@"No description"];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_ANIME:
			return [ADBAnime animeWithAttributes:[NSDictionary dictionaryWithObjects:values
																			 forKeys:ADBAnimeKeyArray] andParent:nil];
		case RC_NO_SUCH_ANIME:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (NSString*)findDescriptionForAnimeByID:(NSString*)animeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"ANIMEDESC aid=%@&part=%@&s=", animeID, @"0"]
																   appendSessionKey:YES];
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_ANIME_DESCRIPTION:
			//NSMutableString* description = [NSMutableString stringWithString:[response objectAtIndex:4]];
			return nil;
		case RC_NO_SUCH_ANIME:
			return nil;
		case RC_NO_SUCH_ANIME_DESCRIPTION:
			return @"No description";
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}

- (ADBEpisode*)findEpisodeByID:(NSString*)episodeID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"EPISODE eid=%@&s=", episodeID]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_EPISODE:
			return [ADBEpisode episodeWithAttributes:[NSDictionary dictionaryWithObjects:values
																				 forKeys:ADBEpisodeKeyArray] andParent:nil];
		case RC_NO_SUCH_EPISODE:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBEpisode*)findEpisodeByAnimeName:(NSString*)animeName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBEpisode*)findEpisodeByAnimeID:(NSString*)animeID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}

- (ADBFile*)findFileByID:(NSString*)fileID {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@"FILE fid=%@&fmask=%@&amask=%@&s=", fileID, DEFAULT_FMASK, @"00000000"]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case RC_FILE:
			return [ADBFile fileWithAttributes:[NSDictionary dictionaryWithObjects:values
																		   forKeys:ADBFileKeyArray] andParent:nil];
		case RC_NO_SUCH_FILE:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
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
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBFile*)findFileByAnimeName:(NSString*)animeName groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupName:(NSString*)groupName andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}
- (ADBFile*)findFileByAnimeID:(NSString*)animeID groupID:(NSString*)groupID andEpNumber:(NSString*)epnumber {
	NSArray* response = [anidb sendAndReceiveUsingDefaultEncodingAndPrepareResponse:[NSString stringWithFormat:@""]
																   appendSessionKey:YES];
	NSMutableArray* values = [NSMutableArray array];
	for (int i = 2; i < [response count]; i++)
		[values addObject:[response objectAtIndex:i]];
	
	switch ([[response objectAtIndex:0] intValue]) {
		case 0:
			return nil;
		default:
			NSLog(@"%@ %@", [response objectAtIndex:0], [response objectAtIndex:1]);
			return nil;
	}
}

- (ADBConnection*)connection
{
	return anidb;
}

- (void)setConnection:(ADBConnection*)newConnection
{
	if (anidb != newConnection)
	{
		[anidb release];
		anidb = [newConnection retain];
	}
}
@end
