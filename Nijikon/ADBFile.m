//
//  ADBFile.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define COMMA_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
#define APOSTROPHE_SEPARATED_LISTS [NSArray arrayWithObjects:nil]
#define TABLE @"files"

#import "ADBFile.h"

@implementation ADBFile
- (id)init {
	if ([super init]) {
		parent = nil;
		att = [NSMutableDictionary dictionaryWithObjects:ADBFileKeyArray
												 forKeys:ADBFileKeyArray];
	}
	return self;
}

- (void)dealloc {
	[parent release];
	[super dealloc];
}

+ (ADBFile*)fileWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent {
	ADBFile* temp = [[ADBFile alloc] init];
	[temp setAtt:newAtt];
	[temp setParent:newParent];
	return temp;
}

+ (ADBFile*)fileWithQuickliteRow:(QuickLiteRow*)row {
	ADBFile* temp = [[ADBFile alloc] init];
	
	for (int i = 0; i < [[[temp att] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp att] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"att.%@", [[[temp att] allKeys] objectAtIndex:i]]];
	
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database {
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
