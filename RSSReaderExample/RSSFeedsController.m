//
//  RSSFeedsController.m
//  
//
//  Created by Alexander Vlasov on 10.04.15.
//
//

#import "RSSFeedsController.h"
#import "RSSReaderDataCode.h"
#import "RSSFeedCell.h"
#import "RSSFeed.h"
#import "RSSPostsController.h"
@interface RSSFeedsController ()

@end

@implementation RSSFeedsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:100];
    [self reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFeed:(UIBarButtonItem *)sender {
    UIAlertController *newFeedAlertController = [UIAlertController alertControllerWithTitle:@"Add new feed" message:@"Enter name and URL" preferredStyle:UIAlertControllerStyleAlert];
    [newFeedAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Feed name";
        textField.tag=0;
    }];
    [newFeedAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"http://";
        textField.tag=1;
    }];
    
    __weak UIAlertController *alertRef = newFeedAlertController;
    [newFeedAlertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *name = ((UITextField*)[[alertRef textFields] objectAtIndex:0]).text;
        NSString *feedURL = ((UITextField*)[[alertRef textFields] objectAtIndex:1]).text;
        if ( (name.length != 0) && (feedURL.length != 0)){
            BOOL success = [[RSSReaderDataCode sharedInstance] createFeedWithName:name URL:feedURL];
            if (success){
                [self reloadData];

            }
        }
    }]];
        
    [newFeedAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertRef dismissViewControllerAnimated:YES completion:^{
            return;
        }];
    }]];
    [self presentViewController:newFeedAlertController animated:YES completion:nil];
    
}
-(void)reloadData{
    NSArray *results = [[RSSReaderDataCode sharedInstance] entitiesForName:@"RSSFeed"];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:results];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSFeedCell *cell = (RSSFeedCell*)[tableView dequeueReusableCellWithIdentifier:@"RSSFeedCell" forIndexPath:indexPath];
    RSSFeed *feed = (RSSFeed*)[self.dataArray objectAtIndex:indexPath.row];
    cell.feedNameLabel.text = feed.name;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RSSFeed *record = [self.dataArray objectAtIndex:indexPath.row];
        if ([[RSSReaderDataCode sharedInstance] removeFeedWithObjectID:[record objectID]]){
        [self.dataArray removeObject:record];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    RSSPostsController *vc = (RSSPostsController *)[segue destinationViewController];
    RSSFeedCell *cell = (RSSFeedCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    RSSFeed *record = [self.dataArray objectAtIndex:path.row];
    vc.currentFeedName = record.name;
    vc.currentFeedURL = record.link;
    vc.currectObjectID = [record objectID];
    // Pass the selected object to the new view controller.
}


@end
