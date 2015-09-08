//
//  ChatRoomViewController.m
//  RealTimePush
//
//  Created by Ashish Agarwal on 2015-09-06.
//  Copyright (c) 2015 AshishAgarwal. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "PubNub.h"
#import "AppDelegate.h"

@interface ChatRoomViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PNObjectEventListener>

@property (nonatomic, strong) PubNub *pubnubClient;
@property (nonatomic, strong) NSMutableArray *messagesArray;
@property (nonatomic, strong) NSMutableArray *sentMessagesArray;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) IBOutlet UIView *sendMessageView;
@property (nonatomic, strong) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, strong) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UITableView *messagesTable;
@property (nonatomic) CGSize tableViewSize;
@property (nonatomic) CGSize keyboardSize;

-(IBAction)sendMessage:(id)sender;

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-7212babd-3bdb-459f-b66b-d1a90c4426d8" subscribeKey:@"sub-c-3ba4ff38-5475-11e5-80a1-0619f8945a4f"];
    self.pubnubClient = [PubNub clientWithConfiguration:configuration];
    [self.pubnubClient addListener:self];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.messagesArray = [NSMutableArray array];
    self.sentMessagesArray = [NSMutableArray array];
    
    
    
    self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10 - 50, 30)];
    [self.messageTextField setBorderStyle:UITextBorderStyleRoundedRect];
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendMessageButton setFrame:CGRectMake(self.view.frame.size.width - 50, 5, 40, 30)];
    
    [self.sendMessageView setBackgroundColor:[UIColor greenColor]];
    [self.sendMessageView addSubview:self.sendMessageButton];
    [self.sendMessageView addSubview:self.messageTextField];


}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // This will add channel to the channel group (if not already added)
    [self.pubnubClient addChannels:@[@"ChatRoomChannel"] toGroup:@"ChatChannels" withCompletion:^(PNAcknowledgmentStatus *status) {
        
    }];
    
    [self.pubnubClient subscribeToChannelGroups:@[@"ChatRoomChannel", @"ChatChannels"] withPresence:NO];
    //[self.messagesArray addObject:@"Joined"];
    [self.messagesTable reloadData];
    

}

-(void) client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    NSLog(@"Message received is %@", message.data.message);
    NSDictionary *dict = (NSDictionary *) message.data.message;
    
    NSString *uuid = [dict objectForKey:@"uuid"];
    NSString *messageContent = [dict objectForKey:@"message"];
    
    if (![uuid isEqualToString:self.appDelegate.deviceUUID]) {
        [self.messagesArray addObject:messageContent];
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"Me: %@", messageContent];
        [self.messagesArray addObject:msg];
    }
    [self.messagesTable reloadData];
}

-(void) client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    
}

-(void) client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
}

-(IBAction)sendMessage:(id)sender {
    __block NSString *message = [self.messageTextField text];
    NSDictionary *dict = @{@"message" : message, @"uuid" : self.appDelegate.deviceUUID};
    
    [self.pubnubClient publish:dict toChannel:@"ChatRoomChannel" withCompletion:^(PNPublishStatus *status) {
        if (status.error) {
            NSLog(@"Could not send message");
            return;
        }
        [self.sentMessagesArray addObject:message];
        
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messagesArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    
    cell.textLabel.text = [self.messagesArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
