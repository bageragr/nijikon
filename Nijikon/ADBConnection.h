//
//  ADBConnection.h
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

//#define AUTH [NSString stringWithString:@"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%dnat=%d&enc=%@"

#import "ADBResponseCodes.h"

#import <Cocoa/Cocoa.h>

#import "NSFileHandle+Extensions.h"
#import "EDUDPSocket.h"


@interface ADBConnection : NSObject {
	EDUDPSocket* udpSocket;
	NSDate* lastAccess;
	NSMutableArray* connectionLog;
	
	NSNumber* status;
	NSString* sessionKey;
}

+ (ADBConnection*)connectionWithLocalPort:(int)localPort;

- (void)send:(NSString*)aString usingEncoding:(NSStringEncoding)encoding;
- (NSString*)receiveUsingEncoding:(NSStringEncoding)encoding;
- (NSString*)sendAndReceiveUsingDefaultEncoding:(NSString*)aString appendSessionKey:(BOOL)appendSessionKey;
- (NSArray*)sendAndReceiveUsingDefaultEncodingAndPrepareResponse:(NSString*)aString appendSessionKey:(BOOL)appendSessionKey;

- (EDUDPSocket*)udpSocket;
- (void)setUdpSocket:(EDUDPSocket*)newUdpSocket;
- (NSNumber*)status;
- (void)setStatus:(NSNumber*)newStatus;
- (NSString*)sessionKey;
- (void)setSessionKey:(NSString*)newSessionKey;
- (void)setSession:(NSString*)newSessionKey;
- (void)clearSession;

- (NSString*)tailLog;
- (NSArray*)log;

- (void)logLine:(NSString*)logEntry;
@end
