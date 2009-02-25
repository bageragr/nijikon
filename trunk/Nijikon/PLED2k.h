//
//  KNED2k.h
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_MAC && (TARGET_OS_IPHONE || MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5)
	#define COMMON_DIGEST_FOR_OPENSSL
	#import <CommonCrypto/CommonDigest.h>
	#define MD4(data, len, md)          CC_MD4(data, len, md)
	#define BLOCKSIZE					9728000
#else
	#import <openssl/md4.h>
#endif

#import <Cocoa/Cocoa.h>


@interface PLED2k : NSObject {

}

+ (NSString*)getED2k:(NSString*)path;

+ (NSString*)getHex:(unsigned char*)digest;

@end
