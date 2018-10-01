//
//  XDTransactionCatgroyView.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/24.
//

#import "XDTransactionCatgroyView.h"
#import "XDTransactionHelpClass.h"
#import "Category.h"
#import "XDHorizontalCollectionViewCell.h"
@interface XDTransactionCatgroyView()<UICollectionViewDelegate,UICollectionViewDataSource,XDHorizontalCollectionDelegate>

@property(nonatomic,strong)NSMutableArray* dataMuArr;

@end

@implementation XDTransactionCatgroyView

static NSString* const cellID = @"cellID";

-(void)setTransactionType:(TransactionType)transactionType{
    _transactionType = transactionType;
    self.dataMuArr = [NSMutableArray arrayWithArray:[XDTransactionHelpClass getCategroysWithTranscationType:transactionType]];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flow];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[XDHorizontalCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        self.backgroundColor = [UIColor whiteColor];
        
       
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger integer = self.dataMuArr.count;
  
    return integer;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XDHorizontalCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section < self.dataMuArr.count) {
        cell.dataArr = self.dataMuArr[indexPath.section];
        cell.delegate = self;
    }
  
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    if ([self.categoryDelegate respondsToSelector:@selector(returnCurrentPage:)]) {
        [self.categoryDelegate returnCurrentPage:index];
    }
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
}


#pragma mark - XDHorizontalCollectionDelegate
-(void)returnSelectedCategory:(Category *)category{
    if ([self.categoryDelegate respondsToSelector:@selector(returnSelectCategory:)]) {
        [self.categoryDelegate returnSelectCategory:category];
    }
}


@end
