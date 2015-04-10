//
//  RSSPostDetailsViewController.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSPostDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *postBodyTextView;
@property (strong, nonatomic) NSString *postName;
@property (strong, nonatomic) NSString *postBody;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
