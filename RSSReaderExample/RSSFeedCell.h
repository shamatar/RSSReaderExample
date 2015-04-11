//
//  RSSFeedCell.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *feedNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedURLLabel;

@end
