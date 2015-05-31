//
//  TextCalculation.h
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//класс, который изменяет табличную ячейку в зависимости от размера текста


@interface TextCalculation : NSObject

+ (CGFloat) heightForText:(NSString*) text View: (UIView *) view Font: (UIFont *) fontType;

@end
