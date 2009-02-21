//
//  ADBAnime.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define COMMA_SEPARATED_LISTS [NSArray array]//WithObjects:@"categList", @"categWeightList", @"categIDList", nil]
#define APOSTROPHE_SEPARATED_LISTS [NSArray array]//WithObjects:@"relList", @"relType", @"others", @"shortNames", @"synonyms", @"prodNameList", @"prodIDList", nil]
#define TABLE @"anime"

#import "ADBAnime.h"

@implementation ADBAnime
- (id)init {
	if ([super init]) {
		parent = nil;
		att = [NSMutableDictionary dictionaryWithObjects:ADBAnimeKeyArray
												 forKeys:ADBAnimeKeyArray];
	}
	return self;
}

- (void)dealloc {
	[parent release];
	[super dealloc];
}

+ (ADBAnime*)animeWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent {
	ADBAnime* temp = [[ADBAnime alloc] init];
	[temp setAtt:newAtt];
	[temp setParent:newParent];
	return temp;
}

+ (ADBAnime*)animeWithQuickliteRow:(QuickLiteRow*)row {
	ADBAnime* temp = [[ADBAnime alloc] init];
	
	for (int i = 0; i < [[[temp att] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp att] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"att.%@", [[[temp att] allKeys] objectAtIndex:i]]];
	
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database {
	for (int i = 0; i < [att count]; i++)
		NSLog(@"[%@]\t\t%@", [[att allKeys] objectAtIndex:i], [[att allValues] objectAtIndex:i]);
	[database insertValues:[[NSArray arrayWithObject:[NSNull null]] arrayByAddingObjectsFromArray:[att allValues]]
				forColumns:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:[att allKeys]] inTable:TABLE];
}

- (ADBMylistEntry*)parent {
	return parent;
}

- (void)setParent:(ADBMylistEntry*)newParent {
	if (parent != newParent)
	{
		[parent release];
		parent = [newParent retain];
	}
}

@end
