//
//  TextCalculation.m
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "TextCalculation.h"

@implementation TextCalculation

+ (CGFloat) heightForText:(NSString*) text View: (UIView *) view Font: (UIFont *) fontType {
    //метод расчета размера текстового поля
    
    CGFloat offset = 5.0;
    UIFont* font = fontType;
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(view.frame.size.width - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}






@end
