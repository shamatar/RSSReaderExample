//
//  RSSFeedPost.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSFeed;

@interface RSSFeedPost : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * orderID;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) RSSFeed *feed;

@end
