//
//  Attachment.h
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface Attachment : Photo

@property (nonatomic, strong) Photo * photo;
@property (nonatomic, copy) NSString * type;

@end
