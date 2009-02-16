//
//  KNController.m
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "KNController.h"


@implementation KNController
- (id)init
{
	if(self = [super init])
	{
		path = [@"~/Library/Application Support/Nijikon" stringByExpandingTildeInPath];
		preferences = [KNPreferences preferenceWithPath:[path stringByAppendingString:@"/nijikon.prefs"]];
		db = nil;
		anidbFacade = [[[ADBFacade alloc] init] retain];
		//[anidbFacade login:@"pipelynx" withPassword:@"53-Ln44~"];
		[self setMylist:mylist];
		[self setGroups:groups];
		[self setAnime:anime];
		[self setAnimeFound:animeFound];
		modal = NO;
		
		/*NSFileManager* fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath:path])
			[fileManager createDirectoryAtPath:path attributes:nil];
		BOOL createDB = NO;
		if (![fileManager fileExistsAtPath:[path stringByAppendingString:@"/database.nijikon"]])
			createDB = YES;
		db = [QuickLiteDatabase databaseWithFile:[path stringByAppendingString:@"/database.nijikon"]];
		[db open];//:YES cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:YES];
		if (createDB)
			[self createDatabase:YES withDummyData:YES];
		[self refreshDatabase:NO detailed:NO];*/
	}
	return self;
}

- (void)awakeFromNib
{
	
}

- (BOOL)applicationShouldTerminate:(NSApplication*)app
{
	[anidbFacade logout];
	return YES;
}

- (void)dealloc
{
	[db closeSavingChanges:YES];
	[anidbFacade release];
	[mylist release];
	[groups release];
	[anime release];
	[super dealloc];
}

- (IBAction)login:(id)sender
{
	[anidbFacade login:@"pipelynx" withPassword:@"53-Ln44~"];
	[connectionPanel viewsNeedDisplay];
}

- (IBAction)logout:(id)sender
{
	[anidbFacade logout];
	[connectionPanel viewsNeedDisplay];
}

- (IBAction)getEpisode:(id)sender
{
	NSLog(@"%@", sender);
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;	
    if (commandSelector == @selector(insertNewline:)) {
		ADBAnime* tempAnime = [anidbFacade findAnimeByName:[control stringValue]];
		//ADBAnime* tempAnime = [anime objectAtIndex:0];
		if (tempAnime != nil)
		{
			ADBEpisode* tempEpisode = nil;
			NSMutableArray* episodes = [NSMutableArray array];
			if (tempAnime == nil)
			{
				[self setAnimeFound:[NSArray array]];
			}
			else
			{
				for (int i = 0; i < [[tempAnime valueForKeyPath:@"properties.nEps"] intValue]; i++)
				{
					tempEpisode = [[ADBEpisode alloc] init];
					[tempEpisode setValue:[NSString stringWithFormat:@"%d", i + 1] forKeyPath:@"properties.epnumber"];
					[tempEpisode setIsLeaf:YES];
					[episodes addObject:tempEpisode];
				}
				[tempAnime setChildren:episodes];
				[self setAnimeFound:[NSArray arrayWithObject:tempAnime]];
			}
		}
		
		result = YES;
    }
    return result;
}

- (ADBConnection*)connection
{
	return [anidbFacade connection];
}

- (NSMutableArray*)mylist
{
	return mylist;
}

- (void)setMylist:(NSArray*)newMylist
{
	if(mylist != newMylist)
	{
		[mylist release];
		mylist = [[NSMutableArray alloc] initWithArray:newMylist];
		[mylist retain];
	}
}

- (NSMutableArray*)anime
{
	return anime;
}

- (void)setAnime:(NSArray*)newAnime
{
	if(anime != newAnime)
	{
		[anime autorelease];
		anime = [[NSMutableArray alloc] initWithArray:newAnime];
		[anime retain];
	}
}

- (NSMutableArray*)groups
{
	return groups;
}

- (void)setGroups:(NSArray*)newGroups
{
	if(groups != newGroups)
	{
		[groups autorelease];
		groups = [[NSMutableArray alloc] initWithArray:newGroups];
		[groups retain];
	}
}

- (NSMutableArray*)animeFound
{
	return animeFound;
}

- (void)setAnimeFound:(NSArray*)newAnimeFound
{
	if(animeFound != newAnimeFound)
	{
		[animeFound release];
		animeFound = [[NSMutableArray alloc] initWithArray:newAnimeFound];
		[animeFound retain];
	}
}

- (BOOL)createDatabase:(BOOL)verbose withDummyData:(BOOL)createDummyData
{
	NSArray* tables = [NSArray arrayWithObjects:@"mylist", @"groups", @"anime", @"episodes", @"files", nil];
	
	NSArray* columns = [NSArray arrayWithObjects:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:ADBMylistEntryKeyArray],
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
			NSLog(@"%@: %d columns and %d datatypes", [tables objectAtIndex:i], [[columns objectAtIndex:i] count], [[datatypes objectAtIndex:i] count]);
	
	[db beginTransaction];
	
	for (int i = 0; i < [tables count]; i++)
	{
		[db createTable:[tables objectAtIndex:i] withColumns:[columns objectAtIndex:i] andDatatypes:[datatypes objectAtIndex:i]];
		 if (verbose) NSLog(@"Table \"%@\" created", [tables objectAtIndex:i]);
	}
	
	if(createDummyData)
	{
		/*//mylist dummy data
		int i = 0;
		if (verbose) NSLog(@"Inserting dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"1", @"443033", @"88811", @"5557", @"4489", @"date", @"state", @"viewdate", @"storage", @"source", @"other", @"filestate", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"1", @"447180", @"88840", @"5557", @"4489", @"date", @"state", @"viewdate", @"storage", @"source", @"other", @"filestate", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if (verbose) NSLog(@"Dummy data for [tables objectAtIndex:i] \"%@\" inserted", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Checking dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"%@",[db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
		
		//groups dummy data
		i = 1;
		if (verbose) NSLog(@"Inserting dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"4489", @"719", @"88", @"5", @"118", @"FTP-Anime Fansubs", @"FTP-A", @"#ftp-anime", @"irc.rizon.net", @"http://www.ftp-anime.com", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"1900", @"706", @"203", @"114", @"1852", @"Blitz-Anime", @"Blitz", @"#Blitz-Anime", @"irc.rizon.net", @"http://www.Blitz-Anime.com", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if (verbose) NSLog(@"Dummy data for [tables objectAtIndex:i] \"%@\" inserted", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Checking dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"%@",[db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
		
		//anime dummy data
		i = 2;
		if (verbose) NSLog(@"Inserting dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"106",@"26",@"26",@"11",@"854",@"5353",@"711",@"473",@"801",@"19",@"2002-2002",@"TV Series",@"Azumanga Daiou",@"あずまんが大王",@"Azumanga Daioh",@"Azu Manga Daioh,아즈망가 대왕,AZ Manga King",@"Адзуманга,AzuDai,Azumanga,azu,AD,Азуманґа",@"阿滋漫画大王,Адзуманга Дайо",@"Manga,High School,Asia,Earth,Present,Slapstick,Comedy,School Life,Seinen,Japan,Daily Life,Coming of Age,Fantasy,Contemporary Fantasy,Stereotypes,Sports,Plot Continuity,Romance",@"description", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"5557",@"24",@"24",@"9",@"723",@"553",@"712",@"256",@"658",@"2",@"2008-2008",@"TV Series",@"Wagaya no Oinari-sama",@"我が家のお稲荷さま。",@"Coo ~ Our Guardian",@"",@"Oinari,Oinarisama,Oinari-sama",@"Wagaya no Oinara-sama,Инари в нашем доме,Інарі нашого дому,我家有个狐仙大人",@"Contemporary Fantasy,Fantasy,Juujin",@"description", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]]);
		if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if (verbose) NSLog(@"Dummy data for [tables objectAtIndex:i] \"%@\" inserted", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Checking dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"%@",[db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
		
		//episodes dummy data
		i = 3;
		if (verbose) NSLog(@"Inserting dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"88811", @"5557", @"24", @"573", @"11", @"1", @"Oinari-sama. Undoing the Seal", @"Oinari-sama. Fuuin tokareru", @"お稲荷さま。封印解かれる", @"07.04.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"88840", @"5557", @"24", @"591", @"7", @"2", @"Oinari-sama. Settling Down In Our Home", @"Oinari-sama. Wagaya ni Sumitsuku", @"お稲荷さま。我が家に住みつく", @"14.04.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"88839", @"5557", @"24", @"648", @"6", @"3", @"Oinari-sama. Goes to School", @"Oinari-sama. Toukou Suru", @"お稲荷さま。登校する", @"21.04.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"88838", @"5557", @"24", @"629", @"5", @"4", @"Oinari-sama. Harvesting", @"Oinari-sama. Shuukaku Suru", @"お稲荷さま。収穫する", @"28.04.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"90431", @"5557", @"24", @"737", @"6", @"5", @"Oinari-sama. Violating a Taboo", @"Oinari-sama. Kinki wo Okasu", @"お稲荷さま。禁忌を侵す", @"5.05.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"90633", @"5557", @"24", @"rate", @"vts", @"6", @"Oinari-sama. Eats A Stomach Full", @"Oinari-sama. Kui Taoreru", @"お稲荷さま。食い倒れる", @"12.05.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"90738", @"5557", @"24", @"rate", @"vts", @"7", @"english", @"Oinari-sama. Kogitsune wo Idaku", @"kanji", @"19.05.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"90851", @"5557", @"24", @"rate", @"vts", @"8", @"english", @"Oinari-sama. Sagashimono Suru", @"kanji", @"26.05.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91116", @"5557", @"24", @"rate", @"vts", @"9", @"english", @"Oinari-sama. Ootachi Mawaru", @"kanji", @"02.06.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91204", @"5557", @"24", @"rate", @"vts", @"10", @"english", @"Oinari-sama. Uragiru!?", @"kanji", @"09.06.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91463", @"5557", @"24", @"rate", @"vts", @"11", @"english", @"Oinari-sama. Houkou ni Deru", @"kanji", @"16.06.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91464", @"5557", @"24", @"rate", @"vts", @"12", @"english", @"Oinari-sama. Ryokou suru", @"kanji", @"23.06.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91465", @"5557", @"24", @"rate", @"vts", @"13", @"english", @"Oinari-sama. Joshikousei ni naru", @"kanji", @"30.06.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91466", @"5557", @"24", @"rate", @"vts", @"14", @"english", @"Oinari-sama. Denwa wo kakeru", @"kanji", @"7.07.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91988", @"5557", @"24", @"rate", @"vts", @"15", @"english", @"Oinari-sama. Kyoukai he iku", @"kanji", @"14.07.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"91989", @"5557", @"24", @"rate", @"vts", @"16", @"english", @"Oinari-sama. Shinbou suru", @"kanji", @"21.07.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92263", @"5557", @"24", @"rate", @"vts", @"17", @"english", @"Oinari-sama. Oikakeru", @"kanji", @"28.07.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92438", @"5557", @"24", @"rate", @"vts", @"18", @"english", @"Oinari-sama. Omoide wo Morau", @"kanji", @"04.08.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92437", @"5557", @"24", @"rate", @"vts", @"19", @"english", @"Oinari-sama. Imo wo Yaku", @"kanji", @"11.08.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92450", @"5557", @"24", @"rate", @"vts", @"20", @"english", @"Oinari-sama. Futatabi Ryokou Suru", @"kanji", @"18.08.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92451", @"5557", @"24", @"rate", @"vts", @"21", @"english", @"Oinari-sama. Chiryou Suru", @"kanji", @"25.08.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92452", @"5557", @"24", @"rate", @"vts", @"22", @"english", @"Oinari-sama. Party ni Norikomu", @"kanji", @"01.09.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92453", @"5557", @"24", @"rate", @"vts", @"23", @"english", @"Oinari-sama. Diet Suru", @"kanji", @"08.09.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"92964", @"5557", @"24", @"rate", @"vts", @"24", @"english", @"Oinari-sama. Hatsumoude ni Iku", @"kanji", @"15.09.2008", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"573",@"106",@"24",@"764",@"29",@"1",@"A Child High School Student - A Genius - Scary? - Rampaging Tomo-chan - It`s an Osakan",@"Kodomo Koukousei - Tensai Desu - Kowai Kana? - Bakusou Tomo-chan - Oosakajin Ya",@"こども高校生 - 天才です - こわいかな？ - 爆走ともちゃん！ - 大阪人や", @"08.04.2002", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if (verbose) NSLog(@"Dummy data for [tables objectAtIndex:i] \"%@\" inserted", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Checking dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"%@",[db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
		
		//files dummy data
		i = 4;
		if (verbose) NSLog(@"Inserting dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"443033", @"5557", @"88811", @"4489", @"1", @"182808576", @"d41a9ebc3ea2a767466c94dcf8381dbd", @"filename", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if(![db insertValues:[NSArray arrayWithObjects:[NSNull null],@"447180", @"5557", @"88840", @"4489", @"1", @"183486464", @"2e9a17c34290c6467e3142c7c223b0e4", @"filename", nil]
				  forColumns:[columns valueForKey:[tables objectAtIndex:i]] inTable:[tables objectAtIndex:i]])
			if (verbose) NSLog(@"%@ inserted", [[tables objectAtIndex:i] capitalizedString]);
		if (verbose) NSLog(@"Dummy data for [tables objectAtIndex:i] \"%@\" inserted", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"Checking dummy data for [tables objectAtIndex:i] \"%@\"...", [tables objectAtIndex:i]);
		if (verbose) NSLog(@"%@",[db performQuery:[NSString stringWithFormat:@"select * from %@", [tables objectAtIndex:i]] cacheMethod:DoNotCacheData]);
	*/}
	
	[db commitTransaction];
	return YES;

}

- (void)refreshDatabase:(BOOL)verbose detailed:(BOOL)detailed
{
	[self setMylist:[NSArray array]];
	[self setAnime:[NSArray array]];
	[self setGroups:[NSArray array]];
	
	QuickLiteCursor* mylistCursor = [db performQuery:@"select * from mylist"];
	QuickLiteCursor* groupCursor = [db performQuery:@"select * from groups"];
	QuickLiteCursor* animeCursor = [db performQuery:@"select * from anime"];
	QuickLiteCursor* episodeCursor;
	QuickLiteCursor* fileCursor;
	QuickLiteRow* row;
	
	ADBMylistEntry* tempMylistEntry;
	ADBGroup* tempGroup;
	ADBAnime* tempAnime;
	ADBEpisode* tempEpisode;
	ADBFile* tempFile;
	
	NSString* table;
	NSString* groupID;
	NSString* animeID;
	NSString* episodeID;
	
	if (verbose || detailed) NSLog(@"%@", animeCursor);
	if (verbose || detailed) NSLog(@"%@", groupCursor);
	
	for (int i = 0; i < [mylistCursor rowCount]; i++)
	{
		table = @"mylist";
		if (verbose || detailed) NSLog(@"%@: Iteration %d", [table capitalizedString], i);
		row = [mylistCursor rowAtIndex:i];
		if (detailed) NSLog(@"%@", row);
		tempMylistEntry = [[ADBMylistEntry alloc] init];
		for (int j = 0; j < [[[tempMylistEntry properties] allKeys] count]; j++)
			[tempMylistEntry setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", table, [[[tempMylistEntry properties] allKeys] objectAtIndex:j]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[tempMylistEntry properties] allKeys] objectAtIndex:j]]];
		
		[mylist addObject:tempMylistEntry];
		if (detailed) NSLog(@"\"%@\" added", tempMylistEntry);
	}
	if (verbose || detailed) NSLog(@"Count of \"groups\" array: %d", [groups count]);
	
	for (int i = 0; i < [groupCursor rowCount]; i++)
	{
		table = @"groups";
		if (verbose || detailed) NSLog(@"%@: Iteration %d", [table capitalizedString], i);
		row = [groupCursor rowAtIndex:i];
		if (detailed) NSLog(@"%@", row);
		tempGroup = [[ADBGroup alloc] init];
		for (int j = 0; j < [[[tempGroup properties] allKeys] count]; j++)
			[tempGroup setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", table, [[[tempGroup properties] allKeys] objectAtIndex:j]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[tempGroup properties] allKeys] objectAtIndex:j]]];
		
		[groups addObject:tempGroup];
		if (detailed) NSLog(@"\"%@\" added", tempGroup);
	}
	if (verbose || detailed) NSLog(@"Count of \"groups\" array: %d", [groups count]);
	
	for (int i = 0; i < [animeCursor rowCount]; i++)
	{
		table = @"anime";
		row = [animeCursor rowAtIndex:i];
		tempAnime = [[ADBAnime alloc] init];
		for (int j = 0; j < [[[tempAnime properties] allKeys] count]; j++)
			[tempAnime setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", table, [[[tempAnime properties] allKeys] objectAtIndex:j]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[tempAnime properties] allKeys] objectAtIndex:j]]];
		
		animeID = [row valueForColumn:@"anime.animeID"];
		episodeCursor = [db performQuery:[NSString stringWithFormat:@"select * from episodes where animeID = %@", animeID] cacheMethod:DoNotCacheData];
		for (int j = 0; j < [episodeCursor rowCount]; j++)
		{
			table = @"episodes";
			row = [episodeCursor rowAtIndex:j];
			tempEpisode = [[ADBEpisode alloc] init];
			for (int k = 0; k < [[[tempEpisode properties] allKeys] count]; k++)
				[tempEpisode setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", table, [[[tempEpisode properties] allKeys] objectAtIndex:k]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[tempEpisode properties] allKeys] objectAtIndex:k]]];
			
			episodeID = [row valueForColumn:@"episodes.episodeID"];
			fileCursor = [db performQuery:[NSString stringWithFormat:@"select * from files where episodeID = %@", episodeID] cacheMethod:DoNotCacheData];
			for (int k = 0; k < [fileCursor rowCount]; k++) {
				table = @"files";
				row = [fileCursor rowAtIndex:k];
				tempFile = [[ADBFile alloc] init];
				for (int l = 0; l < [[[tempFile properties] allKeys] count]; l++)
					[tempFile setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", table, [[[tempFile properties] allKeys] objectAtIndex:l]]] forKeyPath:[NSString stringWithFormat:@"properties.%@", [[[tempFile properties] allKeys] objectAtIndex:l]]];
				
				for (int l = 0; l < [groups count]; l++)
				{
					tempGroup = [groups objectAtIndex:l];
					groupID = [[tempGroup properties] objectForKey:@"groupID"];
					if ([groupID compare:[[tempFile properties] objectForKey:@"groupID"]])
						[tempFile setGroup:tempGroup];
				}
				if (verbose || detailed) NSLog(@"Group of file: %@", [tempFile group]);
				
				[tempFile setIsLeaf:YES];
				[[tempEpisode children] addObject:tempFile];
				if (detailed) NSLog(@"\"%@\" added", tempFile);
			}
			if (verbose || detailed) NSLog(@"Count of \"files\" array: %d", [[tempEpisode children] count]);
			
			[[tempAnime children] addObject:tempEpisode];
			if (detailed) NSLog(@"\"%@\" added", tempEpisode);
		}
		if (verbose || detailed) NSLog(@"Count of \"episodes\" array: %d", [[tempAnime children] count]);
		
		[anime addObject:tempAnime];
		if (detailed) NSLog(@"\"%@\" added", tempAnime);
	}
	if (verbose || detailed) NSLog(@"Count of \"anime\" array: %d", [anime count]);
}
@end
