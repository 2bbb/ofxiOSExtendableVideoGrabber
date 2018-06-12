#pragma once

#include "ofBaseTypes.h"
#include "ofxiOSExtendableVideoGrabberDelegate.h"

class ExtendableAVFoundationVideoGrabber;

class ofxiOSExtendableVideoGrabberImpl : public ofBaseVideoGrabber {
	
public:
	
	ofxiOSExtendableVideoGrabberImpl();
	~ofxiOSExtendableVideoGrabberImpl();
	
    //---------------------------------------
    // inherited from ofBaseVideoGrabber
    //---------------------------------------
    
    std::vector<ofVideoDevice> listDevices() const;
    bool setup(int w, int h);

	float getHeight() const;
	float getWidth() const;
    
    ofTexture * getTexturePtr();
    
    void setVerbose(bool bTalkToMe);
    void setDeviceID(int deviceID);
    void setDesiredFrameRate(int framerate);
    void videoSettings();
    
    //---------------------------------------
    // inherited from ofBaseVideo
    //---------------------------------------
    
    bool isFrameNew() const;
    void close();
    bool isInitialized() const;
    
    bool setPixelFormat(ofPixelFormat pixelFormat);
    ofPixelFormat getPixelFormat() const;
    
    //---------------------------------------
    // inherited from ofBaseHasPixels
    //---------------------------------------
    
	ofPixels & getPixels();
	const ofPixels & getPixels() const;
    
    //---------------------------------------
    // inherited from ofBaseUpdates
    //---------------------------------------
    
	void update();
    
    //---------------------------------------
    // deprecated.
    //---------------------------------------
    
    void addDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);
    void removeDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);
    CGImageRef getCurrentFrame() const;
    
protected:
    std::shared_ptr<ExtendableAVFoundationVideoGrabber> grabber;
    ofPixels pixels;
};
