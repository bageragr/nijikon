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
	IBOutlet NSTextField* username;
	IBOutlet NSSecureTextField* password;
	
	NSString* path;
	KNPreferences* preferences;
	QuickLiteDatabase* db;
	ADBFacade* anidbFacade;
	NSMutableArray* mylist;
	
	NSMutableArray* animeFound;
}
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)saveProperties:(id)sender;

- (ADBConnection*)connection;
- (KNPreferences*)preferences;

- (NSMutableArray*)mylist;
- (void)setMylist:(NSArray*)newMylist;

- (NSMutableArray*)animeFound;
- (void)setAnimeFound:(NSArray*)newAnimeFound;

- (BOOL)createDatabaseVerbose:(BOOL)verbose withDummyData:(BOOL)createDummyData;
- (void)refreshDatabaseVerbose:(BOOL)verbose detailed:(BOOL)detailed;
@end
