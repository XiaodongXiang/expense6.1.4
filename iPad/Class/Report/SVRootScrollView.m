//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"

#import "SVGloble.h"
#import "SVTopScrollView.h"

#import "PokcetExpenseAppDelegate.h"
#import "AppDelegate_iPad.h"
#import "ipad_ReportCategotyViewController.h"

#define POSITIONID (int)(scrollView.contentOffset.x/960)
#define SCROLL_WIDTH 960
@implementation SVRootScrollView

@synthesize viewNameArray;
@synthesize viewArray;
+ (SVRootScrollView *)shareInstance {
    static SVRootScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 93, SCROLL_WIDTH, [SVGloble shareInstance].globleHeight-93)];
        
        
    });
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = YES;
        
        userContentOffsetX = 0;
    }
    return self;
}

- (void)initWithViews
{
//    for (int i = 0; i < [viewNameArray count]; i++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+SCROLL_WIDTH*i, 0, SCROLL_WIDTH, [SVGloble shareInstance].globleHeight-44)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:50.0];
//        label.tag = 200 + i;
//        if (i == 0) {
//            label.text = [viewNameArray objectAtIndex:i];
//        }
//        [self addSubview:label];
//    }
    for (int i = 0; i < [viewArray count]; i++) {
       
        UIViewController *viewController=[viewArray objectAtIndex:i];
        viewController.view.frame=CGRectMake(0+SCROLL_WIDTH*i, 0, SCROLL_WIDTH, [SVGloble shareInstance].globleHeight);
        viewController.view.tag=200+i;
        [self addSubview:viewController.view];
        
    }

    self.contentSize = CGSizeMake(SCROLL_WIDTH*[viewArray count], [SVGloble shareInstance].globleHeight-93);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/viewNameArray.count)/pagewidth)+1;

    if (page==0) {
        
        appDelegate_iPad.mainViewController.iReportRootViewController.cashFlowVC.dateRangeSelView.hidden = YES;
        [appDelegate_iPad.mainViewController.iReportRootViewController.categoryVC reFlashTableViewDataInThisViewController];
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"14_RPT_CAT"];

    }
    else if (page==1)
    {
        [appDelegate_iPad.mainViewController.iReportRootViewController.categoryVC hidePopView];
        [appDelegate_iPad.mainViewController.iReportRootViewController.cashFlowVC reFlashTableViewData];
        
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"14_RPT_CSH"];


    }
}

-(void)resetData
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];

    [appDelegate_iPad.mainViewController.iReportRootViewController.categoryVC reFlashTableViewDataInThisViewController];

}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[SVTopScrollView shareInstance] setButtonUnSelect];
    [SVTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[SVTopScrollView shareInstance] setButtonSelect];
    [[SVTopScrollView shareInstance] setScrollViewContentOffset];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
