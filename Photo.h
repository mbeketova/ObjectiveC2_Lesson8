//
//  Photo.h
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Photo : Jastor

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSString * src_big;


@end
