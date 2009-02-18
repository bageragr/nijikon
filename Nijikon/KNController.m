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
		db = [[QuickLiteDatabase databaseWithFile:[path stringByAppendingString:@"/nijikon.db"]] retain];
		[db open];//:NO cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:YES];
		anidbFacade = [[[ADBCachedFacade alloc] init] retain];
		
		/*if([anidbFacade login:[preferences valueForKeyPath:@"properties.username"] withPassword:[preferences valueForKeyPath:@"properties.password"]]) {
			[[anidbFacade findAnimeByID:@"61"] insertIntoDatabase:db];
			[anidbFacade logout];
		}*/
		[self createDatabaseVerbose:YES];
		//[self fillMylist];
	}
	return self;
}

- (void)awakeFromNib {
	
}

- (BOOL)applicationShouldTerminate:(NSApplication*)app {
	[anidbFacade logout];
	[db closeSavingChanges:YES];
	return YES;
}

- (void)dealloc {
	[db release];
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

- (NSArray*)byMylist {
	if ((byMylist == nil) || ([byMylist count] != [mylist count])) {
		NSMutableArray* groups = [NSMutableArray array];
		NSMutableArray* anime = [NSMutableArray array];
		NSMutableArray* episodes = [NSMutableArray array];
		NSMutableArray* files = [NSMutableArray array];
		byMylist = [NSMutableArray array];
		KNNode* mylistEntryNode = nil;
		
		for (int i = 0; i < [mylist count]; i++) {
			if (![groups containsObject:[[mylist objectAtIndex:i] group]])
				[groups addObject:[[mylist objectAtIndex:i] group]];
			if (![anime containsObject:[[mylist objectAtIndex:i] anime]])
				[anime addObject:[[mylist objectAtIndex:i] anime]];
			if (![episodes containsObject:[[mylist objectAtIndex:i] episode]])
				[episodes addObject:[[mylist objectAtIndex:i] episode]];
			if (![files containsObject:[[mylist objectAtIndex:i] file]])
				[files addObject:[[mylist objectAtIndex:i] file]];
			
			mylistEntryNode = [KNNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Mylist entry", @"Type for ADBMylistEntry nodes"), 
																							  @"",
																							  [NSNumber numberWithInt:(int)([[[mylist objectAtIndex:i] valueForKeyPath:@"file.att.watched"] intValue] > 0)],
																							  [NSNumber numberWithInt:1], nil]
																					 forKeys:KNNodeKeyArray] andIsLeaf:NO];
			[byMylist addObject:mylistEntryNode];
		}
	}
	return byMylist;
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
	
	NSArray* columns   = [NSArray arrayWithObjects:ADBMylistEntryKeyArray, ADBGroupKeyArray, ADBAnimeKeyArray, ADBEpisodeKeyArray, ADBFileKeyArray, nil];
	NSArray* datatypes = [NSArray arrayWithObjects:ADBMylistEntryDatatypeArray, ADBGroupDatatypeArray, ADBAnimeDatatypeArray, ADBEpisodeDatatypeArray, ADBFileDatatypeArray, nil];
	
	if (verbose)
		for (int i = 0; i < [tables count]; i++)
			NSLog(@"%@: (%d:%d) (columns:datatypes)", [tables objectAtIndex:i], [[columns objectAtIndex:i] count], [[datatypes objectAtIndex:i] count]);
	
	for (int i = 0; i < [tables count]; i++) {
		[db createTable:[tables objectAtIndex:i] withColumns:[columns objectAtIndex:i] andDatatypes:[datatypes objectAtIndex:i]];
		if (verbose) NSLog(@"Table \"%@\" created", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Testing table \"%@\": %@", [tables objectAtIndex:i], [db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
	}
	
	//dummy data
	if ([anidbFacade login:[preferences valueForKeyPath:@"properties.username"] withPassword:[preferences valueForKeyPath:@"properties.password"]]) {
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
		[anidbFacade logout];
	}
	
	[db commitTransaction];
	return YES;
}

- (void)fillMylist {
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
		NSLog(@"MylistEntry: lid=%@", [temp valueForKeyPath:@"att.mylistID"]);
		[temp setGroup:[cache valueForKey:[NSString stringWithFormat:@"groups(%@)", [temp valueForKeyPath:@"att.groupID"]]]];
		NSLog(@"	Group: %@", [temp valueForKeyPath:@"group.att.name"]);
		[temp setAnime:[cache valueForKey:[NSString stringWithFormat:@"anime(%@)", [temp valueForKeyPath:@"att.animeID"]]]];
		NSLog(@"	Anime: %@", [temp valueForKeyPath:@"anime.att.romaji"]);
		[temp setEpisode:[cache valueForKey:[NSString stringWithFormat:@"episodes(%@)", [temp valueForKeyPath:@"att.episodeID"]]]];
		NSLog(@"	Episode: %@", [temp valueForKeyPath:@"episode.att.romaji"]);
		[temp setFile:[cache valueForKey:[NSString stringWithFormat:@"files(%@)", [temp valueForKeyPath:@"att.fileID"]]]];
		NSLog(@"	File: %@", [temp valueForKeyPath:@"file.att.filename"]);
		[mylist addObject:temp];
	}
}

@end
