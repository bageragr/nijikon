//
//  ADBConnection.h
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <EDCommon/EDCommon.h>

@interface ADBConnection : NSObject {
	EDUDPSocket* socket;
}

@end
