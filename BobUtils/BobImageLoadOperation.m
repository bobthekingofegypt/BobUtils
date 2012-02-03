//
//  BobImageLoadOperation.h
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import "BobImageLoadOperation.h"

#define kStatusResponseOK 200

@interface BobImageLoadOperation()
-(void)cache:(NSData *)imageData;
-(NSData*) getStoredImage;
@end

@implementation BobImageLoadOperation

@synthesize delegate;
@synthesize bobCache;

-(id) initWithPhotoSource:(BobPhotoSource *) photoSource {
    self = [super init];
    if (self) {
        photoSource_ = [photoSource retain];
    }
    
    return self;
}

-(void) dealloc {
    [photoSource_ release];
    [bobCache release];
    
    [super dealloc];
}

-(CGDataProviderRef) loadWebResource:(NSError **)error {
    NSData *imageData = [self getStoredImage];
    if (imageData) {
        return CGDataProviderCreateWithCFData((CFDataRef)imageData);
    } 
      
    NSURL *url = [NSURL URLWithString:[photoSource_ location]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    NSError *urlResponseError;
    NSURLResponse *response;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlResponseError]; 
        
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
    if ([httpResponse statusCode] == kStatusResponseOK) {
        mimeType = [response MIMEType];
        [self cache:result];
        
        return CGDataProviderCreateWithCFData((CFDataRef)result);
    }
    
    *error = [NSError errorWithDomain:@"failed to load remote image" code:2 userInfo:nil];
    return NULL;
}

-(CGDataProviderRef) createDataProvider:(NSError **)error {
    CGDataProviderRef dataProvider;
    
    if ([[photoSource_ location] hasPrefix:@"http"]) {
        dataProvider = [self loadWebResource:error];
    } else {
        dataProvider = CGDataProviderCreateWithFilename([[photoSource_ location] UTF8String]);
    }
    
    return dataProvider;
}

-(CGImageRef) createImageRef:(CGDataProviderRef) dataProvider {
    if ([[photoSource_ location] hasSuffix:@".png"] || [mimeType isEqualToString:@"image/png"]) {
        return CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, 
                                                 kCGRenderingIntentDefault);
    } 
    
    return CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, 
                                                  kCGRenderingIntentDefault);
}

-(void) loadGifImage:(CGDataProviderRef) dataProvider {
    UIImage *image = [UIImage imageWithData:(NSData*)dataProvider];
    [bobCache addObject:image forKey:[photoSource_ location]];
    
    if (image) {
        [delegate bobImageLoadOperation:self imageLoaded:image];
    } else {
        NSError *error = [NSError errorWithDomain:@"failed to gif image" code:1 userInfo:nil];
        [delegate bobImageLoadOperation:self imageLoadFailed:error];
    }
}

-(void) main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    CGDataProviderRef dataProvider = [self createDataProvider:&error];
    if (!dataProvider) {
        [delegate bobImageLoadOperation:self imageLoadFailed:error];
        return;
    }
    
    if ([photoSource_ imageType] == ImageTypeGIF || 
            [[photoSource_ location] hasSuffix:@".gif"] || 
            [mimeType isEqualToString:@"image/gif"]) {
        [self loadGifImage:dataProvider];
    } else {
        CGImageRef image = [self createImageRef:dataProvider];
        
        [self performSelectorOnMainThread:@selector(preloadImage:) 
                               withObject:[NSValue valueWithPointer:image] waitUntilDone:YES];
        
        CGImageRelease(image);
    }
    
    CGDataProviderRelease(dataProvider);
    
    [pool release];
    
    return;
}

-(void) preloadImage:(NSValue *) value  {
    CGImageRef imageRef = [value pointerValue];
    UIImage *image = nil;
    if ([photoSource_ retina]) {
        image = [UIImage imageWithCGImage:imageRef scale:2.0f orientation:UIImageOrientationUp];
    } else {
        image = [UIImage imageWithCGImage:imageRef];
    }
   
    [bobCache addObject:image forKey:[photoSource_ location]];
    
    if (image) {
        [delegate bobImageLoadOperation:self imageLoaded:image];
    } else {
        NSError *error = [NSError errorWithDomain:@"failed to preload image" code:3 userInfo:nil];
        [delegate bobImageLoadOperation:self imageLoadFailed:error];
    }
}

-(void)cache:(NSData *)imageData {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobimagecache",[paths objectAtIndex:0]];
	
	NSFileManager *fileman = [[NSFileManager alloc] init];
	if (![fileman fileExistsAtPath:imagesDirectory]) {
		[fileman createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	[fileman release];
	
    NSString *key = [photoSource_ cacheKey];
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:key];
    
	[imageData writeToFile:filenameStr atomically:YES];
}


-(NSData*) getStoredImage {
	if ([photoSource_ location] == (id)[NSNull null]) return nil;
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														 NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobimagecache",[paths objectAtIndex:0]];
    NSString *key = [photoSource_ cacheKey];

	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:key];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *imageData = nil;
	
	if ([fileManager fileExistsAtPath:filenameStr]) {
		imageData = [NSData dataWithContentsOfFile:filenameStr];
	}
	
	[fileManager release];
	return imageData;	
}

@end
