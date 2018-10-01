//
//  TodayViewController.m
//  Pocket Expense
//
//  Created by 晓东项 on 2018/8/28.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetBtn.h"
#import <CoreData/CoreData.h>
#import "Category.h"
#import "Accounts.h"
#import "UIView+XDExtension.h"
#import "Transaction.h"
#import "Payee.h"
#import "Setting+CoreDataClass.h"
#import <sys/utsname.h>
#define FontSFUITextMedium                                  @"SFUIText-Medium"

#define IS_IPHONE      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


@interface TodayViewController () <NCWidgetProviding>
{
    NSManagedObjectContext              *managedObjectContext;
    NSManagedObjectModel                *managedObjectModel;
    NSPersistentStoreCoordinator        *persistentStoreCoordinator;
    
    
    NSMutableString* _amountString;
    NSInteger _accountIndex;
    
    BOOL _showingNumView;
    
    Category* _selectCategory;
    Payee* _selectPayee;
}
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong)UIImageView* categoryImgV;

@property(nonatomic, strong)UIView* calculateView;
@property(nonatomic, strong)UILabel* categoryNameLbl;
@property(nonatomic, strong)UILabel* amountLbl;

@property (nonatomic, strong)NSArray* dataArr;

@property(nonatomic, strong)UIView* firstView;
@property(nonatomic, strong)UIView* numberBackView;
@property(nonatomic, strong)NSArray* accountArr;

@property(nonatomic, strong)UIView* smallNumView;

@property(nonatomic, strong)UIImageView* smallCategoryImgV;
@property(nonatomic, strong)UILabel* smallCategoryNameLbl;
@property(nonatomic, strong)UILabel* smallAmountLbl;

@property(nonatomic, strong)UIView* lockView;


@end

@implementation TodayViewController

-(UIView *)lockView{
    if (!_lockView) {
        _lockView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [self getDeviceIsIpadPro]?130:110)];
        //        _lockView.backgroundColor = [UIColor whiteColor];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [self getDeviceIsIpadPro]?130:110)];
        [btn setImage:[UIImage imageNamed:@"widget"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"widget_press"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(unlockView) forControlEvents:UIControlEventTouchUpInside];
        [_lockView addSubview:btn];
        
    }
    return _lockView;
}

-(UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 220)];
        _firstView.backgroundColor = [UIColor clearColor];
        
        
        
        CGFloat width = (self.view.frame.size.width-10)/4;
        CGFloat height = 80;
        if (self.dataArr.count >= 7) {
            for (int i = 0; i < 7; i++) {
                id item = self.dataArr[i];
                Category* category = nil;
                Payee* payee = nil;
                if ([item isKindOfClass:[Category class]]) {
                    category =item;
                }else if ([item isKindOfClass:[Payee class]]){
                    payee = item;
                }
                
                if (i <= 3) {
                    WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * i, 15, width, height)];
                    btn.category = category;
                    btn.payee = payee;
                    [btn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_firstView addSubview:btn];
                }else{
                    WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * (i%4), 110, width, height)];
                    btn.category = category;
                    btn.payee = payee;
                    [btn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_firstView addSubview:btn];
                }
            }
            WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * 3, 110, width, height)];
            btn.categoryLabel.text = @"more";
            btn.categoryImageView.image = [UIImage imageNamed:@"widgetMore"];
            [btn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_firstView addSubview:btn];
            
        }else{
            for (int i = 0; i < self.dataArr.count; i++) {
                id item = self.dataArr[i];
                Category* category = nil;
                Payee* payee = nil;
                if ([item isKindOfClass:[Category class]]) {
                    category =item;
                }else if ([item isKindOfClass:[Payee class]]){
                    payee = item;
                }
                if (i <= 3) {
                    WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * i, 15, width, height)];
                    btn.category = category;
                    btn.payee = payee;
                    [btn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_firstView addSubview:btn];
                }else{
                    WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * (i%4), 110, width, height)];
                    btn.category = category;
                    btn.payee = payee;
                    [btn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_firstView addSubview:btn];
                }
            }
            
            WidgetBtn* btn = [[WidgetBtn alloc]initWithFrame:CGRectMake(width * (self.dataArr.count % 4), 110, width, height)];
            btn.categoryLabel.text = @"more";
            
            [_firstView addSubview:btn];
        }
    }
    return _firstView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BOOL open = [self getSettingBool14];
    
    self.dataArr = [self dataArrWith:[self getAllPayee] categoryArr:[self getAllCategory]];
    self.accountArr = [self getAllAccounts];
    
    [self.view addSubview:self.firstView];
    [self.view addSubview:self.calculateView];
    [self.view addSubview:self.lockView];
    
    if (open) {
        self.lockView.hidden = YES;
        self.firstView.hidden = NO;
        if (self.dataArr.count >= 4) {
            if (@available(iOS 10.0, *)) {
                self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
            } else {
                // Fallback on earlier versions
            }
        }else{
            if (@available(iOS 10.0, *)) {
                self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
            } else {
                // Fallback on earlier versions
            }
        }
        
    }else{
        self.lockView.hidden = NO;
        self.firstView.hidden = YES;
        
        if (@available(iOS 10.0, *)) {
            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}

-(NSArray*)dataArrWith:(NSArray*)payeeArr categoryArr:(NSArray*)categoryArr{
    NSMutableArray* muArr = [NSMutableArray array];
    if (payeeArr.count > 0) {
        if (payeeArr.count >= 7) {
            [muArr addObjectsFromArray:[payeeArr subarrayWithRange:NSMakeRange(0, 7)]];
        }else{
            [muArr addObjectsFromArray:payeeArr];
            NSInteger count = 7 - payeeArr.count;
            if (categoryArr.count >= count) {
                [muArr addObjectsFromArray:[categoryArr subarrayWithRange:NSMakeRange(0, count)]];
            }else{
                [muArr addObjectsFromArray:categoryArr];
            }
        }
    }else{
        if (categoryArr.count >= 7) {
            [muArr addObjectsFromArray:[categoryArr subarrayWithRange:NSMakeRange(0, 7)]];
        }else{
            [muArr addObjectsFromArray:categoryArr];
        }
    }
    return muArr;
}

-(void)unlockView{
    
    [self.extensionContext openURL:[NSURL URLWithString:@"PocketExpenseLite://purchased"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _accountIndex = 0;
    
    //    self.dataArr = [self getAllCategory];
    //    self.accountArr = [self getAllAccounts];
    
    //    [self.view addSubview:self.firstView];
    //    [self.view addSubview:self.calculateView];
    //    [self.view addSubview:self.lockView];
    
    //    if (self.dataArr.count >= 4) {
    //        if (@available(iOS 10.0, *)) {
    //            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //    }else{
    //        if (@available(iOS 10.0, *)) {
    //            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //    }
    //    self.preferredContentSize = CGSizeMake(self.view.width, 110);
}



-(void)moreBtnClick{
    //scheme为app的scheme
    [self.extensionContext openURL:[NSURL URLWithString:@"PocketExpenseLite://addTransaction"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
    
    
}


#pragma mark - database Methods

-(NSArray *)getAllPayee
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Payee"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@ and category != nil",@"1"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:NO];
    
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}


-(NSArray *)getAllCategory
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Category"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@",@"1"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordIndex" ascending:NO];
    
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}

-(BOOL)getSettingBool14{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Setting"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:clientsEntity];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];

    Setting* setting = requests.lastObject;
    
    return [setting.otherBool14 boolValue];
}

-(NSArray *)getAllAccounts
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Accounts"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state = %@",@"1"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"others" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:NO];
    
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setSortDescriptors:@[sortDescriptor,sortDescriptor2]];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}

-(NSArray *)getObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortArray && sortArray.count > 0) {
        [request setSortDescriptors:sortArray];
    }
    
    NSError* error=nil;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
}

-(BOOL)getDeviceIsIpadPro{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([device isEqualToString:@"iPad6,7"] || [device isEqualToString:@"iPad6,8"]) {
        return YES;
    }else{
        return NO;
    }
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        
//        NSLog(@"frame == %@",NSStringFromCGRect(self.view.frame));
        if (activeDisplayMode == NCWidgetDisplayModeCompact)
        {
            self.preferredContentSize = CGSizeMake(maxSize.width, 110);
            
            if(_showingNumView){
                self.smallNumView.x = 0;
                self.smallNumView.hidden = NO;
                self.smallNumView.alpha = 0;
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.calculateView.alpha = 0;
                    self.smallNumView.alpha = 1;
                }completion:^(BOOL finished) {
                    self.calculateView.hidden = YES;
                }];
            }
        }
        else
        {
            
            if(_showingNumView){
                self.calculateView.hidden = NO;
                self.calculateView.alpha = 0;
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.smallNumView.alpha = 0;
                    self.calculateView.alpha = 1;
                }completion:^(BOOL finished) {
                    self.smallNumView.hidden = YES;
                }];
                self.preferredContentSize = CGSizeMake(maxSize.width, 332);
                
            }else{
                self.preferredContentSize = CGSizeMake(maxSize.width, 210);
            }
        }
    } else {
        // Fallback on earlier versions
    }
    
}

//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    return UIEdgeInsetsZero;
//}

-(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}


-(UIView *)calculateView{
    if (!_calculateView) {
        _calculateView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 332)];
        _calculateView.backgroundColor = [UIColor clearColor];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 14, 44, 44)];
        [btn setImage:[UIImage imageNamed:@"Return_icon_normal"] forState:UIControlStateNormal];
        [_calculateView addSubview:btn];
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.categoryImgV = [[UIImageView alloc]initWithFrame:CGRectMake(44, 14, 44, 44)];
        [_calculateView addSubview:self.categoryImgV];
        
        self.categoryNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(90, 14, (self.view.width - 100)/2, 44)];
        self.categoryNameLbl.numberOfLines = 0;
        self.categoryNameLbl.minimumScaleFactor = 0.8;
        self.categoryNameLbl.adjustsFontSizeToFitWidth = YES;
        [_calculateView addSubview:self.categoryNameLbl];
        
        self.numberBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 72, self.view.width, 260)];
        self.numberBackView.backgroundColor = [UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1];
        [_calculateView addSubview:self.numberBackView];
        
        self.amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.categoryNameLbl.frame), 14, self.view.width - CGRectGetMaxX(self.categoryNameLbl.frame) - 25, 44)];
        self.amountLbl.font = [UIFont systemFontOfSize:28];
        self.amountLbl.textAlignment = NSTextAlignmentRight;
        self.amountLbl.textColor = [UIColor blackColor];
        self.amountLbl.minimumScaleFactor = 0.8;
        self.amountLbl.adjustsFontSizeToFitWidth = YES;
        [_calculateView addSubview:self.amountLbl];
        
        [self numBtnConfig:self.numberBackView];
    }
    return _calculateView;
}

-(UIView *)smallNumView{
    if (!_smallNumView) {
        _smallNumView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 73)];
        _smallNumView.backgroundColor = [UIColor clearColor];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, [self getDeviceIsIpadPro]?10:0, 37, 37)];
        [btn setImage:[UIImage imageNamed:@"small_Return_icon_normal"] forState:UIControlStateNormal];
        [_smallNumView addSubview:btn];
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, [self getDeviceIsIpadPro]?13.5:3.5, 30, 30)];
        [_smallNumView addSubview:imageView];
        self.smallCategoryImgV = imageView;
        
        UILabel* nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(70,[self getDeviceIsIpadPro]?13.5:3.5, (self.view.width - 70)/2, 30)];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.textColor = [UIColor colorWithRed:85/255. green:85/255. blue:85/255. alpha:1];
        [_smallNumView addSubview:nameLbl];
        self.smallCategoryNameLbl = nameLbl;
        
        UILabel* amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLbl.frame), [self getDeviceIsIpadPro]?13.5:3.5, self.view.width - CGRectGetMaxX(nameLbl.frame) - 10, 30)];
        amountLbl.font = [UIFont systemFontOfSize:24];
        amountLbl.textColor = [UIColor blackColor];
        [_smallNumView addSubview:amountLbl];
        amountLbl.textAlignment = NSTextAlignmentRight;
        self.smallAmountLbl = amountLbl;
        
        UIView* smallNumView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getDeviceIsIpadPro]?57:37, self.view.width, 73)];
        smallNumView.backgroundColor = [UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1];
        [_smallNumView addSubview:smallNumView];
        
        [self smallNumConfig:smallNumView];
        
        [self.view addSubview:_smallNumView];
        
        
    }
    
    return _smallNumView;
}


-(void)numBtnConfig:(UIView*)view{
    CGFloat width = (self.view.width - 1)/4;
    CGFloat height = 64.5;
    
    UIColor* blackColor = [UIColor colorWithRed:85/255. green:85/255. blue:85/255. alpha:1];
    
    UIButton * oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    oneBtn.backgroundColor = [UIColor whiteColor];
    [oneBtn setTitle:@"1" forState:UIControlStateNormal];
    [oneBtn setTitleColor:blackColor forState:UIControlStateNormal];
    oneBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    oneBtn.tag = 1;
    [oneBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:oneBtn];
    
    UIButton * twoBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, 0, width, height)];
    twoBtn.backgroundColor = [UIColor whiteColor];
    [twoBtn setTitle:@"2" forState:UIControlStateNormal];
    [twoBtn setTitleColor:blackColor forState:UIControlStateNormal];
    twoBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    twoBtn.tag = 2;
    [twoBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:twoBtn];
    
    UIButton * threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width+1, 0, width, height)];
    threeBtn.backgroundColor = [UIColor whiteColor];
    [threeBtn setTitle:@"3" forState:UIControlStateNormal];
    [threeBtn setTitleColor:blackColor forState:UIControlStateNormal];
    threeBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    threeBtn.tag = 3;
    [threeBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:threeBtn];
    
    UIButton * fourBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, height+0.5, width, height)];
    fourBtn.backgroundColor = [UIColor whiteColor];
    [fourBtn setTitle:@"4" forState:UIControlStateNormal];
    [fourBtn setTitleColor:blackColor forState:UIControlStateNormal];
    fourBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    fourBtn.tag = 4;
    [fourBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fourBtn];
    
    UIButton * fiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, height+0.5, width, height)];
    fiveBtn.backgroundColor = [UIColor whiteColor];
    [fiveBtn setTitle:@"5" forState:UIControlStateNormal];
    [fiveBtn setTitleColor:blackColor forState:UIControlStateNormal];
    fiveBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    fiveBtn.tag = 5;
    [fiveBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fiveBtn];
    
    UIButton * sixBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width+1, height+0.5, width, height)];
    sixBtn.backgroundColor = [UIColor whiteColor];
    [sixBtn setTitle:@"6" forState:UIControlStateNormal];
    [sixBtn setTitleColor:blackColor forState:UIControlStateNormal];
    sixBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    sixBtn.tag = 6;
    [sixBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sixBtn];
    
    UIButton * sevenBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2*height+1, width, height)];
    sevenBtn.backgroundColor = [UIColor whiteColor];
    [sevenBtn setTitle:@"7" forState:UIControlStateNormal];
    [sevenBtn setTitleColor:blackColor forState:UIControlStateNormal];
    sevenBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    sevenBtn.tag = 7;
    [sevenBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sevenBtn];
    
    UIButton * eightBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, 2*height+1, width, height)];
    eightBtn.backgroundColor = [UIColor whiteColor];
    [eightBtn setTitle:@"8" forState:UIControlStateNormal];
    [eightBtn setTitleColor:blackColor forState:UIControlStateNormal];
    eightBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    eightBtn.tag = 8;
    [eightBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:eightBtn];
    
    UIButton * nineBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width+1, 2*height+1, width, height)];
    nineBtn.backgroundColor = [UIColor whiteColor];
    [nineBtn setTitle:@"9" forState:UIControlStateNormal];
    [nineBtn setTitleColor:blackColor forState:UIControlStateNormal];
    nineBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    nineBtn.tag = 9;
    [nineBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nineBtn];
    
    UIButton * pointBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3*height+1.5, width, height)];
    pointBtn.backgroundColor = [UIColor whiteColor];
    [pointBtn setTitle:@"." forState:UIControlStateNormal];
    [pointBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    pointBtn.tag = 10;
    [pointBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pointBtn];
    
    UIButton * zeroBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, 3*height+1.5, width, height)];
    zeroBtn.backgroundColor = [UIColor whiteColor];
    [zeroBtn setTitle:@"0" forState:UIControlStateNormal];
    [zeroBtn setTitleColor:blackColor forState:UIControlStateNormal];
    zeroBtn.titleLabel.font = [UIFont fontWithName:FontSFUITextMedium size:26];
    zeroBtn.tag = 0;
    [zeroBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zeroBtn];
    
    UIButton * deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width+1, 3*height+1.5, width, height)];
    [deleBtn setBackgroundColor:[UIColor whiteColor]];
    [deleBtn setImage:[UIImage imageNamed:@"dele"] forState:UIControlStateNormal];
    deleBtn.tag = 11;
    [deleBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleBtn];
    
    UIButton* accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(threeBtn.frame), 0, width, height*2)];
    [accountBtn setBackgroundColor:[UIColor colorWithRed:139/255. green:135/255. blue:1 alpha:1]];
    [accountBtn addTarget:self action:@selector(changeAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.accountArr.count>0) {
        Accounts* acc = self.accountArr[_accountIndex];
        [accountBtn setTitle:acc.accName forState:UIControlStateNormal];
    }
    if (IS_IPHONE) {
        accountBtn.titleLabel.font =[UIFont systemFontOfSize:12];
    }else{
        accountBtn.titleLabel.font =[UIFont fontWithName:FontSFUITextMedium size:22];
    }
    accountBtn.titleLabel.numberOfLines = 0;
    accountBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    [view addSubview:accountBtn];
    
    UIButton* completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(threeBtn.frame), CGRectGetMaxY(accountBtn.frame), width, height*2+2)];
    [completeBtn setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:[UIColor colorWithRed:96/255. green:165/255. blue:1 alpha:1]];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:completeBtn];
    completeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
}

-(void)smallNumConfig:(UIView*)view{
    CGFloat width = (self.view.width - 4.5)/10;
    CGFloat height = 37;
    
    UIButton * oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [oneBtn setImage:[UIImage imageNamed:@"small_1"] forState:UIControlStateNormal];
    [oneBtn setBackgroundColor:[UIColor whiteColor]];
    oneBtn.tag = 1;
    [oneBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:oneBtn];
    
    UIButton * twoBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, 0, width, height)];
    [twoBtn setImage:[UIImage imageNamed:@"small_2"] forState:UIControlStateNormal];
    [twoBtn setBackgroundColor:[UIColor whiteColor]];
    twoBtn.tag = 2;
    [twoBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:twoBtn];
    
    UIButton * threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width+1, 0, width, height)];
    [threeBtn setImage:[UIImage imageNamed:@"small_3"] forState:UIControlStateNormal];
    [threeBtn setBackgroundColor:[UIColor whiteColor]];
    threeBtn.tag = 3;
    [threeBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:threeBtn];
    
    UIButton * fourBtn = [[UIButton alloc]initWithFrame:CGRectMake(3*width+1.5, 0, width, height)];
    [fourBtn setImage:[UIImage imageNamed:@"small_4"] forState:UIControlStateNormal];
    [fourBtn setBackgroundColor:[UIColor whiteColor]];
    fourBtn.tag = 4;
    [fourBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fourBtn];
    
    UIButton * fiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(4*width+2, 0, width, height)];
    [fiveBtn setImage:[UIImage imageNamed:@"small_5"] forState:UIControlStateNormal];
    [fiveBtn setBackgroundColor:[UIColor whiteColor]];
    fiveBtn.tag = 5;
    [fiveBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fiveBtn];
    
    UIButton * sixBtn = [[UIButton alloc]initWithFrame:CGRectMake(5*width+2.5, 0, width, height)];
    [sixBtn setImage:[UIImage imageNamed:@"small_6"] forState:UIControlStateNormal];
    [sixBtn setBackgroundColor:[UIColor whiteColor]];
    sixBtn.tag = 6;
    [sixBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sixBtn];
    
    UIButton * sevenBtn = [[UIButton alloc]initWithFrame:CGRectMake(6*width+3, 0, width, height)];
    [sevenBtn setImage:[UIImage imageNamed:@"small_7"] forState:UIControlStateNormal];
    [sevenBtn setBackgroundColor:[UIColor whiteColor]];
    sevenBtn.tag = 7;
    [sevenBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sevenBtn];
    
    UIButton * eightBtn = [[UIButton alloc]initWithFrame:CGRectMake(7*width+3.5, 0, width, height)];
    [eightBtn setImage:[UIImage imageNamed:@"small_8"] forState:UIControlStateNormal];
    [eightBtn setBackgroundColor:[UIColor whiteColor]];
    eightBtn.tag = 8;
    [eightBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:eightBtn];
    
    UIButton * nineBtn = [[UIButton alloc]initWithFrame:CGRectMake(8*width+4, 0, width, height)];
    [nineBtn setImage:[UIImage imageNamed:@"small_9"] forState:UIControlStateNormal];
    [nineBtn setBackgroundColor:[UIColor whiteColor]];
    nineBtn.tag = 9;
    [nineBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nineBtn];
    
    UIButton * pointBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, height+0.5, width, height)];
    pointBtn.backgroundColor = [UIColor whiteColor];
    [pointBtn setTitle:@"." forState:UIControlStateNormal];
    pointBtn.titleEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
    [pointBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    pointBtn.tag = 10;
    [pointBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pointBtn];
    
    UIButton * zeroBtn = [[UIButton alloc]initWithFrame:CGRectMake(9*width+4.5, 0, width, height)];
    [zeroBtn setImage:[UIImage imageNamed:@"small_0"] forState:UIControlStateNormal];
    [zeroBtn setBackgroundColor:[UIColor whiteColor]];
    zeroBtn.tag = 0;
    [zeroBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zeroBtn];
    
    UIButton * deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(width+0.5, height+0.5, width, height)];
    [deleBtn setBackgroundColor:[UIColor whiteColor]];
    [deleBtn setImage:[UIImage imageNamed:@"small_dele"] forState:UIControlStateNormal];
    deleBtn.tag = 11;
    [deleBtn addTarget:self action:@selector(numbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleBtn];
    
    UIButton* accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width + 1, height+0.5, width*4+2, height)];
    [accountBtn setBackgroundColor:[UIColor colorWithRed:139/255. green:135/255. blue:1 alpha:1]];
    [accountBtn addTarget:self action:@selector(changeAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.accountArr.count>0) {
        Accounts* acc = self.accountArr[_accountIndex];
        [accountBtn setTitle:acc.accName forState:UIControlStateNormal];
    }
    accountBtn.titleLabel.font =[UIFont systemFontOfSize:12];
    [view addSubview:accountBtn];
    
    UIButton* completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(accountBtn.frame), height+0.5, width*4+2, height+2)];
    [completeBtn setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:[UIColor colorWithRed:96/255. green:165/255. blue:1 alpha:1]];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:completeBtn];
}


-(void)completeBtnClick{
    if ([_amountString doubleValue] == 0) {
        [self shakeAnimationForView:self.amountLbl];
        [self shakeAnimationForView:self.smallAmountLbl];
    }else{
        Transaction* transaction = [self insertObjectToTable:@"Transaction"];
        transaction.dateTime = [NSDate date];
        transaction.updatedTime = transaction.dateTime_sync = [NSDate date];
        transaction.state = @"1";
        transaction.amount = [NSNumber numberWithDouble:[_amountString doubleValue]];
        transaction.category = _selectCategory;
        transaction.payee = _selectPayee;
        
        _selectPayee.orderIndex = [NSNumber numberWithInteger:[_selectPayee.orderIndex integerValue] + 1];
        _selectCategory.recordIndex = [NSNumber numberWithInteger:[_selectCategory.recordIndex integerValue] + 1];
        
        Accounts* account = self.accountArr[_accountIndex];
        
        if ([_selectCategory.categoryType isEqualToString:@"EXPENSE"]) {
            transaction.expenseAccount = account;
            transaction.transactionType = @"expense";
        }else{
            transaction.incomeAccount = account;
            transaction.transactionType = @"income";
        }
        
        transaction.isClear = account.autoClear;
        transaction.recurringType = @"Never";
        transaction.uuid = [self getuuid];
        
        [self saveContext];
        
        [self backClick];
    }
    
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            // abort();
        }
    }
}


//create uuid
- (NSString *)getuuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

-(id)insertObjectToTable:(NSString*)tableName
{
    id object = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
    return object;
}

- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 5, position.y);
    CGPoint y = CGPointMake(position.x - 5, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

-(void)changeAccountBtnClick:(UIButton*)btn{
    if (self.accountArr.count>0) {
        _accountIndex += 1;
        if (_accountIndex > self.accountArr.count-1) {
            _accountIndex = 0;
        }
        Accounts* acc = self.accountArr[_accountIndex];
        [btn setTitle:acc.accName forState:UIControlStateNormal];
    }
    
}


-(void)categoryBtnClick:(WidgetBtn*)btn{
    if (btn.payee) {
        _selectCategory = btn.payee.category;
        _selectPayee = btn.payee;
    }else if (btn.category){
        _selectCategory = btn.category;
        _selectPayee = nil;
    }
    _showingNumView = YES;
    
    _amountString = [NSMutableString string];
    
    self.amountLbl.text = self.smallAmountLbl.text = @"0";
    
    [UIView animateWithDuration:0.2 animations:^{
        self.firstView.x = -self.view.width;
        if (self.view.height <= 130) {
            self.smallNumView.frame = CGRectMake(0, 0, self.view.bounds.size.width, [self getDeviceIsIpadPro]?130:110);
            self.calculateView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 332);
            self.smallNumView.alpha = 1;
            self.calculateView.hidden = YES;
            self.smallNumView.hidden = NO;
        }else{
            self.calculateView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 332);
            self.calculateView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 332);
            
            self.calculateView.hidden = NO;
            self.smallNumView.hidden = YES;
            self.calculateView.alpha = 1;
            if (@available(iOS 10.0, *)) {
                self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
                self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 332);
                
            } else {
                // Fallback on earlier versions
            }
        }
    }];
    
    self.categoryNameLbl.text = self.smallCategoryNameLbl.text = btn.payee?btn.payee.name:btn.category.categoryName;
    self.categoryImgV.image = self.smallCategoryImgV.image = [UIImage imageNamed:_selectCategory.iconName];
    
    
    
}

-(void)backClick{
    
    _showingNumView = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.smallNumView.x = self.view.width;
        self.calculateView.x = self.view.width;
        self.firstView.x = 0;
        
        if (self.view.height > 210) {
            self.preferredContentSize = CGSizeMake(self.view.width, 210);
        }
    }];
}

-(void)numbtnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            if (_amountString.length >= 9) {
                break;
            }
            if ([_amountString isEqualToString:@"0"] || [_amountString isEqualToString:@""]) {
                _amountString = [NSMutableString string];
            }
            if ([_amountString containsString:@"."]) {
                NSArray* array = [_amountString componentsSeparatedByString:@"."];
                if (array.count >= 2) {
                    if ([array.lastObject length]>=2) {
                        break;
                    }else{
                        [_amountString appendFormat:@"%ld",(long)btn.tag];
                    }
                }else{
                    [_amountString appendFormat:@"%ld",(long)btn.tag];
                }
            }else{
                [_amountString appendFormat:@"%ld",(long)btn.tag];
            }
            break;
        case 10:
            if (_amountString.length >= 9) {
                break;
            }
            if ([_amountString containsString:@"."]) {
                break;
            }else{
                if (_amountString.length == 0) {
                    _amountString = [NSMutableString stringWithString:@"0"];
                }
                [_amountString appendString:@"."];
            }
            break;
        case 11:
            if (_amountString.length <= 0) {
                break;
            }else{
                if ([_amountString isEqualToString:@"0"]) {
                    break;
                }else{
                    
                    NSString* str = [NSString stringWithString:_amountString];
                    _amountString =[NSMutableString stringWithString:[str substringToIndex:str.length - 1]];
                }
            }
            break;
        default:
            break;
    }
    if (_amountString.length == 0 || [_amountString isEqualToString:@""]) {
        self.amountLbl.text = self.smallAmountLbl.text = @"0";
    }else{
        self.amountLbl.text = [NSString stringWithString:_amountString];
        self.smallAmountLbl.text = [NSString stringWithString:_amountString];
    }
}

#pragma mark - coredata
- (NSManagedObjectContext *) managedObjectContext {
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}



/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *momURL = [[NSBundle mainBundle] URLForResource:@"PokcetExpense" withExtension:@"momd"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"PokcetExpense" ofType:@"momd"];
    //    NSURL *momURL = [NSURL fileURLWithPath:path];
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *storeURL2 = [self applicationDocumentsDirectory];
    NSURL *storeURL = [storeURL2 URLByAppendingPathComponent:@"Expense5.0.0.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager]
            containerURLForSecurityApplicationGroupIdentifier:@"group.com.btgs.pocketExpenseLite.coredata"];
    
    
}

@end
