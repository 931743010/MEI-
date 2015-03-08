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
    CGFloat ccLine[4] = {0.3, 0.3, 0.3, 1.0};
    CGContextSetFillColorSpace(context, rgbColorSpace);
    CGContextSetFillColor(context, ccBkgrd);
    CGContextFillRect(context, rect);
    CGContextSetFillColor(context, ccLine);
    CGRect rects[7] = {
        /*horizontal lines*/
        CGRectMake(15, rect.size.height / 3, rect.size.width - 30, 1.0),
        CGRectMake(15, 2 * rect.size.height / 3, rect.size.width - 30, 1.0),
        /*vertical lines*/
        CGRectMake(rect.size.width / 4, 15, 1, rect.size.height / 3 - 30),
        CGRectMake(2 * rect.size.width / 4, 15, 1, rect.size.height / 3 - 30),
        CGRectMake(3 * rect.size.width / 4, 15, 1, rect.size.height / 3 - 30),
        CGRectMake(rect.size.width / 3, rect.size.height / 3 + 15, 1, rect.size.height / 3 - 30),
        CGRectMake(2 * rect.size.width / 3, rect.size.height / 3 + 15, 1, rect.size.height / 3 - 30)
    };
    CGContextFillRects(context, rects, 7);
    CGColorSpaceRelease(rgbColorSpace);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat buttonWidth1 = (frame.size.width - 30) / 4;
        CGFloat buttonWidth2 = (frame.size.width - 50) / 3;
        CGFloat buttonHeight = frame.size.height / 3;
        for (int i = 0; i < 7; i++)
        {
            UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];
            [self addSubview:button];
            [button setTag:0x9100 + i];
            [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12]];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i < 4)
                [button setFrame:CGRectMake(i * frame.size.width / 4, 0, buttonWidth1, buttonHeight)];
            else if (i >= 4)
                [button setFrame:CGRectMake(25 + (i - 4) * (frame.size.width - 50) / 3, frame.size.height / 3, buttonWidth2, buttonHeight)];
            switch (i)
            {
                case 0:
                    [button setTitle:@"首页" forState:UIControlStateNormal];
                    break;
                case 1:
                    [button setTitle:@"分类" forState:UIControlStateNormal];
                    break;
                case 2:
                    [button setTitle:@"即将上线" forState:UIControlStateNormal];
                    break;
                case 3:
                    [button setTitle:@"关于魅力惠" forState:UIControlStateNormal];
                    break;
                case 4:
                    [button setTitle:@"登陆" forState:UIControlStateNormal];
                    break;
                case 5:
                    [button setTitle:@"注册" forState:UIControlStateNormal];
                    break;
                case 6:
                    [button setTitle:@"物流查询" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)buttonsAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(buttonDidTouchUpInside:)])
    {
        [_delegate buttonDidTouchUpInside:button];
    }
}

@end
