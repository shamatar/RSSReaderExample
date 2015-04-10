//
//  RSSFeed.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSFeedPost;

@interface RSSFeed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * orderID;
@property (nonatomic, retain) NSOrderedSet *posts;
@end

@interface RSSFeed (CoreDataGeneratedAccessors)

- (void)insertObject:(RSSFeedPost *)value inPostsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPostsAtIndex:(NSUInteger)idx;
- (void)insertPosts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePostsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPostsAtIndex:(NSUInteger)idx withObject:(RSSFeedPost *)value;
- (void)replacePostsAtIndexes:(NSIndexSet *)indexes withPosts:(NSArray *)values;
- (void)addPostsObject:(RSSFeedPost *)value;
- (void)removePostsObject:(RSSFeedPost *)value;
- (void)addPosts:(NSOrderedSet *)values;
- (void)removePosts:(NSOrderedSet *)values;
@end
