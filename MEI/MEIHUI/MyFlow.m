//
//  MyFlow.m
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "MyFlow.h"

#define COLUMN 2//
#define MAXCELLNUM 16384

typedef struct cellinfo {
    NSInteger index;
    NSInteger columnIndex;
    char displaying;//will be configured when cell will be displayed or undisplayed
    char configured;
    FlowCell *obj;//will be configured when cell will be displayed or undisplayed
    CGRect frame;
    CGFloat top;
    CGFloat bottom;
    NSInteger column;
} cellinfo_t;

typedef struct reuseableresource {
    NSInteger count;
    FlowCell *cell[MAXCELLNUM];
} reuseableresource_t;


@interface MyFlow ()
{
    char _ready;
    cellinfo_t _cells[MAXCELLNUM];
    NSInteger _cellsConfigured;
    cellinfo_t *_columns[COLUMN][MAXCELLNUM];
    NSInteger _countOfCellsInColumn[COLUMN];
    reuseableresource_t _reuseResource;
    CGFloat _heightOfColumn[COLUMN];
    NSInteger _indexToStartSeekOfColumn[COLUMN];
    
    CGFloat _interval;
    CGFloat _viewHeight;
    CGFloat _viewWidth;
}
@end

@implementation MyFlow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [super setDelegate:self];
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        [self addObserver:self forKeyPath:@"footerView" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    for (int i = 0; i < MAXCELLNUM; i++)
    {
        if (_reuseResource.count == 0)
        {
            break;
        }
        else
        {
            if (_reuseResource.cell[i])
            {
                [_reuseResource.cell[i] release];
                _reuseResource.cell[i] = 0;
                _reuseResource.count--;
            }
        }
    }
    [self removeObserver:self forKeyPath:@"footerView"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"footerView"])
    {
        if (_ready)
        {
            UIView *old = [change objectForKey:@"old"];
            UIView *new = [change objectForKey:@"new"];
            if (old)
            {
                [old removeFromSuperview];
            }
            [new setFrame:CGRectMake(0, [self contentOffset].y - _footerHeight, _viewWidth, _footerHeight)];
            [new addSubview:_footerView];
        }
    }
}

- (void)reloadData
{
    _interval = ([self bounds].size.width - COLUMN * _cellWidth) / (COLUMN + 1);
    _cellsConfigured = 0;
    for (int i = 0; i < COLUMN; i++)
    {
        _indexToStartSeekOfColumn[i] = 0;
        _heightOfColumn[i] = 0;
        _countOfCellsInColumn[i] = 0;
    }
    for (int i = 0; i < [_dataSource count]; i++)
    {
        [self configureNextCell];
        [self cellHasBeenScrolledIntoScreenAtColumn:_cells[i].column columnIndex:_cells[i].columnIndex];
        char num = 0;
        for (int i = 0; i < COLUMN; i++)
        {
            if (_heightOfColumn[i] < _viewHeight)
            {
                break;
            }
            else
            {
                num++;
            }
        }
        if (num == COLUMN)
        {
            break;
        }
    }
    if (_footerView)
    {
        [_footerView setFrame:CGRectMake(0, [self contentSize].height - _footerHeight, _viewWidth, _footerHeight)];
        [self addSubview:_footerView];
    }
    _ready = 1;
}

- (void)configureNextCell
{
    NSInteger index = _cellsConfigured++;//_cellsConfigured
    //cell
    _cells[index].configured = 1;
    _cells[index].index = index;
    _cells[index].column = [self columnWithMinimumHeight];
    _cells[index].columnIndex = _countOfCellsInColumn[_cells[index].column]++;//_columnCellCount[]
    _cells[index].frame = [self frameForNextCellInColumn:_cells[index].column];
    _cells[index].top = _cells[index].frame.origin.y;
    _cells[index].bottom = _cells[index].frame.origin.y + _cellHeight;
    //column
    _columns[_cells[index].column][_cells[index].columnIndex] = _cells + index;//_columns[]
    _heightOfColumn[_cells[index].column] += _cellHeight + _interval;//_columnHeight
    //content size
    [self setContentSize:CGSizeMake(_viewWidth, [self heightOfContentSizeWithoutFooter] + _footerHeight + _cellYCoordinateOffset)];
    [_footerView setFrame:CGRectMake(0, [self contentSize].height - _footerHeight, _viewWidth, _footerHeight)];
}

- (NSInteger)columnWithMinimumHeight
{
    NSInteger column = 0;
    for (int i = 1; i < COLUMN; i++)
    {
        if (_heightOfColumn[column] > _heightOfColumn[i])
        {
            column = i;
        }
    }
    return column;
}

- (CGFloat)heightOfContentSizeWithoutFooter
{
    CGFloat height = _heightOfColumn[0];
    for (int i = 1; i < COLUMN; i++)
    {
        if (height < _heightOfColumn[i])
        {
            height = _heightOfColumn[i];
        }
    }
    return height;
}

- (CGRect)frameForNextCellInColumn:(NSInteger)column
{
    CGFloat x = (column + 1) * _interval + column * _cellWidth;
    CGFloat y = _heightOfColumn[column] + _interval / 2 + _cellYCoordinateOffset;///!!!!
    return CGRectMake(x, y, _cellWidth, _cellHeight);
}

- (void)configureCellsByBackWardSeek
{
    for (int i = 0; i < COLUMN; i++)
    {
        for (NSInteger index = _indexToStartSeekOfColumn[i]; index >= 0; index--)
        {
            if ([self contentOffset].y - _columns[i][index]->bottom > _viewHeight)//current out of screen
            {
                if (_columns[i][index]->displaying == 0)
                {
                    break;
                }
                else//was in screen in the past
                {
                    [self cellHasBeenScrolledOutOfScreenAtColumn:i columnIndex:index];
                }
            }
            else//current in screen
            {
                if (_columns[i][index]->displaying == 0)//was out of screen in the past
                {
                    [self cellHasBeenScrolledIntoScreenAtColumn:i columnIndex:index];
                }
            }
        }
    }
}

- (void)configureCellsByForwardSeek
{
    for (int i = 0; i < COLUMN; i++)
    {
        for (NSInteger index = _indexToStartSeekOfColumn[i]; index < _countOfCellsInColumn[i]; index++)
        {
            if (_columns[i][index]->top - [self contentOffset].y > _viewHeight)
            {
                if (_columns[i][index]->displaying == 0)
                {
                    break;
                }
                else
                {
                    [self cellHasBeenScrolledOutOfScreenAtColumn:i columnIndex:index];
                }
            }
            else
            {
                if (_columns[i][index]->displaying == 0)
                {
                    [self cellHasBeenScrolledIntoScreenAtColumn:i columnIndex:index];
                }
            }
        }
    }
}

- (void)cellHasBeenScrolledIntoScreenAtColumn:(NSInteger)column columnIndex:(NSInteger)index
{
    _columns[column][index]->displaying = 1;
    _indexToStartSeekOfColumn[column] = index;//暂时这么写。。适用于等高cell
    _columns[column][index]->obj = [[self getObjectForCellAtIndex:_columns[column][index]->index] retain];
    [self addSubview:_columns[column][index]->obj];
    [_columns[column][index]->obj release];
    if ([_myFlowDelegate respondsToSelector:@selector(myFlow:willDisplayCellAtIndex:)])
    {
        [_myFlowDelegate myFlow:self willDisplayCellAtIndex:_columns[column][index]->index];
    }
}

- (void)cellHasBeenScrolledOutOfScreenAtColumn:(NSInteger)column columnIndex:(NSInteger)index
{
    _columns[column][index]->displaying = 0;
    for (int i = 0; i < MAXCELLNUM; i++)
    {
        if (_reuseResource.cell[i] == nil)
        {
            _reuseResource.cell[i] = [_columns[column][index]->obj retain];
            _reuseResource.count++;
            [_columns[column][index]->obj removeFromSuperview];
            _columns[column][index]->obj = nil;
            break;
        }
    }
    if ([_myFlowDelegate respondsToSelector:@selector(myFlow:didEndDisplayCellAtIndex:)])
    {
        [_myFlowDelegate myFlow:self didEndDisplayCellAtIndex:_columns[column][index]->index];
    }
}

- (FlowCell *)getObjectForCellAtIndex:(NSInteger)index//index: index of _cells
{
    FlowCell *cell = nil;
    if (_reuseResource.count > 0)
    {
        for (int i = 0; i < MAXCELLNUM; i++)
        {
            if (_reuseResource.cell[i])
            {
                cell = [_reuseResource.cell[i] autorelease];
                _reuseResource.cell[i] = nil;
                _reuseResource.count--;
                break;
            }
        }
    }
    else
    {
        cell = [[[FlowCell alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellHeight)] autorelease];
        [[cell button] addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell setFrame:_cells[index].frame];
    [cell setIndex:index];
    [[cell button] setTag:index];
    //continue to configure the cell...
    cell = [_myFlowDelegate myFlow:self configureCell:cell ForIndex:index];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_ready)
    {
        if (_cellsConfigured < [_dataSource count])
        {
            if ([self contentSize].height - [self contentOffset].y < _viewHeight + _footerHeight + 10)//no y- offset
            {
                for (int i = 0; i < 2 * COLUMN; i++)
                {
                    if (_cellsConfigured < [_dataSource count])
                    {
                        [self configureNextCell];
                    }
                }
            }
        }
        [self configureCellsByForwardSeek];
        [self configureCellsByBackWardSeek];
    }
}

- (void)dataPreparedForMoreCells:(NSInteger)cellsNumber
{
    for (int i = 0; i < cellsNumber; i++)
    {
        if (_cellsConfigured < [_dataSource count])
        {
            [self configureNextCell];
        }
    }
}

- (void)cellButtonAction:(UIButton *)button
{
    if ([_myFlowDelegate respondsToSelector:@selector(myFlow:didSelectedCellAtIndex:)])
    {
        [_myFlowDelegate myFlow:self didSelectedCellAtIndex:[button tag]];
    }
}

@end

@implementation FlowCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *productShow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.75 * frame.size.height)];
        [self setImageShow:productShow];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (0.75 + 0.020) * frame.size.height, frame.size.width - 10, frame.size.height / 16)];//+ 0.20
        [self setBrandName:nameLabel];
        UILabel *pnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (0.8125 + 0.028) * frame.size.height, frame.size.width - 10, frame.size.height / 16)];//+0.08
        [self setProductName:pnameLabel];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (0.872 + 0.030) * frame.size.height, frame.size.width - 10, 0.1 * frame.size.height)];
        [self setPrice:priceLabel];
        UILabel *mpLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, (0.872 + 0.035) * frame.size.height, frame.size.width - 55, 0.1 * frame.size.height)];
        [self setMarketPrice:mpLabel];
        [self addSubview:productShow];
        [self addSubview:nameLabel];
        [self addSubview:pnameLabel];
        [self addSubview:priceLabel];
        [self addSubview:mpLabel];
        [productShow release];
        [nameLabel release];
        [pnameLabel release];
        [priceLabel release];
        [mpLabel release];
        
        [[self brandName] setFont:[UIFont systemFontOfSize:12]];
        [[self productName] setFont:[UIFont systemFontOfSize:13]];
        [[self price] setFont:[UIFont systemFontOfSize:16]];
        [[self marketPrice] setFont:[UIFont systemFontOfSize:13]];
        
        [[self price] setTextColor:[UIColor redColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButton:button];
        [button setFrame:frame];
        [self addSubview:button];
    }
    return self;
}

- (void)dealloc
{
    [self setImageShow:nil];
    [self setBrandName:nil];
    [self setProductName:nil];
    [self setMarketPrice:nil];
    [self setPrice:nil];
    [self setButton:nil];
    [super dealloc];
}

@end
