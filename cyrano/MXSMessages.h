//
//  MXSMessages.h
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXSMessageCategory;

@interface MXSMessages : NSObject

- (void)messagesInCategory:(MXSMessageCategory *)category completion:(void (^)(NSArray *messages))completion;

- (NSArray *)categories;

@end
