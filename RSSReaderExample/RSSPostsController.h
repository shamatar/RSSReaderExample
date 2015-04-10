//
//  RSSPostsController.h
//  
//
//  Created by Alexander Vlasov on 10.04.15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MWFeedParser.h"

@interface RSSPostsController : UITableViewController
@property (strong, nonatomic) NSString *currentFeedURL;
@property (strong, nonatomic) NSString *currentFeedName;
@property (strong, nonatomic) NSManagedObjectID *currectObjectID;
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableDictionary *postItem;
@property (strong, nonatomic) NSMutableString *postTitle;
@property (strong, nonatomic) NSMutableString *postLink;
@property (strong, nonatomic) NSMutableString *postDescription;
@property (strong, nonatomic) NSString *element;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MWFeedParser *mwParser;
@property (assign, nonatomic) BOOL shouldRefreshAfterLoading;

@end
