//
//  KeyTransformer.m
//  ShowAnime
//
//  Created by Pipelynx on 1/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KNLocalizeKeyTransformer.h"


@implementation KNLocalizeKeyTransformer
+ (Class)transformedValueClass
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (id)transformedValue:(id)value
{
	if([value isKindOfClass:[NSString class]])
	{
		return NSLocalizedString((NSString*)value, nil);
	}
	else
		return nil;
}
@end
