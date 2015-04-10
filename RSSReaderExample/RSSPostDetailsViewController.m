//
//  RSSPostDetailsViewController.m
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import "RSSPostDetailsViewController.h"

@interface RSSPostDetailsViewController ()

@end

@implementation RSSPostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postNameLabel.text = self.postName;
    self.postBodyTextView.text = self.postBody;
    [self.webView loadHTMLString:self.postBody baseURL:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
