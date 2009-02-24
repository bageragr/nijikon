//
//  ADBConnection.m
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "ADBConnection.h"


@implementation ADBConnection
- (id)init {
	if (self = [super init]) {
        udpSocket = [[EDUDPSocket socket] retain];
		[self clearSession];
		NSHost* host = [NSHost hostWithName:@"api.anidb.info"];
		if (host == nil) {
			udpSocket = nil;
			[self setStatus:[NSNumber numberWithInt:0]];
		}
		else {
			[udpSocket connectToHost:host port:9000];
			[udpSocket setReceiveTimeout:5];
		}
		lastAccess = [[NSDate distantPast] retain];
    }
    return self;
}

- (void)dealloc {
	[udpSocket release];
	[status release];
	[lastAccess release];
    [super dealloc];
}

+ (ADBConnection*)connectionWithHost:(NSHost*)host remotePort:(int)remotePort andLocalPort:(int)localPort {
	ADBConnection* temp = [[ADBConnection alloc] init];
	EDUDPSocket* udpSocket = [[EDUDPSocket socket] retain];
	[udpSocket setLocalPort:localPort];
	if (host == nil) {
		udpSocket = nil;
		[temp setStatus:[NSNumber numberWithInt:0]];
	}
	else {
		[udpSocket connectToHost:host port:remotePort];
		[udpSocket setReceiveTimeout:5];
	}
	[temp setUdpSocket:udpSocket];
	return temp;
}

- (void)send:(NSString*)aString usingEncoding:(NSStringEncoding)encoding {
	while ([lastAccess timeIntervalSinceNow] > -2.0) {
		sleep(1);
	}
	[udpSocket writeData:[aString dataUsingEncoding:encoding]];
	[lastAccess release];
	lastAccess = [[NSDate date] retain];
}

- (NSString*)receiveUsingEncoding:(NSStringEncoding)encoding {
	@try {
		return [[NSString alloc] initWithData:[udpSocket availableData] encoding:encoding];
	}
	@catch (NSException* e) {
		return nil;
	}
	return nil;
}

- (NSString*)sendAndReceiveUsingDefaultEncoding:(NSString*)aString appendSessionKey:(BOOL)appendSessionKey {
	if (appendSessionKey)
		[self send:[aString stringByAppendingString:sessionKey] usingEncoding:DEFAULT_NSENCODING];
	else
		[self send:aString usingEncoding:DEFAULT_NSENCODING];
	return [self receiveUsingEncoding:DEFAULT_NSENCODING];
}

- (NSArray*)sendAndReceiveUsingDefaultEncodingAndPrepareResponse:(NSString*)aString appendSessionKey:(BOOL)appendSessionKey {
	NSString* response = [[self sendAndReceiveUsingDefaultEncoding:aString appendSessionKey:appendSessionKey] stringByReplacingOccurrencesOfString:@"'" withString:@","];
	NSArray* lines = [response componentsSeparatedByString:@"\n"];
	NSArray* temp = [NSMutableArray arrayWithObjects:[[[lines objectAtIndex:0] componentsSeparatedByString:@" "] objectAtIndex:0], [[lines objectAtIndex:0] substringFromIndex:4], nil];
	if ([lines count] > 1)
		temp = [temp arrayByAddingObjectsFromArray:[[lines objectAtIndex:1] componentsSeparatedByString:@"|"]];
	return temp;
}

- (NSTimeInterval)lastAccess {
	return [lastAccess timeIntervalSinceNow];
}

- (NSNumber*)status {
	return status;
}

- (void)setStatus:(NSNumber*)newStatus {
	if(status != newStatus) {
		[status release];
		status = [newStatus retain];
	}
}

- (EDUDPSocket*)udpSocket {
	return udpSocket;
}

- (void)setUdpSocket:(EDUDPSocket*)newUdpSocket {
	if (udpSocket != newUdpSocket) {
		[udpSocket release];
		[self clearSession];
		NSHost* host = [NSHost hostWithName:@"api.anidb.info"];
		if (host == nil) {
			udpSocket = nil;
			[self setStatus:[NSNumber numberWithInt:0]];
		}
		else {
			[udpSocket connectToHost:host port:9000];
			//[udpSocket setReceiveTimeout:5];
		}
		
		lastAccess = [[NSDate distantPast] retain];
	}
}

- (NSString*)sessionKey {
	return sessionKey;
}

- (void)setSessionKey:(NSString*)newSessionKey {
	if(sessionKey != newSessionKey) {
		[sessionKey release];
		sessionKey = [newSessionKey retain];
	}
}

- (void)setSession:(NSString*)newSessionKey {
	[self setStatus:[NSNumber numberWithInt:2]];
	[self setSessionKey:newSessionKey];
}

- (void)clearSession {
	[self setStatus:[NSNumber numberWithInt:1]];
	[self setSessionKey:@""];
}

- (void)logLine:(NSString*)logEntry {
}
@end
