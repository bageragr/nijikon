//
//  ADBConnection.m
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "ADBConnection.h"


@implementation ADBConnection
- (id)init
{
	if (self = [super init])
    {
        socket = [[EDUDPSocket socket] retain];
		NSHost* host = [NSHost hostWithName:@"api.anidb.info"];
		if (host == nil) {
			socket = nil;
			[self setStatus:[NSNumber numberWithInt:0]];
		}
		else {
			[socket connectToHost:host port:9000];
			[socket setReceiveTimeout:5];
			[self setStatus:[NSNumber numberWithInt:1]];
		}
		
		lastAccess = [[NSDate distantPast] retain];
		connectionLog = [[[NSMutableArray alloc] initWithObjects:@"<> Log initialized",nil] retain];
    }
    return self;
}

- (void)dealloc
{
	[socket release];
	[status release];
	[lastAccess release];
	[connectionLog release];
    [super dealloc];
}

- (void)send:(NSString*)aString usingEncoding:(NSStringEncoding)encoding
{
	while ([lastAccess timeIntervalSinceNow] > -2.0) {
		sleep(1);
	}
	[socket writeData:[aString dataUsingEncoding:encoding]];
	[lastAccess release];
	lastAccess = [[NSDate date] retain];
}

- (NSString*)receiveUsingEncoding:(NSStringEncoding)encoding
{
	@try
	{
		return [[NSString alloc] initWithData:[socket availableData] encoding:encoding];
	}
	@catch (NSException* e)
	{
		return nil;
	}
	return nil;
}

- (NSArray*)sendAndReceiveUsingDefaultEncodingAndPrepareResponse:(NSString*)aString appendSessionKey:(BOOL)appendSessionKey
{
	if (appendSessionKey)
		[self send:[aString stringByAppendingString:sessionKey] usingEncoding:DEFAULT_NSENCODING];
	else
		[self send:aString usingEncoding:DEFAULT_NSENCODING];
	NSArray* lines = [[self receiveUsingEncoding:DEFAULT_NSENCODING] componentsSeparatedByString:@"\n"];
	NSArray* temp = [NSMutableArray arrayWithObjects:[[[lines objectAtIndex:0] componentsSeparatedByString:@" "] objectAtIndex:0], [[lines objectAtIndex:0] substringFromIndex:4], nil];
	if ([lines count] > 1)
		temp = [temp arrayByAddingObjectsFromArray:[[lines objectAtIndex:1] componentsSeparatedByString:@"|"]];
	return temp;
}

- (NSTimeInterval)lastAccess
{
	return [lastAccess timeIntervalSinceNow];
}

- (NSNumber*)status
{
	return status;
}

- (void)setStatus:(NSNumber*)newStatus
{
	if(status != newStatus)
	{
		[status release];
		status = [newStatus retain];
	}
}

- (NSString*)sessionKey
{
	return sessionKey;
}

- (void)setSessionKey:(NSString*)newSessionKey
{
	if(sessionKey != newSessionKey)
	{
		[sessionKey release];
		sessionKey = [newSessionKey retain];
	}
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

- (void)setSession:(NSString*)newSessionKey withUsername:(NSString*)newUsername andPassword:(NSString*)newPassword
{
	[self setStatus:[NSNumber numberWithInt:2]];
	[self setSessionKey:newSessionKey];
	[self setUsername:newUsername];
	[self setPassword:newPassword];
}

- (void)clearSession
{
	[self setStatus:[NSNumber numberWithInt:1]];
	[self setSessionKey:@""];
	[self setUsername:@""];
	[self setPassword:@""];
}

- (NSString*)tailLog
{
	return [connectionLog objectAtIndex:[connectionLog count] - 1];
}

- (NSArray*)log
{
	return connectionLog;
}

- (void)logLine:(NSString*)logEntry
{
	[connectionLog addObject:[NSString stringWithFormat:@"[%@] %@", [[NSDate date] description], logEntry]];
}
@end
