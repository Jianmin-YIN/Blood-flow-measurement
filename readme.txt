This code is based on Alex Liberzon & Roi Gurka's work on PIV tracking at 20-Jul-99.
This code required high speed imaging at 120fps or higher. In our study, high speed imaging was made by iPhone 7 at 120fps with a Labcam adaptor connected with a Leica stereomicroscope. 
The stereomicroscope should be adjusted that single blood cell is visible(by changing the intensity and reflection of light). 
The video should be imported to ImageJ with the plugin of MMFPEG.
The video should be rotated so that tail towards the top and head towards the bottom. 
The video is stabilised by the plugin of image stabiliser in ImageJ.
This code is suitable for the measurement of blood flow zebrafish embryo at 1.5 days after fertilisation or later. 
This method does not require tricaine treatment or mounting of embryo.  
The main program is main.m
You need to define the location of the video;the number of measurement between frames; the region to blood vessel; the the number of probes per measurement(optional) 