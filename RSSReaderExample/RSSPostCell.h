//
//  RSSPostCell.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partOfBodyLabel;

@end
