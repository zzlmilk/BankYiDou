//
//  VoiceManager.h
//  ims
//
//  Created by Tony Ju on 10/22/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioManagerDelegate.h"

typedef enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;

@interface AudioManager : NSObject <
                                AVAudioRecorderDelegate,
                                AVAudioPlayerDelegate>

@property(nonatomic,assign)id<AudioManagerDelegate>delegate;

+( AudioManager *)getInstance:(NSString*)fileName audioManagerDelegate:(id<AudioManagerDelegate>)delegate;

@property (nonatomic, strong) NSString* audioFileName;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) float recordTime;
@property (nonatomic, assign) BOOL isInitHysteriaPlayerBlockFunction;


-(BOOL) startRecord;
-(void) stopRecord;

-(BOOL) playOnlineAudio:(NSString *)url AudioCacheName:(NSString*)audioCacheName;
-(void) stopPlayOnline;

+(BOOL)canRecord;

@end
