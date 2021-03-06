//
//  KeyTransformer.m
//  ShowAnime
//
//  Created by Pipelynx on 1/30/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "PLLocalizeKeyTransformer.h"


@implementation PLLocalizeKeyTransformer
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
