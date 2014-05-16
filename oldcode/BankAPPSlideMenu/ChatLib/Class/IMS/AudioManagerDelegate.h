//
//  AudioManagerDelegate.h
//  ims
//
//  Created by Tony Ju on 10/22/13.
//  Copyright (c) 2013 Tony Ju. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioManagerDelegate <NSObject>

@optional
-(void) startRecording;
-(void) onRecorderFinished;
-(void) onRecorderErrorWithErrorInfo:(NSDictionary*)errorInfo;


-(void) startPlaying;
-(void) onPlayFinished;
-(void) onPlayErrorWithErrorInfo:(NSDictionary*)errorInfo;


@end

