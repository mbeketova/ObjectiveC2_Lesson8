//
//  Response.h
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"

@interface Response : Attachment

@property (nonatomic, strong) Attachment * attachment;
@property (nonatomic, copy) NSString * text;

@end
