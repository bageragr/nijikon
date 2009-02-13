//
//  KNStatusToStringTransformer.m
//  Nijikon
//
//  Created by Pipelynx on 2/8/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#import "KNStatusToStringTransformer.h"


@implementation KNStatusToStringTransformer
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
	if([value isKindOfClass:[NSNumber class]])
		switch ([value intValue]) {
			case 0:
				return NSLocalizedString(@"Not connected", nil);
			case 1:
				return NSLocalizedString(@"Connected", nil);
			case 2:
				return NSLocalizedString(@"Authenticated", nil);
			default:
				return NSLocalizedString(@"Unkown status", nil);
		}
	else
		return nil;
}
@end
