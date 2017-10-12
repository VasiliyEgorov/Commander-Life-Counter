//
//  AudioSessionData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AudioSessionData.h"

@import MediaPlayer;



@interface AudioSessionData ()

@property (strong, nonatomic) MPVolumeView *volumeView;
@property (assign, nonatomic) CGFloat currentVolume;
@property (strong, nonatomic) UISlider *slider;
@end

@implementation AudioSessionData


- (instancetype)init
{
    if (self){
        
        if ([self activateAudioSession]){
            
            [self setupVolumeView];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        }
    }
    return self;
}



#pragma mark - MPVolumeView Setup

- (void)setupVolumeView {
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0)];
    volumeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    volumeView.showsRouteButton = NO;
    volumeView.showsVolumeSlider = YES;
    self.volumeView = volumeView;
    
    [[UIApplication sharedApplication].keyWindow insertSubview:volumeView atIndex:0];
    
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupVolumeViewSliderHandler];
    });
}

- (void)removeVolumeView {
    
    [self.volumeView removeFromSuperview];
    self.volumeView = nil;
}

#pragma mark - MPVolumeViews slider

- (void)setupVolumeViewSliderHandler {
    
   
    
    [self.volumeView.subviews enumerateObjectsUsingBlock:^(UISlider *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UISlider class]]){
            self.slider = obj;
            *stop = YES;
        }
    }];
    
   
    
    [self setDefaultVolumeValueForSlider:self.slider];
    [self.slider addTarget:self action:@selector(volumeViewSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}



- (void)volumeViewSliderValueChanged:(UISlider *)slider {
    
    [self setDefaultVolumeValueForSlider:slider];
    
}

- (void)setDefaultVolumeValueForSlider:(UISlider *)slider {
    
    slider.value = self.currentVolume;
}

#pragma mark - Notification

- (void) volumeChanged:(NSNotification*)notification {
    
    [self setDefaultVolumeValueForSlider:self.slider];
    [self.delegate volumeButtonPressed];
}

#pragma mark - AVAudioSession

- (BOOL)activateAudioSession {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
   
    self.currentVolume = session.outputVolume;
   
    NSError *error;
    [session setCategory:AVAudioSessionCategoryAmbient error:&error];
    if (error){
       
        return NO;
    }
    [session setActive:YES error:&error];
    if (error){
       
        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
    return YES;
}

- (void)deactivateAudioSession {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setActive:NO error:&error];
   
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)audioSessionInterruptionNotification:(NSNotification *)notification {
    
    AVAudioSessionInterruptionType interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    if (interruptionType == AVAudioSessionInterruptionTypeEnded){
       
        [self activateAudioSession];
    }
}

- (void)dealloc {
    
    [self removeVolumeView];
    [self deactivateAudioSession];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
