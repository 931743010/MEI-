//
//  TableFooterView.m
//  MEI
//
//  Created by Yosemite on 3/7/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "TableFooterView.h"

@implementation TableFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat ccBkgrd[4] = {1.0, 1.0, 1.0, 1.0};
    CGFloat ccLine[4] = {0.5, 0.5, 0.5, 1.0};
    CGContextSetFillColorSpace(context, rgbColorSpace);
    CGContextSetFillColor(context, ccBkgrd);
    CGContextFillRect(context, rect);
    CGContextSetFillColor(context, ccLine);
    
    CGFloat x_Offset = 0.00 * rect.size.width;
    CGFloat width = 1.0 * rect.size.width;
    CGRect rects[7] = {
        /*horizontal lines*/
        CGRectMake(0, rect.size.height / 3, rect.size.width, 0.5),//fixed
        CGRectMake(0, 0.66 * rect.size.height, rect.size.width, 0.5),
        /*vertical lines*/
        CGRectMake(x_Offset + 0.21 * width, 15, 0.5, rect.size.height / 3 - 30),
        CGRectMake(x_Offset + 0.43 * width, 15, 0.5, rect.size.height / 3 - 30),
        CGRectMake(x_Offset + 0.68 * width, 15, 0.5, rect.size.height / 3 - 30),
        CGRectMake(x_Offset + 0.33 * width, rect.size.height / 3 + 15, 0.5, rect.size.height / 3 - 30),
        CGRectMake(x_Offset + 0.6 * width, rect.size.height / 3 + 15, 0.5, rect.size.height / 3 - 30)
    };
    CGContextFillRects(context, rects, 7);
    CGColorSpaceRelease(rgbColorSpace);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat x_Offset = 0.0 * frame.size.width;
        CGFloat width = 1.0 * frame.size.width;
        CGFloat buttonHeight = frame.size.height / 3;
        for (int i = 0; i < 7; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [self addSubview:button];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
            switch (i)
            {
                case 0:
                    [button setTitle:@"首页" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.005 * width, 0, 0.21 * width, buttonHeight)];
                    [button setTag:0x9a00];
                    break;
                case 1:
                    [button setTitle:@"分类" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.21 * width, 0, 0.23 * width, buttonHeight)];
                    [button setTag:0x9a01];
                    break;
                case 2:
                    [button setTitle:@"即将上线" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.435 * width, 0, 0.24 * width, buttonHeight)];
                    [button setTag:0x9a02];
                    break;
                case 3:
                    [button setTitle:@"关于魅力惠" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.68 * width, 0, 0.3 * width, buttonHeight)];
                    [button setTag:0x9a05];
                    break;
                case 4:
                    [button setTitle:@"登陆" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.05 * width, 0.333333 * frame.size.height, 0.27 * width, buttonHeight)];
                    [button setTag:0x9b01];
                    break;
                case 5:
                    [button setTitle:@"注册" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.333333 * width, 0.333333 * frame.size.height, 0.27 * width, buttonHeight)];
                    [button setTag:0x9b02];
                    break;
                case 6:
                    [button setTitle:@"物流查询" forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(x_Offset + 0.6 * width, 0.333333 * frame.size.height, 0.35 * width, buttonHeight)];
                    [button setTag:0x9a03];
                    break;
                    
                default:
                    break;
            }
        }
        UIButton *telephone = [[UIButton alloc] initWithFrame:CGRectMake(0.3 * frame.size.width, 0.67 * frame.size.height + 1, 0.4 * frame.size.width, 0.3 * frame.size.height)];
        [telephone setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        [self addSubview:telephone];
        [telephone release];
        [telephone setTag:0x9fff];
        [telephone addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonsAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(footerButtonDidTouchedUpInside:)])
    {
        [_delegate footerButtonDidTouchedUpInside:button];
    }
}

@end
