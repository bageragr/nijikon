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
		preferences = [KNPreferences preferenceWithPath:[@"~/Library/Application Support/Nijikon/nijikon.prefs" stringByExpandingTildeInPath]];
		db = [[QuickLiteDatabase databaseWithFile:[[[preferences valueForKeyPath:@"att.databasePath"] stringByExpandingTildeInPath] stringByAppendingPathComponent:[preferences valueForKeyPath:@"att.databaseFile"]]] retain];
		[db open];//:NO cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:YES];
		anidbFacade = [[ADBCachedFacade cachedFacadeWithHost:[NSHost hostWithName:[preferences valueForKeyPath:@"att.server"]] remotePort:[[preferences valueForKeyPath:@"att.remotePort"] intValue] andLocalPort:[[preferences valueForKeyPath:@"att.localPort"] intValue]] retain];
		
		//[self fillDatabaseWithMylistExport:[ADBMylistExport mylistExportWithPath:[@"~/Downloads/mylist.xml" stringByExpandingTildeInPath]]];
		[self fillMylistVerbose:NO];
	}
	return self;
}

- (void)awakeFromNib {
	[mylistOutline needsDisplay];
	[byAnimeOutline needsDisplay];
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
	[mylistOutline needsDisplay];
	[byAnimeOutline needsDisplay];
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;	
    if (commandSelector == @selector(insertNewline:)) {
		[self setAnimeFound:[anidbFacade findAnimeByName:[control stringValue]]];
		[mainWindow viewsNeedDisplay];
		result = YES;
    }
    return result;
}

- (ADBFacade*)facade {
	return anidbFacade;
}

- (KNPreferences*)preferences {
	return preferences;
}

- (NSArray*)byMylist {
	byMylist = [NSMutableArray array];
	NSArray* watched = [NSArray array];
	NSArray* have = [NSArray array];
	ADBMylistEntry* mylistEntry = nil;
	KNNode* mylistEntryNode = nil;
	KNNode* groupNode = nil;
	KNNode* animeNode = nil;
	KNNode* episodeNode = nil;
	KNNode* fileNode = nil;
	
	for (int i = 0; i < [mylist count]; i++) {
		mylistEntry = [mylist objectAtIndex:i];
		watched = [self getWatched:[mylistEntry group]];
		have = [self getHave:[mylistEntry group]];
		groupNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Group", @"Type for ADBGroup nodes"), 
																					[mylistEntry valueForKeyPath:@"group.att.name"],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:KNNodeKeyArray] representedObject:[mylistEntry group] andIsLeaf:YES];
		watched = [self getWatched:[mylistEntry anime]];
		have = [self getHave:[mylistEntry anime]];
		animeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Anime", @"Type for ADBAnime nodes"), 
																					[mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:KNNodeKeyArray] representedObject:[mylistEntry anime] andIsLeaf:YES];
		watched = [self getWatched:[mylistEntry episode]];
		have = [self getHave:[mylistEntry episode]];
		episodeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Episode", @"Type for ADBEpisode nodes"), 
																					  [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"episode.att.%@", [preferences valueForKeyPath:@"att.episodeName"]]],
																					  [watched objectAtIndex:0],
																					  [watched objectAtIndex:1],
																					  [have objectAtIndex:0],
																					  [have objectAtIndex:1], nil]
																			 forKeys:KNNodeKeyArray] representedObject:[mylistEntry episode] andIsLeaf:YES];
		watched = [self getWatched:mylistEntry];
		have = [self getHave:mylistEntry];
		fileNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"File", @"Type for ADBFile nodes"), 
																				   [NSString stringWithFormat:@"f%@", [mylistEntry valueForKeyPath:@"file.att.fileID"]],
																				   [watched objectAtIndex:0],
																				   [watched objectAtIndex:1],
																				   [have objectAtIndex:0],
																				   [have objectAtIndex:1], nil]
																		  forKeys:KNNodeKeyArray] representedObject:[mylistEntry file] andIsLeaf:YES];
		mylistEntryNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Mylist entry", @"Type for ADBMylistEntry nodes"), 
																						  [NSString stringWithFormat:NSLocalizedString(@"%@ - %@ (by %@)", @"Name for ADBMylistEntry nodes (<Anime> - <Epnumber> (by <Group>))"),
																						   [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																						   [mylistEntry valueForKeyPath:@"episode.att.epnumber"],
																						   [mylistEntry valueForKeyPath:@"group.att.name"]],
																						  [watched objectAtIndex:0],
																						  [watched objectAtIndex:1],
																						  [have objectAtIndex:0],
																						  [have objectAtIndex:1], nil]
																				 forKeys:KNNodeKeyArray] representedObject:mylistEntry andIsLeaf:NO];
		[mylistEntryNode setChildren:[NSArray arrayWithObjects:groupNode, animeNode, episodeNode, fileNode, nil]];
		[byMylist addObject:mylistEntryNode];
	}
	
	NSLog (@"byMylist refreshed");
	return byMylist;
}

- (NSArray*)byAnime {
	byAnime = [NSMutableArray array];
	NSArray* watched = [NSArray array];
	NSArray* have = [NSArray array];
	ADBMylistEntry* mylistEntry = nil;
	ADBAnime* anime = nil;
	ADBGroup* group = nil;
	ADBEpisode* episode = nil;
	KNNode* animeNode = nil;
	KNNode* groupNode = nil;
	KNNode* episodeNode = nil;
	KNNode* fileNode = nil;
	
	BOOL doContinue = NO;
	for (int i = 0; i < [mylist count]; i++) {
		mylistEntry = [mylist objectAtIndex:i];
		doContinue = NO;
		for (int j = 0; j < [byAnime count]; j++)
			if ([[[byAnime objectAtIndex:j] representedObject] isEqualTo:[mylistEntry anime]])
				doContinue = YES;
		if (doContinue)
			continue;
		
		anime = [mylistEntry anime];
		watched = [self getWatched:anime];
		have = [self getHave:anime];
		animeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Anime", @"Type for ADBAnime nodes"), 
																					[anime valueForKeyPath:[NSString stringWithFormat:@"att.romaji"/*, [preferences valueForKeyPath:@"att.animeName"]*/]],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:KNNodeKeyArray] representedObject:anime andIsLeaf:NO];
		for (int j = 0; j < [mylist count]; j++) {
			mylistEntry = [mylist objectAtIndex:j];
			if ([[mylistEntry anime] isEqualTo:anime]) {
				doContinue = NO;
				for (int k = 0; k < [[animeNode children] count]; k++)
					if ([[[[animeNode children] objectAtIndex:k] representedObject] isEqualTo:[mylistEntry group]])
						doContinue = YES;
				if (doContinue)
					continue;
				
				group = [mylistEntry group];
				watched = [self getWatched:group];
				have = [self getHave:group];
				groupNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Group", @"Type for ADBGroup nodes"), 
																							[group valueForKeyPath:@"att.name"],
																							[watched objectAtIndex:0],
																							[watched objectAtIndex:1],
																							[have objectAtIndex:0],
																							[have objectAtIndex:1], nil]
																				   forKeys:KNNodeKeyArray] representedObject:group andIsLeaf:NO];
				for (int k = 0; k < [mylist count]; k++) {
					mylistEntry = [mylist objectAtIndex:k];
					if ([[mylistEntry group] isEqualTo:group]) {
						doContinue = NO;
						for (int l = 0; l < [[groupNode children] count]; l++)
							if ([[[[groupNode children] objectAtIndex:l] representedObject] isEqualTo:[mylistEntry episode]])
								doContinue = YES;
						if (doContinue)
							continue;
						
						episode = [mylistEntry episode];
						watched = [self getWatched:episode];
						have = [self getHave:episode];
						episodeNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Episode", @"Type for ADBEpisode nodes"), 
																									  [NSString stringWithFormat:@"%@ - %@", [episode valueForKeyPath:@"att.epnumber"], [episode valueForKeyPath:[NSString stringWithFormat:@"att.%@", [preferences valueForKeyPath:@"att.episodeName"]]]],
																									  [watched objectAtIndex:0],
																									  [watched objectAtIndex:1],
																									  [have objectAtIndex:0],
																									  [have objectAtIndex:1], nil]
																							 forKeys:KNNodeKeyArray] representedObject:episode andIsLeaf:NO];
						for (int l = 0; l < [mylist count]; l++)
							if ([[[mylist objectAtIndex:l] anime] isEqualTo:anime] && [[[mylist objectAtIndex:l] group] isEqualTo:group] && [[[mylist objectAtIndex:l] episode] isEqualTo:episode]) {
								watched = [self getWatched:[mylist objectAtIndex:l]];
								have = [self getHave:[mylist objectAtIndex:l]];
								fileNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"File", @"Type for ADBFile nodes"), 
																										   [NSString stringWithFormat:@"f%@", [[mylist objectAtIndex:l] valueForKeyPath:@"file.att.fileID"]],
																										   [watched objectAtIndex:0],
																										   [watched objectAtIndex:1],
																										   [have objectAtIndex:0],
																										   [have objectAtIndex:1], nil]
																								  forKeys:KNNodeKeyArray] representedObject:[[mylist objectAtIndex:l] file] andIsLeaf:YES];
								[[episodeNode children] addObject:fileNode];
							}
						[[groupNode children] addObject:episodeNode];
					}
				}
				[[animeNode children] addObject:groupNode];
			}
		}
		[byAnime addObject:animeNode];
	}
	
	NSLog (@"byAnime refreshed");
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

- (ADBAnime*)animeFound {
	return animeFound;
}

- (void)setAnimeFound:(ADBAnime*)newAnimeFound {
	if(animeFound != newAnimeFound)
	{
		[animeFound release];
		animeFound = [newAnimeFound retain];
	}
}

- (NSArray*)getWatched:(ADBObject*)adbObject {
	int watched = 0;
	int maxWatched = 0;
	if ([adbObject isKindOfClass:[ADBMylistEntry class]]) {
		watched = (int)([[adbObject valueForKeyPath:@"att.viewdate"] intValue] > 0);
		maxWatched = 1;
	}
	if ([adbObject isKindOfClass:[ADBFile class]]) {
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] file] isEqualTo:adbObject]) {
				watched = [[[self getWatched:[mylist objectAtIndex:i]] objectAtIndex:0] intValue];
				maxWatched = 1;
			}
	}
	if ([adbObject isKindOfClass:[ADBEpisode class]]) {
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] episode] isEqualTo:adbObject]) {
				watched += [[[self getWatched:[mylist objectAtIndex:i]] objectAtIndex:0] intValue];
				maxWatched++;
			}
	}
	if ([adbObject isKindOfClass:[ADBAnime class]]) {
		NSMutableArray* episodes = [NSMutableArray array];
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] anime] isEqualTo:adbObject])
				if (![episodes containsObject:[[mylist objectAtIndex:i] episode]]) {
					[episodes addObject:[[mylist objectAtIndex:i] episode]];
					watched += (int)([[[self getWatched:[[mylist objectAtIndex:i] episode]] objectAtIndex:0] intValue] > 0);
					maxWatched++;
				}
	}
	return [NSArray arrayWithObjects:[NSNumber numberWithInt:watched], [NSNumber numberWithInt:maxWatched], nil];
}

- (NSArray*)getHave:(ADBObject*)adbObject {
	int have = 0;
	int maxHave = 1;
	if ([adbObject isKindOfClass:[ADBMylistEntry class]]) {
		have = (int)([[adbObject valueForKeyPath:@"att.state"] intValue] == 0 || [[adbObject valueForKeyPath:@"att.state"] intValue] == 1 || [[adbObject valueForKeyPath:@"att.state"] intValue] == 2);
	}
	if ([adbObject isKindOfClass:[ADBFile class]]) {
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] file] isEqualTo:adbObject]) {
				have = [[[self getHave:[mylist objectAtIndex:i]] objectAtIndex:0] intValue];
			}
	}
	if ([adbObject isKindOfClass:[ADBEpisode class]]) {
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] episode] isEqualTo:adbObject]) {
				have = 1;
				break;
			}
	}
	if ([adbObject isKindOfClass:[ADBAnime class]]) {
		NSMutableArray* episodes = [NSMutableArray array];
		for (int i = 0; i < [mylist count]; i++)
			if ([[[mylist objectAtIndex:i] anime] isEqualTo:adbObject])
				if (![episodes containsObject:[[mylist objectAtIndex:i] episode]] && [[[mylist objectAtIndex:i] episode] isNormal]) {
					[episodes addObject:[[mylist objectAtIndex:i] episode]];
					have++;
				}
		maxHave = [[adbObject valueForKeyPath:@"att.nEps"] intValue];
		
	}
	if ([adbObject isKindOfClass:[ADBGroup class]])
		maxHave = 0;
	return [NSArray arrayWithObjects:[NSNumber numberWithInt:have], [NSNumber numberWithInt:maxHave], nil];
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
	
	[db commitTransaction];
	return YES;
}

- (void)fillDatabaseWithMylistExport:(ADBMylistExport*)mylistExport {
	if ([anidbFacade login:[preferences valueForKeyPath:@"att.username"] withPassword:[preferences valueForKeyPath:@"att.password"]]) {
		NSArray* mylistIDs = [mylistExport mylistIDs];
		NSLog(@"%@", mylistIDs);
		
		ADBMylistEntry* temp = nil;
		
		for (int i = 0; i < [mylistIDs count]; i++) {
			temp = [anidbFacade findMylistEntryByID:[mylistIDs objectAtIndex:i]];
			NSLog(@"MylistEntry (l%@)", [temp valueForKeyPath:@"att.mylistID"]);
			[temp setGroup:[anidbFacade findGroupByID:[temp valueForKeyPath:@"att.groupID"]]];
			[temp setAnime:[anidbFacade findAnimeByID:[temp valueForKeyPath:@"att.animeID"]]];
			[temp setEpisode:[anidbFacade findEpisodeByID:[temp valueForKeyPath:@"att.episodeID"]]];
			[temp setFile:[anidbFacade findFileByID:[temp valueForKeyPath:@"att.fileID"]]];
			[temp insertIntoDatabase:db];
		}
	}
	[anidbFacade logout];
}

- (void)fillMylistVerbose:(BOOL)verbose {
	[self setMylist:[NSMutableArray array]];
	
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
		if (verbose) NSLog(@"MylistEntry: (l%@)", [temp valueForKeyPath:@"att.mylistID"]);
		[temp setGroup:[cache valueForKey:[NSString stringWithFormat:@"groups(%@)", [temp valueForKeyPath:@"att.groupID"]]]];
		if (verbose) NSLog(@"	Group: %@ (g%@)", [temp valueForKeyPath:@"group.att.name"], [temp valueForKeyPath:@"group.att.groupID"]);
		[temp setAnime:[cache valueForKey:[NSString stringWithFormat:@"anime(%@)", [temp valueForKeyPath:@"att.animeID"]]]];
		if (verbose) NSLog(@"	Anime: %@ (a%@)", [temp valueForKeyPath:@"anime.att.romaji"], [temp valueForKeyPath:@"anime.att.animeID"]);
		[temp setEpisode:[cache valueForKey:[NSString stringWithFormat:@"episodes(%@)", [temp valueForKeyPath:@"att.episodeID"]]]];
		if (verbose) NSLog(@"	Episode: %@ (e%@)", [temp valueForKeyPath:@"episode.att.romaji"], [temp valueForKeyPath:@"episode.att.episodeID"]);
		[temp setFile:[cache valueForKey:[NSString stringWithFormat:@"files(%@)", [temp valueForKeyPath:@"att.fileID"]]]];
		if (verbose) NSLog(@"	File: (f%@)", [temp valueForKeyPath:@"file.att.fileID"]);
		[mylist addObject:temp];
	}
}

@end
