//
//  KNDisplayedNameTransformer.m
//  Nijikon
//
//  Created by Pipelynx on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PLDisplayedNameTransformer.h"


@implementation PLDisplayedNameTransformer
+ (Class)transformedValueClass {
	return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	if([value isKindOfClass:[NSString class]]) {
		if ([(NSString*)value isEqualToString:@"romaji"])
			return [NSNumber numberWithInt:0];
		if ([(NSString*)value isEqualToString:@"kanji"])
			return [NSNumber numberWithInt:1];
		if ([(NSString*)value isEqualToString:@"english"])
			return [NSNumber numberWithInt:2];
	}
	return nil;
}

- (id)reverseTransformedValue:(id)value {
	if([value isKindOfClass:[NSNumber class]]) {
		if ([(NSNumber*)value intValue] == 0)
			return @"romaji";
		if ([(NSNumber*)value intValue] == 1)
			return @"kanji";
		if ([(NSNumber*)value intValue] == 2)
			return @"english";
	}
	return nil;
}
@end
