//
//  BaseDownloadRequest.m
//  downloader
//
//  Created by Kevin Willford on 1/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDownloadRequest.h"

@implementation BaseDownloadRequest

@synthesize name = _name;
@synthesize locale = _locale;
@synthesize creationUtc = _creationUtc;
@synthesize overrideStorageLocation = _overrideStorageLocation;
@synthesize priority = _priority;
@synthesize overridePermittedNetworkTypes = _overridePermittedNetworkTypes;
@synthesize length = _length;
@synthesize availableLength = _availableLength;
@synthesize finalStorageLocation = _finalStorageLocation;
@synthesize status = _status;
@synthesize finalPermittedNetworkTypes = _finalPermittedNetworkTypes;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.priority = 0.2;
        self.status = DownloadStatusNone;
    }
    
    return self;
}

- (void)dealloc
{
    [self.name release];
    [self.locale release];
    [self.creationUtc release];
    [self.overrideStorageLocation release];
    [self.finalStorageLocation release];
    
    [super dealloc];
}

@end
