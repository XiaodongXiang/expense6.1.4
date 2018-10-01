//
//  ipad_ReleatedCell.h
//  PocketExpense
//
//  Created by humingjing on 14-5-26.
//
//

#import <UIKit/UIKit.h>
@class ipad_SearchRelatedViewController;


@interface ipad_ReleatedCell : UITableViewCell
{
    UIImageView								*bgImageView;
    
    UIImageView                             *cateIcon;
	UILabel									*nameLabel;
    UILabel                                 *dateTimeLabel;
 	UILabel									*blanceLabel;
    
    UIImageView                             *memoIcon;
    UIImageView                             *phonteIcon;

}
@property (nonatomic, strong)UIImageView	*bgImageView;
@property (nonatomic, strong)UIImageView    *cateIcon;
@property (nonatomic, strong)UILabel		*nameLabel;
@property (nonatomic, strong)UILabel		*blanceLabel;
@property (nonatomic, strong)UILabel        *dateTimeLabel;

@property (nonatomic, strong)UIImageView                             *memoIcon;
@property (nonatomic, strong)UIImageView                             *phonteIcon;




@end
