//
//  UIActionSheet+MessageCategory.m
//  cyrano
//
//  Created by Michael Strand on 10/1/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "UIActionSheet+MessageCategory.h"

@implementation UIActionSheet (MessageCategory)

static id theNavController = nil;

+(UIActionSheet*) showMessageCategoriesWithNavController:navController
{
    theNavController = navController;
    UIActionSheet *displayImageOption = [[UIActionSheet alloc] initWithTitle:@""
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"Flirt / Funny",
                                         @"Get a Date",
                                         @"Birthday / Anniversary",
                                         @"Romantic",
                                         @"Get Lucky",
                                         @"Most Popular",
                                         @"I'm Sorry", nil];
    displayImageOption.delegate = displayImageOption;
    [displayImageOption setOpaque:YES];
    
    return displayImageOption;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self gotoFlirtFunny];
    }
    if(buttonIndex == 1){
        [self gotoGetADate];
    }
    if(buttonIndex == 2){
        [self gotoBirthdayAnniversary];
    }
    if(buttonIndex == 3){
        [self gotoRomantic];
    }
    if(buttonIndex == 4){
        [self gotoGetLucky];
    }
    if(buttonIndex == 5){
        [theNavController popToRootViewControllerAnimated:YES];
    }
    if(buttonIndex == 6){
        [self gotoImSorry];
    }
}

- (void)gotoFlirtFunny
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //The name "Main_iPhone" is the filename of your storyboard (without the extension).
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSFlirtViewController"];
    // push to current navigation controller, from any view controller
    
    [theNavController pushViewController:vc animated:YES];
    //The view controller's identifier has to be set as the "Storyboard ID" in the Identity Inspector.
    
}

- (void)gotoBirthdayAnniversary
{
    
}

- (void)gotoGetADate
{
    
}

- (void)gotoRomantic
{
}

- (void)gotoGetLucky
{
    
}

- (void)gotoImSorry
{
    
}


- (void)willPresentActionSheet:(UIActionSheet *)displayImageOption
{
    //displayImageOption.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
}


@end
