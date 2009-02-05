//
//  KNController.m
//  Nijikon
//
//  Created by Pipelynx on 2/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KNController.h"


@implementation KNController
- (id)init
{
	if(self = [super init])
	{
		NSFileManager* fileManager = [NSFileManager defaultManager];
		anime = [[NSMutableArray alloc] init];
		NSString* path = [@"~/Library/Application Support/Nijikon" stringByExpandingTildeInPath];
		
		if (![fileManager fileExistsAtPath:path])
			[fileManager createDirectoryAtPath:path attributes:nil];
		if (![fileManager fileExistsAtPath:[path stringByAppendingString:@"/database.nijikon"]])
			if(![self createDatabase:path])
				NSLog(@"Database creation failed");
			else
				NSLog(@"FTW!");
	}
	return self;
}

- (void)dealloc
{
	[anime release];
	[super dealloc];
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
	}
}

- (BOOL)createDatabase:(NSString*)path
{
	db = [QuickLiteDatabase databaseWithFile:[path stringByAppendingString:@"/database.nijikon"]];
	[db open];
	
	[db close];
	return true;
}

- (void)refreshDatabase
{
}
@end
