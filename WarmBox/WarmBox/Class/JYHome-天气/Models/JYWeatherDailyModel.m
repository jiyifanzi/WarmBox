//
//  JYWeatherDailyModel.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherDailyModel.h"

@implementation JYWeatherDailyModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_astro forKey:@"astro"];
    [aCoder encodeObject:_cond forKey:@"cond"];
    [aCoder encodeObject:_hum forKey:@"hum"];
    [aCoder encodeObject:_pcpn forKey:@"pcpn"];
    [aCoder encodeObject:_pop forKey:@"pop"];
    [aCoder encodeObject:_pres forKey:@"pres"];
    [aCoder encodeObject:_tmp forKey:@"tmp"];
    [aCoder encodeObject:_vis forKey:@"vis"];
    [aCoder encodeObject:_wind forKey:@"wind"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _date = [aDecoder decodeObjectForKey:@"date"];
        _astro = [aDecoder decodeObjectForKey:@"astro"];
        _cond = [aDecoder decodeObjectForKey:@"cond"];
        _hum = [aDecoder decodeObjectForKey:@"hum"];
        _pcpn = [aDecoder decodeObjectForKey:@"pcpn"];
        _pop = [aDecoder decodeObjectForKey:@"pop"];
        _pres = [aDecoder decodeObjectForKey:@"pres"];
        _tmp = [aDecoder decodeObjectForKey:@"tmp"];
        _vis = [aDecoder decodeObjectForKey:@"vis"];
        _wind = [aDecoder decodeObjectForKey:@"wind"];
    }
    return self;
}

@end


@implementation JYWeatherDailyAstroModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_sr forKey:@"sr"];
    [aCoder encodeObject:_ss forKey:@"ss"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _sr = [aDecoder decodeObjectForKey:@"_sr"];
        _ss = [aDecoder decodeObjectForKey:@"_ss"];
    }
    return self;
}

@end


@implementation JYWeatherDailyCondModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_code_d forKey:@"code_d"];
    [aCoder encodeObject:_code_n forKey:@"code_n"];
    [aCoder encodeObject:_txt_d forKey:@"txt_d"];
    [aCoder encodeObject:_txt_n forKey:@"txt_n"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _code_d = [aDecoder decodeObjectForKey:@"code_d"];
        _code_n = [aDecoder decodeObjectForKey:@"code_n"];
        _txt_d = [aDecoder decodeObjectForKey:@"txt_d"];
        _txt_n = [aDecoder decodeObjectForKey:@"txt_n"];
    }
    return self;
}

@end


@implementation JYWeatherDailyTmpModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_max forKey:@"max"];
    [aCoder encodeObject:_min forKey:@"min"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _max = [aDecoder decodeObjectForKey:@"max"];
        _min = [aDecoder decodeObjectForKey:@"min"];
    }
    return self;
}

@end


@implementation JYWeatherDailyWindModel

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
