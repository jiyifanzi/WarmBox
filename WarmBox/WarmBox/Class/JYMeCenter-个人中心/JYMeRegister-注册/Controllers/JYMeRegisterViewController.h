//
//  JYMeRegisterViewController.h
//  WarmBox
//
//  Created by JiYi on 16/7/18.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYMeRegisterViewController : JYBaseViewController

@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *userEmail;

@property (weak, nonatomic) IBOutlet UITextField *userPassword;

//  用户头像
@property (weak, nonatomic) IBOutlet UIButton *userIcon;

@end
