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

@interface BobImageLoadOperation : NSOperation {
    @private
    id<BobPhotoSource> photoSource_;
    UIImage *image_;
    id<BobImageLoadOperationDelegate> delegate;
    BobCache *bobCache;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) BobCache *bobCache;

-(id) initWithPhotoSource:(id<BobPhotoSource>) photoSource;

@end

@protocol BobImageLoadOperationDelegate <NSObject>
-(void) imageLoaded:(UIImage *) image;
-(void) imageLoadFailed;
@end
