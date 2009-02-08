//
//  ADBConnection.m
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ADBConnection.h"


@implementation ADBConnection
- (id)init
{
	if (self = [super init])
    {
        socket = [EDUDPSocket socket];
		connectionLog = [[NSMutableArray alloc] initWithObjects:@"<> Log initialized",nil];
		status = [NSNumber numberWithInt:0];
		sessionKey = @"";
    }
    return self;
}

- (void)dealloc
{
	send([NSString stringWithFormat:@"LOGOUT s=%@&tag=%@", sessionKey, @"See you next time."], socket, NSUTF8StringEncoding);
	NSLog(receive(socket, DEFAULT_ENCODING));
	[socket release];
	[connectionLog release];
    [super dealloc];
}

void send(NSString* aString, EDSocket* socket, NSStringEncoding enc)
{
	[socket writeData:[aString dataUsingEncoding:enc]];
}

NSString* receive(EDSocket* socket, NSStringEncoding enc)
{
	@try
	{
		NSString* string = [[NSString alloc] initWithData:[socket availableData] encoding:enc];
		return string;
	}
	@catch (NSException* e)
	{
		return nil;
	}
	return @"";
}

- (BOOL)connect:(unsigned short)port
{
	NSHost* host = [NSHost hostWithName:@"api.anidb.info"];
	if (host == nil)
		return NO;
	else
	{
		[socket setLocalPort:port];
		[socket connectToHost:host port:9000];
		[socket setReceiveTimeout:2];
		status = [NSNumber numberWithInt:1];
		return YES;
	}
}

- (BOOL)authenticate:(NSString*)aUsername withPassword:(NSString*)aPassword
{
	[self setUsername:aUsername];
	[self setPassword:aPassword];
	NSString* command = [NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%d&client=%@&clientver=%d&nat=%d&enc=%@", [username lowercaseString], password, 3, @"nijikon", CLIENTVER, 1, @"UTF8"];
	send(command, socket, NSASCIIStringEncoding);
	[connectionLog addObject:[NSString stringWithFormat:@"IN # %@", command]];
	NSArray* response = [receive(socket, DEFAULT_ENCODING) componentsSeparatedByString:@" "];
	[connectionLog addObject:[NSString stringWithFormat:@"OUT # %@", response]];
	NSLog(@"%d", [[response objectAtIndex:0] intValue]);
	switch ([[response objectAtIndex:0] intValue]) {
		//command specific
		case LOGIN_ACCEPTED:
			sessionKey = [response objectAtIndex:1];
			status = [NSNumber numberWithInt:2];
			return YES;
		case LOGIN_ACCEPTED_NEW_VER:
			sessionKey = [response objectAtIndex:1];
			status = [NSNumber numberWithInt:2];
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
	}
}

- (ADBAnime*)findAnimeByID:(NSString*)animeID
{
	ADBAnime* temp = [[ADBAnime alloc] init];
	NSString* command = [NSString stringWithFormat:@"ANIME aid=%@&s=%@", animeID, sessionKey];
	send(command, socket, DEFAULT_ENCODING);
	[connectionLog addObject:[NSString stringWithFormat:@"IN # %@", command]];
	NSString* response = receive(socket, DEFAULT_ENCODING);
	[connectionLog addObject:[NSString stringWithFormat:@"OUT # %@", response]];
	switch ([[[response componentsSeparatedByString:@" "] objectAtIndex:0] intValue]) {
			//command specific
		case ANIME:
			[temp setValues:[[[response componentsSeparatedByString:@"\n"] objectAtIndex:1] componentsSeparatedByString:@"|"]];
			return temp;
		case NO_SUCH_ANIME:
			return nil;
			//generic
		case ILLEGAL_INPUT_OR_ACCESS_DENIED:
			return nil;
		case BANNED:
			return nil;
		case UNKNOWN_COMMAND:
			return nil;
		case INTERNAL_SERVER_ERROR:
			return nil;
		case ANIDB_OUT_OF_SERVICE:
			return nil;
		case SERVER_BUSY:
			return nil;
		default:
			return nil;
	}
}

- (ADBAnime*)findAnimeByName:(NSString*)aName
{
	ADBAnime* temp = [[ADBAnime alloc] init];
	return temp;
}

- (NSNumber*)status
{
	return status;
}

- (NSString*)sessionKey
{
	return sessionKey;
}

- (NSString*)username
{
	return username;
}

- (void)setUsername:(NSString*)newUsername
{
	if(username != newUsername)
	{
		[username release];
		username = [NSString stringWithString:newUsername];
	}
}

- (NSString*)password
{
	return password;
}

- (void)setPassword:(NSString*)newPassword
{
	if(password != newPassword)
	{
		[password release];
		password = [NSString stringWithString:newPassword];
	}
}

- (NSString*)tailLog
{
	return [connectionLog objectAtIndex:[connectionLog count] - 1];
}

- (NSArray*)log
{
	return connectionLog;
}
@end
