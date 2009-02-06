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
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)connect
{
	socket = [[EDUDPSocket alloc] initWithFileHandle:[NSFileHandle fileHandleForReadingAtPath:@"api.anidb.info:9000"]];
	return true;
}
@end
