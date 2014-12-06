//
//  DownloadInformation.h
//  downloader
//
//  Created by Kevin Willford on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkTypes.h"

@interface DownloadInformation : NSObject <NSCoding>
{
}

@property (retain) NSObject* data;
@property (retain) NSString* url;
@property (retain) NSString* name;
@property (retain) NSString* locale;
@property (retain) NSString* filePath;
@property (retain) NSString* storageLocation;
@property NetworkTypes permittedNetworkTypes;
@property NSUInteger length;
@property NSInteger mediaBitsPerSecond;
@property NSUInteger availableLength;
@property (retain) NSDate* creationUtc;
@property (retain) NSDate* lastWriteUtc;
@property NSInteger lastDownloadBitsPerSecond;
@property double downloadPriority;
@property BOOL isReadyForPlayback;
@property (retain) NSString* message;


@end
