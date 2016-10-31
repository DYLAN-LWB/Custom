//
//  WBPopListView.m
//  WBPopListMenu
//
//  Created by 李伟宾 on 16/7/11.
//  Copyright © 2016年 李伟宾. All rights reserved.
//

#import "WBDropDownMenu.h"



static  NSString *cellID = @"cellID";

@interface WBDropDownMenu () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSArray    *listArray;

@property (nonatomic, strong) UICollectionViewCell *lastSelectedCell;   // 默认选中的行,点击其它行时取消该行
@property (nonatomic, strong) UIButton *lastSelectedButton;             // 上次选中的按钮

@property (nonatomic, assign) BOOL isTwoColumns;            // 用来标识显示一列还是两列
@property (nonatomic, assign) BOOL isShowCollectionView;    // 是否显示collectionview

@property (nonatomic, strong) NSMutableArray *passValueAM;  // 传递给控制器,有几个分类就添加几个元素


@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) NSInteger menuCount;      // cell的个数,用来设置collectionview高度 和 显示单列或者多列


@property (nonatomic, strong) UIColor *menuBtnDefaultColor;     // 菜单栏按钮默认状态颜色
@property (nonatomic, strong) UIColor *menuBtnSelectedColor;    // 菜单栏按钮选中状态颜色
@property (nonatomic, strong) UIColor *menuBtnTextColor;        // 菜单栏按钮颜色
@property (nonatomic, strong) UIColor *itemDefaultColor;        // cell背景颜色
@property (nonatomic, strong) UIColor *itemSelectedColor;       // 选中状态cell背景色
@property (nonatomic, strong) UIColor *itemTextColor;           // cell颜色
@property (nonatomic, strong) UIColor *splitColor;              // 分割线颜色

@property (nonatomic, copy) NSString *upImageName;
@property (nonatomic, copy) NSString *downImageName;

@property (nonatomic, assign) NSInteger viewType;

@property (nonatomic, strong) UIView *bgView;
@end

@implementation WBDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame menuCount:(NSInteger)menuCount colorType:(NSInteger)colorType viewController:(UIViewController *)viewController {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isTwoColumns = NO;
        self.viewController = viewController;
        self.menuCount = menuCount;
        self.viewType = colorType;
        
        if (colorType == 1) {
            
            self.menuBtnDefaultColor  = [UIColor lightGrayColor];
            self.menuBtnSelectedColor = [UIColor grayColor];
            self.menuBtnTextColor     = [UIColor whiteColor];
            self.upImageName = @"arrow_up_icon_write";
            self.downImageName = @"arrow_down_icon_write";
            
        } else {
            
            self.menuBtnDefaultColor  = [UIColor blueColor];
            self.menuBtnSelectedColor = [UIColor redColor];
            self.menuBtnTextColor     = [UIColor blackColor];
            self.upImageName = @"arrow_up_icon";
            self.downImageName = @"arrow_down_icon";
        }
        
        self.itemDefaultColor     = [UIColor colorWithRed:0.972 green:0.976 blue:0.986 alpha:1.000];
        self.itemSelectedColor    = [UIColor blueColor];
        self.itemTextColor        = [UIColor blackColor];
        self.splitColor           = [UIColor colorWithWhite:0.800 alpha:1.000];
        
        [self setupMenuButtons];
        [self setupCollectionView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDropDownView) name:@"hideDropDownView" object:nil];
    }
    
    return self;
}

- (void)hideDropDownView {
    if (self.isShowCollectionView) {
        
        [self buttonClick:_lastSelectedButton];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    
    
    // 得到数据源判断显示列数
    self.isTwoColumns = dataSource.count > 6 ? YES : NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isShowCollectionView) {
            self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 3, self.frame.size.width, CELL_HEIGHT * (dataSource.count > 6 ? (dataSource.count/2+1) : dataSource.count));
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.collectionView.frame) - 49);

        }

    }];
    
    [self.collectionView reloadData];
}

- (void)setupMenuButtons {
    
    CGFloat buttonW = self.frame.size.width / self.menuCount;
    NSArray *title = @[@"书名", @"年级", @"学科", @"版本", @"册次", @"排序"];
    for (int i = 0; i < self.menuCount; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW * i, 0, buttonW, MENU_HEIGHT);
        button.backgroundColor = self.menuBtnDefaultColor;
        button.tag = i;
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        if (self.viewType == 2) {
            button.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:self.menuBtnTextColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.downImageName] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, buttonW - 15, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 15)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 添加分割线
        if (i != 0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0 , 10, 0.5, MENU_HEIGHT - 20);
            lineView.backgroundColor = self.splitColor;
            [button addSubview:lineView];
        }
        
        
        if (i == 0) {
            self.lastSelectedButton = button;
        }
    }
}

// 点击按钮请求接口或者隐藏collectionview
- (void)buttonClick:(UIButton *)button {
    
    button.backgroundColor = self.menuBtnSelectedColor;
    
    self.collectionView.tag = button.tag;   // 用来判断选中的是哪个collectionview
    
    
    if (button.tag == self.lastSelectedButton.tag) { // 点击的同一个按钮
        
        
        if (self.isShowCollectionView) {
            self.isShowCollectionView = NO;
            
            [self hideCollectionView];
            
        } else {
            
            self.isShowCollectionView = YES;
            
            if ([self.delegate respondsToSelector:@selector(getDataWithType:)]) {
                [self.delegate getDataWithType:button.tag];
            }
            
        }
        [button setImage:[UIImage imageNamed:button.selected ? self.downImageName : self.upImageName] forState:UIControlStateNormal];
        button.selected = !button.selected;
        
    } else {
        self.isShowCollectionView = YES;
        
        self.lastSelectedButton.selected = NO;
        [self.lastSelectedButton setImage:[UIImage imageNamed:self.downImageName] forState:UIControlStateNormal];
        
        [self hideCollectionView];
        
        if ([self.delegate respondsToSelector:@selector(getDataWithType:)]) {
            [self.delegate getDataWithType:button.tag];
        }
        
        [button setImage:[UIImage imageNamed:self.upImageName] forState:UIControlStateNormal];
        button.selected = YES;
        
        self.lastSelectedButton = button;
    }
}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;  // item横向间距
    layout.minimumLineSpacing      = 0;  // item竖向间距
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 2, self.frame.size.width, 0) collectionViewLayout:layout];

    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = self.itemDefaultColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_WIDTH, 0)];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.239 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewRestureRecognizer:)]];

    [[UIApplication sharedApplication].keyWindow addSubview:self.collectionView];

    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
}

- (void)touchViewRestureRecognizer:(UITapGestureRecognizer*)recognizer {
    self.isShowCollectionView = NO;
    [self.lastSelectedButton setImage:[UIImage imageNamed:self.downImageName] forState:UIControlStateNormal];
    self.lastSelectedButton.selected = NO;
    [self hideCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 每个section item单元格的大小
    return  CGSizeMake(self.isTwoColumns ? self.frame.size.width/2 : self.frame.size.width, CELL_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = self.itemDefaultColor;
    

    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = self.itemSelectedColor;
    cell.selectedBackgroundView = view;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:cell.bounds];
    titleLabel.text = [NSString stringWithFormat:@"　　%@", self.dataSource[indexPath.row][@"name"]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.textColor = self.itemTextColor;
    [cell.contentView addSubview:titleLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height - 0.6, titleLabel.frame.size.width, 0.6)];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.917 alpha:1.000];
    [cell.contentView addSubview: bottomLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width - 0.6, 0, 0.6, titleLabel.frame.size.height)];
    rightLine.backgroundColor = [UIColor colorWithWhite:0.917 alpha:1.000];
    [cell.contentView addSubview: rightLine];
    
    if ([titleLabel.text isEqualToString:self.lastSelectedButton.titleLabel.text]) {
        cell.selected = YES;
        self.lastSelectedCell = cell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消上一个选中状态的cell
    self.lastSelectedCell.selected = NO;
    
    // 设置按钮文字
    NSString *title = self.dataSource[indexPath.row][@"name"];
    if (title.length > 4) {
        title = [title substringToIndex:4];
    }
    
    [self.lastSelectedButton setTitle:title forState:UIControlStateNormal];
    
    // 选中哪一个分类的哪一行
    [self.passValueAM replaceObjectAtIndex:collectionView.tag withObject:self.dataSource[indexPath.row][@"id"]];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedItemWithValueArray:)]) {
        [self.delegate didSelectedItemWithValueArray:self.passValueAM];
    }
    
    
    self.isShowCollectionView = NO;
    [self.lastSelectedButton setImage:[UIImage imageNamed:self.downImageName] forState:UIControlStateNormal];
    self.lastSelectedButton.selected = NO;
    
    
    [self hideCollectionView];
}

// 隐藏
- (void)hideCollectionView {
    
    self.lastSelectedButton.backgroundColor = self.menuBtnDefaultColor;
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 3, self.frame.size.width, 0);
    self.bgView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_WIDTH, 0);

    // 清空数组,刷新collectionview
    self.dataSource = nil; ;
    [self.collectionView reloadData];
}

- (NSMutableArray *)passValueAM {
    if (!_passValueAM) {
        _passValueAM = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0", @"0", @"0"]];
    }
    return _passValueAM;
}

@end
