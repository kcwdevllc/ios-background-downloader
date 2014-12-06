//
//  BaseDownloadRequest.h
//  downloader
//
//  Created by Kevin Willford on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#include "DownloadStatus.h"
#include "NetworkTypes.h"

@interface BaseDownloadRequest : NSObject
{
}

@property (retain) NSString* name;
@property (retain) NSString* locale;
@property (retain) NSDate* creationUtc;
@property (retain) NSString* overrideStorageLocation;
@property double priority;
@property NetworkTypes overridePermittedNetworkTypes;
@property NSUInteger length;
@property NSUInteger availableLength;
@property (retain) NSString* finalStorageLocation;
@property DownloadStatus status;
@property NetworkTypes finalPermittedNetworkTypes;



@end
