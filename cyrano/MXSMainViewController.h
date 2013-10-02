//
//  MXSViewController.h
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSMainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void)showSMS:(NSString*)message;

@end
