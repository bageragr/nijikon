//
//  KNController.h
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteRow.h>

#import "ADBAnime.h"
#import "ADBEpisode.h"
#import "ADBFile.h"
#import "ADBGroup.h"


@interface KNController : NSObject {
	QuickLiteDatabase* db;
	NSMutableArray* anime;
}

- (NSMutableArray*)anime;
- (void)setAnime:(NSArray*)newAnime;

- (BOOL)createDatabase:(NSString*)path;
- (void)refreshDatabase;
@end
