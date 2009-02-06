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
		log = [[NSMutableArray alloc] init];
		[log addObject:@"<> Log initialized"];
		sessionKey = @"";
    }
    return self;
}

- (void)dealloc
{
	send([NSString stringWithFormat:@"LOGOUT s=%@", sessionKey], socket, NSUTF8StringEncoding);
	[socket release];
	[log release];
    [super dealloc];
}

void send(NSString* aString, EDSocket* socket, NSStringEncoding enc)
{
	[socket writeData:[aString dataUsingEncoding:enc]];
	//[log addObject:[NSString stringWithFormat:@">> %@", aString]];
}

NSString* receive(EDSocket* socket, NSStringEncoding enc)
{
	@try
	{
		NSString* string = [[NSString alloc] initWithData:[socket availableData] encoding:enc];
		//[log addObject:[NSString stringWithFormat:@"<< %@", string]];
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
	if ([NSHost hostWithName:@"api.anidb.info"] == nil)
		return NO;
	else
	{
		[socket setLocalPort:port];
		[socket connectToHost:[NSHost hostWithName:@"api.anidb.info"] port:9000];
		[socket setReceiveTimeout:2.5];
		return YES;
	}
}

- (BOOL)authenticate:(NSString*)username withPassword:(NSString*)password
{
	send([NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%d&client=%@&clientver=%d&nat=%d&enc=%@", [username lowercaseString], password, 3, @"nijikon", CLIENTVER, 1, @"ASCII"], socket, NSASCIIStringEncoding);
	NSArray* response = [receive(socket, DEFAULT_ENCODING) componentsSeparatedByString:@" "];
	NSLog(@"%d", [[response objectAtIndex:0] intValue]);
	switch ([[response objectAtIndex:0] intValue]) {
		//command specific
		case LOGIN_ACCEPTED:
			sessionKey = [response objectAtIndex:1];
			return YES;
		case LOGIN_ACCEPTED_NEW_VER:
			sessionKey = [response objectAtIndex:1];
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
	send([NSString stringWithFormat:@"ANIME aid=%@&s=%@", animeID, sessionKey], socket, DEFAULT_ENCODING);
	NSString* response = receive(socket, DEFAULT_ENCODING);
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

- (NSString*)sessionKey
{
	return sessionKey;
}

- (NSString*)tailLog
{
	return [log objectAtIndex:[log count] - 1];
}

- (NSArray*)log
{
	return log;
}
@end
