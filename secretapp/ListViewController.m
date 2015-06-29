//
//  ListViewController.m
//  secretapp
//
//  Created by John McClelland on 6/27/15.
//  Copyright (c) 2015 bjc. All rights reserved.
//

#import "ListViewController.h"
#import "Emotion.h"
#import "Event.h"
#import "EventTableViewCell.h"

@interface ListViewController ()
@property PFUser *currentUser;
@property NSArray *events;
@property NSArray *emotions;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addEmotionButton = [self createButtonWithTitle:@"add" chooseColor:[UIColor redColor] andPosition:50];
    [self.addEmotionButton addTarget:self action:@selector(onAddEmotionButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    self.emotions = [[NSArray alloc]init];
    self.events = [NSArray new];

    PFQuery *eventsQuery = [PFQuery queryWithClassName:@"Event"];
    [eventsQuery includeKey:@"createdBy"];
    [eventsQuery includeKey:@"emotionObject"];
    [eventsQuery orderByDescending:@"createdAt"];
    [eventsQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (!error) {
            NSLog(@"total events: %lu", events.count);
            NSLog(@"%@", events.firstObject);
            self.events = events;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    self.userLocation = [LocationService sharedInstance].currentLocation;
}

#pragma mark - Tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

-(EventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    Event *event = [self.events objectAtIndex:indexPath.row];
    Emotion *emotion = event.emotionObject;
    cell.emotionName.text = emotion.name;
    NSString *imageString = emotion.imageString;
    cell.emotionImageView.image = [UIImage imageNamed:imageString];
    [cell expandImageView:cell.emotionImageView andActivatedValue:emotion];
    cell.timeAgo.text = [self relativeDate:event.createdAt];
    PFUser *user = event.createdBy;
    cell.user_name_here_filler.text = [NSString stringWithFormat:@"%@", user.email];
    return cell;
}

#pragma mark - Floating button

- (UIButton *)createButtonWithTitle:(NSString *)title chooseColor:(UIColor *)color andPosition:(int)position {
    int diameter = 65;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    button.center = CGPointMake(self.view.frame.size.width - position, self.view.frame.size.height - 100);
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = color;
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self.view addSubview:button];
    return button;
}

#pragma mark - Segue

- (void)onAddEmotionButtonPressed {
    NSLog(@"pressed");
    [self performSegueWithIdentifier:@"ListToAdd" sender:self];

}

#pragma mark - Utility Methods
- (NSString *)relativeDate:(NSDate *)dateCreated {
    NSCalendarUnit units = NSCalendarUnitSecond |
    NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;

    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:dateCreated
                                                                     toDate:[NSDate date]
                                                                    options:0];
    //    NSLog(@"%ld year, %ld month, %ld day, %ld hour, %ld minute, %ld second", components.year, components.month, components.day, components.hour, components.minute, (long)components.second);
    if (components.year > 0) {
        if (components.year == 1) {
            return [NSString stringWithFormat:@"%ld year ago", (long)components.year];
        } else {
            return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        }
    } else if (components.month > 0) {
        if (components.month == 1) {
            return [NSString stringWithFormat:@"%ld month ago", (long)components.month];
        } else {
            return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
        }
    } else if (components.weekOfYear > 0) {
        if (components.weekOfYear == 1) {
            return [NSString stringWithFormat:@"%ld week ago", (long)components.weekOfYear];
        } else {
            return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
        }
    } else if (components.day > 0) {
        if (components.day == 1) {
            return [NSString stringWithFormat:@"%ld day ago", (long)components.day];
        } else {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        }
    } else if (components.hour > 0) {
        if (components.hour == 1) {
            return [NSString stringWithFormat:@"%ld hour ago", (long)components.hour];
        } else {
            return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
        }
    } else if (components.minute > 0) {
        if (components.year == 1) {
            return [NSString stringWithFormat:@"%ld minute ago", (long)components.minute];
        } else {
            return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
        }
    } else if (components.second > 0) {
        if (components.second == 1) {
            return [NSString stringWithFormat:@"%ld second ago", (long)components.second];
        } else {
            return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
        }
    } else {
        return [NSString stringWithFormat:@"Time Traveller"];
    }
}

@end