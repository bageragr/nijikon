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
#import "KNPreferences.h"
#import "ADBMylistExport.h"
#import "ADBFacade.h"


@interface KNController : NSObject {
	IBOutlet NSWindow* mainWindow;
	IBOutlet NSWindow* configurationDialog;
	IBOutlet NSPanel* connectionPanel;
	
	BOOL modal;
	IBOutlet NSTextField* modalUsername;
	IBOutlet NSSecureTextField* modalPassword;
	IBOutlet NSTextField* modalStatus;
	
	NSString* path;
	KNPreferences* preferences;
	QuickLiteDatabase* db;
	ADBFacade* anidbFacade;
	NSMutableArray* mylist;
	NSMutableArray* anime;
	NSMutableArray* groups;
	
	NSMutableArray* animeFound;
}
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)getEpisode:(id)sender;

- (ADBConnection*)connection;

- (NSMutableArray*)mylist;
- (void)setMylist:(NSArray*)newMylist;
- (NSMutableArray*)anime;
- (void)setAnime:(NSArray*)newAnime;
- (NSMutableArray*)groups;
- (void)setGroups:(NSArray*)newGroups;

- (NSMutableArray*)animeFound;
- (void)setAnimeFound:(NSArray*)newAnimeFound;

- (BOOL)createDatabase:(BOOL)verbose withDummyData:(BOOL)createDummyData;
- (void)refreshDatabase:(BOOL)verbose detailed:(BOOL)detailed;
@end
