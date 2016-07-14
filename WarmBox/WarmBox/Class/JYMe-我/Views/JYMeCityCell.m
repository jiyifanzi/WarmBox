//
//  JYMeCityCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/1.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeCityCell.h"

@interface JYMeCityCell ()



@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@property (weak, nonatomic) IBOutlet UILabel *weaherDesc;

//  网络请求管理者
@property (nonatomic, strong) AFHTTPSessionManager * requestManager;

@end

@implementation JYMeCityCell

- (void)awakeFromNib {
    // Initialization code
    
    _location.hidden = YES;
}

//  实例化网络请求管理者
- (AFHTTPSessionManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPSessionManager manager];
        //self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8", nil];
        //  更改json解析器的解析支持文件格式
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestManager.responseSerializer.acceptableContentTypes = [_requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _requestManager;
}


- (void)setModel:(JYWeatherModel *)model {
    
    _model = model;

    
    _weaherDesc.text = model.now.cond.txt;
    
    _weatherImage.image = [UIImage imageNamed:[JYWeatherTools getBackImageNameWithWeatherNumber:model.now.cond.code]];
}
- (void)setCityName:(NSString *)cityName {
    
    _cityName = cityName;
    
    _cityNameLabel.text = self.cityName;
    
    //  以name来请求数据
    [self requestDataWithCityName:cityName];
}

- (void)requestDataWithCityName:(NSString *)cityName {
    //  更改编码
    NSString * cityNameStr = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.requestManager.responseSerializer.acceptableContentTypes = [self.requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [self.requestManager.requestSerializer setValue:@"66bc66db9d0b9dcc7b9a4c712830549a" forHTTPHeaderField:@"apikey"];
    
    //  请求数据
    [self.requestManager GET:[NSString stringWithFormat:WB_Weather,cityNameStr] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * dataArray = responseObject[@"HeWeather data service 3.0"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYWeatherModel class] json:dataArray];
        self.model = [modelArray firstObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
