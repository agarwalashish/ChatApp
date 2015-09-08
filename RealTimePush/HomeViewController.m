//
//  HomeViewController.m
//  RealTimePush
//
//  Created by Ashish Agarwal on 2015-09-06.
//  Copyright (c) 2015 AshishAgarwal. All rights reserved.
//

#import "HomeViewController.h"
#import "ChatRoomViewController.h"

//ChatSegue

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

-(IBAction)joinButtonPressed:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)joinButtonPressed:(id)sender {
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ChatSegue"]) {
        ChatRoomViewController *chatController = [segue destinationViewController];
        [chatController setName:self.nameTextField.text];
    }
}

@end
