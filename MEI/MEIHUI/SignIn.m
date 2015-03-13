//
//  SignIn.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "SignIn.h"
#import "HeaderFooterManager.h"
#import "SignUp.h"
@interface SignIn ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;//with navigation button bar
    UITextField *_name;
    UITextField *_password;
}
@end

@implementation SignIn

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
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackOnly withTitle:@"会员登录"];
    UIImageView *bg_login = [[UIImageView alloc] initWithFrame:CGRectMake(0.1 * _viewWidth, 0.4 * _viewHeight, 0.8 * _viewWidth, 0.17 * _viewHeight)];
    [bg_login setImage:[UIImage imageNamed:@"bg_login1@2x.png"]];
    [[self view] addSubview:bg_login];
    [bg_login release];
    UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5 * [bg_login bounds].size.height, [bg_login bounds].size.width, 0.5)];
    [midLine setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [bg_login addSubview:midLine];
    [midLine release];
    _name = [[UITextField alloc] initWithFrame:CGRectMake(60 + [bg_login frame].origin.x, [bg_login frame].origin.y, [bg_login bounds].size.width - 60, 0.5 * [bg_login bounds].size.height)];
    _password = [[UITextField alloc] initWithFrame:CGRectMake(60 + [bg_login frame].origin.x, 0.5 * [bg_login bounds].size.height + [bg_login frame].origin.y, [bg_login bounds].size.width - 60, 0.5 * [bg_login bounds].size.height)];
    [[self view] addSubview:_name];
    [[self view] addSubview:_password];
    [_name release];
    [_password release];
    [_name setPlaceholder:@"请输入您的EMAIL地址"];
    [_password setPlaceholder:@"（6-20个字符）"];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 0.5 * [bg_login bounds].size.height)];
    UILabel *password = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.5 * [bg_login bounds].size.height, 40, 0.5 * [bg_login bounds].size.height)];
    [bg_login addSubview:name];
    [bg_login addSubview:password];
    [name release];
    [password release];
    [name setText:@"邮箱:"];
    [password setText:@"密码:"];
    [_name setTextAlignment:NSTextAlignmentLeft];
    [_password setTextAlignment:NSTextAlignmentLeft];
    [name setTextAlignment:NSTextAlignmentCenter];
    [password setTextAlignment:NSTextAlignmentCenter];
    [_name setFont:[UIFont systemFontOfSize:14]];
    [_password setFont:[UIFont systemFontOfSize:14]];
    [name setFont:[UIFont systemFontOfSize:14]];
    [password setFont:[UIFont systemFontOfSize:14]];
    //146 x 50
    UIButton *forgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(0.6 * [_password bounds].size.width, 0.25 * [_password bounds].size.height, 0.35 * [_password bounds].size.width, 0.5 * [_password bounds].size.height)];
    [forgetPassword setBackgroundImage:[UIImage imageNamed:@"button_forget_password@2x.png"] forState:UIControlStateNormal];
    [_password addSubview:forgetPassword];
    [forgetPassword release];
    
    UIButton *signinButton = [[UIButton alloc] initWithFrame:CGRectMake([bg_login frame].origin.x, 1.48 * [bg_login frame].origin.y, [bg_login bounds].size.width, [bg_login bounds].size.height / 2)];
    [signinButton setBackgroundImage:[UIImage imageNamed:@"button_red_big2.png"] forState:UIControlStateNormal];
    [[self view] addSubview:signinButton];
    [signinButton release];
    [signinButton setTitle:@"登录" forState:UIControlStateNormal];
    [signinButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *signUp = [[UILabel alloc] initWithFrame:CGRectMake(0.25 * _viewWidth, 0.7 * _viewHeight, 0.5 * _viewWidth, 0.08 * _viewHeight)];
    [[self view] addSubview:signUp];
    [signUp release];
    [signUp setText:@"还不是会员"];
    [signUp setFont:[UIFont systemFontOfSize:14]];
    UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(0.4 * [signUp bounds].size.width, 0, 0.6 * [signUp bounds].size.width, [signUp bounds].size.height)];
    [signUp addSubview:signUpButton];
    [signUp setUserInteractionEnabled:YES];
    [signUpButton release];
    [signUpButton setTitle:@"马上加入" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[signUpButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [signUpButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)signIn:(UIButton *)button
{
    
}

- (void)signUp:(UIButton *)button
{
    UINavigationController *navigationController = [self navigationController];
    [navigationController popViewControllerAnimated:YES];
    SignUp *signUp = [SignUp new];
    [navigationController pushViewController:signUp animated:YES];
    [signUp release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
