//
//  ADBKeyArrays.h
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define KNNodeKeyArray [NSArray arrayWithObjects: @"ID", @"number", @"name", @"epnumber", @"inMylistValue", @"inMylistMax", nil]

#define ADBMylistEntryKeyArray [NSArray arrayWithObjects:@"mylistID",@"fileID",@"episodeID",@"animeID",@"groupID",@"date",@"state",@"viewdate",@"storage",@"source",@"other",@"filestate",nil]
#define ADBGroupKeyArray [NSArray arrayWithObjects: @"groupID", @"rate", @"vts", @"animecount", @"filecount", @"name", @"short", @"ircchan", @"ircserv", @"url", nil]
#define ADBAnimeKeyArray [NSArray arrayWithObjects:@"animeID",@"allEps",@"nEps",@"sEps",@"rate",@"vts",@"tmprate",@"tmpvts",@"reviewrateavg",@"reviews",@"year",@"type",@"romaji",@"kanji",@"english",@"other",@"shortNames",@"synonyms",@"categories",@"description",nil]
#define ADBEpisodeKeyArray [NSArray arrayWithObjects: @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil]
#define ADBFileKeyArray [NSArray arrayWithObjects: @"fileID", @"animeID", @"episodeID", @"groupID", @"state", @"size", @"ed2k", @"filename", nil]