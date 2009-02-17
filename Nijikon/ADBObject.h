//
//  ADBObject.h
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteRow.h>

#import "ADBKeyArrays.h"


@interface ADBObject : NSObject {
	NSMutableDictionary* att;
}

- (NSMutableDictionary*)att;
- (void)setAtt:(NSDictionary*)newAtt;

@end
