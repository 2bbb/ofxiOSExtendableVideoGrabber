//
//  ofxiOSExtendableVideoGrabberDelegate.h
//
//  Created by ISHII 2bit on 2018/06/08.
//

#ifndef ofxiOSExtendableVideoGrabberDelegate_h
#define ofxiOSExtendableVideoGrabberDelegate_h

#import <CoreMedia/CoreMedia.h>
#import <CoreImage/CoreImage.h>

struct ofxiOSExtendableVideoGrabberDelegate {
    virtual void didOutputSampleBuffer(CVImageBufferRef imageBuffer) {};
};

#endif /* ofxiOSExtendableVideoGrabberDelegate_h */
