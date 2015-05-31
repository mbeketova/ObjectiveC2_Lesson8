//
//  APIManager.m
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "APIManager.h"
#import "Result.h"


#define     MAIN_URL   @"https://api.vk.com/method/"

@implementation APIManager

+ (APIManager*) managerWhitDelegate: (id <APIManagerDelegate>) aDelegate {
    
    return [[APIManager alloc]initWhitDelegate:aDelegate];
}

- (id) initWhitDelegate: (id <APIManagerDelegate>) aDelegate {
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    
    return self;
    
}

- (void) getDataFromWall: (NSDictionary*) params {
    
    NSURL*url = [NSURL URLWithString:MAIN_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
    [manager GET:@"wall.get" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        Result * res = [[Result alloc] initWithDictionary:responseObject];
        
        //Получение данных:
        
        if ([self.delegate respondsToSelector:@selector(response:Answer:)]) {
            [self.delegate response:self Answer:res];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(responseError:Error:)]) {
            [self.delegate responseError:self Error:error];
        }

    }];
    
}
   
   
   
@end
