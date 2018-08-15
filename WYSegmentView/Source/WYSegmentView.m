//
//  WYSegmentView.m
//  WYSegmentView
//
//  Created by wangyu on 2018/8/15.
//  Copyright © 2018 Wangyu. All rights reserved.
//

#import "WYSegmentView.h"
@interface WYSegmentView()

/**
 label宽度根据屏幕均分后的宽度
 */
@property(nonatomic, assign)CGFloat commonWidth;

@property (strong, nonatomic)UIScrollView *mainScrollView;

@property (strong, nonatomic)UIView *moveView;
@property (strong, nonatomic)UIView *highlightView;
@property (strong, nonatomic)UIView *lineView;

@end

@implementation WYSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles frame:(CGRect)frame {
    WYSegmentView *v = [[self alloc] initWithFrame:frame];
    v.titles = titles;
    [v loadSubViews];
    return v;
}

+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles {
    WYSegmentView *v = [[self alloc] init];
    v.titles = titles;
    [v loadSubViews];
    return v;
}

+ (WYSegmentView *)viewWithTitles:(NSArray <NSString *>*)titles segmentType:(SegmentType)segmentType {
    WYSegmentView *v = [[self alloc] init];
    v.titles = titles;
    v.segmentType = segmentType;
    [v loadSubViews];
    return v;
}

-(void)loadSubViews {
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:14];
    _textColorHighlighted = [UIColor redColor];
    switch (_segmentType) {
        case SegmentTypeFixedAndEquational:
            [self loadSubViewsWithTypeFixedAndEquational];
            break;
        case SegmentTypeFixedAndAdaptive:
            [self loadSubViewsWithTypeFixedAndAdaptive];
            break;
        case SegmentTypeScrolledAndAdaptive:
            [self loadSubViewsWithTypeScrolledAndAdaptive];
            break;
        default:
            break;
    }
    
}

-(void)loadSubViewsWithTypeFixedAndEquational {
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_mainScrollView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _commonWidth = screenWidth/[_titles count];
    CGFloat labelHeight = self.frame.size.height;
    
    //初始化最底层normalView
    UIView *normalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, labelHeight)];
    normalView.backgroundColor = UIColor.whiteColor;
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.commonWidth * idx, 0, self.commonWidth, labelHeight)];
        label.text = obj;
        label.textColor = self.textColor;
        //普通label为10000 + n
        label.tag = 10000 + idx;
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        [normalView addSubview:label];
    }];
    [_mainScrollView addSubview:normalView];
    
    //初始化moveView 即显示蓝色的移动label区域view
    _moveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _commonWidth, labelHeight)];
    //生成遮蔽
    _moveView.clipsToBounds = YES;
    
    //初始化高亮的蓝色label的view
    //位置与normalView 重叠
    _highlightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _commonWidth, labelHeight)];
    //各个label 分别是红色字体 是高亮状态
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.commonWidth * idx, 0, self.commonWidth, labelHeight)];
        label.text = obj;
        label.textColor = self.textColorHighlighted;
        //普通label为20000 + n
        label.tag = 20000 + idx;
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        [self.highlightView addSubview:label];
    }];
    
    //把高亮view加入到只显示一部分的moveView
    [_moveView addSubview:_highlightView];
    [_mainScrollView addSubview:_moveView];
    
    //加入btn层view
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _commonWidth)];
    btnView.backgroundColor = [UIColor clearColor];
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.commonWidth * idx, 0, self.commonWidth, labelHeight);
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = idx;
        [btnView addSubview:btn];
    }];
    [_mainScrollView addSubview:btnView];
    
    
    //加入底部下划线
    CGSize titleSize = [[_titles firstObject] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((self.commonWidth/2 - titleSize.width/2), labelHeight - 0.5, titleSize.width, 0.5)];
    _lineView.backgroundColor = self.textColorHighlighted;
    [_moveView addSubview:_lineView];
}
-(void)loadSubViewsWithTypeFixedAndAdaptive {
    
}
-(void)loadSubViewsWithTypeScrolledAndAdaptive {
    
}

-(void)click:(UIButton *)btn {
    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat labelHeight = self.frame.size.height;
    
    CGSize titleSize = [_titles[btn.tag] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    
    [UIView animateWithDuration:0.3 animations:^{
        //移动moveView 显示不同的
        self.moveView.frame = CGRectMake(self.commonWidth * btn.tag, 0, self.commonWidth, labelHeight);
        //反向移动highlightView,让label显示正确
        self.highlightView.frame = CGRectMake(self.commonWidth * -btn.tag, 0, self.commonWidth, labelHeight);
        
        self.lineView.frame = CGRectMake((self.commonWidth/2 - titleSize.width/2), labelHeight - 0.5, titleSize.width, 0.5);
    }];
    
    if (_clickTagClock) {
        self.clickTagClock(btn.tag);
    }
}

//MARK: set方法

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self.mainScrollView viewWithTag:10000 + idx];
        if (label) {
            label.textColor = self.textColor;
        }
    }];
}

- (void)setTextColorHighlighted:(UIColor *)textColorHighlighted {
    _textColorHighlighted = textColorHighlighted;
    _lineView.backgroundColor = _textColorHighlighted;
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self.mainScrollView viewWithTag:20000 + idx];
        if (label) {
            label.textColor = self.textColorHighlighted;
        }
    }];
}


@end
