/*
 *  ExtendableAVFoundationVideoGrabber.h
 */

#pragma once

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#include "ofBaseTypes.h"
#include "ofTexture.h"

#include "ofxiOSExtendableVideoGrabberDelegate.h"

class ExtendableAVFoundationVideoGrabber;

@interface iOSExtendableVideoGrabber : UIViewController <
    AVCaptureVideoDataOutputSampleBufferDelegate
> {
@public
    CGImageRef currentFrame;
    
    int width;
    int height;
    
    BOOL bInitCalled;
    int deviceID;
    
    ExtendableAVFoundationVideoGrabber *grabberPtr;
    std::vector<ofxiOSExtendableVideoGrabberDelegate *> delegates;
}

- (BOOL)initCapture:(int)framerate capWidth:(int)w capHeight:(int)h;
- (void)startCapture;
- (void)stopCapture;
- (void)lockExposureAndFocus;
- (std::vector<std::string>)listDevices;
- (void)setDevice:(int)_device;
- (void)eraseGrabberPtr;

- (void)addDelegate:(ofxiOSExtendableVideoGrabberDelegate *)delegate;
- (void)removeDelegate:(ofxiOSExtendableVideoGrabberDelegate *)delegate;

- (CGImageRef)getCurrentFrame;

@end

class ExtendableAVFoundationVideoGrabber{
public:
    ExtendableAVFoundationVideoGrabber();
    ~ExtendableAVFoundationVideoGrabber();

    void clear();
    void setCaptureRate(int capRate);

    bool initGrabber(int w, int h);
    bool isInitialized();
    void updatePixelsCB(CGImageRef &ref);

    void update();

    bool isFrameNew();

    vector <ofVideoDevice> listDevices();
    void setDevice(int deviceID);
    bool setPixelFormat(ofPixelFormat PixelFormat);
    ofPixelFormat getPixelFormat();

    unsigned char *getPixels() { return pixels; };
    const unsigned char *getPixels() const { return pixels; };
    float getWidth() const { return width; };
    float getHeight() const { return height; };

    GLint internalGlDataType;
    unsigned char * pixels;
    bool newFrame;
    bool bLock;

    int width, height;
    
    CGImageRef getCurrentFrame() const;
    iOSExtendableVideoGrabber *grabber;
    
    void addDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);
    void removeDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);

protected:
    int device;
    bool bIsInit;
    bool bHavePixelsChanged;
    
    int fps;
    ofTexture tex;
    GLubyte *pixelsTmp;
};
