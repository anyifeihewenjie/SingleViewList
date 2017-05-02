//
//  FilterListView.h
//  SingleViewList
//
//  Created by anyifei’s Mac on 2017/3/6.
//  Copyright © 2017年 esteel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterListViewDelegate <NSObject>

- (void)selectIndex:(NSString *)indexStr;

@end



@interface FilterListView : UIView
@property (nonatomic,weak) id<FilterListViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame createTitles:(NSString *)titles  withDataArray:(NSArray *)dataArray  withSelectData:(NSArray *)selectData;
@end
