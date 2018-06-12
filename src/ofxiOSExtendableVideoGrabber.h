//
//  ofxiOSExtendableVideoGrabber.h
//
//  Created by ISHII 2bit on 2018/06/08.
//

#ifndef ofxiOSExtendableVideoGrabber_h
#define ofxiOSExtendableVideoGrabber_h

#pragma once

#include "ofConstants.h"
#include "ofTexture.h"
#include "ofBaseTypes.h"
#include "ofPixels.h"
#include "ofTypes.h"

#include "ofxiOSExtendableVideoGrabberDelegate.h"

class ofxiOSExtendableVideoGrabber : public ofBaseVideoGrabber,public ofBaseVideoDraws{
public :
    ofxiOSExtendableVideoGrabber();
    virtual ~ofxiOSExtendableVideoGrabber();
    
    std::vector<ofVideoDevice> listDevices() const;
    bool                isFrameNew() const;
    void                update();
    void                close();
    bool                setup(int w, int h){return setup(w,h,true);}
    bool                setup(int w, int h, bool bTexture);
    
    bool                setPixelFormat(ofPixelFormat pixelFormat);
    ofPixelFormat         getPixelFormat() const;
    
    void                videoSettings();
    ofPixels&             getPixels();
    const ofPixels&        getPixels() const;
    ofTexture &            getTexture();
    const ofTexture &    getTexture() const;
    std::vector<ofTexture> & getTexturePlanes();
    const std::vector<ofTexture> & getTexturePlanes() const;
    void                setVerbose(bool bTalkToMe);
    void                setDeviceID(int _deviceID);
    void                setDesiredFrameRate(int framerate);
    void                setUseTexture(bool bUse);
    bool                 isUsingTexture() const;
    void                draw(float x, float y, float w, float h) const;
    void                draw(float x, float y) const;
    using ofBaseDraws::draw;
    
    void                 bind() const;
    void                 unbind() const;
    
    //the anchor is the point the image is drawn around.
    //this can be useful if you want to rotate an image around a particular point.
    void                setAnchorPercent(float xPct, float yPct);    //set the anchor as a percentage of the image width/height ( 0.0-1.0 range )
    void                setAnchorPoint(float x, float y);                //set the anchor point in pixels
    void                resetAnchor();                                //resets the anchor to (0, 0)
    
    float                getHeight() const;
    float                getWidth() const;
    
    bool                isInitialized() const;
    
    void                    setGrabber(shared_ptr<ofBaseVideoGrabber> newGrabber);
    shared_ptr<ofBaseVideoGrabber> getGrabber();
    const shared_ptr<ofBaseVideoGrabber> getGrabber() const;
    
    template<typename GrabberType>
    shared_ptr<GrabberType> getGrabber(){
        return dynamic_pointer_cast<GrabberType>(getGrabber());
    }
    
    template<typename GrabberType>
    const shared_ptr<GrabberType> getGrabber() const{
        return dynamic_pointer_cast<GrabberType>(getGrabber());
    }
    
    void addDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);
    void removeDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate);
    CGImageRef getCurrentFrame() const;

private:
    
    std::vector<ofTexture> tex;
    bool bUseTexture;
    std::shared_ptr<ofBaseVideoGrabber> grabber;
    int requestedDeviceID;
    
    mutable ofPixelFormat internalPixelFormat;
    int desiredFramerate;
};


#endif /* ofxiOSExtendableVideoGrabber_h */
