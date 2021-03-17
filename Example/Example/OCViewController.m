//
//  OCViewController.m
//  Example
//
//  Created by Yanni Wang on 17/3/21.
//

#import "OCViewController.h"
@import NestedScrollView;

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // just make sure NestedScrollView works well in OC.
    [[[UIScrollView alloc] init] setupInternalScrollView:[[UIScrollView alloc] init]];
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
