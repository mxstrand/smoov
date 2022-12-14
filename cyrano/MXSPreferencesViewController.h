//
//  MXSPreferencesViewController.h
//  cyrano
//
//  Created by Michael Strand on 9/25/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSPreferencesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *personLabel;

@property (nonatomic, weak) IBOutlet UILabel *weeklyCalendarEventStatusLabel;

@property (nonatomic, weak) IBOutlet UILabel *weeklyReminderStatusLabel;

@property (nonatomic, weak) IBOutlet UISwitch *weeklyCalendarEventSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *weeklyReminderSwitch;


@property (nonatomic, weak) IBOutlet UIButton *setDefaultRecipientButton;

@property (nonatomic, weak) IBOutlet UIButton *contactUsButton;

@property (nonatomic, weak) IBOutlet UIButton *shareWithUsButton;

@end
