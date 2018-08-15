//
//  WYSegmentView.h
//  WYSegmentView
//
//  Created by wangyu on 2018/8/15.
//  Copyright © 2018 Wangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSegmentView : UIView

typedef NS_ENUM(NSInteger,SegmentType) {
    
    SegmentTypeFixedAndEquational       = 0,  // 不滑动并且每个title长度根据屏幕均分
    SegmentTypeFixedAndAdaptive         = 1,  // 不滑动, 每个title会根据长度自适应宽度
    SegmentTypeScrolledAndAdaptive      = 2,  // 可滑动, 每个title会根据长度自适应宽度
};

@property (nonatomic, copy) void(^clickTagClock)(NSInteger idx);

@property(nonatomic, assign)SegmentType segmentType;
@property(nonatomic, strong)NSArray <NSString *>* titles;

/**
 默认 [UIFont systemFontOfSize:14]
 */
@property(nonatomic, strong)UIFont *textFont;

/**
 默认 [UIColor blackColor]
 */
@property(nonatomic, strong)UIColor *textColor;

/**
 默认 [UIColor redColor]
 */
@property(nonatomic, strong)UIColor *textColorHighlighted;


//MARK: 构造方法
+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles;

+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles frame:(CGRect)frame;

+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles segmentType:(SegmentType)segmentType;
@end
