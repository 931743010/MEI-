//
//  SignUp.m
//  MEI
//
//  Created by Yosemite on 3/12/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "SignUp.h"
#import "HeaderFooterManager.h"
#import "SignIn.h"

@interface SignUp ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;//with navigation button bar
    UITextField *_name;
    UITextField *_password;
    UITextField *_extTextField;
}
@end

@implementation SignUp

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    _headerHeight = (0.220689 - 0.02) * _viewHeight;
    
    UIImageView *backgouund = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headerHeight * 0.61, _viewWidth, _viewHeight - _headerHeight * 0.61)];
    [[self view] addSubview:backgouund];
    [backgouund release];
    [backgouund setImage:[UIImage imageNamed:@"login_bg_ios@2x.png"]];
    [backgouund setContentMode:UIViewContentModeTop];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackOnly withTitle:@"会员注册"];
    UIImageView *bg_login = [[UIImageView alloc] initWithFrame:CGRectMake(0.1 * _viewWidth, 0.35 * _viewHeight, 0.8 * _viewWidth, 0.255 * _viewHeight)];
    [bg_login setImage:[UIImage imageNamed:@"bg_login1@2x.png"]];
    [[self view] addSubview:bg_login];
    [bg_login release];
    UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.333333 * [bg_login bounds].size.height, [bg_login bounds].size.width, 0.5)];
    [midLine setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [bg_login addSubview:midLine];
    [midLine release];
    UIImageView *midLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.666666 * [bg_login bounds].size.height, [bg_login bounds].size.width, 0.5)];
    [midLine2 setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [bg_login addSubview:midLine2];
    [midLine2 release];
    _name = [[UITextField alloc] initWithFrame:CGRectMake(60 + [bg_login frame].origin.x, [bg_login frame].origin.y, [bg_login bounds].size.width - 60, 0.333333 * [bg_login bounds].size.height)];
    _password = [[UITextField alloc] initWithFrame:CGRectMake(60 + [bg_login frame].origin.x, 0.333333 * [bg_login bounds].size.height + [bg_login frame].origin.y, [bg_login bounds].size.width - 60, 0.333333 * [bg_login bounds].size.height)];
    _extTextField = [[UITextField alloc] initWithFrame:CGRectMake(60 + [bg_login frame].origin.x, 0.666666 * [bg_login bounds].size.height + [bg_login frame].origin.y, [bg_login bounds].size.width - 60, 0.333333 * [bg_login bounds].size.height)];
    [[self view] addSubview:_name];
    [[self view] addSubview:_password];
    [[self view] addSubview:_extTextField];
    [_name release];
    [_password release];
    [_extTextField release];
    [_name setPlaceholder:@"请输入您的EMAIL地址"];
    [_password setPlaceholder:@"（6-20个字符）"];
    [_extTextField setPlaceholder:@"请重新输入您的密码"];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 0.333333 * [bg_login bounds].size.height)];
    UILabel *password = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.333333 * [bg_login bounds].size.height, 40, 0.333333 * [bg_login bounds].size.height)];
    UILabel *extLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.666666 * [bg_login bounds].size.height, 40, 0.333333 * [bg_login bounds].size.height)];
    [bg_login addSubview:name];
    [bg_login addSubview:password];
    [bg_login addSubview:extLabel];
    [name release];
    [password release];
    [extLabel release];
    [name setText:@"邮箱:"];
    [password setText:@"密码:"];
    [extLabel setText:@"确认:"];
    [_name setTextAlignment:NSTextAlignmentLeft];
    [_password setTextAlignment:NSTextAlignmentLeft];
    [extLabel setTextAlignment:NSTextAlignmentRight];
    [name setTextAlignment:NSTextAlignmentRight];
    [password setTextAlignment:NSTextAlignmentRight];
    [_name setFont:[UIFont systemFontOfSize:14]];
    [_password setFont:[UIFont systemFontOfSize:14]];
    [name setFont:[UIFont systemFontOfSize:14]];
    [password setFont:[UIFont systemFontOfSize:14]];
    [extLabel setFont:[UIFont systemFontOfSize:14]];
    [_extTextField setFont:[UIFont systemFontOfSize:14]];
    
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake([bg_login frame].origin.x, 1.785 * [bg_login frame].origin.y, [bg_login bounds].size.width, [bg_login bounds].size.height / 3.01)];
    [signupButton setBackgroundImage:[UIImage imageNamed:@"button_red_big2.png"] forState:UIControlStateNormal];
    [[self view] addSubview:signupButton];
    [signupButton release];
    [signupButton setTitle:@"注册" forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *signIn = [[UILabel alloc] initWithFrame:CGRectMake(0.25 * _viewWidth, 0.7 * _viewHeight, 0.5 * _viewWidth, 0.08 * _viewHeight)];
    [[self view] addSubview:signIn];
    [signIn release];
    [signIn setText:@"已经是会员"];
    [signIn setFont:[UIFont systemFontOfSize:14]];
    UIButton *signinButton = [[UIButton alloc] initWithFrame:CGRectMake(0.4 * [signIn bounds].size.width, 0, 0.6 * [signIn bounds].size.width, [signIn bounds].size.height)];
    [signIn addSubview:signinButton];
    [signIn setUserInteractionEnabled:YES];
    [signinButton release];
    [signinButton setTitle:@"馬上登录" forState:UIControlStateNormal];
    [signinButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[signinButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [signinButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)signUp:(UIButton *)button
{
    
}

- (void)signIn:(UIButton *)button
{
    UINavigationController *navigationController = [self navigationController];
    [navigationController popViewControllerAnimated:YES];
    SignIn *signIn = [SignIn new];
    [navigationController pushViewController:signIn animated:YES];
    [signIn release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
