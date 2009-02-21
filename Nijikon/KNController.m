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
		db = [[QuickLiteDatabase databaseWithFile:[path stringByAppendingString:@"/nijikon.db"]] retain];
		[db open];//:NO cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:YES];
		anidbFacade = [[[ADBCachedFacade alloc] init] retain];
		
		/*if([anidbFacade login:[preferences valueForKeyPath:@"properties.username"] withPassword:[preferences valueForKeyPath:@"properties.password"]]) {
			[[anidbFacade findAnimeByID:@"61"] insertIntoDatabase:db];
			[anidbFacade logout];
		}*/
		
		//[self createDatabaseVerbose:NO];
		[self fillMylistVerbose:NO];
	}
	return self;
}

- (void)awakeFromNib {
	
}

- (BOOL)applicationShouldTerminate:(NSApplication*)app {
	if ([db isDatabaseOpen])
		[db closeSavingChanges:YES];
	[anidbFacade logout];
	return YES;
}

- (void)dealloc {
	[db release];
	[anidbFacade release];
	[mylist release];
	[byMylist release];
	[byAnime release];
	[super dealloc];
}

- (IBAction)login:(id)sender {
	if(![anidbFacade login:[preferences valueForKeyPath:@"att.username"]
			  withPassword:[preferences valueForKeyPath:@"att.password"]])
		NSRunAlertPanel(@"Login failed", @"Username or password is wrong\nChange it in the settings", @"OK", nil, nil);
}

- (IBAction)logout:(id)sender {
	[anidbFacade logout];
}

- (IBAction)saveProperties:(id)sender {
	[preferences persistPreferences];
	[mainWindow viewsNeedDisplay];
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

- (NSArray*)byMylist {
	NSLog (@"byMylist refreshed");
	byMylist = [NSMutableArray array];
	int watched = 0;
	int maxWatched = 0;
	ADBMylistEntry* mylistEntry = nil;
	KNNode* mylistEntryNode = nil;
	KNNode* groupNode = nil;
	KNNode* animeNode = nil;
	KNNode* episodeNode = nil;
	KNNode* fileNode = nil;
	
	for (int i = 0; i < [mylist count]; i++) {
		mylistEntry = [mylist objectAtIndex:i];	
		watched = 0;
		maxWatched = 0;
		for (int j = 0; j < [mylist count]; j++)
			if ([(NSString*)[[mylist objectAtIndex:j] valueForKeyPath:@"att.groupID"] isEqualToString:[mylistEntry valueForKeyPath:@"att.groupID"]]) {
				watched += (int)([[[mylist objectAtIndex:j] valueForKeyPath:@"att.viewdate"] intValue] > 0);
				maxWatched++;
			}
		groupNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Group", @"Type for ADBGroup nodes"), 
																					[mylistEntry valueForKeyPath:@"group.att.name"],
																					[NSNumber numberWithInt:watched],
																					[NSNumber numberWithInt:maxWatched], nil]
																		   forKeys:KNNodeKeyArray] representedObject:[mylistEntry group] andIsLeaf:YES];
		watched = 0;
		maxWatched = 0;
		for (int j = 0; j < [mylist count]; j++)
			if ([(NSString*)[[mylist objectAtIndex:j] valueForKeyPath:@"att.animeID"] isEqualToString:[mylistEntry valueForKeyPath:@"att.animeID"]]) {
				watched += (int)([[[mylist objectAtIndex:j] valueForKeyPath:@"att.viewdate"] intValue] > 0);
				maxWatched++;
			}
		animeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Anime", @"Type for ADBAnime nodes"), 
																					[mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																					[NSNumber numberWithInt:watched],
																					[NSNumber numberWithInt:maxWatched], nil]
																		   forKeys:KNNodeKeyArray] representedObject:[mylistEntry anime] andIsLeaf:YES];
		watched = 0;
		maxWatched = 0;
		for (int j = 0; j < [mylist count]; j++)
			if ([(NSString*)[[mylist objectAtIndex:j] valueForKeyPath:@"att.episodeID"] isEqualToString:[mylistEntry valueForKeyPath:@"att.episodeID"]]) {
				watched += (int)([[[mylist objectAtIndex:j] valueForKeyPath:@"att.viewdate"] intValue] > 0);
				maxWatched++;
			}
		episodeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Episode", @"Type for ADBEpisode nodes"), 
																					  [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"episode.att.%@", [preferences valueForKeyPath:@"att.episodeName"]]],
																					  [NSNumber numberWithInt:watched],
																					  [NSNumber numberWithInt:maxWatched], nil]
																			 forKeys:KNNodeKeyArray] representedObject:[mylistEntry episode] andIsLeaf:YES];
		watched = (int)([[mylistEntry valueForKeyPath:@"att.viewdate"] intValue] > 0);
		maxWatched = 1;
		fileNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"File", @"Type for ADBFile nodes"), 
																				   [NSString stringWithFormat:@"f%@", [mylistEntry valueForKeyPath:@"file.att.fileID"]],
																				   [NSNumber numberWithInt:watched],
																				   [NSNumber numberWithInt:maxWatched], nil]
																		  forKeys:KNNodeKeyArray] representedObject:[mylistEntry file] andIsLeaf:YES];
		mylistEntryNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Mylist entry", @"Type for ADBMylistEntry nodes"), 
																						  [NSString stringWithFormat:NSLocalizedString(@"%@ - %@ (by %@)", @"Name for ADBMylistEntry nodes (<Anime> - <Epnumber> (by <Group>))"),
																						   [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																						   [mylistEntry valueForKeyPath:@"episode.att.epnumber"],
																						   [mylistEntry valueForKeyPath:@"group.att.name"]],
																						  [NSNumber numberWithInt:watched],
																						  [NSNumber numberWithInt:maxWatched], nil]
																				 forKeys:KNNodeKeyArray] representedObject:mylistEntry andIsLeaf:NO];
		[mylistEntryNode setChildren:[NSArray arrayWithObjects:groupNode, animeNode, episodeNode, fileNode, nil]];
		[byMylist addObject:mylistEntryNode];
	}
	return byMylist;
}

- (NSArray*)byAnime {
	NSLog (@"byAnime refreshed");
	byAnime = [NSMutableArray array];
	int watched = 0;
	int maxWatched = 0;
	ADBMylistEntry* mylistEntry = nil;
	KNNode* mylistEntryNode = nil;
	KNNode* groupNode = nil;
	KNNode* animeNode = nil;
	KNNode* episodeNode = nil;
	KNNode* fileNode = nil;
	
	return byAnime;
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

- (BOOL)createDatabaseVerbose:(BOOL)verbose {
	NSArray* tables = [NSArray arrayWithObjects:@"mylist", @"groups", @"anime", @"episodes", @"files", nil];
	
	[db beginTransaction];
	
	for (int i = 0; i < [tables count]; i++) {
		[db dropTable:[tables objectAtIndex:i]];
		if (verbose) NSLog(@"Table \"%@\" dropped", [tables objectAtIndex:i]);
	}
	
	NSArray* columns   = [NSArray arrayWithObjects:ADBMylistEntryColumnArray, ADBGroupColumnArray, ADBAnimeColumnArray, ADBEpisodeColumnArray, ADBFileColumnArray, nil];
	NSArray* datatypes = [NSArray arrayWithObjects:ADBMylistEntryDatatypeArray, ADBGroupDatatypeArray, ADBAnimeDatatypeArray, ADBEpisodeDatatypeArray, ADBFileDatatypeArray, nil];
	
	if (verbose)
		for (int i = 0; i < [tables count]; i++)
			NSLog(@"%@: (%d:%d) (columns:datatypes)", [tables objectAtIndex:i], [[columns objectAtIndex:i] count], [[datatypes objectAtIndex:i] count]);
	
	for (int i = 0; i < [tables count]; i++) {
		[db createTable:[tables objectAtIndex:i] withColumns:[columns objectAtIndex:i] andDatatypes:[datatypes objectAtIndex:i]];
		if (verbose) NSLog(@"Table \"%@\" created", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Testing table \"%@\": %@", [tables objectAtIndex:i], [db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
	}
	
	[db insertValues:[NSArray arrayWithObjects:[NSNull null], @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil]
		  forColumns:ADBAnimeColumnArray inTable:@"anime"];
	if (verbose) NSLog(@"Testing table \"%@\": %@", @"anime", [db performQuery:[NSString stringWithFormat:@"select * from %@", @"anime"] cacheMethod:DoNotCacheData]);
	
	//dummy data
	if ([anidbFacade login:[preferences valueForKeyPath:@"att.username"] withPassword:[preferences valueForKeyPath:@"att.password"]]) {
		NSArray* mylistIDs = [NSArray arrayWithObjects:@"60787305", @"60787306", @"60787307", @"60787308", @"60787309", @"60786550", nil];
		
		ADBMylistEntry* temp = nil;
		
		for (int i = 0; i < [mylistIDs count]; i++) {
			temp = [anidbFacade findMylistEntryByID:[mylistIDs objectAtIndex:i]];
			if (verbose) NSLog(@"MylistEntry: lid=%@", [temp valueForKeyPath:@"att.mylistID"]);
			[temp setGroup:[anidbFacade findGroupByID:[temp valueForKeyPath:@"att.groupID"]]];
			if (verbose) NSLog(@"	Group: %@", [temp valueForKeyPath:@"group.att.name"]);
			[temp setAnime:[anidbFacade findAnimeByID:[temp valueForKeyPath:@"att.animeID"]]];
			if (verbose) NSLog(@"	Anime: %@", [temp valueForKeyPath:@"anime.att.romaji"]);
			[temp setEpisode:[anidbFacade findEpisodeByID:[temp valueForKeyPath:@"att.episodeID"]]];
			if (verbose) NSLog(@"	Episode: %@", [temp valueForKeyPath:@"episode.att.romaji"]);
			[temp setFile:[anidbFacade findFileByID:[temp valueForKeyPath:@"att.fileID"]]];
			if (verbose) NSLog(@"	File: %@", [temp valueForKeyPath:@"file.att.filename"]);
			[temp insertIntoDatabase:db];
		}
	}
	
	[db commitTransaction];
	[db closeSavingChanges:YES];
	[anidbFacade logout];
	return YES;
}

- (void)fillMylistVerbose:(BOOL)verbose {
	[self setMylist:[NSMutableArray array]];
	
	//See ADBCachedFacade -init
	NSMutableDictionary* cache = [NSMutableDictionary dictionary];
	QuickLiteCursor* cursor;
	ADBMylistEntry* temp;
	
	NSArray* tables = [NSArray arrayWithObjects:@"groups", @"anime", @"episodes", @"files", nil];
	for (int i = 0; i < [tables count]; i++) {
		cursor = [db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData];
		for (int j = 0; j < [cursor rowCount]; j++) {
			if ([(NSString*)[tables objectAtIndex:i] isEqualToString:@"groups"])
				[cache setValue:[ADBGroup groupWithQuickliteRow:[cursor rowAtIndex:j]] forKey:[NSString stringWithFormat:@"%@(%@)", [tables objectAtIndex:i], [[ADBGroup groupWithQuickliteRow:[cursor rowAtIndex:j]] valueForKeyPath:@"att.groupID"]]];
			if ([(NSString*)[tables objectAtIndex:i] isEqualToString:@"anime"])
				[cache setValue:[ADBAnime animeWithQuickliteRow:[cursor rowAtIndex:j]] forKey:[NSString stringWithFormat:@"%@(%@)", [tables objectAtIndex:i], [[ADBAnime animeWithQuickliteRow:[cursor rowAtIndex:j]] valueForKeyPath:@"att.animeID"]]];
			if ([(NSString*)[tables objectAtIndex:i] isEqualToString:@"episodes"])
				[cache setValue:[ADBEpisode episodeWithQuickliteRow:[cursor rowAtIndex:j]] forKey:[NSString stringWithFormat:@"%@(%@)", [tables objectAtIndex:i], [[ADBEpisode episodeWithQuickliteRow:[cursor rowAtIndex:j]] valueForKeyPath:@"att.episodeID"]]];
			if ([(NSString*)[tables objectAtIndex:i] isEqualToString:@"files"])
				[cache setValue:[ADBFile fileWithQuickliteRow:[cursor rowAtIndex:j]] forKey:[NSString stringWithFormat:@"%@(%@)", [tables objectAtIndex:i], [[ADBFile fileWithQuickliteRow:[cursor rowAtIndex:j]] valueForKeyPath:@"att.fileID"]]];
		}
	}
	
	cursor = [db performQuery:@"select * from mylist" cacheMethod:DoNotCacheData];
	for (int i = 0; i < [cursor rowCount]; i++) {
		temp = [ADBMylistEntry mylistEntryWithQuickliteRow:[cursor rowAtIndex:i]];
		if (verbose) NSLog(@"MylistEntry: lid=%@", [temp valueForKeyPath:@"att.mylistID"]);
		[temp setGroup:[cache valueForKey:[NSString stringWithFormat:@"groups(%@)", [temp valueForKeyPath:@"att.groupID"]]]];
		if (verbose) NSLog(@"	Group: %@", [temp valueForKeyPath:@"group.att.name"]);
		[temp setAnime:[cache valueForKey:[NSString stringWithFormat:@"anime(%@)", [temp valueForKeyPath:@"att.animeID"]]]];
		if (verbose) NSLog(@"	Anime: %@", [temp valueForKeyPath:@"anime.att.romaji"]);
		[temp setEpisode:[cache valueForKey:[NSString stringWithFormat:@"episodes(%@)", [temp valueForKeyPath:@"att.episodeID"]]]];
		if (verbose) NSLog(@"	Episode: %@", [temp valueForKeyPath:@"episode.att.romaji"]);
		[temp setFile:[cache valueForKey:[NSString stringWithFormat:@"files(%@)", [temp valueForKeyPath:@"att.fileID"]]]];
		if (verbose) NSLog(@"	File: %@", [temp valueForKeyPath:@"file.att.filename"]);
		[mylist addObject:temp];
	}
}

@end
