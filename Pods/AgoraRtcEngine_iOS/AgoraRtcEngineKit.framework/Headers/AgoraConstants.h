//
//  AgoraConstants.h
//  AgoraRtcEngineKit
//
//  Copyright (c) 2018 Agora. All rights reserved.
//
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

/** The standard bitrate in [setVideoEncoderConfiguration]([AgoraRtcEngineKit setVideoEncoderConfiguration:]).

(Recommended) The standard bitrate mode. In this mode, the bitrate under the live broadcast and communication profiles differs:

    - In the communication profile, the video bitrate is the same as the base bitrate.
    - In the live broadcast profile, the video bitrate is twice the base bitrate.
 */
extern NSInteger const AgoraVideoBitrateStandard;

/** The compatible bitrate in [setVideoEncoderConfiguration]([AgoraRtcEngineKit setVideoEncoderConfiguration:]).

The compatible bitrate mode. In this mode, the bitrate stays the same regardless of the channel profile. In a live broadcast channel, if you choose this mode, the video frame rate may be lower than the set value.
 */
extern NSInteger const AgoraVideoBitrateCompatible;
/** 120 &times; 120
 */
extern CGSize const AgoraVideoDimension120x120;
/** 160 &times; 120
 */
extern CGSize const AgoraVideoDimension160x120;
/** 180 &times; 180
 */
extern CGSize const AgoraVideoDimension180x180;
/** 240 &times; 180
 */
extern CGSize const AgoraVideoDimension240x180;
/** 320 &times; 180
 */
extern CGSize const AgoraVideoDimension320x180;
/** 240 &times; 240
 */
extern CGSize const AgoraVideoDimension240x240;
/** 320 &times; 240
 */
extern CGSize const AgoraVideoDimension320x240;
/** 424 &times; 240
 */
extern CGSize const AgoraVideoDimension424x240;
/** 360 &times; 360
 */
extern CGSize const AgoraVideoDimension360x360;
/** 480 &times; 360
 */
extern CGSize const AgoraVideoDimension480x360;
/** 640 &times; 360
 */
extern CGSize const AgoraVideoDimension640x360;
/** 480 &times; 480
 */
extern CGSize const AgoraVideoDimension480x480;
/** 640 &times; 480
 */
extern CGSize const AgoraVideoDimension640x480;
/** 840 &times; 480
 */
extern CGSize const AgoraVideoDimension840x480;
/** 960 &times; 720 (Depends on the hardware)
 */
extern CGSize const AgoraVideoDimension960x720;
/** 1280 &times; 720 (Depends on the hardware)
 */
extern CGSize const AgoraVideoDimension1280x720;
#if TARGET_OS_MAC
/** 1920 &times; 1080 (Depends on the hardware, macOS only)
 */
extern CGSize const AgoraVideoDimension1920x1080;
/** 25400 &times; 1440 (Depends on the hardware, macOS only)
 */
extern CGSize const AgoraVideoDimension2540x1440;
/** 3840 &times; 2160 (Depends on the hardware, macOS only)
 */
extern CGSize const AgoraVideoDimension3840x2160;
#endif
