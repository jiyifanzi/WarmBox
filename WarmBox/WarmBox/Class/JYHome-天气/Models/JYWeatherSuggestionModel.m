//
//  JYWeatherSuggestionModel.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherSuggestionModel.h"

@implementation JYWeatherSuggestionModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_comf forKey:@"comf"];
    [aCoder encodeObject:_cw forKey:@"cw"];
    [aCoder encodeObject:_drsg forKey:@"drsg"];
    [aCoder encodeObject:_flu forKey:@"flu"];
    [aCoder encodeObject:_sport forKey:@"sport"];
    [aCoder encodeObject:_trav forKey:@"trav"];
    [aCoder encodeObject:_uv forKey:@"uv"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _comf = [aDecoder decodeObjectForKey:@"comf"];
        _cw = [aDecoder decodeObjectForKey:@"cw"];
        _drsg = [aDecoder decodeObjectForKey:@"drsg"];
        _flu = [aDecoder decodeObjectForKey:@"flu"];
        _sport = [aDecoder decodeObjectForKey:@"sport"];
        _trav = [aDecoder decodeObjectForKey:@"trav"];
        _uv = [aDecoder decodeObjectForKey:@"uv"];
    }
    return self;
}

@end


@implementation JYWeatherSugDescModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_brf forKey:@"brf"];
    [aCoder encodeObject:_txt forKey:@"txt"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _brf = [aDecoder decodeObjectForKey:@"brf"];
        _txt = [aDecoder decodeObjectForKey:@"txt"];
    }
    return self;
}

@end