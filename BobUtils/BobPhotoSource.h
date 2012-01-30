//
//  BobPhotoSource.h
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import <Foundation/Foundation.h>

typedef enum {
   ImageTypePNG,
   ImageTypeJPG,
    ImageTypeGIF
} ImageType;

/** Any photo source object must adopt the BobPhotoSource protocol. 
 */
@protocol BobPhotoSource <NSObject>

/** returns the url location of the image */
-(NSString *) location;

/** Returns true if the photo source contains a retina version */
-(BOOL) retina;

/** The key to be used when caching the images */
-(NSString *) cacheKey;

@optional
/** Return the type of the image that is at the location of this photosource */
-(ImageType) imageType;

@end
