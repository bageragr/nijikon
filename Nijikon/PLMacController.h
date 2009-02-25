//
//  KNMacController.h
//  Nijikon
//
//  Created by Pipelynx on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PLController.h"


@interface PLMacController : PLController {
	NSMutableArray* byMylist;
	NSMutableArray* byAnime;
}

- (NSArray*)byMylist;
- (NSArray*)byAnime;

@end
