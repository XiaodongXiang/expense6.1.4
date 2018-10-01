//
//  XDTranscationNoteViewController.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/29.
//

#import "XDTranscationNoteViewController.h"

@interface XDTranscationNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation XDTranscationNoteViewController

-(void)setNoteStr:(NSString *)noteStr{
    _noteStr = noteStr;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.noteTextView becomeFirstResponder];
    self.noteTextView.text = _noteStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        self.noteLabel.frame = CGRectMake(5, 90, 200, 30);
        self.bottom.constant = -355;
    }else{
        self.noteLabel.frame = CGRectMake(5, 66, 200, 30);
        self.bottom.constant = -280;

    }
    self.noteLabel.text = NSLocalizedString(@"VC_Memo", nil);
    
    self.navigationItem.title = NSLocalizedString(@"VC_Memo", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(doneClick) title:@"Done" font:[UIFont fontWithName:FontSFUITextRegular size:17] titleColor:RGBColor(113, 163, 245) highlightedColor:RGBColor(113, 163, 245) titleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) title:@"Cancel" font:[UIFont fontWithName:FontSFUITextRegular size:17] titleColor:RGBColor(113, 163, 245) highlightedColor:RGBColor(113, 163, 245) titleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    if (self.noteStr.length>0) {
        self.noteLabel.hidden = YES;
    }else{
        self.noteLabel.hidden = NO;

    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneClick{
    
    if ([self.delegate respondsToSelector:@selector(returnNote:)]) {
        [self.delegate returnNote:self.noteTextView.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.noteLabel.hidden = YES;
    }else{
        self.noteLabel.hidden = NO;
    }
}
@end
