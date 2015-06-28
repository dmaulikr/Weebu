//
//  ViewController.m
//  secretapp
//
//  Created by John McClelland on 6/27/15.
//  Copyright (c) 2015 bjc. All rights reserved.
//

#import "GeneralViewController.h"

@implementation GeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Find location;
    self.userLocation = [LocationService sharedInstance].currentLocation;


    //Add bubbles
    self.bubbles = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        int a = arc4random_uniform(200);
        int b = arc4random_uniform(500);
        EmotionBubble *bubble = [[EmotionBubble alloc] initWithFrame:CGRectMake(a, b, 50, 50)];
//        bubble.backgroundColor = [UIColor grayColor];
        [bubble setupBubble];
        [bubble bubbleSetup:@"emotion" andInt:i];
        [self.bubbles addObject:bubble];
        [self.view addSubview:bubble];
        NSLog(@"%i", i);
    }
    
    //Add buttons
    self.addEmotionButton = [self createButtonWithTitle:@"add" chooseColor:[UIColor redColor] andPosition:50];
    [self.addEmotionButton addTarget:self action:@selector(onAddEmotionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"currentLocation"]) {
        NSLog(@"something");
    }
}

#pragma mark - Creating bubbles

- (void)initializeBubbles {

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
    [self performSegueWithIdentifier:@"GeneralToAdd" sender:self];
    
}

@end
