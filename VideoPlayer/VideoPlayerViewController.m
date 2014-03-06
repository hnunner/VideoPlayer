//
//  VideoPlayerViewController.m
//  VideoPlayer
//
//  Created by Hendrik Nunner on 06.03.14.
//  Copyright (c) 2014 Hendrik Nunner. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *moviePlayerView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation VideoPlayerViewController

#pragma mark - Getters/Setters
- (MPMoviePlayerController *) moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        [self prepareMp4Movie:@"short"];
    }
    return _moviePlayerController;
}


#pragma mark - System Callbacks
- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // layout
    {
        self.view.backgroundColor = [UIColor darkGrayColor];
        self.moviePlayerView.frame = CGRectMake(40, 40, 240, 240);
    }
    
    // movie player
    {
        // layout and size
        self.moviePlayerController.view.frame = self.moviePlayerView.bounds;
        self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        // add movie player to view
        [self.moviePlayerView addSubview:self.moviePlayerController.view];
        // do not autostart
        [self.moviePlayerController prepareToPlay];
        self.moviePlayerController.shouldAutoplay = NO;
        
        // trying to repeat
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User Interactions

- (IBAction)playVideo:(UIButton *)sender {
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying) {
        [self.moviePlayerController pause];
        NSLog(@"Pausing: %@", self.moviePlayerController.contentURL);
    }
    else {
        [self.moviePlayerController play];
        NSLog(@"Playing: %@", self.moviePlayerController.contentURL);
    }
}

- (IBAction)nextVideo:(id)sender {
    
    NSString *videoPath = self.moviePlayerController.contentURL.description;
    NSRange rangeOfTitle = [videoPath rangeOfString:@"short"];
    if (rangeOfTitle.length) {
        [self prepareMp4Movie:@"car"];
    }
    else {
        [self prepareMp4Movie:@"short"];
    }
}


#pragma mark - Custom Logic

- (void)prepareMp4Movie:(NSString *) movie {
    NSURL *mp4MovieURL = [[NSBundle mainBundle] URLForResource:movie withExtension:@"mp4"];
    self.moviePlayerController.contentURL = mp4MovieURL;
}

@end
