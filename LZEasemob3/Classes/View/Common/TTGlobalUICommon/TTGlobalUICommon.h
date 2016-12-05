//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @return the current runtime version of the iPhone OS.
 */
float TTOSVersion();

/**
 * Checks if the run-time version of the OS is at least a certain version.
 */
BOOL TTRuntimeOSVersionIsAtLeast(float version);

/**
 * Checks if the link-time version of the OS is at least a certain version.
 */
BOOL TTOSVersionIsAtLeast(float version);

/**
 * @return TRUE if the keyboard is visible.
 */
BOOL TTIsKeyboardVisible();

/**
 * @return TRUE if the device has phone capabilities.
 */
BOOL TTIsPhoneSupported();

/**
 * @return TRUE if the device supports backgrounding
 */
BOOL TTIsMultiTaskingSupported();

/**
 * @return TRUE if the device is iPad.
 */
BOOL TTIsPad();

/**
 * @return the current device orientation.
 */
UIDeviceOrientation TTDeviceOrientation();

/**
 * @return TRUE if the current device orientation is portrait or portrait upside down.
 */
BOOL TTDeviceOrientationIsPortrait();

/**
 * @return TRUE if the current device orientation is landscape left, or landscape right.
 */
BOOL TTDeviceOrientationIsLandscape();

/**
 * @return device full model name in human readable strings
 */
NSString* TTDeviceModelName();


/**
 * @return the application frame with no offset.
 *
 * From the Apple docs:
 * Frame of application screen area in points (i.e. entire screen minus status bar if visible)
 */
CGRect TTApplicationFrame();

/**
 * A convenient way to show a UIAlertView with a message.
 */
void TTAlert(NSString* message);

/**
 * Same as TTAlert but the alert view has no title.
 */
void TTAlertNoTitle(NSString* message);
