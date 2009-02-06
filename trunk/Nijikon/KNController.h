//
//  KNController.h
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteRow.h>

#import "ADBConnection.h"


@interface KNController : NSObject {
	IBOutlet NSBrowser* mainView;
	
	NSString* path;
	QuickLiteDatabase* db;
	NSMutableArray* anime;
	NSMutableArray* groups;
}

- (NSMutableArray*)anime;
- (void)setAnime:(NSArray*)newAnime;
- (NSMutableArray*)groups;
- (void)setGroups:(NSArray*)newGroups;

- (BOOL)createDatabase:(BOOL)verbose withDummyData:(BOOL)createDummyData;
- (void)refreshDatabase:(BOOL)verbose detailed:(BOOL)detailed;
@end
