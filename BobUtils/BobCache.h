//
//  BobCache.h
//  BobUtils
//
//  Copyright (c) 2011 Richard Martin. All rights reserved.
//  Licensed under the terms of the BSD License, see LICENSE.txt
//

#import <Foundation/Foundation.h>

/** BobCache is a simple entry count limited LRU cache.  It is thread safe. 
 */
@interface BobCache : NSObject {
    @private
    NSMutableArray *keys;
    NSMutableDictionary *entries;
    NSUInteger capacity_;
    NSLock *lock;
}

/**---------------------------------------------------------------------------------------
 * @name Creating the cache
 *  ---------------------------------------------------------------------------------------
 */

/** Initialises a cache with the given capacity 
 @param capacity The maximum number of entries in the cache
 @return cache The created cache 
 */
-(id) initWithCapacity:(NSUInteger) capacity;

/**---------------------------------------------------------------------------------------
 * @name Interacting with the cache
 *  ---------------------------------------------------------------------------------------
 */

/** Returns the object stored under the given key or nil if it doesn't exist 
 @param key The key to identify the entry in the cache
 @return entry The entry stored under key or nil if no entry
 */
-(id) objectForKey:(NSString *) key;

/** Adds the given object to the cache, object can then be retrieved using the key
 @param object The object to be cached
 @param key The key to identify the object
 */
-(void) addObject:(id) object forKey:(NSString *)key;

/** Clears the current cache removing all entries */
-(void) clear;

@end
