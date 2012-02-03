//
//  BobImageLoadOperation.h
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import <UIKit/UIKit.h>
#import "BobCache.h"
#import "BobPhotoSource.h"

@protocol BobImageLoadOperationDelegate;

/** BobImageLoadOperation is an NSOperation for loading a disk or remote image file. 
 */
@interface BobImageLoadOperation : NSOperation {
    BobPhotoSource *photoSource_;
    BobCache *bobCache;
    
    id<BobImageLoadOperationDelegate> delegate;
    
    BOOL failed;
    NSString *mimeType;
}

/**---------------------------------------------------------------------------------------
 * @name Managing the delegate
 *  ---------------------------------------------------------------------------------------
 */

/** the delegate for this image load operation */
@property (nonatomic, assign) id<BobImageLoadOperationDelegate> delegate;

/**---------------------------------------------------------------------------------------
 * @name Managing the cache
 *  ---------------------------------------------------------------------------------------
 */ 

/** the cache to place the image in once loaded */
@property (nonatomic, retain) BobCache *bobCache;

/**---------------------------------------------------------------------------------------
 * @name Initialising the image load operation
 *  ---------------------------------------------------------------------------------------
 */ 

/** Creates an image load operation for the given photosource
 @param photoSource The photosource containing the location of the photo
 @return the image load operation
 */
-(id) initWithPhotoSource:(BobPhotoSource *) photoSource;

@end


/** The delegate of a BSGView must adopt the BSGViewDelegate protocol. 
 */
@protocol BobImageLoadOperationDelegate <NSObject>
/** 
 Informs the delegate when an image loads successfully.
 @param bobImageLoadOperation An object representing the BobImageLoadOperation providing this information.
 @param image The loaded image
 */
-(void) bobImageLoadOperation:(BobImageLoadOperation*)bobImageLoadOperation imageLoaded:(UIImage *) image;

/** 
 Informs the delegate when an image load fails.
 @param bobImageLoadOperation An object representing the BobImageLoadOperation providing this information.
 @param error The error caused when loading
 */
-(void) bobImageLoadOperation:(BobImageLoadOperation*)bobImageLoadOperation imageLoadFailed:(NSError *)error;

@end
