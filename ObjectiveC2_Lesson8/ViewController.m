//
//  ViewController.m
//  ObjectiveC2_Lesson8
//
//  Created by Admin on 31.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"
#import "Result.h"
#import "TextCalculation.h"
#import <SDWebImage/UIImageView+WebCache.h>

/*
 Домашнее задание: Используя API социальной сети Вконтакте реализовать новостную ленту любой группы (из vk) на выбор.
 
 PS В работе использованы библиотеки: AFNetworking, SDWebImage, Jastor, TextCalculation
 
 */

@interface ViewController () <APIManagerDelegate>

@property (nonatomic, strong) NSMutableArray * arrayResult;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Создаем дикшинари для запроса на сервер:
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:
                             //использую id группы: dfilm (Достойные фильмы)
                             @"-33769500", @"owner_id",
                             @10, @"count",
                             @1, @"offset",
                             @"owner", @"filter", nil];
    
    [[APIManager managerWhitDelegate:self] getDataFromWall:params];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//-----------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - APIManagerDelegate

- (void) response: (APIManager *) manager Answer: (id) respObject {
    
    if ([respObject isKindOfClass:[Result class]]) {
        Result * res = (id) respObject;
        self.arrayResult = [[NSMutableArray alloc]init];
        
        int photoCount = 0;
        
        for (int i = 1; i < [res.response count]; i++) {
            
            if ([[[res.response objectAtIndex:i]attachment]photo]) {
                
                photoCount++; //количество фотографий к новостям

            }
          
        }
        
        for (int i = 1; i < [res.response count]; i++ ) {
               
                NSString * link = [[[[res.response objectAtIndex:i]attachment] photo] src_big];
                CGFloat height = [[[[res.response objectAtIndex:i]attachment] photo] height];
                CGFloat width = [[[[res.response objectAtIndex:i]attachment] photo] width];
                NSString * text = [[res.response objectAtIndex:i]text];
                text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
                //определяем размеры картинки и текста:
                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:link]
                                                                    options:0
                                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     // progression tracking code
                 }
                                                                  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                 {
                     if (image && finished)
                     {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             //
                         
                         
                         CGFloat heightNeeded = [self heightImage:height WidthImage:width];
                         
                         UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightNeeded)];
                       
                         imageView.image = [self resizing_Image:image height:heightNeeded width:self.view.frame.size.width];
                         
                         UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(0, heightNeeded, self.view.frame.size.width, [TextCalculation heightForText:text View:self.view Font:[UIFont systemFontOfSize:12]])];
                         
                         textView.userInteractionEnabled = NO; //блокируем вызов клавиатуры по нажатию на текствью
                         textView.font = [UIFont systemFontOfSize:12];
                         textView.text = text;
                         
                         UIView * viewNews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageView.bounds.size.height + textView.bounds.size.height)];
                         
                         [imageView addSubview:textView];
                         [viewNews addSubview:imageView];
                         
                         [self.arrayResult addObject:viewNews];
 
                         if (self.arrayResult.count == photoCount) { //загрузить таблицу после того, как наполнится массив
                             [self reload_TableView];
                         }
                             
                        });
                         
                     }
                 }];
                
                
            }
        
        }
    
    
}

- (void) responseError: (APIManager *) manager Error: (NSError*) error{
    
    NSLog(@"error: %@",error);
    
}

//-----------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) heightImage:(CGFloat)height WidthImage:(CGFloat)width {
    
    //меняем пропорции картинки
    
    CGFloat heightImageTable = 0.0;
    CGFloat proportion = 0.0;
    
    //если ширина картинки больше ширины экрана:
    if (width > self.view.frame.size.width) {
        
        if (height > width) { //если высота больше ширины
            proportion = height/width;
            heightImageTable = self.view.frame.size.width * proportion;
            
        }
        
        else { //если высота меньше или равно ширине
            proportion = width/height;
            heightImageTable = self.view.frame.size.width / proportion;
        }
    }
    
    
    //если ширина картинки меньше ширины экрана:
    else {
        
        if (width < self.view.frame.size.width) {
            proportion = self.view.frame.size.width - width;
            heightImageTable = height + proportion;
            
        }
        
        else {
            
            heightImageTable = height;
        }
        
    }
    
    
    return heightImageTable;
    
}


//-----------------------------------------------------------------------------------------------------------------------------------------

- (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width  {
    
    //метод, который ресайзит картинку
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//-----------------------------------------------------------------------------------------------------------------------------------------

#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    for (UIView * view in cell.contentView.subviews) {
        //избавление от бага наложения ячеек:
        [view removeFromSuperview];
    }
    
    
    [cell.contentView addSubview:[self.arrayResult objectAtIndex:indexPath.row]];
 
    return cell;
    
    
}
//-----------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //метод определяет высоту ячейки
    
    UIView * newsView = [self.arrayResult objectAtIndex:indexPath.row];
    
    return newsView.bounds.size.height;
    
}

//-----------------------------------------------------------------------------------------------------------------------------------------

//метод, который перезагружает таблицу:
- (void) reload_TableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];});
}





@end
