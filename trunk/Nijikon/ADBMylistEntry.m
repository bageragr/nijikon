//
//  ADBMylistEntry.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define COMMA_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
#define APOSTROPHE_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
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
	
	NSArray* commaSeparated = COMMA_SEPARATED_LISTS;
	for (int i = 0; i < [commaSeparated count]; i++)
		[[temp att] setValue:[[newAtt valueForKey:[commaSeparated objectAtIndex:i]] componentsSeparatedByString:@","] forKey:[commaSeparated objectAtIndex:i]];
	
	NSArray* apostropheSeparated = APOSTROPHE_SEPARATED_LISTS;
	for (int i = 0; i < [apostropheSeparated count]; i++)
		[[temp att] setValue:[[newAtt valueForKey:[apostropheSeparated objectAtIndex:i]] componentsSeparatedByString:@"'"] forKey:[apostropheSeparated objectAtIndex:i]];
	
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
}

- (ADBAnime*)anime {
	return anime;
}
	
- (void)setAnime:(ADBAnime*)newAnime {
	if (anime != newAnime)
	{
		[anime release];
		anime = [newAnime retain];
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
	}
}

@end
