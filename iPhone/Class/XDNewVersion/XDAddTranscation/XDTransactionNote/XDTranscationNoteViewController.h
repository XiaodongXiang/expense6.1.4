//
//  XDTranscationNoteViewController.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/29.
//

#import <UIKit/UIKit.h>
@protocol XDTranscationNoteViewDelegate <NSObject>
-(void)returnNote:(NSString*)note;
@end

@interface XDTranscationNoteViewController : UIViewController

@property(nonatomic, copy)NSString * noteStr;

@property(nonatomic, weak)id<XDTranscationNoteViewDelegate> delegate;

@end
