#include "ofxiOSExtendableVideoGrabberImpl.h"
#include "ExtendableAVFoundationVideoGrabber.h"

ofxiOSExtendableVideoGrabberImpl::ofxiOSExtendableVideoGrabberImpl() {
    grabber = std::make_shared<ExtendableAVFoundationVideoGrabber>();
}

ofxiOSExtendableVideoGrabberImpl::~ofxiOSExtendableVideoGrabberImpl() {
    //
}

//--------------------------------------------------------------
std::vector<ofVideoDevice> ofxiOSExtendableVideoGrabberImpl::listDevices() const {
	return grabber->listDevices();
}

bool ofxiOSExtendableVideoGrabberImpl::setup(int w, int h) {
    if(grabber->initGrabber(w, h)) {
        return true;
    } else {
        ofLog(OF_LOG_ERROR, "Failed to init the ofxiOSExtendableVideoGrabberImpl");
#if TARGET_IPHONE_SIMULATOR
        ofLog(OF_LOG_WARNING, "ofxiOSExtendableVideoGrabberImpl::setup(int w, int h) :: The iOS Video Grabber will not function on the iOS Simulator");
#endif
        return false;
    }
    
}

float ofxiOSExtendableVideoGrabberImpl::getHeight() const {
	return grabber->getHeight();
}

float ofxiOSExtendableVideoGrabberImpl::getWidth() const {
	return grabber->getWidth();
}

ofTexture * ofxiOSExtendableVideoGrabberImpl::getTexturePtr() {
    return NULL;
}

void ofxiOSExtendableVideoGrabberImpl::setVerbose(bool bTalkToMe) {
    ofLogWarning("ofxiOSExtendableVideoGrabberImpl") << "setVerbose() is not implemented";
}

void ofxiOSExtendableVideoGrabberImpl::setDeviceID(int deviceID) {
    grabber->setDevice(deviceID);
}

void ofxiOSExtendableVideoGrabberImpl::setDesiredFrameRate(int framerate) {
    grabber->setCaptureRate(framerate);
}

void ofxiOSExtendableVideoGrabberImpl::videoSettings() {
    ofLogWarning("ofxiOSExtendableVideoGrabberImpl") << "videoSettings() is not implemented";
}

//--------------------------------------------------------------
bool ofxiOSExtendableVideoGrabberImpl::isFrameNew() const {
	return grabber->isFrameNew();
}

void ofxiOSExtendableVideoGrabberImpl::close() {
    ofLogWarning("ofxiOSExtendableVideoGrabberImpl") << "close() is not implemented";
}

bool ofxiOSExtendableVideoGrabberImpl::isInitialized() const{
    return grabber->isInitialized();
}

bool ofxiOSExtendableVideoGrabberImpl::setPixelFormat(ofPixelFormat internalPixelFormat) {
	return grabber->setPixelFormat(internalPixelFormat);
}

ofPixelFormat ofxiOSExtendableVideoGrabberImpl::getPixelFormat() const {
    return grabber->getPixelFormat();
}

//--------------------------------------------------------------
ofPixels &ofxiOSExtendableVideoGrabberImpl::getPixels() {
    return pixels;
}

const ofPixels & ofxiOSExtendableVideoGrabberImpl::getPixels() const {
    return getPixels();
}

//--------------------------------------------------------------
void ofxiOSExtendableVideoGrabberImpl::update() {
	grabber->update();
    
    if(grabber->isFrameNew() == true) {
        pixels.setFromPixels(grabber->getPixels(),
                             getWidth(),
                             getHeight(),
                             grabber->getPixelFormat());
    }
}

void ofxiOSExtendableVideoGrabberImpl::addDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate)
{ if(grabber) grabber->addDelegate(delegate); };

void ofxiOSExtendableVideoGrabberImpl::removeDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate)
{ if(grabber) grabber->removeDelegate(delegate); };

CGImageRef ofxiOSExtendableVideoGrabberImpl::getCurrentFrame() const
{ return grabber->getCurrentFrame(); };
