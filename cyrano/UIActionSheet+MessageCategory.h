//
//  UIActionSheet+UIActionSheet_MessageCategory.h
//  cyrano
//
//  Created by Michael Strand on 10/1/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (MessageCategory) <UIActionSheetDelegate>

+(UIActionSheet*) showMessageCategoriesWithNavController:navController;

@end
