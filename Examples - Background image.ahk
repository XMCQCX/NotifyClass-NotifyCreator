#Requires AutoHotkey v2.0
#SingleInstance

#include Notify.ahk

;============================================================================================
;   Show(title, message, image, sound, callback, options)
;
;   For more details on the BGIMG and BGIMGPOS settings, refer to the documentation in Notify.ahk and the tooltips in Notify Creator.
;============================================================================================

Notify.Show('DLL Icon as Background', 'This notification uses an icon from a DLL as its background.',,,,
    'theme=Frost style=edge bgImg=' A_WinDir '\System32\msctf.dll|Icon13')

;============================================================================================
;   Using a Pixel Color as the Background Image Setting to Create a Sidebar
;============================================================================================

Notify.Show('Error', 'Something has gone wrong!',,,, 'theme=xdark gmb=25 bgImg=0xC61111 bgImgPos=bl wStretch h8')
Notify.Show('Info', 'Some information to show.',,,, 'theme=ilight style=edge pad=,,5,5,10,5,10,0 bdr=0x41A5EE,3 bgImg=0x41A5EE bgImgPos=w50 hStretch')

;============================================================================================
;   Creating a Gradient Bitmap to Use as a Background Image
;============================================================================================

bgImgGradTitle := 'Gradient Background'
bgImgGradMsg := 'This notification uses a gradient bitmap as its background.'

Notify.Show(bgImgGradTitle, bgImgGradMsg,,,, 'theme=Cyberpunk maxW=400 bgImg=hBITMAP:*' CreateGradient(['0x383836', '0x000000']*))
Notify.Show(bgImgGradTitle, bgImgGradMsg,,,, 'theme=monokai style=edge maxW=325 bdr=0xA6E22E bgImg=hBITMAP:*' CreateGradient(['0x3f590b', '0x000000']*))

/**********************************************
 * @credits jNizM, just me, SKAN
 * @see {@link https://github.com/jNizM/ahk-scripts-v2/blob/main/src/Gui/CreateGradient.ahk GitHub}
 */
CreateGradient(Colors*) {
    static IMAGE_BITMAP := 0
    static LR_COPYDELETEORG := 0x00000008
    static LR_CREATEDIBSECTION := 0x00002000
    size := 500
    Bits := Buffer(Colors.Length * 2 * 4)
    Addr := Bits

    for each, Color in Colors
        Addr := NumPut("UInt", Color, "UInt", Color, Addr)

    hBITMAP := DllCall("CreateBitmap", "Int", 2, "Int", Colors.Length, "UInt", 1, "UInt", 32, "Ptr", 0, "Ptr")
    hBITMAP := DllCall("CopyImage", "Ptr", hBITMAP, "UInt", IMAGE_BITMAP, "Int", 0, "Int", 0, "UInt", LR_COPYDELETEORG | LR_CREATEDIBSECTION, "Ptr")
    DllCall("SetBitmapBits", "Ptr", hBITMAP, "UInt", Bits.Size, "Ptr", Bits)
    hBITMAP := DllCall("CopyImage", "Ptr", hBITMAP, "UInt", 0, "Int", size, "Int", size, "UInt", LR_COPYDELETEORG | LR_CREATEDIBSECTION, "Ptr")
    return hBITMAP
}

;============================================================================================
;   Setting Click Callbacks for GUI and Images
;
;   For more details on the callback parameter, refer to the documentation in Notify.ahk
;============================================================================================

strOpts := 'theme=matrix dg=5 tag=cbGUI'

mapObjGUI := Notify.Show(
    'GUI and Images with Callbacks.',
    'This notification uses a background image as a close button. Clicking on it triggers a callback that destroys the GUI.',
    'iconi',,
    [(*) => Notify.Show('GUI clicked',,,,, strOpts),
     (*) => Notify.Show('Image clicked',,,,, strOpts),
     (*) => BgImg_Click()],
    'theme=Monaspace dur=0 maxW=400 bgImg=iconx bgImgPos=tr w20 h-1 ofstx-15 ofsty15'
)

BgImg_Click(*) {
    Notify.Destroy(mapObjGUI['hwnd'])
    Notify.Show('Background image clicked',,,,, strOpts)
}