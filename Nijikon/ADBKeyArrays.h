//
//  ADBKeyArrays.h
//  Nijikon
//
//  Created by Pipelynx on 2/13/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#define ADBMylistExportKeyArray [NSArray arrayWithObjects:@"userid", @"username", @"date", @"size", nil]

#define ADBMylistEntryKeyArray [NSArray arrayWithObjects:@"mylistID", @"fileID", @"episodeID", @"animeID", @"groupID", @"date", @"state", @"viewdate", @"storage", @"source", @"other", @"filestate", nil]
#define ADBMylistEntryColumnArray [NSArray arrayWithObjects:QLRecordUID, @"mylistID", @"fileID", @"episodeID", @"animeID", @"groupID", @"date", @"state", @"viewdate", @"storage", @"source", @"other", @"filestate", nil]
#define ADBMylistEntryDatatypeArray [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, nil]

#define ADBGroupKeyArray [NSArray arrayWithObjects:@"groupID", @"rate", @"vts", @"animecount", @"filecount", @"name", @"short", @"ircchan", @"ircserv", @"url", nil]
#define ADBGroupColumnArray [NSArray arrayWithObjects:QLRecordUID, @"groupID", @"rate", @"vts", @"animecount", @"filecount", @"name", @"short", @"ircchan", @"ircserv", @"url", nil]
#define ADBGroupDatatypeArray [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, nil]

#define ADBAnimeKeyArray [NSArray arrayWithObjects:@"animeID", @"year", @"type", @"relList", @"relType", @"categList", @"categWeightList", @"romaji", @"kanji", @"english", @"others", @"shortNames", @"synonyms", @"prodNameList", @"prodIDList", @"allEps", @"nEps", @"sEps", @"startDate", @"endDate", @"url", @"pic", @"categIDList", @"rate", @"vts", @"tmpRate", @"tmpVts", @"avgReviewRate", @"reviews", @"awardList", @"animePlanetID", @"ANNID", @"allcinemaID", @"animenfoID", @"description", nil]
#define ADBAnimeColumnArray [NSArray arrayWithObjects:QLRecordUID, @"animeID", @"year", @"type", @"relList", @"relType", @"categList", @"categWeightList", @"romaji", @"kanji", @"english", @"others", @"shortNames", @"synonyms", @"prodNameList", @"prodIDList", @"allEps", @"nEps", @"sEps", @"startDate", @"endDate", @"url", @"pic", @"categIDList", @"rate", @"vts", @"tmpRate", @"tmpVts", @"avgReviewRate", @"reviews", @"awardList", @"animePlanetID", @"ANNID", @"allcinemaID", @"animenfoID", @"description", nil]
#define ADBAnimeDatatypeArray [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, nil]

#define ADBEpisodeKeyArray [NSArray arrayWithObjects:@"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil]
#define ADBEpisodeColumnArray [NSArray arrayWithObjects:QLRecordUID, @"episodeID", @"animeID", @"length", @"rate", @"vts", @"epnumber", @"english", @"romaji", @"kanji", @"aired", nil]
#define ADBEpisodeDatatypeArray [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, nil]

#define ADBFileKeyArray [NSArray arrayWithObjects:@"fileID", @"animeID", @"episodeID", @"groupID", @"mylistID", @"otherEps", @"depr", @"state", @"size", @"eD2k", @"md5", @"sha1", @"crc32", @"quality", @"source", @"audCodec", @"audBitrate", @"vidCodec", @"vidBitrate", @"vidResolution", @"ext", @"dubLang", @"subLang", @"length", @"description", @"release", @"filename", nil]
#define ADBFileColumnArray [NSArray arrayWithObjects:QLRecordUID, @"fileID", @"animeID", @"episodeID", @"groupID", @"mylistID", @"otherEps", @"depr", @"state", @"size", @"eD2k", @"md5", @"sha1", @"crc32", @"quality", @"source", @"audCodec", @"audBitrate", @"vidCodec", @"vidBitrate", @"vidResolution", @"ext", @"dubLang", @"subLang", @"length", @"description", @"release", @"filename", nil]
#define ADBFileDatatypeArray [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString,QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, QLString, nil]