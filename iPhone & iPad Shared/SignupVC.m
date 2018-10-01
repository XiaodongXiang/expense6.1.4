//
//  SignupVC.m
//  PocketExpense
//
//  Created by APPXY_DEV005 on 15/5/21.
//
//

#import "SignupVC.h"
#import "AppDelegate_iPhone.h"
@interface SignupVC ()
{
    UIScrollView *_sv;
}
@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollViewSet];
    self.signUpView.logo=nil;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.signUpView.usernameField setFrame:CGRectMake1(30, 300, 250, 40)];
    [self.signUpView.passwordField setFrame:CGRectMake1(30, 340, 250, 40)];
    [self.signUpView.signUpButton setFrame:CGRectMake(85, 595, 205, 50)];
}
-(void)scrollViewSet
{
    _sv=[[UIScrollView alloc]initWithFrame:CGRectMake1(12, 30, 350, 350)];
    _sv.contentSize=CGSizeMake(350*3, 350);
    _sv.pagingEnabled=YES;
    for (int i=0; i<3; i++)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(350*i, 0, 350, 350)];
        [imageView setImage:[UIImage imageNamed:@"welcome.png"]];
        [_sv addSubview:imageView];
    }
    [self.view addSubview:_sv];
}
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * appDelegate_iphone.autoSizeScaleX;
    rect.origin.y = y * appDelegate_iphone.autoSizeScaleY;
    rect.size.width = width * appDelegate_iphone.autoSizeScaleX;
    rect.size.height = height * appDelegate_iphone.autoSizeScaleY;
    return rect;
}
CG_INLINE CGSize
CGSizeMake1(CGFloat width, CGFloat height)
{
    AppDelegate_iPhone *appDelegate_iphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    CGSize size;
    size.width = width* appDelegate_iphone.autoSizeScaleX;
    size.height = height* appDelegate_iphone.autoSizeScaleY;
    return size;
}
#pragma mark - UITextField Delegate 方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    [textField resignFirstResponder];
}
-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    float movementDuration=0.3;
    int movement=(up?(-216):216);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    
    self.view.frame=CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
