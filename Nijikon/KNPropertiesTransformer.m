//
//  KNPropertiesTransformer.m
//  ShowAnime
//
//  Created by Pipelynx on 1/30/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "KNPropertiesTransformer.h"


@implementation KNPropertiesTransformer
+ (Class)transformedValueClass
{
	return [NSMutableDictionary class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (id)transformedValue:(id)value
{
	if([value isKindOfClass:[NSMutableDictionary class]])
	{
		NSMutableDictionary* properties = (NSMutableDictionary*)value;
		for (int i = 0; i < [properties count]; i++)
		{
			NSString* key = [[properties allKeys] objectAtIndex:i];
			NSLog(key);
			if (key == @"synonyms" || key == @"shortNames")
				[properties setObject:[[[properties allValues] objectAtIndex:i] stringByReplacingOccurrencesOfString:@"'" withString:@", "] forKey:key];
			if (key == @"categories")
				[properties setObject:[[[properties allValues] objectAtIndex:i] stringByReplacingOccurrencesOfString:@"," withString:@", "] forKey:key];
		}
		return properties;
		
	}
	else
		return nil;
}
@end
