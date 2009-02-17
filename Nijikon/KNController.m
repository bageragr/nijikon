//
//  KNController.m
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "KNController.h"


@implementation KNController
- (id)init {
	if(self = [super init])
	{
		path = [@"~/Library/Application Support/Nijikon" stringByExpandingTildeInPath];
		preferences = [KNPreferences preferenceWithPath:[path stringByAppendingString:@"/nijikon.prefs"]];
		[username setStringValue:[preferences valueForKeyPath:@"properties.username"]];
		[password setStringValue:[preferences valueForKeyPath:@"properties.password"]];
		db = [QuickLiteDatabase databaseWithFile:[path stringByAppendingString:@"/nijikon.db"]];
		[db open];
		anidbFacade = [[[ADBFacade alloc] init] retain];
		[self setMylist:mylist];
		[self setAnimeFound:animeFound];
		
		[self createDatabaseVerbose:YES	withDummyData:YES];
		[self refreshDatabaseVerbose:NO detailed:YES];
	}
	return self;
}

- (void)awakeFromNib {
	
}

- (BOOL)applicationShouldTerminate:(NSApplication*)app {
	[anidbFacade logout];
	return YES;
}

- (void)dealloc {
	[db closeSavingChanges:YES];
	[anidbFacade release];
	[mylist release];
	[super dealloc];
}

- (IBAction)login:(id)sender {
	if(![anidbFacade login:[preferences valueForKeyPath:@"properties.username"]
			  withPassword:[preferences valueForKeyPath:@"properties.password"]])
		NSRunAlertPanel(@"Login failed", @"Username or password is wrong\nChange it in the settings", @"OK", nil, nil);
	[connectionPanel viewsNeedDisplay];
}

- (IBAction)logout:(id)sender {
	[anidbFacade logout];
	[connectionPanel viewsNeedDisplay];
}

- (IBAction)saveProperties:(id)sender {
	[preferences setProperties:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[username stringValue], [password stringValue], nil]
														   forKeys:[NSArray arrayWithObjects:@"username", @"password", nil]]];
	[preferences persistPreferences];
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;	
    if (commandSelector == @selector(insertNewline:)) {
		//ADBAnime* tempAnime = [anidbFacade findAnimeByName:[control stringValue]];
		
		result = YES;
    }
    return result;
}

- (ADBConnection*)connection {
	return [anidbFacade connection];
}

- (KNPreferences*)preferences {
	return preferences;
}

- (NSMutableArray*)mylist {
	return mylist;
}

- (void)setMylist:(NSArray*)newMylist {
	if(mylist != newMylist)
	{
		[mylist release];
		mylist = [[NSMutableArray alloc] initWithArray:newMylist];
		[mylist retain];
	}
}

- (NSMutableArray*)animeFound {
	return animeFound;
}

- (void)setAnimeFound:(NSArray*)newAnimeFound {
	if(animeFound != newAnimeFound)
	{
		[animeFound release];
		animeFound = [[NSMutableArray alloc] initWithArray:newAnimeFound];
		[animeFound retain];
	}
}

- (BOOL)createDatabaseVerbose:(BOOL)verbose{
	NSArray* tables = [NSArray arrayWithObjects:@"mylist", @"groups", @"anime", @"episodes", @"files", nil];
	
	for (int i = 0; i < [tables count]; i++)
	{
		[db dropTable:[tables objectAtIndex:i]];
		if (verbose) NSLog(@"Table \"%@\" dropped", [tables objectAtIndex:i]);
	}
	
	NSArray* columns   = [NSArray arrayWithObjects:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBMylistEntryKeyArray],
						  [[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBGroupKeyArray],
						  [[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBAnimeKeyArray],
						  [[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBEpisodeKeyArray],
						  [[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBFileKeyArray]];
	
	NSArray* datatypes = [NSArray arrayWithObjects:[[NSArray arrayWithObject:QLRecordUIDDatatype] arrayByAddingObjectsFromArray:ADBMylistEntryDatatypeArray],
						  [[NSArray arrayWithObject:QLRecordUIDDatatype] arrayByAddingObjectsFromArray:ADBGroupDatatypeArray],
						  [[NSArray arrayWithObject:QLRecordUIDDatatype] arrayByAddingObjectsFromArray:ADBAnimeDatatypeArray],
						  [[NSArray arrayWithObject:QLRecordUIDDatatype] arrayByAddingObjectsFromArray:ADBEpisodeDatatypeArray],
						  [[NSArray arrayWithObject:QLRecordUIDDatatype] arrayByAddingObjectsFromArray:ADBFileDatatypeArray]];
	if (verbose)
		for (int i = 0; i < [tables count]; i++)
			NSLog(@"%@: (%d:%d) (columns:datatypes)", [tables objectAtIndex:i], [[columns objectAtIndex:i] count], [[datatypes objectAtIndex:i] count]);
	
	[db beginTransaction];
	
	for (int i = 0; i < [tables count]; i++)
	{
		[db createTable:[tables objectAtIndex:i] withColumns:[columns objectAtIndex:i] andDatatypes:[datatypes objectAtIndex:i]];
		if (verbose) NSLog(@"Table \"%@\" created", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Testing table \"%@\": %@", [tables objectAtIndex:i], [db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
	}
	
	//dummy data
	if ([anidbFacade login:[preferences valueForKeyPath:@"properties.username"] withPassword:[preferences valueForKeyPath:@"properties.password"]]) {
		NSArray* mylistIDs = [NSArray arrayWithObjects:@"60787305", @"60787306", @"60787307", @"60787308", @"60787309", @"60786550", nil];
		NSMutableDictionary* anime = [NSMutableDictionary dictionary];
		
		ADBMylistEntry* tempMylistEntry = nil;
		
		for (int i = 0; i < [mylistIDs count]; i++) {
			tempMylistEntry = [anidbFacade findMylistEntryByID:[mylistIDs objectAtIndex:i]];
			//getAnime
			
		}
	}
	
	[db commitTransaction];
	return YES;
}

- (void)refreshDatabaseVerbose:(BOOL)verbose detailed:(BOOL)detailed {
	[self setMylist:[NSArray array]];
}
@end
