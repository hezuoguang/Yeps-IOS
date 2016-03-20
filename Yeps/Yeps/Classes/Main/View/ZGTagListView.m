//
//  ZGTagListView.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGTagListView.h"
#import "ZGTagCollectionViewCell.h"

@interface ZGTagListView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *tagList;

@end

static NSString *collectionViewID = @"collectionViewID";

@implementation ZGTagListView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerClass:[ZGTagCollectionViewCell class] forCellWithReuseIdentifier:collectionViewID];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.cellStyle = ZGTagCollectionViewCellStyleDefault;
    }
    return self;
}

- (void)setTags:(NSArray *)tags {
    self.tagList = [NSMutableArray arrayWithArray:[tags copy]];
    [self reloadData];
}

- (NSArray *)tags {
    return [self.tagList copy];
}

- (void)addTag:(NSString *)tag {
    [self.tagList addObject:[tag copy]];
    [self reloadData];
}

- (void)addTags:(NSArray *)tags {
    [self.tagList addObjectsFromArray:[tags copy]];
    [self reloadData];
}

- (void)removeTag:(NSString *)tag {
    for (NSString *t in self.tagList) {
        if ([t isEqualToString:tag]) {
            [self.tagList removeObject:t];
            [self reloadData];
            break;
        }
    }
}

- (NSMutableArray *)tagList {
    if (_tagList == nil) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZGTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewID forIndexPath:indexPath];
    cell.tagName = self.tagList[indexPath.row];
    [cell setCellStyle:self.cellStyle];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.tagList[indexPath.row];
    NSDictionary *dict = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:17]
                           };
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return CGSizeMake(size.width + 30, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tagName = [self.tagList[indexPath.row] copy];
    [self.tagList removeObjectAtIndex:indexPath.row];
    if (self.didSelectTag) {
        self.didSelectTag(tagName);
    }
    [self reloadData];
}

@end
