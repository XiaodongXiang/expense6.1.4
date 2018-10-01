//
//  XDFirstPromptViewController.m
//  PocketExpense
//
//  Created by 下大雨 on 2018/7/9.
//

#import "XDFirstPromptViewController.h"
#import "ParseDBManager.h"

@interface XDFirstPromptViewController ()
{
    CGPoint _startPoint;
    float _progressFloat;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *syncImg;
@property (weak, nonatomic) IBOutlet UIImageView *syncingImg;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *failLbl;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;


@end

@implementation XDFirstPromptViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startAnimation];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 7.f);
    self.progressView.transform = transform;
    
    self.progressView.layer.cornerRadius = 3.5;
    self.progressView.layer.masksToBounds = YES;
    
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    [self.againBtn addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
    _progressFloat = 0.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compltionSync) name:@"logInPromptCompleted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failSync) name:@"logInPromptFailed" object:nil];

    [self startLoad];
}



-(void)pan:(UIPanGestureRecognizer*)swipe{
   
        
        if (swipe.state == UIGestureRecognizerStateChanged) {
            [self commitTranslation:[swipe translationInView:self.view]];
        }
}

-(void)startLoad{
    if (self.progressView.progress < 0.5) {
        [self loadProgress:NO];
    }else if(self.progressView.progress < 0.9){
        [self loadSlowProgress:NO];
    }else{
        [self loadSlowProgress:YES];
    }
}




-(void)loadProgress:(BOOL)stop{
    _progressFloat += 1/100.f;
    [self.progressView setProgress:_progressFloat animated:YES];
    
    if (!stop) {
        [self performSelector:@selector(startLoad) withObject:self afterDelay:1];
    }
}

-(void)loadSlowProgress:(BOOL)stop{
     _progressFloat += 1/200.f;
    [self.progressView setProgress:_progressFloat animated:YES];
    if (!stop) {
        [self performSelector:@selector(startLoad) withObject:self afterDelay:1];
    }
}


- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    
    
    if (absX > absY ) {
        
        if (translation.x<0) {
            
            //向左滑动
        }else{
            
            //向右滑动
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            
            //向上滑动
            
            [UIView animateWithDuration:0.2 animations:^{
                self.view.y = -60;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            
            //向下滑动
            
        }
    }
}

-(void)startAnimation
{
    
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    rotationAnimation.duration = 1.5;
    
    rotationAnimation.repeatCount = 100000;
    
    rotationAnimation.cumulative = NO;
    
    rotationAnimation.removedOnCompletion = NO;
    
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [self.syncingImg.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
}
-(void)tryAgain {

    dispatch_async(dispatch_get_main_queue(), ^{
        _progressFloat = 0;

        [self.progressView setProgress:_progressFloat animated:NO];

        self.syncImg.image = [UIImage imageNamed:@"syncing"];
        self.syncingImg.hidden = NO;
        self.lbl.hidden = NO;
        self.progressView.hidden = NO;
        self.failLbl.hidden = YES;
        self.againBtn.hidden = YES;
        
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
    });
    
    [[ParseDBManager sharedManager] dataSyncWithLogInServer];

}

-(void)compltionSync{
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressFloat = 1;

        [self.progressView setProgress:_progressFloat animated:YES];

        self.syncImg.image = [UIImage imageNamed:@"success"];
        self.syncingImg.hidden = YES;
        self.lbl.text = @"Syncing Success";
        
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
            self.view.y = -60;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    });
    
    
}

-(void)failSync{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.syncImg.image = [UIImage imageNamed:@"try again"];
        self.lbl.hidden = YES;
        self.syncingImg.hidden = YES;
        self.progressView.hidden = YES;
        self.failLbl.hidden = NO;
        self.againBtn.hidden = NO;
        self.againBtn.userInteractionEnabled = YES;
    });


}


@end
