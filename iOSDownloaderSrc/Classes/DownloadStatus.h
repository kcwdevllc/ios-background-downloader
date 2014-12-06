//
//  DownloadStatus.h
//  downloader
//
//  Created by Kevin Willford on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifndef downloader_DownloadStatus_h
#define downloader_DownloadStatus_h
enum
{
    DownloadStatusNone = 0,
    DownloadStatusInProgress = 1,
    DownloadStatusPaused = 2,
    DownloadStatusComplete = 3
};


typedef NSInteger DownloadStatus;

#endif
