//
//  MySimpleWaterFlowLayout.m
//  TransitionAnimatedDemo
//
//  Created by Turbo on 2017/6/28.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "MySimpleWaterFlowLayout.h"

@interface MySimpleWaterFlowLayout ()

//该委托设置为self.collectionView.delegate
@property (nonatomic,weak) id<MySimpleWaterFlowLayoutDelegate>delegate;
//存所有布局
@property (nonatomic,strong) NSMutableArray *allAttrsArr;
//存所有item布局
@property (nonatomic,strong) NSMutableArray *itemAttrsArr;
//存放所有区头尾布局
@property (nonatomic, strong) NSMutableArray *supplementaryAttrsArr;
//滚动最大高度
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation MySimpleWaterFlowLayout


#pragma mark - 初始化

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)init
{
    if(self == [super init]){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    // 默认设置
    self.columnMargin = 10;
    self.rowMargin = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.columnCount = 2;
    self.headerHeight = 0;
    self.footerHeight = 0;
}

#pragma mark - getter
- (NSMutableArray *)allAttrsArr{
    
    if (!_allAttrsArr) {
        _allAttrsArr = [NSMutableArray array];
    }
    return _allAttrsArr;
}

- (NSMutableArray *)itemAttrsArr{
    if (!_itemAttrsArr) {
        _itemAttrsArr = [NSMutableArray array];
    }
    return _itemAttrsArr;
}

- (NSMutableArray *)supplementaryAttrsArr{
    
    if (!_supplementaryAttrsArr) {
        _supplementaryAttrsArr = [NSMutableArray array];
    }
    return _supplementaryAttrsArr;
}

- (id<MySimpleWaterFlowLayoutDelegate>)delegate{
    
    if (!_delegate) {
        _delegate = (id<MySimpleWaterFlowLayoutDelegate>)self.collectionView.delegate;
    }
    return _delegate;
}

#pragma mark - 瀑布流布局
/**
 * 当collectionView第一次要显示的时候会调用此方法来准备布局。
 * 当collectionView的布局发生变化时，也会调用此方法。
 * 当刷新数据时，也会调用此方法。
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    //每次刷新前清空之前的数据
    self.contentHeight = 0;
    [self.allAttrsArr removeAllObjects];
    [self.itemAttrsArr removeAllObjects];
    [self.supplementaryAttrsArr removeAllObjects];
    
    //布局
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if (sectionCount == 0) return;
    
    for (NSInteger section = 0; section<sectionCount; section++) {
        
        CGFloat m_headerHeight = [self headerHeightForSection:section];
        CGFloat m_footerHeight = [self footerHeightForSection:section];
        NSInteger m_columnCount = [self columnCountForSection:section];
        NSInteger m_rowMargin = [self rowMarginForSection:section];
        NSInteger m_columnMargin = [self columnMarginForSection:section];
        UIEdgeInsets m_sectionInset = [self sectionInsetForSection:section];
        
        // 头部布局
        NSMutableDictionary *supplementaryDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        /* 头部 UIEdgeInsetsMake(0, 0, 0, 0) 这个属性可以设置，这里不作处理了，可以添加属性设置*/
        
        if (m_headerHeight>0) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, self.contentHeight, self.collectionView.frame.size.width, m_headerHeight);
            
            [self.allAttrsArr addObject:attributes];
            [supplementaryDic setObject:attributes forKey:UICollectionElementKindSectionHeader];
            
            self.contentHeight = CGRectGetMaxY(attributes.frame)+m_sectionInset.top;
        }
        
        // item布局
        NSMutableDictionary *maxDict = [NSMutableDictionary dictionary];
        for(int i=0;i<m_columnCount;i++){
            NSString *column = [NSString stringWithFormat:@"%d",i];
            maxDict[column] = @(self.contentHeight);
        }
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for(int item = 0;item<itemCount;item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            //假设当前y轴最小的那一列是第零列
            __block NSString *minColumn = @"0";
            //遍历字典取最小y轴
            [maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
                //如果y值小于当前最小的值
                if([maxY floatValue] < [maxDict[minColumn] floatValue]){
                    minColumn = column;
                }
            }];
            
            //1.计算每个item的布局属性
            CGFloat width = (self.collectionView.frame.size.width - m_sectionInset.left-m_sectionInset.right-m_columnMargin*(m_columnCount-1))/m_columnCount;
            CGFloat height = [self.delegate alw_collectionView:self.collectionView layout:self heightForWidth:width indexPath:indexPath];
            
            CGFloat x = m_sectionInset.left+(width+m_columnMargin)*[minColumn intValue];
            CGFloat y = [maxDict[minColumn] floatValue];
            
            //更新这一列最大的y值
            maxDict[minColumn] = @(y+height+m_rowMargin);
            
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame = CGRectMake(x, y, width, height);
            
            //2.把每一个item的布局属性添加到数据中
            [self.itemAttrsArr addObject:attr];
            [self.allAttrsArr addObject:attr];
        }
        
        
        //取最大y值
        __block  NSString *maxColumn = @"0";
        [maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
            if([maxY floatValue]>[maxDict[maxColumn] floatValue]){
                maxColumn = column;
            }
        }];
        self.contentHeight = [maxDict[maxColumn] floatValue];
        self.contentHeight += m_sectionInset.bottom - m_rowMargin;
        
        //尾部布局
        if (m_footerHeight>0) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, self.contentHeight, self.collectionView.frame.size.width, m_footerHeight);
            
            [self.allAttrsArr addObject:attributes];
            [supplementaryDic setObject:attributes forKey:UICollectionElementKindSectionFooter];
            
            self.contentHeight = CGRectGetMaxY(attributes.frame);
        }
        
        [self.supplementaryAttrsArr addObject:supplementaryDic];
        
    }
    
    
}

#pragma mark - 设置每个item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    for (NSInteger i = 0; i<indexPath.section; i++) {
        index += [self.collectionView numberOfItemsInSection:indexPath.section];
    }
    return [self.itemAttrsArr objectAtIndex:index];
}

#pragma mark - 设置头部和尾部布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return [self.supplementaryAttrsArr objectAtIndex:indexPath.section][elementKind];
}

#pragma mark - 返回当前显示在屏幕上的item（包含头部和尾部）布局属性数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //谓词筛选出在rect范围内的布局属性
    NSArray *attrs = [self.allAttrsArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, evaluatedObject.frame);
    }]];
    return attrs;
}

#pragma mark - 设置滚动的范围
- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

/*
 只要滚动屏幕 就会调用  方法  -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect，返回显示在屏幕上的布局属性数组
 只要布局页面的属性发生改变 就会重新调用  -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect  这个方法
 * 一般collectionView的bounds发生改变才会返回YES
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}


#pragma mark - 私有方法
- (NSInteger)columnCountForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:columnCountForSection:)]) {
        self.columnCount = [self.delegate alw_collectionView:self.collectionView layout:self columnCountForSection:section];
    }
    return self.columnCount;
}

- (CGFloat)headerHeightForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:heightForHeaderInSection:)]) {
        self.headerHeight = [self.delegate alw_collectionView:self.collectionView layout:self heightForHeaderInSection:section];
    }
    
    return self.headerHeight;
}

- (CGFloat)footerHeightForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:heightForFooterInSection:)]) {
        self.headerHeight = [self.delegate alw_collectionView:self.collectionView layout:self heightForFooterInSection:section];
    }
    
    return self.footerHeight;
}

- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:insetForSectionAtIndex:)]) {
        self.sectionInset = [self.delegate alw_collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}

- (CGFloat)rowMarginForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:rowMarginForSectionAtIndex:)]) {
        self.rowMargin = [self.delegate alw_collectionView:self.collectionView layout:self rowMarginForSectionAtIndex:section];
    }
    
    return self.rowMargin;
}

- (CGFloat)columnMarginForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(alw_collectionView:layout:columnMarginForSectionAtIndex:)]) {
        self.columnMargin = [self.delegate alw_collectionView:self.collectionView layout:self columnMarginForSectionAtIndex:section];
    }
    
    return self.columnMargin;
}

@end

