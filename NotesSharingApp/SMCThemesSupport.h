//
//  SMCGraphics.h
//  SMCFootballV4
//
//  Created by Naveen Aranha on 29/04/14.
//  Copyright (c) 2014 SI. All rights reserved.
//

#import <UIKit/UIKit.h>



//pkl new added

#define PKLFONT_GothamBook  @"Gotham-Book"
#define PKLFONT_GothamMedium  @"Gotham-Medium"
#define PKLFONT_GothamBlack  @"Gotham-Black"
#define PKLFONT_GothamBold  @"Gotham-Bold"
#define PKLFONT_GothamMediumItalic @"Gotham-MediumItalic"
#define PKLFONT_GothamLight @"Gotham-Light"
#define PKLFONT_GothamNarrowBook @"GothamNarrow-Book"


#define HILFONT_UbuntuItalic @"Ubuntu-Italic"
#define HILFONT_UbuntuBold  @"Ubuntu-Bold"
#define HILFONT_UbuntuBoldItalic @"Ubuntu-BoldItalic"
#define HILFONT_UbuntuMediumItalic @"Ubuntu-MediumItalic"
#define HILFONT_UbuntuLight @"Ubuntu-Light"
#define HILFONT_UbuntuMedium @"Ubuntu-Medium"
#define HILFONT_UbuntuLightItalic @"Ubuntu-LightItalic"
//#define HILFONT_UbuntuRegular @"UbuntuMono-Regular"
#define HILFONT_UbuntuRegular @"Ubuntu-Light"
#define HILFONT_UbuntuMonoBlod @"UbuntuMono-Bold"
#define HILFONT_UbuntuMonoItalic @"UbuntuMono-Italic"
#define HILFONT_UbuntuMonoBoldItalic @"UbuntuMono-BoldItalic"
#define HILFONT_UbuntuConRegular @"UbuntuCondensed-Regular"
#define HILFONT_ArialBold @"Arial-BoldMT"
#define HILFONT_ArialBoldItalic @"Arial-BoldItalicMT"
#define HILFONT_ArialReuular @"ArialMT"
#define HILFONT_ArialItalic @"Arial-ItalicMT"
#define HILFONT_Roboto_BoldCondensed @"Roboto-BoldCondensed"
//Ubuntu-Light
#define TEAM_PLACEHOLDER_LOGO  [UIImage imageNamed:@"default_team"]
#define PLAYER_PLACEHOLDER_LOGO  [UIImage imageNamed:@"default_player"]


#define SMCFONT(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]
#define COLOR_THEME_RED 0xe11700
#define SMCUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SMCUIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define IMAGE_MENU_BUTTON [UIImage imageNamed:@"menu.png"]
#define SMCIMAGE_EVENT_GOAL [UIImage imageNamed:@"Event_Goal.png"]
#define SMCIMAGE_EVENT_RED [UIImage imageNamed:@"Event_Red.png"]
#define kHeaderAppLogo [UIImage imageNamed:@"app_logo.png"]//

#define PlaceHolderImageHIL [UIImage imageNamed:@"placeHolder.png"]
#define PlaceHolderImageHI [UIImage imageNamed:@"HI_PlaceHolder.png"]


//PKL colors
#define COLOR_NK_WHITE 0xffffff
#define COLOR_NK_DARKGRAY_333333 0x333333
#define COLOR_NK_ff6600 0xff6600
#define COLOR_NK_999999 0x999999
#define COLOR_NK_LIGHTGRAY_666666 0x666666
#define COLOR_NK_FF0000 0xFF0000
#define COLOR_NK_F3F3F3 0xf3f3f3
#define COLOR_NK_ff9966 0xff9966
#define COLOR_NK_2D2D2D 0x2D2D2D
#define COLOR_NK_CF2F31 0xCF2F31
#define COLOR_NK_85BD42 0x85BD42
#define COLOR_NK_7F7F7F 0x7F7F7F
#define COLOR_NK_292929 0x292929
#define COLOR_NK_1F1F1F 0x1F1F1F
#define COLOR_NK_141414 0x141414
#define COLOR_NK_0F0F0F 0x0F0F0F
#define COLOR_NK_111111 0x111111
#define COLOR_NK_330000 0x330000
#define COLOR_NK_161616 0x161616
#define COLOR_NK_dadada 0xdadada



#define COLOR_NK_TABCOLORSELECETD 0xeb0a8b
#define COLOR_NK_SKYBLUE 0x176ab3
#define COLOR_NK_NAVIGATIONBAR 0xe8e8e8
#define COLOR_NK_SCROLLER 0xbdbdbd
#define COLOR_NK_SKIN_eeeeee 0xeeeeee
#define COLOR_NK_f8f8f8 0xf8f8f8
#define COLOR_NK_e4e4e4 0xe4e4e4
#define COLOR_NK_cccccc 0xcccccc
#define COLOR_NK_161d66 0x161d66
#define COLOR_BLACK 0x000000

#define COLOR_NK_SKIN_1668B2 0x1668B2
#define COLOR_NK_0A0A0A  0x0A0A0A
#define COLOR_NK_0D0D0D 0x0D0D0D
#define COLOR_NK_1098C9 0x1098C9
#define COLOR_NK_90918B 0x90918B
#define COLOR_NK_454a85 0x454a85
#define COLOR_NK_2c3690 0x2c3690
#define COLOR_NK_7b7d9e 0x7b7d9e


#define COLOR_NK_BLACK 0x000000 //now black
#define COLOR_NK_262626 0x262626
#define COLOR_NK_dbdbdb 0xdbdbdb





#define COLOR_DS_RED_e4232c 0xd08c03
#define COLOR_NK_PROGRESSRING 0xe41b23
#define COLOR_NK_GOALBALLCOLOR 0xf2321c
#define COLOR_NK_181818 0x181818
#define COLOR_NK_fefefe 0xfefefe
#define COLOR_NK_272727 0x272727
#define COLOR_NK_101010 0x101010
#define COLOR_NK_853301 0x853301
#define COLOR_NK_a23d01 0xa23d01
#define COLOR_NK_c44a00 0xc44a00
#define COLOR_NK_e55700 0xe55700
#define COLOR_NK_ff6100 0xe41b23
#define COLOR_NK_e5e5e5 0xe5e5e5
#define COLOR_NK_faddcc 0xfaddcc
#define COLOR_NK_fbe6d9 0xfbe6d9
#define COLOR_NK_6f6f6 0xf6f6f6
#define COLOR_NK_e9e9e9 0xe9e9e9

//ISL
#define COLOR_ISL_090532 0x090532
#define COLOR_ISL_0b0640 0x0b0640
#define COLOR_ISL_0f0859 0x0f0859
#define COLOR_ISL_0d074d 0x0d074d
#define COLOR_ISL_110966 0x110966
#define COLOR_ISL_666666 0x666666
#define COLOR_ISL_b9b7c9 0xb9b7c9
#define COLOR_ISL_a2a0b7 0xa2a0b7
#define COLOR_ISL_e1e1e1 0xe1e1e1


#define COLOR_DS_YELLOW_f7a827 0xf7a827
#define COLOR_DS_GREEN_3c6c3c 0x3c6c3c
//#define COLOR_DS_RED_e4232c 0xd08c03
#define COLOR_DS_SKIN_f4dfbb 0xf4dfbb
#define COLOR_DS_BLACK_101010 0x101010
#define COLOR_DS_GRAY_333333 0x333333  //to COLOR_NK_WHITE
#define COLOR_DS_LIGHTGRAY_e5e2e2 0xe5e2e2
#define COLOR_DS_TWITTERBLUE_55acee 0x55acee
#define COLOR_DS_VIDEO_55acee 0x16114b
#define COLOR_NK_1769b2  0x1769b2

#define COLOR_Green 0x009966
#define COLOR_Red 0x990000
#define COLOR_Comment 0x666666
#define Color_be026f 0xbe026f

#define kLikeImage [UIImage imageNamed:@"like.png"]
#define kLikeImage_selected [UIImage imageNamed:@"like_f.png"]

#define kDisLikeImage [UIImage imageNamed:@"dislike.png"]
#define kDisLikeImage_selected [UIImage imageNamed:@"dislike_f.png"]
#define kCommentImage [UIImage imageNamed:@"comment.png"]


#define SMCFONT_CanaroBold                  @"Klavika-Bold"
#define SMCFONT_CanaroBlackItalic           @"Canaro-BlackItalic"
#define SMCFONT_CanaroThinItalic            @"Canaro-ThinItalic"
#define SMCFONT_CanaroMediumItalic          @"Canaro-MediumItalic"
#define SMCFONT_CanaroBlack                 @"Canaro-Black"
#define SMCFONT_CanaroBook                  @"Canaro-Book"
#define SMCFONT_CanaroExtraBold             @"Canaro-ExtraBold"
#define SMCFONT_CanaroBookItalic            @"Canaro-BookItalic"
#define SMCFONT_CanaroExtraLightItalic      @"Canaro-ExtraLightItalic"
#define SMCFONT_CanaroLightItalic           @"Canaro-LightItalic"
#define SMCFONT_CanaroSemiBold              @"Klavika-Regular"
#define SMCFONT_CanaroExtraLight            @"Canaro-ExtraLight"
#define SMCFONT_CanaroExtraBoldItalic       @"Canaro-ExtraBoldItalic"
#define SMCFONT_CanaroLight                 @"Klavika-Light"
#define SMCFONT_CanaroThin                  @"Canaro-Thin"
#define SMCFONT_CanaroBoldItalic            @"Canaro-BoldItalic"
#define SMCFONT_CanaroMedium                @"Klavika-Medium"




#pragma fonts for noteshare

//16
#define SMCFONT_ArialMTRegular                  @"ArialMT"
#define SMCFONT_ArialBoldMT                  @"Arial-BoldMT"
#define SMCFONT_ArialItalicMT                  @"Arial-ItalicMT"





//2
#define SMCFONT_TimesNewRomanPSMTRegular             @"TimesNewRomanPSMT"
#define SMCFONT_TimesNewRomanPSBoldMT                @"TimesNewRomanPS-BoldMT"
#define SMCFONT_TimesNewRomanPSItalicMT              @"TimesNewRomanPS-ItalicMT"




//8
#define SMCFONT_HelveticaNeueRegular                  @"HelveticaNeue"
#define SMCFONT_HelveticaNeueBold                  @"HelveticaNeue-Bold"
#define SMCFONT_HelveticaNeueItalic                  @"HelveticaNeue-Italic"





#define SMCFONT_MonotypeCorsivaRegular                  @"MonotypeCorsiva"




#define SMCFONT_EdwardianScriptITCRegular                  @"EdwardianScriptITC"




#define SMCFONT_MongolianBaitiRegular                  @"MongolianBaiti"




#define SMCFONT_SakkalMajallaRegular                  @"SakkalMajalla"




#define SMCFONT_DosisBold                  @"Dosis-Bold"






#define SMCFONT_DancingScriptRegular                  @"DancingScript"




#define SMCFONT_ErasITCMediumRegular                  @"ErasITC-Medium"



#define SMCFONT_CinzelDecorativeRegular                  @"CinzelDecorative-Regular"




#define SMCFONT_junctionRegular                 @"junctionregular"



#define SMCFONT_LindenHillRegular                 @"LindenHill-Regular"




#define SMCFONT_PacificoRegular                 @"Pacifico-Regular"



#define SMCFONT_WINDSONGRegular                 @"WINDSONG"







#pragma others noteshare

#define SMCFONT_DevanagariSangamMN                  @"DevanagariSangamMN"
#define SMCFONT_DevanagariSangamMNBold              @"DevanagariSangamMN-Bold"


//1
#define SMCFONT_AvenirNextRegular                 @"AvenirNext-Regular"
#define SMCFONT_AvenirNextBold                    @"AvenirNext-Bold"
#define SMCFONT_AvenirNextItalic                  @"AvenirNext-Italic"

#define SMCFONT_KohinoorDevanagariRegular           @"KohinoorDevanagari-Light"

//3
#define SMCFONT_GillSansReular                  @"GillSans"
#define SMCFONT_GillSansBold                 @"GillSans-Bold"
#define SMCFONT_GillSansItalic                  @"GillSans-Italic"


#define SMCFONT_KailasaRegular                  @"Kailasa"
#define SMCFONT_KailasaBold                 @"Kailasa-Bold"


#define SMCFONT_BradleyHandITCTTBold                  @"BradleyHandITCTT-Bold"


#define SMCFONT_SavoyeLetPlainRegular                  @"SavoyeLetPlain"


#define SMCFONT_DancingScriptRegular                 @"DancingScript"


//4
#define SMCFONT_TrebuchetMSRegular                  @"TrebuchetMS"
#define SMCFONT_TrebuchetMSBold                  @"TrebuchetMS-Bold"
#define SMCFONT_TrebuchetMSItalic                 @"TrebuchetMS-Italic"


//5
#define SMCFONT_BaskervilleRegular                 @"Baskerville"
#define SMCFONT_BaskervilleBold                  @"Baskerville-Bold"
#define SMCFONT_BaskervilleItalic                  @"Baskerville-Italic"


//6
#define SMCFONT_BodoniSvtyTwoITCTTBookRegular                  @"BodoniSvtyTwoITCTT-Book"
#define SMCFONT_BodoniSvtyTwoITCTTBold                 @"BodoniSvtyTwoITCTT-Bold"
#define SMCFONT_BodoniSvtyTwoITCTTBookIta                 @"BodoniSvtyTwoITCTT-BookIta"


#define SMCFONT_HoeflerTextRegular                 @"HoeflerText-Regular"
#define SMCFONT_HoeflerTextItalic                  @"HoeflerText-Italic"


//7
#define SMCFONT_OptimaRegular                  @"Optima-Regular"
#define SMCFONT_OptimaBold                 @"Optima-Bold"
#define SMCFONT_OptimaItalic                 @"Optima-Italic"



#define SMCFONT_PartyLetPlainRegular                  @"PartyLetPlain"


#define SMCFONT_BanglaSangamMNRegular                  @"BanglaSangamMN"
#define SMCFONT_BanglaSangamMNBold                  @"BanglaSangamMN-Bold"


//9
#define SMCFONT_SuperclarendonRegular                  @"Superclarendon-Regular"
#define SMCFONT_SuperclarendonBold                  @"Superclarendon-Bold"
#define SMCFONT_SuperclarendonItalic                  @"Superclarendon-Italic"



//10
#define SMCFONT_IowanOldStyleRomanRegular                  @"IowanOldStyle-Roman"
#define SMCFONT_IowanOldStyleBold                  @"IowanOldStyle-Bold"
#define SMCFONT_IowanOldStyleItalic                 @"IowanOldStyle-Italic"



//11
#define SMCFONT_CochinRegular                  @"Cochin"
#define SMCFONT_CochinBold                 @"Cochin-Bold"
#define SMCFONT_CochinItalic                  @"Cochin-Italic"


//12
#define SMCFONT_EuphemiaUCASRegular                  @"EuphemiaUCAS"
#define SMCFONT_EuphemiaUCASBold                  @"EuphemiaUCAS-Bold"
#define SMCFONT_EuphemiaUCASItalic                 @"EuphemiaUCAS-Italic"


#define SMCFONT_AcademyEngravedLetPlainRegular                 @"AcademyEngravedLetPlain"

#define SMCFONT_HelveticaRegular                  @"Helvetica"
#define SMCFONT_HelveticaBold                  @"Helvetica-Bold"


#define SMCFONT_AmericanTypewriterRegular                  @"AmericanTypewriter"
#define SMCFONT_AmericanTypewriterBold                  @"AmericanTypewriter-Bold"


//13
#define SMCFONT_DidotRegular                  @"Didot"
#define SMCFONT_DidotBold                  @"Didot-Bold"
#define SMCFONT_DidotItalic                  @"Didot-Italic"



//14
#define SMCFONT_CourierNewPSMTregular                  @"CourierNewPSMT"
#define SMCFONT_CourierNewPSBoldMT                  @"CourierNewPS-BoldMT"
#define SMCFONT_CourierNewPSItalicMT                  @"CourierNewPS-ItalicMT"



//15
#define SMCFONT_AvenirNextCondensedRegular                  @"AvenirNextCondensed-Regular"
#define SMCFONT_AvenirNextCondensedBold                  @"AvenirNextCondensed-Bold"
#define SMCFONT_AvenirNextCondensedItalic                @"AvenirNextCondensed-Italic"


#define SMCFONT_DamascusRegular                 @"Damascus"
#define SMCFONT_DamascusBold                  @"DamascusBold"




#define SMCFONT_OriyaSangamMNRegular                  @"OriyaSangamMN"
#define SMCFONT_OriyaSangamMNBold                  @"OriyaSangamMN-Bold"



//17
#define SMCFONT_Georgiaregular                  @"Georgia"
#define SMCFONT_GeorgiaBold                  @"Georgia-Bold"
#define SMCFONT_GeorgiaItalic                  @"Georgia-Italic"



//18
#define SMCFONT_VerdanaRegular                 @"Verdana"
#define SMCFONT_VerdanaBold                  @"Verdana-Bold"
#define SMCFONT_VerdanaItalic                  @"Verdana-Italic"


//19
#define SMCFONT_MarionRegular                  @"Marion-Regular"
#define SMCFONT_MarionBold                  @"Marion-Bold"
#define SMCFONT_MarionItalic                 @"Marion-Italic"

//20
#define SMCFONT_MenloRegular                  @"Menlo-Regular"
#define SMCFONT_MenloBold                 @"Menlo-Bold"
#define SMCFONT_MenloItalic                  @"Menlo-Italic"











@interface SMCThemesSupport : NSObject
+(UIImage *)si_imageWithColor:(UIColor *)color andSize:(CGSize)size ;
@end


/*
 <color name="E2A9F3">#E2A9F3</color>
 <color name="F5A9BC">#F5A9BC</color>
 <color name="F5A9E1">#F5A9E1</color>
 <color name="F6D8CE">#F6D8CE</color>
 <color name="F5F6CE">#F5F6CE</color>
 <color name="CEF6EC">#CEF6EC</color>
 <color name="D8CEF6">#D8CEF6</color>
 <color name="E610B4B">#610B4B</color>
 <color name="A08088A">#08088A</color>
 <color name="C58FAD0">#58FAD0</color>
 <color name="ffffff">#ffffff</color>
 */

