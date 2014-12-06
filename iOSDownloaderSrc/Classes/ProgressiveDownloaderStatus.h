//
//  ProgressiveDownloaderStatus.h
//  downloader
//
//  Created by Kevin Willford on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef downloader_ProgressiveDownloaderStatus_h
#define downloader_ProgressiveDownloaderStatus_h

enum 
{
    ProgressiveDownloaderStatusNone = 0,
    ProgressiveDownloaderStatusStarted = 1,
    ProgressiveDownloaderStatusPaused = 2
}

typedef NSInteger ProgressiveDownloaderStatus;

#endif
