//
//  PLED2k.h
//  Nijikon
//
//  Created by Pipelynx on 2/15/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

#if TARGET_OS_MAC && (TARGET_OS_IPHONE || MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5)
	#define COMMON_DIGEST_FOR_OPENSSL
	#import <CommonCrypto/CommonDigest.h>
	#define MD4(data, len, md)          CC_MD4(data, len, md)
#else
	#import <openssl/md4.h>
#endif

#define SUPPORTED_FILE_TYPES [NSArray arrayWithObjects:@"mkv", @"avi", @"ogm", @"mp4", nil]
#define BLOCKSIZE 9728000

#import <Cocoa/Cocoa.h>


@interface PLED2k : NSObject {

}

+ (NSArray*)getED2kAndSize:(NSString*)path;
+ (NSString*)getED2k:(NSString*)path;

+ (NSString*)getHex:(unsigned char*)digest;

+ (BOOL)isSupportedFileType:(NSString*)path;

@end
