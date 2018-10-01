//
//  ipad_SyncViewController.h
//  PocketExpense
//
//  Created by humingjing on 14-6-5.
//
//

#import <UIKit/UIKit.h>
#import "DropboxObject.h"

@interface ipad_SyncViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *myTableView;
    
    UITableViewCell     *dropboxCell;
    UITableViewCell     *syncCell;
    
    UISwitch            *syncswitch;
    UILabel             *dropboxLabelText;
    UILabel             *dropbox1Text;
    UILabel             *dropbox2Text;
    
    
    DropboxObject       *dropbox;
    UILabel             *dropboxAccountNameLabel;
    
}

@property(nonatomic,strong)IBOutlet UITableView         *myTableView;

@property(nonatomic,strong)IBOutlet UITableViewCell     *dropboxCell;
@property(nonatomic,strong)IBOutlet UITableViewCell     *syncCell;

@property(nonatomic,strong)IBOutlet UISwitch            *syncswitch;
@property(nonatomic,strong)IBOutlet UILabel             *dropboxLabelText;
@property(nonatomic,strong)IBOutlet UILabel             *dropbox1Text;
@property(nonatomic,strong)IBOutlet UILabel             *dropbox2Text;

@property(nonatomic,strong)DropboxObject       *dropbox;
@property(nonatomic,strong)IBOutlet UILabel             *dropboxAccountNameLabel;
//-(IBAction)syncSwithTouchInside:(id)sender;
-(void)flashView2;
-(void)flashView;
@end
