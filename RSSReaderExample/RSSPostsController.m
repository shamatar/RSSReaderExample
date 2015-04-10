//
//  RSSPostsController.m
//  
//
//  Created by Alexander Vlasov on 10.04.15.
//
//

#import "RSSPostsController.h"
#import "RSSReaderDataCode.h"
#import "RSSFeed.h"
#import "RSSFeedPost.h"
#import "RSSPostCell.h"
#import "RSSPostDetailsViewController.h"
#import "NSString+HTML.h"

@interface RSSPostsController () <NSXMLParserDelegate,MWFeedParserDelegate>

@end


@implementation RSSPostsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:200];
    self.tempPostsArray = [NSMutableArray arrayWithCapacity:200];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(attempRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.shouldRefreshAfterLoading=YES;
    [self reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)feedParserDidStart:(MWFeedParser *)parser{
    NSLog(@"Started");
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    NSLog(@"Did parse feed info");
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = item.title ? item.title : @"[No Title]";
        NSString *link = item.link ? item.link : @"[No Link]";
        NSString *summary = item.summary ? item.summary : @"[No Summary]";
        NSString *content = item.content ? item.content : @"[No Content]";
        NSDictionary *dict = @{@"title":title,
                           @"link":link,
                           @"summary":summary,
                           @"content":content,};
        [self.tempPostsArray addObject:dict];
//    });
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *results = [[RSSReaderDataCode sharedInstance] postForFeedWithObjectID:self.currectObjectID];
        NSMutableArray *mutable = [NSMutableArray arrayWithArray:results];
        for (RSSFeedPost *post in mutable){
//            NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
//            [context refreshObject:post mergeChanges:YES];
            [[RSSReaderDataCode sharedInstance] removePostWithObjectID:[post objectID]];
        }
        for (NSDictionary *item in self.tempPostsArray){
            [[RSSReaderDataCode sharedInstance] createPostWithTitle:[item objectForKey:@"title"] Summary:[[item objectForKey:@"summary"] stringByConvertingHTMLToPlainText] Content:[item objectForKey:@"content"] Link:[item objectForKey:@"link"]  ForFeedObjectID:self.currectObjectID];
        }
        [self reloadData];
//    });
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    if (self.refreshControl.refreshing){
        [self.refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (void)attempRefresh:(UIRefreshControl *)sender {
    [self.tempPostsArray removeAllObjects];
    NSURL *url = [NSURL URLWithString:self.currentFeedURL];
    self.mwParser = [[MWFeedParser alloc] initWithFeedURL:url];
    self.mwParser.delegate = self;
    self.mwParser.feedParseType = ParseTypeFull;
    self.mwParser.connectionType = ConnectionTypeAsynchronously;
    [self.mwParser parse];
}



-(void)reloadData{
    [self.dataArray removeAllObjects];
    NSArray *res = [[RSSReaderDataCode sharedInstance] postForFeedWithObjectID:self.currectObjectID];
    [self.dataArray addObjectsFromArray:res];
    if (self.refreshControl.refreshing){
        [self.refreshControl endRefreshing];
    }
    [self.tableView reloadData];
    if (self.shouldRefreshAfterLoading){
        NSURL *url = [NSURL URLWithString:self.currentFeedURL];
        self.mwParser = [[MWFeedParser alloc] initWithFeedURL:url];
        self.mwParser.delegate = self;
        self.mwParser.feedParseType = ParseTypeFull;
        self.mwParser.connectionType = ConnectionTypeAsynchronously;
        [self.mwParser parse];
        self.shouldRefreshAfterLoading=NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSPostCell *cell = (RSSPostCell*)[tableView dequeueReusableCellWithIdentifier:@"RSSPostCell" forIndexPath:indexPath];
    RSSFeedPost *post = (RSSFeedPost*)[self.dataArray objectAtIndex:indexPath.row];
    cell.postNameLabel.text = post.title;
    cell.partOfBodyLabel.text = post.summary;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    NSString *name = segue.identifier;
    RSSPostDetailsViewController *vc = (RSSPostDetailsViewController *)[segue destinationViewController];
    RSSPostCell *cell = (RSSPostCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    RSSFeedPost *record = [self.dataArray objectAtIndex:path.row];
    vc.postName = record.title;
    if ([record.content isEqualToString:@"[No Content]"]){
        vc.postBody=record.summary;
    }
    else{
        vc.postBody = record.content;
    }
    // Pass the selected object to the new view controller.
}

@end
