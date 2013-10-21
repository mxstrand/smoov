//
//  MXSMessageReversalViewController.m
//  cyrano
//
//  Created by Michael Strand on 10/17/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageReversalViewController.h"
#import "FHSTwitterEngine.h"
#import <Twitter/Twitter.h>

#import <iAd/iAd.h>
#import "Flurry.h"
#import <uservoice-iphone-sdk/UserVoice.h>

@interface MXSMessageReversalViewController ()
{
    UIView *messageReversalInfo;
    UIImage *profileImg;
    NSString *author;
    UIView *myAdView;
}

@property (nonatomic, strong) IBOutlet ADBannerView *banner;
@property (nonatomic, weak) IBOutlet UIButton *authorImageButton;

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

    NSString *twitterAuthor = @"@";
    twitterAuthor = [twitterAuthor stringByAppendingString:_message.author];
    [authorLabel setText:twitterAuthor];
    
    [self clickableAuthor];
    [self getAuthorImageFromTwitter];
    [self createMyAd];
    
    // If 3.5 inch device, adjust view size and banner placement, so visible.
    if( self.view.frame.size.height == 480. ) {
        CGRect frame = self.view.frame;
        frame.size.height = self.view.frame.size.height - frame.origin.y - _banner.frame.size.height;
        self.view.frame = frame;
        
        frame = _banner.frame;
        frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        _banner.frame = frame;
        
        frame = myAdView.frame;
        frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        myAdView.frame = frame;
    }
    
    // Format button
    CALayer * layer = [self.authorImageButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:16.0]; //when radius is 0, the border is a rectangle
    [layer setBorderWidth:1.35];
    [layer setBorderColor:[[UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1] CGColor]];

    
    CALayer * layer2 = [self->authorLabel layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setCornerRadius:16.0]; //when radius is 0, the border is a rectangle
    [layer2 setBorderWidth:1.35];
    [layer2 setBorderColor:[[UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1] CGColor]];


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

- (void)clickableAuthor
{
    authorLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUrl:)];
    gestureRec.numberOfTouchesRequired = 1;
    gestureRec.numberOfTapsRequired = 1;
    [authorLabel addGestureRecognizer:gestureRec];
}

- (void)openUrl:(id)sender
{
    NSString *twitterAuthorProfileURL;
    twitterAuthorProfileURL = @"twitter://user?screen_name=";
    twitterAuthorProfileURL= [twitterAuthorProfileURL stringByAppendingString:_message.author];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterAuthorProfileURL]];
}


- (void)createMyAd
{
    myAdView = [[UIView alloc] initWithFrame:_banner.frame];
    myAdView.backgroundColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.view addSubview:myAdView];
    //myAdView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactUs)];
    // Set required taps and number of touches
    [touchOnView setNumberOfTapsRequired:1];
    [touchOnView setNumberOfTouchesRequired:1];
    [myAdView addGestureRecognizer:touchOnView];
    
    UILabel *adLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 300, 25)];
    
    [adLabel1 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]];
    [adLabel1 setBackgroundColor:[UIColor clearColor]];
    [adLabel1 setFont:[UIFont fontWithName: @"Helvetica-Bold" size: 15.0f]];
    [adLabel1 setNumberOfLines:2];
    [adLabel1 setText:@"Your name could be here too!"];
    [myAdView addSubview:adLabel1];
    
    UILabel *adLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(93, 25, 300, 20)];
    
    [adLabel2 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    [adLabel2 setBackgroundColor:[UIColor clearColor]];
    [adLabel2 setFont:[UIFont fontWithName: @"Helvetica-Bold" size: 15.0f]];
    [adLabel2 setNumberOfLines:2];
    [adLabel2 setText:@"Click here to 'POST AN IDEA'"];
    [myAdView addSubview:adLabel2];
    
}



# pragma mark - Ad Error Handling

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error Loading Ad in %@", [self class]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:myAdView];
    });
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"did load ad %@", [self class]);
    
    [myAdView removeFromSuperview];
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

- (void)contactUs
{
    UVConfig *config = [UVConfig configWithSite:@"smoov.uservoice.com"
                                         andKey:@"jXrGUkCby9YjzgTsoKIA"
                                      andSecret:@"xSDPS0gEKKTf8R142QuJlrR3VjPpqlAtAcWMw6R0Y"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
    [Flurry logEvent:@"Uservoice engaged from ad"];
}


- (IBAction)showAuthorProfileImages:(id)sender
{
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"PYY26ixEeMeTzsV9UnV3A" andSecret:@"Uq6E52txfWkndIq0d29bShaYpsdv2NoV50d7MCnVwo"];

    [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self
                                                                withCompletion:^(BOOL success) {
        if (success) {
            [self getAuthorImageFromTwitter];
            //[[FHSTwitterEngine sharedEngine]setDelegate:self];
        }
    }];
}

- (void)getAuthorImageFromTwitter
{
    NSString *messageAuthor = _message.author;
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    UIImage *authorProfileImg = [[FHSTwitterEngine sharedEngine] getProfileImageForUsername:messageAuthor andSize:FHSTwitterEngineImageSizeNormal];
    
    if ([authorProfileImg isKindOfClass:[UIImage class]]) {
        profileImage.image = authorProfileImg;
    }
    else {
        NSLog(@"%@", authorProfileImg);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
