//
//  MXSViewController.h
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface MXSMainViewController : UIViewController <ADBannerViewDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *messages;
    NSUserDefaults *standard; //supports abbreviated code in NSUserDefaults code references.

    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;    
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet ADBannerView *banner;

@property (nonatomic, strong) IBOutlet UIImageView *logo;

- (void)showSMS:(NSString*)message;

@end
