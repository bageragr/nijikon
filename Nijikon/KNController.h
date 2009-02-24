//
//  KNController.h
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteRow.h>

#import "KNED2k.h"
#import "KNNode.h"
#import "KNPreferences.h"
#import "ADBMylistExport.h"
#import "ADBCachedFacade.h"


@interface KNController : NSObject {
	IBOutlet NSWindow* mainWindow;
	IBOutlet NSOutlineView* mylistOutline;
	IBOutlet NSOutlineView* byAnimeOutline;
	IBOutlet NSOutlineView* byGroupOutline;
	
	NSString* path;
	KNPreferences* preferences;
	QuickLiteDatabase* db;
	ADBCachedFacade* anidbFacade;
	
	NSMutableArray* byMylist;
	NSMutableArray* byAnime;
	
	NSMutableArray* mylist;
	ADBAnime* animeFound;
}
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)saveProperties:(id)sender;

- (ADBFacade*)facade;
- (KNPreferences*)preferences;

- (NSArray*)byMylist;
- (NSArray*)byAnime;

- (NSMutableArray*)mylist;
- (void)setMylist:(NSArray*)newMylist;

- (ADBAnime*)animeFound;
- (void)setAnimeFound:(ADBAnime*)newAnimeFound;

- (NSArray*)getWatched:(ADBObject*)adbObject;
- (NSArray*)getHave:(ADBObject*)adbObject;

- (BOOL)createDatabaseVerbose:(BOOL)verbose;
- (void)fillDatabaseWithMylistExport:(ADBMylistExport*)mylistExport;
- (void)fillMylistVerbose:(BOOL)verbose;
@end
