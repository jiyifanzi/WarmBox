//
//  JYWeatherHourlyModel.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherHourlyModel.h"

@implementation JYWeatherHourlyModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_hum forKey:@"hum"];
    [aCoder encodeObject:_pop forKey:@"pop"];
    [aCoder encodeObject:_pres forKey:@"pres"];
    [aCoder encodeObject:_tmp forKey:@"tmp"];
    [aCoder encodeObject:_wind forKey:@"wind"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _date = [aDecoder decodeObjectForKey:@"date"];
        _hum = [aDecoder decodeObjectForKey:@"hum"];
        _pop = [aDecoder decodeObjectForKey:@"pop"];
        _pres = [aDecoder decodeObjectForKey:@"pres"];
        _tmp = [aDecoder decodeObjectForKey:@"tmp"];
        _wind = [aDecoder decodeObjectForKey:@"wind"];
    }
    return self;
}


@end



@implementation JYWeatherHourlyWindModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_deg forKey:@"deg"];
    [aCoder encodeObject:_dir forKey:@"dir"];
    [aCoder encodeObject:_sc forKey:@"sc"];
    [aCoder encodeObject:_spd forKey:@"spd"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _deg = [aDecoder decodeObjectForKey:@"deg"];
        _dir = [aDecoder decodeObjectForKey:@"dir"];
        _sc = [aDecoder decodeObjectForKey:@"sc"];
        _spd = [aDecoder decodeObjectForKey:@"spd"];
    }
    return self;
}
@end


