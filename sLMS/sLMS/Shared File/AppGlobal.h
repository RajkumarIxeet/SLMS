//
//  AppGlobal.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppGlobal : NSObject

//Show warning message
+(void)showAlertWithMessage:(NSString*)msg title:(NSString*)title;

//Set View Position
+(void)setViewPositionWithView:(UIView*)view axisX:(NSInteger)axisX axisY:(NSInteger)axisY withAnimation:(BOOL)animation;

//Custom Button
+(void)roundButton:(UIButton*)btn withFontColor:(UIColor*)fontColor withBG:(UIColor*)BGcolor withRadius:(NSInteger)radius withborderWidth:(float)borderWidt;

//Round View
+(void)roundView:(UIView*)view withRadius:(NSInteger)radius borderWidth:(float)width color:(UIColor*)bcolor setshadow:(BOOL)shadow shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity  shadowColor:(UIColor*)shadowColor;

//Manage User Default Value
+(void)setValueInDefault:(NSString *)key value:(id)value;
+(id)getValueInDefault:key;

//Create Error Object
+(NSError*)createErrorObjectWithDescription:(NSString*)error_str errorCode:(NSInteger)errorCode;

//NSDate Convert to String
+(NSString*)nsdateConvertToStringWithFormate:(NSString *)Formate date:(NSDate*)date;

//string date cinver to nsdate
+(NSDate*)convertStringDateToNSDate:(NSString*)CustomeFormate withNSDate:(NSString*)str_date;


//read the File Data
+(NSMutableArray *)readFileData:(NSString *)strPath;
//write the File Data
+(void)writeFile:(NSString *)filePath andData:(NSData *)data;

//Calculate Dynamic Size of text
+(CGSize)calculateTextSizeWithString:(NSString*)text width:(CGFloat)width font:(UIFont*)font;

//Check Data Available in string or note
+(BOOL)checkDataAvailableInString:(NSString*)str_data;

//Formatter Currency
+(NSString*)returnFormattedCurrency:(NSNumber*)currency;
+(NSNumber*)returnNumberOfFormattedString:(NSString*)currency;
+(NSString*)returnWithoutFormattedCurrency:(NSString *)currency;

//Manage Image Bytes
+(NSMutableArray*)returnBytesArrayOfNSData:(NSData*)data;
+(NSMutableData*)returnNSDataOfBytesArray:(NSArray*)bytes;

//element Set Enabled
+(void)elementSetEnabled:(BOOL)enabled OfView:(UIView*)view;

// get the dropdown data
+(NSMutableArray*)getDropdownList:(AppDropdownType)dropdownName;
// set the dropdown data
+(void)setDropdownList:(AppDropdownType)dropdownName andData:(NSData *)data;

+ (void)ShowHidePickeratWindow:(UIView *)viewFromWindow fromWindow:(UIView *)viewAtWindow withVisibility:(BOOL)bIsPickerHidden ;
//genrate thumbnail for image
+(UIImage*)generateThumbnail:(NSString *)url;

@end
