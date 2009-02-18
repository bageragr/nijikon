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
	IBOutlet NSWindow* configurationDialog;
	IBOutlet NSPanel* connectionPanel;
	
	IBOutlet NSTextField* username;
	IBOutlet NSSecureTextField* password;
	
	NSString* path;
	KNPreferences* preferences;
	QuickLiteDatabase* db;
	ADBCachedFacade* anidbFacade;
	
	NSMutableArray* byMylist;
	
	NSMutableArray* mylist;
	NSMutableArray* animeFound;
}
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)saveProperties:(id)sender;

- (ADBConnection*)connection;
- (KNPreferences*)preferences;

- (NSArray*)byMylist;

- (void)fillMylist;
- (NSMutableArray*)mylist;
- (void)setMylist:(NSArray*)newMylist;

- (NSMutableArray*)animeFound;
- (void)setAnimeFound:(NSArray*)newAnimeFound;

- (BOOL)createDatabaseVerbose:(BOOL)verbose;
@end
