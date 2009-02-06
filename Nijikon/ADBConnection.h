//
//  ADBConnection.h
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#define AUTH [NSString stringWithString:@"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%dnat=%d&enc=%@"

#import "ADBResponseCodes.h"

#import <Cocoa/Cocoa.h>

#import "NSFileHandle+Extensions.h"
#import "EDUDPSocket.h"

#import "ADBAnime.h"
#import "ADBEpisode.h"
#import "ADBFile.h"
#import "ADBGroup.h"

@interface ADBConnection : NSObject {
	EDUDPSocket* socket;
	NSMutableArray* log;
	NSString* sessionKey;
}
void send(NSString* aString, EDSocket* socket, NSStringEncoding enc);
NSString* receive(EDSocket* socket, NSStringEncoding enc);

//Pre-query methods
- (BOOL)connect:(unsigned short)port;
- (BOOL)authenticate:(NSString*)username withPassword:(NSString*)password;

//Query methods
- (ADBAnime*)findAnimeByID:(NSString*)animeID;
- (ADBAnime*)findAnimeByName:(NSString*)aName;

//Post-query methods

- (NSString*)sessionKey;
- (NSString*)tailLog;
- (NSArray*)log;
@end
