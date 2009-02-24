//
//  ADBEpisode.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define COMMA_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
#define APOSTROPHE_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
#define TABLE @"episodes"

#import "ADBEpisode.h"

@implementation ADBEpisode
- (id)init {
	if ([super init]) {
		parent = nil;
		att = [NSMutableDictionary dictionaryWithObjects:ADBEpisodeKeyArray
												 forKeys:ADBEpisodeKeyArray];
	}
	return self;
}

- (void)dealloc {
	[parent release];
	[super dealloc];
}

- (NSString*)description {
	NSMutableString* description = [NSMutableString stringWithFormat:@"%@ {\n", [super description]];
	for (int i = 0; i < [att count]; i++)
		[description appendFormat:@"[%@]: %@\n", [[att allKeys] objectAtIndex:i], [[att allValues] objectAtIndex:i]];
	return [description stringByAppendingFormat:@"}"];
}

+ (ADBEpisode*)episodeWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent {
	ADBEpisode* temp = [[ADBEpisode alloc] init];
	[temp setAtt:newAtt];
	[temp setParent:newParent];
	return temp;
}

+ (ADBEpisode*)episodeWithQuickliteRow:(QuickLiteRow*)row {
	ADBEpisode* temp = [[ADBEpisode alloc] init];
	
	for (int i = 0; i < [[[temp att] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp att] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"att.%@", [[[temp att] allKeys] objectAtIndex:i]]];
	
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database {
	[database insertValues:[[NSArray arrayWithObject:[NSNull null]] arrayByAddingObjectsFromArray:[att allValues]]
				forColumns:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:[att allKeys]] inTable:TABLE];
}

- (BOOL)isSpecial {
	return [[[att valueForKey:@"epnumber"] capitalizedString] hasPrefix:@"S"];
}

- (BOOL)isCredits {
	return [[[att valueForKey:@"epnumber"] capitalizedString] hasPrefix:@"C"];
}

- (BOOL)isTrailer {
	return [[[att valueForKey:@"epnumber"] capitalizedString] hasPrefix:@"T"];
}

- (BOOL)isParody {
	return [[[att valueForKey:@"epnumber"] capitalizedString] hasPrefix:@"P"];
}

- (BOOL)isOther {
	return [[[att valueForKey:@"epnumber"] capitalizedString] hasPrefix:@"O"];
}

- (BOOL)isNormal { //SCTPO
	return !([self isSpecial] || [self isCredits] || [self isTrailer] || [self isParody] || [self isOther]);
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
