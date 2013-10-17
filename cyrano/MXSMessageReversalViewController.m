//
//  MXSMessageReversalViewController.m
//  cyrano
//
//  Created by Michael Strand on 10/17/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageReversalViewController.h"

@interface MXSMessageReversalViewController ()
{
    UIView *messageReversalInfo;
}
@end

@implementation MXSMessageReversalViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [messageLabel setText:_message.content];
    
    visualPopularityImage.image = [self imageForPopularity:_message.popularityImage];
    
    //[self subViewMethod];
	// Do any additional setup after loading the view.
}


- (UIImage *)imageForPopularity:(CGFloat)popularity
{
    //    NSLog(@"Magnitude is: %f", magnitude);
    UIImage *popularityImage = nil;
    
    if (popularity <= 1) {
		popularityImage = [UIImage imageNamed:@"1star"];
	}
    else if (popularity >= 1.1 && popularity <= 2) {
		popularityImage = [UIImage imageNamed:@"2star"];
	}
    
    else if (popularity >= 2.1 && popularity <= 3) {
		popularityImage = [UIImage imageNamed:@"3star"];
	}
    
    else if (popularity >= 3.1 && popularity <= 4) {
		popularityImage = [UIImage imageNamed:@"4star"];
	}
    
    else {
		popularityImage = [UIImage imageNamed:@"5star"];
	}
    
	return popularityImage;
}

- (void)subViewMethod
{
    [messageReversalInfo removeFromSuperview];
    messageReversalInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0., self.view.frame.size.width, self.view.frame.size.height)];
    messageReversalInfo.backgroundColor = [UIColor redColor];
    [self.navigationController.view addSubview:messageReversalInfo];
    
    UITapGestureRecognizer *touchOnMessageReversal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMessageReversal)];
    // Set required taps and number of touches
    [touchOnMessageReversal setNumberOfTapsRequired:1];
    [touchOnMessageReversal setNumberOfTouchesRequired:1];
    [messageReversalInfo addGestureRecognizer:touchOnMessageReversal];
    
    UILabel *adLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 300, 25)];
    
    [adLabel1 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]];
    [adLabel1 setBackgroundColor:[UIColor clearColor]];
    [adLabel1 setFont:[UIFont fontWithName: @"Helvetica-Bold" size: 15.0f]];
    [adLabel1 setNumberOfLines:2];
    
    NSString *selectedContent = _message.content;
    [adLabel1 setText:selectedContent];
    [messageReversalInfo addSubview:adLabel1];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
