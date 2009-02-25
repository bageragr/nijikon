//
//  KNController.m
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "PLController.h"


@implementation PLController
- (id)init {
	if(self = [super init])
	{
		preferences = [PLPreferences preferenceWithPath:[@"~/Library/Application Support/Nijikon/nijikon.prefs" stringByExpandingTildeInPath]];
		db = [[QuickLiteDatabase databaseWithFile:[[[preferences valueForKeyPath:@"att.databasePath"] stringByExpandingTildeInPath] stringByAppendingPathComponent:[preferences valueForKeyPath:@"att.databaseFile"]]] retain];
		[db open];//:NO cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:YES];
		anidbFacade = [[ADBCachedFacade cachedFacadeWithHost:[NSHost hostWithName:[preferences valueForKeyPath:@"att.server"]] remotePort:[[preferences valueForKeyPath:@"att.remotePort"] intValue] andLocalPort:[[preferences valueForKeyPath:@"att.localPort"] intValue]] retain];
		
		[self createDatabaseVerbose:NO];
		[self fillDatabaseWithMylistExport:[ADBMylistExport mylistExportWithPath:[@"~/Downloads/mylist.xml" stringByExpandingTildeInPath]]];
		[self fillMylistVerbose:NO];
	}
	return self;
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

- (PLPreferences*)preferences {
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
