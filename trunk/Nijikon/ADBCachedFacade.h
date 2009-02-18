//
//  ADBCachedFacade.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ADBFacade.h"


@interface ADBCachedFacade : ADBFacade {
	NSMutableDictionary* cache;
}

- (void)clearCache;

@end
