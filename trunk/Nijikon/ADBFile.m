//
//  ADBFile.m
//  Nijikon
//
//  Created by Pipelynx on 2/17/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#define TABLE @"files"

#import "ADBFile.h"

@implementation ADBFile
- (id)init {
	if ([super init]) {
		[self setParent:nil];
		[self setAnidbAtt:[NSMutableDictionary dictionaryWithObjects:ADBFileKeyArray
														forKeys:ADBFileKeyArray]];
	}
	return self;
}

- (void)dealloc {
	[parent release];
	[super dealloc];
}

- (NSString*)description {
	NSMutableString* description = [NSMutableString stringWithFormat:@"%@ {\n", [super description]];
	for (int i = 0; i < [anidbAtt count]; i++)
		[description appendFormat:@"[%@]: %@\n", [[anidbAtt allKeys] objectAtIndex:i], [[anidbAtt allValues] objectAtIndex:i]];
	return [description stringByAppendingFormat:@"}"];
}

+ (ADBFile*)fileWithAttributes:(NSDictionary*)newAtt andParent:(ADBMylistEntry*)newParent {
	ADBFile* temp = [[ADBFile alloc] init];
	[temp setAnidbAtt:newAtt];
	[temp setParent:newParent];
	return temp;
}

+ (ADBFile*)fileWithQuickliteRow:(QuickLiteRow*)row {
	ADBFile* temp = [[ADBFile alloc] init];
	
	for (int i = 0; i < [[[temp anidbAtt] allKeys] count]; i++)
		[temp setValue:[row valueForColumn:[NSString stringWithFormat:@"%@.%@", TABLE, [[[temp anidbAtt] allKeys] objectAtIndex:i]]] forKeyPath:[NSString stringWithFormat:@"anidbAtt.%@", [[[temp anidbAtt] allKeys] objectAtIndex:i]]];
	
	return temp;
}

- (void)insertIntoDatabase:(QuickLiteDatabase*)database {
	[database insertValues:[[NSArray arrayWithObject:[NSNull null]] arrayByAddingObjectsFromArray:[anidbAtt allValues]]
				forColumns:[[NSArray arrayWithObject:QLRecordUID] arrayByAddingObjectsFromArray:[anidbAtt allKeys]] inTable:TABLE];
}

- (NSString*)name {
	return [NSString stringWithFormat:@"f%@", [anidbAtt valueForKey:@"fileID"]];
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
