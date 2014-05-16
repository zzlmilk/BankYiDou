//
//  AudioManager.m
//  ims
//
//  Created by Tony Ju on 10/22/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import "AudioManager.h"
#import "PathUtils.h"
#import "LCVoiceHud.h"
#import "HOSMusicPlayer.h"
#import "CommonUtils.h"

#define WAVE_UPDATE_FREQUENCY   0.05

static AudioManager* s_audioManager = nil;

@interface AudioManager()
{
     int encoding;
     NSTimer * _timer;
 
}

@property (nonatomic,strong)LCVoiceHud * voiceHud;


@end

@implementation AudioManager


+( AudioManager *) getInstance :(NSString*) fileName audioManagerDelegate:(id<AudioManagerDelegate>) delegte{

    [PathUtils createDocuemntCacheFolder];

    @synchronized(self) {
        if (s_audioManager == nil) {
            s_audioManager = [[AudioManager alloc] initWithFileName:fileName Delegate:delegte];
        } else {
            s_audioManager.delegate = delegte;
        }
        s_audioManager.audioFileName = fileName;

        return s_audioManager;
    }
    
    return nil;
}

-(void)dealloc
{
    [self resetTimer];
    
}

-(id) initWithFileName:(NSString*)fileName  Delegate:(id <AudioManagerDelegate>) delegate {
    NIF_ALLINFO(@"initialize audio manager.");
    self = [super init];
    if (self) {
        _delegate = delegate;
        _audioFileName = fileName;
        encoding = ENC_AAC;
//        [HeadphonesDetector sharedDetector].delegate = self;
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        //[self updateRoute];

    }
    return self;
}


+(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CommonUtils AlertWithTitle:@"提示"
                                      OkButtonTitle:nil
                                  CancelButtonTitle:@"关闭"
                                                Msg:@"App需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                           Delegate:self
                                                Tag:0];
                      
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}


#pragma mark ---- audio record and play ----
-(BOOL) startRecord {
    NIF_ALLINFO(@"startRecord...");
    
    /*
     *1. 判断是否可以录音，这里暂时只判断是否可以访问麦克风
     */
    
    if (![self.class canRecord]) {
        return  NO;
    }
    
    if(_recorder){
        [_recorder stop];
        _recorder = nil;   
    }
    
    
    NSString* path = [PathUtils getAudioDirectory];
    NSURL *url = [PathUtils getURLByFileName:path :_audioFileName];
    NIF_ALLINFO(@"record file URL :%@",url);
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:[url path]]) {
//        NIF_ALLINFO(@"存在录音文件先删除");
//        [fm removeItemAtURL:url error:nil];
//    }
    
     BOOL result = YES;
     NSError *recordError ;
/*
 * 2. 设置AvAudio为录音
 */
    //初始化播放器的时候如下设置
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&recordError];
    
    

    
    if(recordError){
        NIF_ALLINFO(@"audioSession: %@ %d %@", [recordError domain], [recordError code], [[recordError userInfo] description]);
        return  [self recorderError];
	}
    
   
    recordError = nil;
    [audioSession setActive:YES error:&recordError];
    if(recordError){
        NIF_ALLINFO(@"audioSession: %@ %d %@", [recordError domain], [recordError code], [[recordError userInfo] description]);
        return  [self recorderError];
	}
    
    NSMutableDictionary *recordSettings = [self getAudioRecordSettings];
    
    recordError = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&recordError];
    
   	if(recordError || !_recorder){
        NIF_ALLINFO(@"audioSession: %@ %d %@", [recordError domain], [recordError code], [[recordError userInfo] description]);
        return  [self recorderError];
    }

    
    self.recorder.delegate  = self;
    
    
    if ([self.recorder prepareToRecord] == YES){
        [self.recorder record];
        [self.recorder updateMeters];
        self.recorder.meteringEnabled = YES;
     }else {
         return NO;
    }
    
    BOOL audioHWAvailable = audioSession.isInputAvailable;
	if (!audioHWAvailable) {
        NIF_ALLINFO(@"麦克风未准备好");
        return  [self recorderError];
    }
    
    //设置最长录音时间
//    [_recorder recordForDuration:(NSTimeInterval) 60];

    self.recordTime = 0;
    [self resetTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    //显示录音状态
    [self showVoiceHud:YES];
    
    NIF_ALLINFO(@"...startRecord");
    if (_delegate && [_delegate respondsToSelector:@selector(startRecording)]) {
        [_delegate startRecording];
    }
    return result;
    
}

-(void) stopRecord {
    if (_recorder) {
        [self.recorder stop];
        [self resetTimer];
       _recorder = nil;
    }
}

-(BOOL) playOnlineAudio:(NSString *)url AudioCacheName:(NSString*)audioCacheName
{

    BOOL success = NO;
    
    HOSMusicPlayer *hOSMusicPlayer = [HOSMusicPlayer shareInstance];
    
     __weak AudioManager* weakSelf = (AudioManager*)self;
    
    [hOSMusicPlayer registerCache:YES
              MusicFileNameForKey:audioCacheName
                   CacheDirectory:nil];
    
    [hOSMusicPlayer registerAutoPlayWithMusicURLSource:^NSString *{
        return url;
    }
                                      DownLoadPregress:^(NSInteger pregress) {
                                          
                                      }
                                         WillStartPlay:^(NSString *musicCacheFileURL) {
                                             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(startPlaying)]) {
                                                 [weakSelf.delegate startPlaying];
                                             }
                                         }
                                           PlaySuccess:^(NSString *musicCacheFileURL, BOOL isNeedChangeType) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onPlayFinished)]) {
                                                   [weakSelf.delegate onPlayFinished];
                                               }
                                           }
                                              PlayFail:^(NSString *musicCacheFileURL, NSError *error) {
                                                  NIF_ALLINFO(@"播放失败,%@",error);
                                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onPlayErrorWithErrorInfo:)]) {
                                                      [weakSelf.delegate onPlayErrorWithErrorInfo:nil];
                                                  }
                                              }  ];
    
 
    return  success;

}



-(void) stopPlayOnline
{
 
    HOSMusicPlayer *hOSMusicPlayer = [HOSMusicPlayer shareInstance];
    [hOSMusicPlayer stop];

}



-(NSMutableDictionary *) getAudioRecordSettings{
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(encoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (encoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）

        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
       [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
       
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
//        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];

        //线性采样位数  8、16、24、32
//        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        
 
    }
    
    
    return recordSettings;
}


#pragma mark - define
-(void) resetTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void) showVoiceHud:(BOOL)yesOrNo{
    
    if (yesOrNo) {
        [self.voiceHud show];
    }else{
        [self.voiceHud hide];
    }
    
  
}
- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (!self.voiceHud.hidden)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (_recorder) {
            [_recorder updateMeters];
        }
        
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        [self.voiceHud setProgress:peakPowerForChannel];
    }
}

-(BOOL)recorderError
{
    [self resetTimer];
    [self showVoiceHud:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(onRecorderErrorWithErrorInfo:)]) {
        [_delegate  onRecorderErrorWithErrorInfo:nil];
    }
    return NO;
}

#pragma mark --- AVRecorder Delegate ---
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NIF_ALLINFO(@"audioRecorderDidFinishRecording...");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    
    [self showVoiceHud:NO];

    
    if (_delegate && [_delegate respondsToSelector:@selector(onRecorderFinished)]) {
        [_delegate onRecorderFinished];
    }
    
 }

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NIF_ALLINFO(@"...audioRecorderEncodeErrorDidOccur");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [self recorderError];
}




#pragma mark -- getter

-(LCVoiceHud*)voiceHud
{
    if (_voiceHud == nil) {
        _voiceHud = [[LCVoiceHud alloc] init];
    }
    return  _voiceHud;

}




@end
