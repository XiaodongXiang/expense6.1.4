//
//  XDLaunchFileViewController.m
//  PocketExpense
//
//  Created by 晓东项 on 2018/10/8.
//

#import "XDLaunchFileViewController.h"
#import <AVKit/AVKit.h>

@interface XDLaunchFileViewController ()
@property(nonatomic, strong)AVPlayerViewController* moviePlayer;

@end

@implementation XDLaunchFileViewController

-(AVPlayerViewController*)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[AVPlayerViewController alloc]init];
        NSString *path  = [[NSBundle mainBundle]  pathForResource:@"launchFilm" ofType:@"mov"];

        NSURL *url = [NSURL fileURLWithPath:path];

        _moviePlayer.player = [AVPlayer playerWithURL:url];
        _moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }
    return _moviePlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer.player play];
    
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
