//
//  MXSMessages.h
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSMessages : NSObject

- (void)messagesInCategory:(NSString *)category completion:(void (^)(NSArray *messages))completion;

@end
