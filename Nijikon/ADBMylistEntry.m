//
//  ADBMylistEntry.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define TABLE @"mylist"

#import "ADBMylistEntry.h"

#import "ADBAnime.h"
#import "ADBEpisode.h"
#import "ADBFile.h"
#import "ADBGroup.h"


@implementation ADBMylistEntry
- (id)init {
	if ([super init]) {
		att = [NSMutableDictionary dictionaryWithObjects:ADBMylistEntryKeyArray
												 forKeys:ADBMylistEntryKeyArray];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

+ (ADBMylistEntry*)mylistEntryWithAttributes:(NSDictionary*)newAtt {
	ADBMylistEntry* temp = [[ADBMylistEntry alloc] init];
	[temp setAtt:newAtt];
	return temp;
}

+ (ADBMylistEntry*)mylistEntryWithQuickliteRow:(QuickLiteRow*)row {
	ADBMylistEntry* temp = [[ADBMylistEntry alloc] init];
	
	for (int i = 0; i < [[[temp att] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp att] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"att.%@", [[[temp att] allKeys] objectAtIndex:i]]];
	
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database {
	[database insertValues:[[NSArray arrayWithObject:[NSNull null]] arrayByAddingObjectsFromArray:[att allValues]]
				forColumns:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:[att allKeys]] inTable:TABLE];
	//NSLog(@"Groups found: %d", [[database performQuery:[NSString stringWithFormat:@"select * from groups where groupID=%@", [group valueForKeyPath:@"att.groupID"]]] rowCount]);
	if ([[database performQuery:[NSString stringWithFormat:@"select * from groups where groupID=%@", [group valueForKeyPath:@"att.groupID"]]] rowCount] == 0)
		[group insertIntoDatabase:database];
	//NSLog(@"Anime found: %d", [[database performQuery:[NSString stringWithFormat:@"select * from anime where animeID=%@", [anime valueForKeyPath:@"att.animeID"]]] rowCount]);
	if ([[database performQuery:[NSString stringWithFormat:@"select * from anime where animeID=%@", [anime valueForKeyPath:@"att.animeID"]]] rowCount] == 0)
		[anime insertIntoDatabase:database];
	//NSLog(@"Episodes found: %d", [[database performQuery:[NSString stringWithFormat:@"select * from episodes where episodeID=%@", [episode valueForKeyPath:@"att.episodeID"]]] rowCount]);
	if ([[database performQuery:[NSString stringWithFormat:@"select * from episodes where episodeID=%@", [episode valueForKeyPath:@"att.episodeID"]]] rowCount] == 0)
		[episode insertIntoDatabase:database];
	//NSLog(@"Files found: %d", [[database performQuery:[NSString stringWithFormat:@"select * from files where fileID=%@", [file valueForKeyPath:@"att.fileID"]]] rowCount]);
	if ([[database performQuery:[NSString stringWithFormat:@"select * from files where fileID=%@", [file valueForKeyPath:@"att.fileID"]]] rowCount] == 0)
		[file insertIntoDatabase:database];
}

- (ADBAnime*)anime {
	return anime;
}
	
- (void)setAnime:(ADBAnime*)newAnime {
	if (anime != newAnime)
	{
		[anime release];
		anime = [newAnime retain];
		[anime setParent:self];
	}
}

- (ADBEpisode*)episode {
	return episode;
}

- (void)setEpisode:(ADBEpisode*)newEpisode {
	if (episode != newEpisode)
	{
		[episode release];
		episode = [newEpisode retain];
		[episode setParent:self];
	}
}

- (ADBGroup*)group {
	return group;
}

- (void)setGroup:(ADBGroup*)newGroup {
	if (group != newGroup)
	{
		[group release];
		group = [newGroup retain];
		[group setParent:self];
	}
}

- (ADBFile*)file {
	return file;
}

- (void)setFile:(ADBFile*)newFile {
	if (file != newFile)
	{
		[file release];
		file = [newFile retain];
		[file setParent:self];
	}
}

@end
