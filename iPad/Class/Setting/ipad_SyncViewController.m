//
//  ipad_SyncViewController.m
//  PocketExpense
//
//  Created by humingjing on 14-6-5.
//
//

#import "ipad_SyncViewController.h"
#import <Dropbox/Dropbox.h>
#import "AppDelegate_iPad.h"
@interface ipad_SyncViewController ()

@end

@implementation ipad_SyncViewController
@synthesize myTableView,dropboxCell,syncCell,syncswitch,dropbox;
@synthesize dropboxAccountNameLabel;
@synthesize dropboxLabelText;
@synthesize dropbox1Text,dropbox2Text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavStyle];
    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];

    if (appDelegate.dropbox.drop_account.linked) {
       self.dropboxAccountNameLabel.text = appDelegate.dropbox.drop_account.info.userName;
        syncswitch.on = YES;
    }
    else
    {
        self.dropboxAccountNameLabel.text = @"";
        syncswitch.on = NO;
        [appDelegate.epnc setFlurryEvent_WithIdentify:@"18_SET_SYNC"];

    }
}

-(void)initNavStyle
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed: @"ipad_nav_480_44.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = image;
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexible.width = -11;
    
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
	back.frame = CGRectMake(0, 0, 30, 30);
	[back setImage: [UIImage imageNamed:@"ipad_icon_back_30_30.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithCustomView:back];
	self.navigationItem.leftBarButtonItems = @[flexible,leftButton];
    
   	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
	[titleLabel setTextColor:[appDelegate.epnc getiPadNavigationBarTiltleTeextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = NSLocalizedString(@"VC_Sync", nil);
    self.navigationItem.titleView = titleLabel;
}

-(void)initPoint{
    dropboxLabelText.text = NSLocalizedString(@"VC_Sync", nil);
    dropbox1Text.text = NSLocalizedString(@"VC_Dropbox", nil);
    dropbox2Text.text = NSLocalizedString(@"VC_LinkyourDropbox", nil);
    
    [syncswitch addTarget:self action:@selector(syncswitchValueChanged) forControlEvents:UIControlEventValueChanged];
    
    syncswitch.on = ([[DBAccountManager sharedManager] linkedAccount] != nil);
}

#pragma mark Btn Action
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)syncswitchValueChanged{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!syncswitch.on) {
        self.dropboxAccountNameLabel.text = @"";

    }
    
    //当点击switch按钮的时候，根据switch按钮的状态来设置开启／关闭同步
    [appDelegate.dropbox linkDropBoxAccount:syncswitch.on fromViewController:self];
    
    if (syncswitch.on == YES)
    {
        syncswitch.on = NO;
        

    }

}

-(void)refleshStatus
{
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    syncswitch.on = YES;
    if (appDelegate_iPad.dropbox.drop_account.linked) {
        self.dropboxAccountNameLabel.text = appDelegate_iPad.dropbox.drop_account.info.userName;
    }
    else
        self.dropboxAccountNameLabel.text = @"";
}

-(void)flashView
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    syncswitch.on = [appDelegate.dropbox.drop_account isLinked];
    
    if (syncswitch.on == YES)
    {
        DBAccountInfo *acountInfo = appDelegate.dropbox.drop_account.info;
        self.dropboxAccountNameLabel.text = acountInfo.userName;
    }
    else
    {
        self.dropboxAccountNameLabel.text = @"";
    }
}

-(void)flashView2
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    syncswitch.on = [appDelegate.dropbox.drop_account isLinked];
    [self performSelector:@selector(setName) withObject:nil afterDelay:1];
}

-(void)setName
{
    PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
    syncswitch.on = [appDelegate.dropbox.drop_account isLinked];
    
    DBAccountInfo *acountInfo = appDelegate.dropbox.drop_account.info;
    if (self.syncswitch.on == YES)
    {
        self.dropboxAccountNameLabel.text = acountInfo.userName;
    }
    else
    {
        self.dropboxAccountNameLabel.text = @"";
    }
}


//-(IBAction)syncSwithTouchInside:(id)sender
//{
//    
//     PokcetExpenseAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//    
//    if ([[DBAccountManager sharedManager] linkedAccount]) {
//        [appDelegate.dropbox linkDropBoxAccount:NO fromViewController:self];
//    }
//    else
//    {
//        [appDelegate.dropbox linkDropBoxAccount:YES fromViewController:self];
//    }
//    syncswitch.on = ([[DBAccountManager sharedManager] linkedAccount] != nil);
//
//}



#pragma mark TableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;;
    }
    else
        return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 85;
    }
    else
        return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    else{
        UIView *headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        headView.backgroundColor = [UIColor clearColor];
        return headView;
    }
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if(indexPath.section ==0 && indexPath.row==0)
	{
		return dropboxCell;
	}
    else
	{
		return syncCell;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
