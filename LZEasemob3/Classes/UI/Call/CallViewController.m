/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "CallViewController.h"

#import "ChatDemoHelper.h"
//#import "EMPluginVideoRecorder.h"

@interface CallViewController ()
{
    BOOL _isCaller;
    NSString *_status;
    int _timeLength;
    
    UIImageView *_bgImageView;
    //视频属性显示区域
    UIView *_propertyView;
    UILabel *_sizeLabel;
    UILabel *_timedelayLabel;
    UILabel *_framerateLabel;
    UILabel *_lostcntLabel;
    UILabel *_remoteBitrateLabel;
    UILabel *_localBitrateLabel;
    NSTimer *_propertyTimer;
    //弱网检测
    UILabel *_networkLabel;
}

@property (weak, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation CallViewController

- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString
{
    self = [super init];
    if (self) {
        _callSession = session;
        _isCaller = isCaller;
        _timeLabel.text = @"";
        _timeLength = 0;
        _status = statusString;
        _isDismissing = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    if (_isDismissing) {
        return;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [self _setupSubviews];
    
    _nameLabel.text = _callSession.remoteName;
    _statusLabel.text = _status;
    if (_isCaller) {
        self.rejectButton.hidden = YES;
        self.answerButton.hidden = YES;
        self.cancelButton.hidden = NO;
    }
    else{
        self.cancelButton.hidden = YES;
        self.rejectButton.hidden = NO;
        self.answerButton.hidden = NO;
    }
    
    if (_callSession.type == EMCallTypeVideo) {
        [self _initializeVideoView];
        
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_actionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_isDismissing) {
        return;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_isDismissing) {
        return;
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - getter

- (BOOL)isShowCallInfo
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"showCallInfo"];
    if (object == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"showCallInfo"];
        return YES;
    }
    return [object boolValue];
}

#pragma makr - property

- (UITapGestureRecognizer *)tapRecognizer
{
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    }
    
    return _tapRecognizer;
}

#pragma mark - subviews

- (void)_setupSubviews
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.image = [UIImage imageNamed:@"callBg.png"];
    [self.view addSubview:_bgImageView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, _topView.frame.size.width - 20, 20)];
    _statusLabel.font = [UIFont systemFontOfSize:15.0];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:self.statusLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), _topView.frame.size.width, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_timeLabel];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_topView.frame.size.width - 50) / 2, CGRectGetMaxY(_statusLabel.frame) + 20, 50, 50)];
    _headerImageView.image = [UIImage imageNamed:@"user"];
    [_topView addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerImageView.frame) + 5, _topView.frame.size.width, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = _callSession.remoteName;
    [_topView addSubview:_nameLabel];
    
    _networkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 5, _topView.frame.size.width, 20)];
    _networkLabel.font = [UIFont systemFontOfSize:14.0];
    _networkLabel.backgroundColor = [UIColor clearColor];
    _networkLabel.textColor = [UIColor whiteColor];
    _networkLabel.textAlignment = NSTextAlignmentCenter;
    _networkLabel.hidden = YES;
    [_topView addSubview:_networkLabel];
    
    if (_callSession.type == EMCallTypeVideo) {
        _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_statusLabel.frame) + 20, 60, 30)];
        [_switchCameraButton setBackgroundColor:[UIColor grayColor]];
        [_switchCameraButton setTitle:NSLocalizedString(@"call.switchCamera", @"Switch Camera") forState:UIControlStateNormal];
        [_switchCameraButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
        _switchCameraButton.userInteractionEnabled = YES;
        [_topView addSubview:_switchCameraButton];
    }
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260)];
    _actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_actionView];
    
    CGFloat tmpWidth = _actionView.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, 80, 40, 40)];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_silenceButton.frame) + 5, tmpWidth - 60, 20)];
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = NSLocalizedString(@"call.silence", @"Silence");
        [_actionView addSubview:_silenceLabel];
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, _silenceButton.frame.origin.y, 40, 40)];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_speakerOutButton];
    
    _speakerOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(tmpWidth + 30, CGRectGetMaxY(_speakerOutButton.frame) + 5, tmpWidth - 60, 20)];
    _speakerOutLabel.backgroundColor = [UIColor clearColor];
    _speakerOutLabel.textColor = [UIColor whiteColor];
    _speakerOutLabel.font = [UIFont systemFontOfSize:13.0];
    _speakerOutLabel.textAlignment = NSTextAlignmentCenter;
    _speakerOutLabel.text = NSLocalizedString(@"call.speaker", @"Speaker");
        [_actionView addSubview:_speakerOutLabel];
    
    _rejectButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 100) / 2, CGRectGetMaxY(_speakerOutLabel.frame) + 30, 100, 40)];
    [_rejectButton setTitle:NSLocalizedString(@"call.reject", @"Reject") forState:UIControlStateNormal];
    [_rejectButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_rejectButton];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 100) / 2, _rejectButton.frame.origin.y, 100, 40)];
    [_answerButton setTitle:NSLocalizedString(@"call.answer", @"Answer") forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
//    _answerButton.enabled = NO;
    [_actionView addSubview:_answerButton];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, _rejectButton.frame.origin.y, 200, 40)];
    [_cancelButton setTitle:NSLocalizedString(@"call.hangup", @"Hangup") forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_cancelButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_cancelButton];
    
    if (_callSession.type == EMCallTypeVideo) {
        CGFloat tmpWidth = _actionView.frame.size.width / 3;
//        _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth-40)/2, 20, 40, 40)];
//        _recordButton.layer.cornerRadius = 20.f;
//        [_recordButton setTitle:@"录制" forState:UIControlStateNormal];
//        [_recordButton setTitle:@"停止播放" forState:UIControlStateSelected];
//        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [_recordButton setBackgroundColor:[UIColor grayColor]];
//        [_recordButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
//        [_actionView addSubview:_recordButton];
        
        _videoButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, 20, 40, 40)];
        _videoButton.layer.cornerRadius = 20.f;
        [_videoButton setTitle:@"视频开启" forState:UIControlStateNormal];
        [_videoButton setTitle:@"视频中断" forState:UIControlStateSelected];
        [_videoButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_videoButton setBackgroundColor:[UIColor grayColor]];
        [_videoButton addTarget:self action:@selector(videoPauseAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_videoButton];
        
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth * 2 + (tmpWidth - 40) / 2, 20, 40, 40)];
        _voiceButton.layer.cornerRadius = 20.f;
        [_voiceButton setTitle:@"音视开启" forState:UIControlStateNormal];
        [_voiceButton setTitle:@"音视中断" forState:UIControlStateSelected];
        [_voiceButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_voiceButton setBackgroundColor:[UIColor grayColor]];
        [_voiceButton addTarget:self action:@selector(voicePauseAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_voiceButton];
    }
}

- (void)_setupRemoteView
{
    //1.对方窗口
    if (_callSession.type == EMCallTypeVideo && _callSession.remoteVideoView == nil) {
        NSLog(@"\n########################_setupRemoteView");
        _callSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _callSession.remoteVideoView.hidden = YES;
        _callSession.remoteVideoView.backgroundColor = [UIColor clearColor];
        _callSession.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill;
        [_bgImageView addSubview:_callSession.remoteVideoView];
        [_bgImageView sendSubviewToBack:_callSession.remoteVideoView];
        
        __weak CallViewController *weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.callSession.remoteVideoView.hidden = NO;
        });
    }
}

- (void)_initializeVideoView
{
    //2.自己窗口
    CGFloat width = 80;
    CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
    _callSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, CGRectGetMaxY(_statusLabel.frame), width, height)];
    [self.view addSubview:_callSession.localVideoView];
    
    //3、属性显示层
    _propertyView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(_actionView.frame) - 90, self.view.frame.size.width - 20, 90)];
    _propertyView.backgroundColor = [UIColor clearColor];
    _propertyView.hidden = ![self isShowCallInfo];
    [self.view addSubview:_propertyView];
    
    width = (CGRectGetWidth(_propertyView.frame) - 20) / 2;
    height = CGRectGetHeight(_propertyView.frame) / 3;
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_sizeLabel];
    
    _timedelayLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    _timedelayLabel.backgroundColor = [UIColor clearColor];
    _timedelayLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_timedelayLabel];
    
    _framerateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];
    _framerateLabel.backgroundColor = [UIColor clearColor];
    _framerateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_framerateLabel];
    
    _lostcntLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height, width, height)];
    _lostcntLabel.backgroundColor = [UIColor clearColor];
    _lostcntLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_lostcntLabel];
    
    _localBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 2, width, height)];
    _localBitrateLabel.backgroundColor = [UIColor clearColor];
    _localBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_localBitrateLabel];
    
    _remoteBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height * 2, width, height)];
    _remoteBitrateLabel.backgroundColor = [UIColor clearColor];
    _remoteBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_remoteBitrateLabel];
}

#pragma mark - private

- (void)_reloadPropertyData
{
    if (_callSession) {
        NSString *connectStr = @"None";
        if (_callSession.connectType == EMCallConnectTypeRelay) {
            connectStr = @"Relay";
        } else if (_callSession.connectType == EMCallConnectTypeDirect) {
            connectStr = @"Direct";
        }
        self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
        
        if (_callSession.type == EMCallTypeVideo) {
            _sizeLabel.text = [NSString stringWithFormat:@"%@%.0f/%.0f", NSLocalizedString(@"call.videoSize", @"Width/Height: "), _callSession.remoteVideoResolution.width, _callSession.remoteVideoResolution.height];
            _timedelayLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoTimedelay", @"Timedelay: "), _callSession.videoLatency];
            _framerateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoFramerate", @"Framerate: "), _callSession.remoteVideoFrameRate];
            _lostcntLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoLostcnt", @"Lostcnt: "), _callSession.remoteVideoLostRateInPercent];
            _localBitrateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoLocalBitrate", @"Local Bitrate: "), _callSession.localVideoBitrate];
            _remoteBitrateLabel.text = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"call.videoRemoteBitrate", @"Remote Bitrate: "), _callSession.remoteVideoBitrate];
        }
    }
}

- (void)_beginRing
{
    [_ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    _topView.hidden = !_topView.hidden;
    _actionView.hidden = !_actionView.hidden;
}

#pragma mark - action

- (void)switchCameraAction
{
    [_callSession switchCameraPosition:_switchCameraButton.selected];
    _switchCameraButton.selected = !_switchCameraButton.selected;
}

- (void)recordAction
{
//    _recordButton.selected = !_recordButton.selected;
//    if (_recordButton.selected) {
//        NSString *recordPath = NSHomeDirectory();
//        recordPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer",recordPath];
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if(![fm fileExistsAtPath:recordPath]){
//            [fm createDirectoryAtPath:recordPath
//          withIntermediateDirectories:YES
//                           attributes:nil
//                                error:nil];
//        }
//        
//        [[EMPluginVideoRecorder sharedInstance] startVideoRecordingToFilePath:recordPath error:nil];
//    } else {
//        NSString *tempPath = [[EMPluginVideoRecorder sharedInstance] stopVideoRecording:nil];
//        if (tempPath.length > 0) {
//            NSURL *videoURL = [NSURL fileURLWithPath:tempPath];
//            MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
//            [moviePlayerController.moviePlayer prepareToPlay];
//            moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//            [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
//        }
//    }
}

- (void)videoPauseAction
{
    _videoButton.selected = !_videoButton.selected;
    if (_videoButton.selected) {
        [_callSession pauseVideo];
    } else {
        [_callSession resumeVideo];
    }
}

- (void)voicePauseAction
{
    _voiceButton.selected = !_voiceButton.selected;
    if (_voiceButton.selected) {
        [_callSession pauseVoice];
        [_callSession pauseVideo];
    } else {
        [_callSession resumeVoice];
        [_callSession resumeVideo];
    }
}

- (void)silenceAction
{
    _silenceButton.selected = !_silenceButton.selected;
    if (_silenceButton.selected) {
        [_callSession pauseVoice];
    } else {
        [_callSession resumeVoice];
    }
}

- (void)speakerOutAction
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (_speakerOutButton.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    [audioSession setActive:YES error:nil];
    _speakerOutButton.selected = !_speakerOutButton.selected;
}

- (void)answerAction
{
#if DEMO_CALL == 1
    [self _stopRing];
    
//    self.answerButton.enabled = NO;
    [[ChatDemoHelper shareHelper] answerCall:_callSession.callId];
#endif
}

- (void)hangupAction
{
#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    
    [[ChatDemoHelper shareHelper] hangupCallWithReason:EMCallEndReasonHangup];
#endif
}

- (void)rejectAction
{
#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    
    [[ChatDemoHelper shareHelper] hangupCallWithReason:EMCallEndReasonDecline];
#endif
}

#pragma mark - public

+ (BOOL)canVideo
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if(!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)){\
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"No camera permissions" message:@"Please open in \"Setting\"-\"Privacy\"-\"Camera\"." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
            return NO;
        }
    }
    
    return YES;
}

- (void)startTimeTimer
{
    _timeLength = 0;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)startShowInfo
{
    if ([self isShowCallInfo] || _callSession.type == EMCallTypeVoice) {
        [self _reloadPropertyData];
        _propertyTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(_reloadPropertyData) userInfo:nil repeats:YES];
    }
}

- (void)setNetwork:(EMCallNetworkStatus)status
{
    switch (status) {
        case EMCallNetworkStatusNormal:
        {
            _networkLabel.text = @"";
            _networkLabel.hidden = YES;
        }
            break;
        case EMCallNetworkStatusUnstable:
        {
            _networkLabel.text = @"当前网络不稳定";
            _networkLabel.hidden = NO;
        }
            break;
        case EMCallNetworkStatusNoData:
        {
            _networkLabel.text = @"没有通话数据";
            _networkLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)stateToConnected
{
    self.statusLabel.text = NSLocalizedString(@"call.finished", "Establish call finished");
//    self.answerButton.enabled = YES;
}

- (void)stateToAnswered
{
    NSString *connectStr = @"None";
    if (_callSession.connectType == EMCallConnectTypeRelay) {
        connectStr = @"Relay";
    } else if (_callSession.connectType == EMCallConnectTypeDirect) {
        connectStr = @"Direct";
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
    self.timeLabel.hidden = NO;
    [self startTimeTimer];
    [self startShowInfo];
    self.cancelButton.hidden = NO;
    self.rejectButton.hidden = YES;
    self.answerButton.hidden = YES;
    
    [self _setupRemoteView];
}

- (void)clear
{
    _callSession.remoteVideoView.hidden = YES;
    _callSession = nil;
    _propertyView = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    if (_propertyTimer) {
        [_propertyTimer invalidate];
        _propertyTimer = nil;
    }
}

@end
