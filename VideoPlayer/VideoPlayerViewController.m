//
//  VideoPlayerViewController.m
//  VideoPlayer
//
//  Created by Hendrik Nunner on 06.03.14.
//  Copyright (c) 2014 Hendrik Nunner. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moviePlayerView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VideoPlayerViewController

#pragma mark - Getters/Setters
- (MPMoviePlayerController *) moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        [self prepareLocalMp4Movie:@"short"];
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
        self.moviePlayerView.frame = CGRectMake(80, 20, 180, 180);
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
    
    // web view
    {
        // layout and size
        self.webView.scalesPageToFit = YES;
        
        
        // load google website
        self.webView.delegate = self;
        NSString *googlePath = @"http://www.google.de";
        NSURL *googleUrl = [NSURL URLWithString:googlePath];
        NSURLRequest *googleURLRequest = [[NSURLRequest alloc] initWithURL:googleUrl];
        [self.webView loadRequest:googleURLRequest];
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
        [self prepareLocalMp4Movie:@"car"];
    }
    else {
        [self prepareLocalMp4Movie:@"short"];
    }
}


#pragma mark - Custom Logic

- (void)prepareRemoteMp4Movie:(NSString *) movieName {
    NSString *movieFilePath = [[NSString alloc] initWithFormat:@"http://localhost/dump/%@.mp4", movieName];
    NSLog(@"Loading file from: %@", movieFilePath);
    
    NSURL *mp4MovieFileURL = [NSURL URLWithString:movieFilePath];
    self.moviePlayerController.contentURL = mp4MovieFileURL;
}

- (void)prepareLocalMp4Movie:(NSString *) movie {
    NSURL *mp4MovieURL = [[NSBundle mainBundle] URLForResource:movie withExtension:@"mp4"];
    self.moviePlayerController.contentURL = mp4MovieURL;
}

- (void) readCookies {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSLog(@"Cookie comment: %@", [cookie comment]);
        NSLog(@"Cookie comment URL: %@", [cookie commentURL]);
        NSLog(@"Cookie domain: %@", [cookie domain]);
        NSLog(@"Cookie expires date: %@", [cookie expiresDate]);
        NSLog(@"Cookie is HTTP only: %c", [cookie isHTTPOnly]);
        NSLog(@"Cookie is secure: %c", [cookie isSecure]);
        NSLog(@"Cookie is session only: %c", [cookie isSessionOnly]);
        NSLog(@"Cookie name: %@", [cookie name]);
        NSLog(@"Cookie path: %@", [cookie path]);
        NSLog(@"Cookie port list: %@", [cookie portList]);
        NSLog(@"Cookie properties: %@", [cookie properties]);
        NSLog(@"Cookie value: %@", [cookie value]);
        NSLog(@"Cookie version: %d", [cookie version]);
    }
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                              [cookieJar cookies]];
    NSUInteger headerCount = [headers count];
    NSLog(@"Cookie name: %@", [headers objectForKey:NSHTTPCookieName]);
    NSLog(@"Cookie headers count: %i", headerCount);
    for (NSString *key in headers) {
        NSLog(@"Cookie Header: %@=%@", key, [headers objectForKey:key]);
    }
}

- (void)addCookiesToRequest:(NSMutableURLRequest *) request {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                              [cookieJar cookies]];
    [request setAllHTTPHeaderFields:headers];
}

# pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Web view finished loading.. Start reading cookie ;-)");
    [self readCookies];
}

@end
