//
//  ADBResponseCodes.h
//  Nijikon
//
//  Created by Pipelynx on 2/6/09.
//  Copyright 2009 Martin Fellner. All rights reserved.
//

// CLIENT VARIABLES

#define PROTOCOLVER @"3"
#define CLIENT @"nijikon"
#define CLIENTVER @"1"
#define DEFAULT_ENCODING @"UTF8"
#define DEFAULT_NSENCODING NSUTF8StringEncoding
#define DEFAULT_AMASK @"BFFFFFFEF0"
#define DEFAULT_FMASK @"7FF8FFF9"

// POSITIVE 2XX

#define RC_LOGIN_ACCEPTED 200
#define RC_LOGIN_ACCEPTED_NEW_VER 201
#define RC_LOGGED_OUT 203
#define RC_RESOURCE 205
#define RC_STATS 206
#define RC_TOP 207
#define RC_UPTIME 208
#define RC_ENCRYPTION_ENABLED 209

#define RC_MYLIST_ENTRY_ADDED 210
#define RC_MYLIST_ENTRY_DELETED 211

#define RC_ADDED_FILE 214
#define RC_ADDED_STREAM 215

#define RC_ENCODING_CHANGED 219

#define RC_FILE 220
#define RC_MYLIST 221
#define RC_MYLIST_STATS 222

#define RC_ANIME 230
#define RC_ANIME_BEST_MATCH 231
#define RC_RANDOMANIME 232
#define RC_ANIME_DESCRIPTION 233

#define RC_EPISODE 240
#define RC_PRODUCER 245
#define RC_GROUP 250

#define RC_BUDDY_LIST 253
#define RC_BUDDY_STATE 254
#define RC_BUDDY_ADDED 255
#define RC_BUDDY_DELETED 256
#define RC_BUDDY_ACCEPTED 257
#define RC_BUDDY_DENIED 258

#define RC_VOTED 260
#define RC_VOTE_FOUND 261
#define RC_VOTE_UPDATED 262
#define RC_VOTE_REVOKED 263

#define RC_NOTIFICATION_ENABLED 270
#define RC_NOTIFICATION_NOTIFY 271
#define RC_NOTIFICATION_MESSAGE 272
#define RC_NOTIFICATION_BUDDY 273
#define RC_NOTIFICATION_SHUTDOWN 274
#define RC_PUSHACK_CONFIRMED 280
#define RC_NOTIFYACK_SUCCESSFUL_M 281
#define RC_NOTIFYACK_SUCCESSFUL_N 282
#define RC_NOTIFICATION 290
#define RC_NOTIFYLIST 291
#define RC_NOTIFYGET_MESSAGE 292
#define RC_NOTIFYGET_NOTIFY 293

#define RC_SENDMSG_SUCCESSFUL 294
#define RC_USER 295

// AFFIRMATIVE/NEGATIVE 3XX

#define RC_PONG 300
#define RC_AUTHPONG 301
#define RC_NO_SUCH_RESOURCE 305
#define RC_API_PASSWORD_NOT_DEFINED 309

#define RC_FILE_ALREADY_IN_MYLIST 310
#define RC_MYLIST_ENTRY_EDITED 311
#define RC_MULTIPLE_MYLIST_ENTRIES 312

#define RC_SIZE_HASH_EXISTS 314
#define RC_INVALID_DATA 315
#define RC_STREAMNOID_USED 316

#define RC_NO_SUCH_FILE 320
#define RC_NO_SUCH_ENTRY 321
#define RC_MULTIPLE_FILES_FOUND 322

#define RC_NO_SUCH_ANIME 330
#define RC_NO_SUCH_ANIME_DESCRIPTION 333
#define RC_NO_SUCH_EPISODE 340
#define RC_NO_SUCH_PRODUCER 345
#define RC_NO_SUCH_GROUP 350

#define RC_BUDDY_ALREADY_ADDED 355
#define RC_NO_SUCH_BUDDY 356
#define RC_BUDDY_ALREADY_ACCEPTED 357
#define RC_BUDDY_ALREADY_DENIED 358

#define RC_NO_SUCH_VOTE 360
#define RC_INVALID_VOTE_TYPE 361
#define RC_INVALID_VOTE_VALUE 362
#define RC_PERMVOTE_NOT_ALLOWED 363
#define RC_ALREADY_PERMVOTED 364

#define RC_NOTIFICATION_DISABLED 370
#define RC_NO_SUCH_PACKET_PENDING 380
#define RC_NO_SUCH_ENTRY_M 381
#define RC_NO_SUCH_ENTRY_N 382

#define RC_NO_SUCH_MESSAGE 392
#define RC_NO_SUCH_NOTIFY 393
#define RC_NO_SUCH_USER 394

// NEGATIVE 4XX

#define RC_NOT_LOGGED_IN 403

#define RC_NO_SUCH_MYLIST_FILE 410
#define RC_NO_SUCH_MYLIST_ENTRY 411

// CLIENT SIDE FAILURE 5XX

#define RC_LOGIN_FAILED 500
#define RC_LOGIN_FIRST 501
#define RC_ACCESS_DENIED 502
#define RC_CLIENT_VERSION_OUTDATED 503
#define RC_CLIENT_BANNED 504
#define RC_ILLEGAL_INPUT_OR_ACCESS_DENIED 505
#define RC_INVALID_SESSION 506
#define RC_NO_SUCH_ENCRYPTION_TYPE 509
#define RC_ENCODING_NOT_SUPPORTED 519

#define RC_BANNED 555
#define RC_UNKNOWN_COMMAND 598

// SERVER SIDE FAILURE 6XX

#define RC_INTERNAL_SERVER_ERROR 600
#define RC_ANIDB_OUT_OF_SERVICE 601
#define RC_SERVER_BUSY 602
#define RC_API_VIOLATION 666