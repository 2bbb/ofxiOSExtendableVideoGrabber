//
//  ofxiOSExtendableVideoGrabber.mm
//
//  Created by ISHII 2bit on 2018/06/08.
//

#include "ofxiOSExtendableVideoGrabberImpl.h"
#include "ofxiOSExtendableVideoGrabber.h"
#include "ofUtils.h"
#include "ofBaseTypes.h"
#include "ofConstants.h"
#include "ofAppRunner.h"

//--------------------------------------------------------------------
ofxiOSExtendableVideoGrabber::ofxiOSExtendableVideoGrabber(){
    bUseTexture            = false;
    requestedDeviceID    = -1;
    internalPixelFormat = OF_PIXELS_RGB;
    desiredFramerate     = -1;
    tex.resize(1);
}

//--------------------------------------------------------------------
ofxiOSExtendableVideoGrabber::~ofxiOSExtendableVideoGrabber(){
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setGrabber(std::shared_ptr<ofBaseVideoGrabber> newGrabber){
    grabber = newGrabber;
}

//--------------------------------------------------------------------
std::shared_ptr<ofBaseVideoGrabber> ofxiOSExtendableVideoGrabber::getGrabber(){
    if(!grabber){
        setGrabber(std::make_shared<ofxiOSExtendableVideoGrabberImpl>());
    }
    return grabber;
}

const std::shared_ptr<ofBaseVideoGrabber> ofxiOSExtendableVideoGrabber::getGrabber() const{
    return grabber;
}

//--------------------------------------------------------------------
bool ofxiOSExtendableVideoGrabber::setup(int w, int h, bool setUseTexture){
    if(!grabber){
        setGrabber(std::make_shared<ofxiOSExtendableVideoGrabberImpl>());
    }
    
    bUseTexture = setUseTexture;
    
    if( requestedDeviceID >= 0 ){
        grabber->setDeviceID(requestedDeviceID);
    }
    
    setPixelFormat(internalPixelFormat); //this safely handles checks for supported format
    
    if( desiredFramerate!=-1 ){
        grabber->setDesiredFrameRate(desiredFramerate);
    }
    
    grabber->setup(w, h);
    
    if( grabber->isInitialized() && bUseTexture ){
        if(!grabber->getTexturePtr()){
            for(int i=0;i<grabber->getPixels().getNumPlanes();i++){
                ofPixels plane = grabber->getPixels().getPlane(i);
                tex.push_back(ofTexture());
                tex[i].allocate(plane);
            }
        }
    }
    
    return grabber->isInitialized();
}

//--------------------------------------------------------------------
bool ofxiOSExtendableVideoGrabber::setPixelFormat(ofPixelFormat pixelFormat) {
    if(grabber){
        if( grabber->isInitialized() ){
            ofLogWarning("ofxiOSExtendableVideoGrabber") << "setPixelFormat(): can't set pixel format while grabber is running";
            internalPixelFormat = grabber->getPixelFormat();
            return false;
        }else{
            if( grabber->setPixelFormat(pixelFormat) ){
                internalPixelFormat = grabber->getPixelFormat();  //we do this as either way we want the grabbers format
            }else{
                internalPixelFormat = grabber->getPixelFormat();  //we do this as either way we want the grabbers format
                return false;
            }
        }
    }else{
        internalPixelFormat = pixelFormat;
    }
    return true;
}

//---------------------------------------------------------------------------
ofPixelFormat ofxiOSExtendableVideoGrabber::getPixelFormat() const{
    if(grabber){
        internalPixelFormat = grabber->getPixelFormat();
    }
    return internalPixelFormat;
}

//--------------------------------------------------------------------
std::vector<ofVideoDevice> ofxiOSExtendableVideoGrabber::listDevices() const{
    if(!grabber){
        ofxiOSExtendableVideoGrabber * mutThis = const_cast<ofxiOSExtendableVideoGrabber*>(this);
        mutThis->setGrabber(std::make_shared<ofxiOSExtendableVideoGrabberImpl>());
    }
    return grabber->listDevices();
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setVerbose(bool bTalkToMe){
    if(grabber){
        grabber->setVerbose(bTalkToMe);
    }
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setDeviceID(int _deviceID){
    requestedDeviceID = _deviceID;
    if( grabber && grabber->isInitialized() ){
        ofLogWarning("ofxiOSExtendableVideoGrabber") << "setDeviceID(): can't set device while grabber is running.";
    }
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setDesiredFrameRate(int framerate){
    desiredFramerate = framerate;
    if(grabber){
        grabber->setDesiredFrameRate(framerate);
    }
}

//---------------------------------------------------------------------------
ofPixels & ofxiOSExtendableVideoGrabber::getPixels(){
    return getGrabber()->getPixels();
}

//---------------------------------------------------------------------------
const ofPixels & ofxiOSExtendableVideoGrabber::getPixels() const{
    return getGrabber()->getPixels();
}

//------------------------------------
ofTexture & ofxiOSExtendableVideoGrabber::getTexture() {
    if(grabber->getTexturePtr() == nullptr){
        return tex[0];
    }
    else{
        return *grabber->getTexturePtr();
    }
}

//------------------------------------
const ofTexture & ofxiOSExtendableVideoGrabber::getTexture() const{
    if(grabber->getTexturePtr() == nullptr){
        return tex[0];
    }
    else{
        return *grabber->getTexturePtr();
    }
}

//------------------------------------
std::vector<ofTexture> & ofxiOSExtendableVideoGrabber::getTexturePlanes(){
    if(grabber->getTexturePtr() != nullptr){
        tex.clear();
        tex.push_back(*grabber->getTexturePtr());
    }
    return tex;
}

//------------------------------------
const std::vector<ofTexture> & ofxiOSExtendableVideoGrabber::getTexturePlanes() const{
    if(grabber->getTexturePtr() != nullptr){
        ofxiOSExtendableVideoGrabber* mutThis = const_cast<ofxiOSExtendableVideoGrabber*>(this);
        mutThis->tex.clear();
        mutThis->tex.push_back(*grabber->getTexturePtr());
    }
    return tex;
}

//---------------------------------------------------------------------------
bool  ofxiOSExtendableVideoGrabber::isFrameNew() const{
    if(grabber){
        return grabber->isFrameNew();
    }
    return false;
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::update(){
    if(grabber){
        grabber->update();
        if( bUseTexture && !grabber->getTexturePtr() && grabber->isFrameNew() ){
            if(int(tex.size())!=grabber->getPixels().getNumPlanes()){
                tex.resize(grabber->getPixels().getNumPlanes());
            }
            for(int i=0;i<grabber->getPixels().getNumPlanes();i++){
                ofPixels plane = grabber->getPixels().getPlane(i);
                bool bDiffPixFormat = ( tex[i].isAllocated() && tex[i].texData.glInternalFormat != ofGetGLInternalFormatFromPixelFormat(plane.getPixelFormat()) );
                if(bDiffPixFormat || !tex[i].isAllocated() ){
                    tex[i].allocate(plane);
                }else{
                    tex[i].loadData(plane);
                }
            }
        }
    }
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::close(){
    if(grabber){
        grabber->close();
    }
    tex.clear();
}

//--------------------------------------------------------------------
void ofxiOSExtendableVideoGrabber::videoSettings(void){
    if(grabber){
        grabber->videoSettings();
    }
}

//------------------------------------
void ofxiOSExtendableVideoGrabber::setUseTexture(bool bUse){
    bUseTexture = bUse;
}

//------------------------------------
bool ofxiOSExtendableVideoGrabber::isUsingTexture() const{
    return bUseTexture;
}


//----------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setAnchorPercent(float xPct, float yPct){
    getTexture().setAnchorPercent(xPct, yPct);
}

//----------------------------------------------------------
void ofxiOSExtendableVideoGrabber::setAnchorPoint(float x, float y){
    getTexture().setAnchorPoint(x, y);
}

//----------------------------------------------------------
void ofxiOSExtendableVideoGrabber::resetAnchor(){
    getTexture().resetAnchor();
}

//------------------------------------
void ofxiOSExtendableVideoGrabber::draw(float _x, float _y, float _w, float _h) const{
    ofGetCurrentRenderer()->draw(*this,_x,_y,_w,_h);
}

//------------------------------------
void ofxiOSExtendableVideoGrabber::draw(float _x, float _y) const{
    draw(_x, _y,getWidth(),getHeight());
}


//------------------------------------
void ofxiOSExtendableVideoGrabber::bind() const{
    std::shared_ptr<ofBaseGLRenderer> renderer = ofGetGLRenderer();
    if(renderer){
        renderer->bind(*this);
    }
}

//------------------------------------
void ofxiOSExtendableVideoGrabber::unbind() const{
    std::shared_ptr<ofBaseGLRenderer> renderer = ofGetGLRenderer();
    if(renderer){
        renderer->unbind(*this);
    }
}

//----------------------------------------------------------
float ofxiOSExtendableVideoGrabber::getHeight() const{
    if(grabber){
        return grabber->getHeight();
    }else{
        return 0;
    }
}

//----------------------------------------------------------
float ofxiOSExtendableVideoGrabber::getWidth() const{
    if(grabber){
        return grabber->getWidth();
    }else{
        return 0;
    }
}

//----------------------------------------------------------
bool ofxiOSExtendableVideoGrabber::isInitialized() const{
    return grabber && grabber->isInitialized() && (!bUseTexture || tex[0].isAllocated() || grabber->getTexturePtr());
}

// added

void ofxiOSExtendableVideoGrabber::addDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate)
{ getGrabber<ofxiOSExtendableVideoGrabberImpl>()->addDelegate(delegate); }

void ofxiOSExtendableVideoGrabber::removeDelegate(ofxiOSExtendableVideoGrabberDelegate *delegate)
{ getGrabber<ofxiOSExtendableVideoGrabberImpl>()->removeDelegate(delegate); }

CGImageRef ofxiOSExtendableVideoGrabber::getCurrentFrame() const
{ return getGrabber<ofxiOSExtendableVideoGrabberImpl>()->getCurrentFrame(); };
