//
//  FilterListView.m
//  SingleViewList
//
//  Created by anyifei’s Mac on 2017/3/6.
//  Copyright © 2017年 esteel. All rights reserved.
//

#import "FilterListView.h"
#define ViewTag 1000000
#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define kTitleBarHeight 44
@interface FilterListView ()<UITableViewDelegate,UITableViewDataSource>
//列表数据
@property (nonatomic,strong) NSArray *dataArr;
//选中的传值数据
@property (nonatomic,strong) NSArray *selectData;
//筛选点击view
@property (nonatomic,strong) UIView *listView;
//筛选点击view上面的label
@property (nonatomic,strong) UILabel *listLabel;
//筛选点击view上面的图标l
@property (nonatomic,strong) UIImageView *arrowImg;
//筛选点击view上面的label的text
@property (nonatomic,copy) NSString *titleStr;
//筛选点击view的坐标
@property (nonatomic, assign) CGRect  filterListViewFrame;
//存放的列表折叠的状态
@property (nonatomic, strong) NSMutableArray *btnArr;//存放状态
//背景蒙版
@property (nonatomic, strong) UIView *bgView;
//选择的cell的索引
@property (nonatomic,assign) NSInteger selectedIndex;
////存放的列表折叠的状态的id
@property (nonatomic, weak) NSNumber  *index;
@property (nonatomic, strong) UITableView  *tableview;
@end
@implementation FilterListView
- (instancetype)initWithFrame:(CGRect)frame createTitles:(NSString *)titles  withDataArray:(NSArray *)dataArray  withSelectData:(NSArray *)selectData {
    
    if (self = [super initWithFrame:frame]) {
        self.dataArr = dataArray;
        self.titleStr = titles;
        self.filterListViewFrame = frame;
        self.selectData = selectData;
        [self addSubview:self.listView];
        _selectedIndex = 10;
    }
    return self;
    
    
}
- (UIView *)listView
{
    if (!_listView) {
        _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTitleBarHeight)];
        _listView.backgroundColor = [UIColor cyanColor];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tapGest.numberOfTapsRequired = 1;
        [_listView addGestureRecognizer:tapGest];
        _listLabel = [[UILabel alloc] init];
        _listLabel.text = _titleStr;
        _listLabel.font = [UIFont systemFontOfSize:14];
        _listLabel.frame = CGRectMake(20, 5, [self widthForString:_listLabel.text fontSize:14 andHeight:25], 35);
        [_listView addSubview:_listLabel];
        
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_listLabel.frame)+5, 17.5, 8, 10)];
        _arrowImg.image = [UIImage imageNamed:@"资源号箭头"];
        [_listView addSubview:_arrowImg];
        
    }
    return _listView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight )];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
        [_bgView addGestureRecognizer:tapGest];
    }
    return _bgView;
}
- (UITableView *)tableview {

    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), ScreenWidth, 0) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableview;
}
- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc]init];
    }
    return _btnArr;
}
- (void)hide:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.25 animations:^{
        _tableview.frame = CGRectMake(0, CGRectGetMaxY(self.frame), ScreenWidth, 0);
        _arrowImg.transform = CGAffineTransformMakeRotation(0);
        [self.btnArr removeObject:_index];
    } completion:^(BOOL finished) {
        [self removeSubviews];
    }];
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    _index = [NSNumber numberWithInteger:tap.view.tag];
    if ([self.btnArr containsObject:_index])
    {
        //已经展开的
        //        _headerView.moreImage.transform=CGAffineTransformMakeRotation(M_PI/2);
        [self.btnArr removeObject:_index];
        [self removeSubviews];
        
    }else
    {
        [self.superview addSubview:self.bgView];
        [self.superview addSubview:self.tableview];
        
        [UIView animateWithDuration:0.25 animations:^{
            _tableview.frame = CGRectMake(0, CGRectGetMaxY(self.frame), ScreenWidth, kTitleBarHeight*4);
            _arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [_tableview reloadData];
        }];
        [self.btnArr addObject:_index];
        
    }
    
    
}
- (void)removeSubviews
{
    [UIView animateWithDuration:0.25 animations:^{
        _arrowImg.transform = CGAffineTransformMakeRotation(0);
    }];
    
    !_bgView?:[_bgView removeFromSuperview];
    _bgView=nil;
    
    !_tableview?:[_tableview removeFromSuperview];
    _tableview=nil;
    
    
    
    
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    UIColor  *backgroundColor=[UIColor blackColor];
    UIFont *font=[UIFont boldSystemFontOfSize:fontSize];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:backgroundColor,NSFontAttributeName:font} context:nil];
    
    return sizeToFit.size.width;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static  NSString *indexID = @"indexID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexID];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-50, kTitleBarHeight)];
    label.text = [NSString stringWithFormat:@"- %@",_dataArr[indexPath.row]];
   
    if (_selectedIndex == indexPath.row) {
        label.textColor = [UIColor redColor];
    }else {
    
        label.textColor = [UIColor blackColor];
    }
    [cell.contentView addSubview:label];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _listLabel.text = _dataArr[indexPath.row];
    [self removeSubviews];
    [self.btnArr removeObject:_index];
    _listLabel.frame = CGRectMake(20, 5, [self widthForString:_listLabel.text fontSize:14 andHeight:25], 35);
    _arrowImg.frame = CGRectMake(CGRectGetMaxX(_listLabel.frame)+5, 17.5, 8, 10);
    if ([self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:_selectData[indexPath.row]];
    }
    
    _selectedIndex = indexPath.row;
    
}
#pragma mark - HiddenUITableView
- (void)dealloc
{
    [self removeSubviews];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
