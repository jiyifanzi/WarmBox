//
//  JYWeatherNowModel.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherNowModel.h"



@implementation JYWeatherNowModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cond forKey:@"cond"];
    [aCoder encodeObject:_fl forKey:@"fl"];
    [aCoder encodeObject:_hum forKey:@"hum"];
    [aCoder encodeObject:_pcpn forKey:@"pcpn"];
    [aCoder encodeObject:_pres forKey:@"pres"];
    [aCoder encodeObject:_tmp forKey:@"tmp"];
    [aCoder encodeObject:_vis forKey:@"vis"];
    [aCoder encodeObject:_wind forKey:@"wind"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _cond = [aDecoder decodeObjectForKey:@"cond"];
        _fl = [aDecoder decodeObjectForKey:@"fl"];
        _hum = [aDecoder decodeObjectForKey:@"hum"];
        _pcpn = [aDecoder decodeObjectForKey:@"pcpn"];
        _pres = [aDecoder decodeObjectForKey:@"pres"];
        _tmp = [aDecoder decodeObjectForKey:@"tmp"];
        _vis = [aDecoder decodeObjectForKey:@"vis"];
        _wind = [aDecoder decodeObjectForKey:@"wind"];
    }
    return self;
}

@end



@implementation JYWeatherNowCondModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_code forKey:@"code"];
    [aCoder encodeObject:_txt forKey:@"txt"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _code = [aDecoder decodeObjectForKey:@"code"];
        _txt = [aDecoder decodeObjectForKey:@"txt"];
    }
    return self;
}

@end



@implementation JYWeatherNowWindModel

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
        _spd = [aDecoder decodeObjectForKey:@"sdp"];
    }
    return self;
}


@end


