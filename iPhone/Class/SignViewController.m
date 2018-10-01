//
//  SignViewController.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/12/15.
//
//


#import "SignViewController.h"
#import "firstView.h"
#import "secondView.h"
#import "thirdView.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import "MyPageControl.h"

@interface  SignViewController()<UIScrollViewDelegate>
{
    UIScrollView *pageScrollView;
    secondView *second;
    MyPageControl *pagecontrol;
    
    UIImageView *dot;
    float lineLength;
    CGPoint initPoint;
}
@end

@implementation SignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createScrollView];
    [self createSubviews];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)createScrollView
{
    pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT )];
    pageScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    pageScrollView.pagingEnabled=YES;
    pageScrollView.bouncesZoom=NO;
    pageScrollView.bounces=NO;
    pageScrollView.showsHorizontalScrollIndicator=NO;
    pageScrollView.delegate=self;
    [self.view addSubview:pageScrollView];
    
    //custome pageControl
    
    float circleInterval;
    float circleToBottom;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        circleInterval=16;
        circleToBottom=15;
    }
    else
    {
        circleInterval=12;
        circleToBottom=31;
    }
    UIImage *circle=[UIImage imageNamed:@"pilot_point1"];
    UIImageView *firstCircle=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1.5*circle.size.width-circleInterval, SCREEN_HEIGHT-circleToBottom-circle.size.height, circle.size.width, circle.size.height)];
    firstCircle.image=circle;
    [self.view addSubview:firstCircle];
    
    UIImageView *secondCircle=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5*circle.size.width, SCREEN_HEIGHT-circleToBottom-circle.size.height, circle.size.width, circle.size.height)];
    secondCircle.image=circle;
    [self.view addSubview:secondCircle];
    
    UIImageView *thirdCircle=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+0.5*circle.size.width+circleInterval, SCREEN_HEIGHT-circleToBottom-circle.size.height,circle.size.width, circle.size.height)];
    thirdCircle.image=circle;
    [self.view addSubview:thirdCircle];
    
    UIImage *dotImage=[UIImage imageNamed:@"pilot_point2"];
    dot=[[UIImageView alloc]initWithImage:dotImage];
    dot.frame=CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
    dot.center=firstCircle.center;
    [self.view addSubview:dot];
    
    lineLength=thirdCircle.center.x-firstCircle.center.x;
    initPoint=firstCircle.center;
}
-(void)createSubviews
{
    firstView *first=[[firstView alloc]init];
    first.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [pageScrollView addSubview:first];
    
    thirdView *view=[[thirdView alloc]init];
    view.frame=CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [pageScrollView addSubview:view];
    
    second=[[secondView alloc]init];
    second.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [pageScrollView addSubview:second];
}
#pragma mark - ScrollView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x==0)
    {
        [second labelStartAnimation];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x==SCREEN_WIDTH)
    {
        [second labelEndAnimation];
        [second iconAnimation];
        pagecontrol.currentPage=1;
    }
    else if (scrollView.contentOffset.x==SCREEN_WIDTH*2)
    {
        pagecontrol.currentPage=2;
    }
    else if (scrollView.contentOffset.x==0)
    {
        pagecontrol.currentPage=0;
    }
    if (scrollView.contentOffset.x==SCREEN_WIDTH*2)
    {
        scrollView.scrollEnabled=NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //实时更新dot位置
    float pointX=(scrollView.contentOffset.x/(2*SCREEN_WIDTH))*lineLength;
    
    dot.center=CGPointMake(initPoint.x+pointX, initPoint.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
