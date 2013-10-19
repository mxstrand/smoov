//
//  MXSMessageCell.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageCell.h"
#import "MXSMessage.h"
#import <Parse/Parse.h>

@implementation MXSMessageCell


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


@end
