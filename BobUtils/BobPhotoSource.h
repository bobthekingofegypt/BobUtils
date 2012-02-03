//
//  BobPhotoSource.h
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import <UIKit/UIKit.h>

typedef enum {
    ImageTypeNotSet = 0,
    ImageTypePNG,
    ImageTypeJPG,
    ImageTypeGIF
} ImageType;


@interface BobPhotoSource : NSObject {
    NSString *imageLocation;
    NSString *imageLocationRetina;
    NSString *imageCacheKey;

    BOOL cached;
    BOOL retina;
    
    ImageType imageType;
}

@property (nonatomic, copy) NSString *imageLocation;
@property (nonatomic, copy) NSString *imageLocationRetina;
@property (nonatomic, copy) NSString *imageCacheKey;

/** returns the url location of the image */
-(NSString *) location;

/** Returns true if the photo source contains a retina version */
-(BOOL) retina;

/** The key to be used when caching the images */
-(NSString *) cacheKey;

/** Return the type of the image that is at the location of this photosource */
-(ImageType) imageType;

@end
