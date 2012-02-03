//
//  BobPhotoSource.m
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import "BobPhotoSource.h"

@implementation BobPhotoSource

@synthesize imageLocation;
@synthesize imageLocationRetina;
@synthesize imageCacheKey;

-(void) dealloc {
    [imageLocation release];
    [imageLocationRetina release];
    [imageCacheKey release];
    [super dealloc];
}

-(NSString *) location {
    if ([self retina]) {
        return imageLocationRetina;
    }
    
    return imageLocation;
}

-(NSString *) cacheKey {
    return [self location];
}

-(BOOL) retina {
    if (cached) {
        return retina;
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            retina = YES;
        }
    } else {
        retina = NO;
    }
    
    cached = YES;
    return retina;
}

-(ImageType) imageType {
    return imageType;
}



@end
