//
//  SingleDownload.h
//  downloader
//
//  Created by Kevin Willford on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadRequest.h"
#import "DownloadInformation.h"


@protocol SingleDownloadDelegate <NSObject>
- (void) downloadCompleted: (DownloadInformation *) information;
- (void) downloadProgress: (DownloadInformation *) information;
- (BOOL) canContinue: (DownloadInformation *) information;
- (void) downloadFailed: (DownloadInformation *) information;
- (void) downloadRestart: (DownloadInformation *) information;
- (void) downloadStarted: (DownloadInformation *) information;
@end

@interface SingleDownload : NSObject
{
}


@property (retain, nonatomic) id <SingleDownloadDelegate> delegate;
@property (retain) DownloadRequest* downloadRequest;
@property (retain) NSNumber* permittedNetworks;

-(void)start;
-(void)startRequest;


@end
