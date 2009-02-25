//
//  KNMacController.m
//  Nijikon
//
//  Created by Pipelynx on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PLMacController.h"


@implementation PLMacController
- (id)init {
	if ([super init]) {
		
	}
	return self;
}

- (void)dealloc {
	[byMylist release];
	[byAnime release];
	[super dealloc];
}

- (void)awakeFromNib {
	[mylistOutline needsDisplay];
	[byAnimeOutline needsDisplay];
}

- (NSArray*)byMylist {
	byMylist = [NSMutableArray array];
	NSArray* watched = [NSArray array];
	NSArray* have = [NSArray array];
	ADBMylistEntry* mylistEntry = nil;
	PLNode* mylistEntryNode = nil;
	PLNode* groupNode = nil;
	PLNode* animeNode = nil;
	PLNode* episodeNode = nil;
	PLNode* fileNode = nil;
	
	for (int i = 0; i < [mylist count]; i++) {
		mylistEntry = [mylist objectAtIndex:i];
		watched = [self getWatched:[mylistEntry group]];
		have = [self getHave:[mylistEntry group]];
		groupNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Group", @"Type for ADBGroup nodes"), 
																					[mylistEntry valueForKeyPath:@"group.att.name"],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:PLNodeKeyArray] representedObject:[mylistEntry group] andIsLeaf:YES];
		watched = [self getWatched:[mylistEntry anime]];
		have = [self getHave:[mylistEntry anime]];
		animeNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Anime", @"Type for ADBAnime nodes"), 
																					[mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:PLNodeKeyArray] representedObject:[mylistEntry anime] andIsLeaf:YES];
		watched = [self getWatched:[mylistEntry episode]];
		have = [self getHave:[mylistEntry episode]];
		episodeNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Episode", @"Type for ADBEpisode nodes"), 
																					  [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"episode.att.%@", [preferences valueForKeyPath:@"att.episodeName"]]],
																					  [watched objectAtIndex:0],
																					  [watched objectAtIndex:1],
																					  [have objectAtIndex:0],
																					  [have objectAtIndex:1], nil]
																			 forKeys:PLNodeKeyArray] representedObject:[mylistEntry episode] andIsLeaf:YES];
		watched = [self getWatched:mylistEntry];
		have = [self getHave:mylistEntry];
		fileNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"File", @"Type for ADBFile nodes"), 
																				   [NSString stringWithFormat:@"f%@", [mylistEntry valueForKeyPath:@"file.att.fileID"]],
																				   [watched objectAtIndex:0],
																				   [watched objectAtIndex:1],
																				   [have objectAtIndex:0],
																				   [have objectAtIndex:1], nil]
																		  forKeys:PLNodeKeyArray] representedObject:[mylistEntry file] andIsLeaf:YES];
		mylistEntryNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Mylist entry", @"Type for ADBMylistEntry nodes"), 
																						  [NSString stringWithFormat:NSLocalizedString(@"%@ - %@ (by %@)", @"Name for ADBMylistEntry nodes (<Anime> - <Epnumber> (by <Group>))"),
																						   [mylistEntry valueForKeyPath:[NSString stringWithFormat:@"anime.att.%@", [preferences valueForKeyPath:@"att.animeName"]]],
																						   [mylistEntry valueForKeyPath:@"episode.att.epnumber"],
																						   [mylistEntry valueForKeyPath:@"group.att.name"]],
																						  [watched objectAtIndex:0],
																						  [watched objectAtIndex:1],
																						  [have objectAtIndex:0],
																						  [have objectAtIndex:1], nil]
																				 forKeys:PLNodeKeyArray] representedObject:mylistEntry andIsLeaf:NO];
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
	PLNode* animeNode = nil;
	PLNode* groupNode = nil;
	PLNode* episodeNode = nil;
	PLNode* fileNode = nil;
	
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
		animeNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Anime", @"Type for ADBAnime nodes"), 
																					[anime valueForKeyPath:[NSString stringWithFormat:@"att.romaji"/*, [preferences valueForKeyPath:@"att.animeName"]*/]],
																					[watched objectAtIndex:0],
																					[watched objectAtIndex:1],
																					[have objectAtIndex:0],
																					[have objectAtIndex:1], nil]
																		   forKeys:PLNodeKeyArray] representedObject:anime andIsLeaf:NO];
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
				groupNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Group", @"Type for ADBGroup nodes"), 
																							[group valueForKeyPath:@"att.name"],
																							[watched objectAtIndex:0],
																							[watched objectAtIndex:1],
																							[have objectAtIndex:0],
																							[have objectAtIndex:1], nil]
																				   forKeys:PLNodeKeyArray] representedObject:group andIsLeaf:NO];
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
						episodeNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"Episode", @"Type for ADBEpisode nodes"), 
																									  [NSString stringWithFormat:@"%@ - %@", [episode valueForKeyPath:@"att.epnumber"], [episode valueForKeyPath:[NSString stringWithFormat:@"att.%@", [preferences valueForKeyPath:@"att.episodeName"]]]],
																									  [watched objectAtIndex:0],
																									  [watched objectAtIndex:1],
																									  [have objectAtIndex:0],
																									  [have objectAtIndex:1], nil]
																							 forKeys:PLNodeKeyArray] representedObject:episode andIsLeaf:NO];
						for (int l = 0; l < [mylist count]; l++)
							if ([[[mylist objectAtIndex:l] anime] isEqualTo:anime] && [[[mylist objectAtIndex:l] group] isEqualTo:group] && [[[mylist objectAtIndex:l] episode] isEqualTo:episode]) {
								watched = [self getWatched:[mylist objectAtIndex:l]];
								have = [self getHave:[mylist objectAtIndex:l]];
								fileNode = [PLNode nodeWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"File", @"Type for ADBFile nodes"), 
																										   [NSString stringWithFormat:@"f%@", [[mylist objectAtIndex:l] valueForKeyPath:@"file.att.fileID"]],
																										   [watched objectAtIndex:0],
																										   [watched objectAtIndex:1],
																										   [have objectAtIndex:0],
																										   [have objectAtIndex:1], nil]
																								  forKeys:PLNodeKeyArray] representedObject:[[mylist objectAtIndex:l] file] andIsLeaf:YES];
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
@end
