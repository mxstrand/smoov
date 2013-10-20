//
//  MXSMessageCategory.h
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSMessageCategory : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *key;

- (id)initWithTitle:(NSString *)title key:(NSString *)key;

@end
