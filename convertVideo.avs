### SagaraS Scriptmaker - Version 6.0 ###

### Lade Plugins und setze die globalen Variablen ###
Global breite = 1280
Global hoehe = 720
Global AR = 0

### Lade Videoquellen ###
SetMTMode(3)
AVIload(LeftStr(ScriptName(), StrLen(ScriptName()) - 4)+".avi", 0, 0, 0, -0, -0, "Auto", "Auto", 0, 0)

### Funktion für Video-Laderoutine ###
Function AVIload (String file, int loading, int cl, int co, int cr, int cu, string pixtype, string afps, int fpsn, int fpsd) {
    (loading == 1) ? FFIndex(file) : nop()
    clip0 = (loading == 3) ? LWLibavVideoSource(file) : (loading == 2) ? Import(file).KillAudio() : (loading == 1) ? FFVideoSource(file, threads=1) : (pixtype == "Auto") ? AVISource(file, false).KillAudio() : AVISource(file, false, pixel_type=pixtype).KillAudio()
    clip1 = clip0.AutoFPS(afps, fpsn, fpsd).Cropping(cl, co, cr, cu)
    Return (clip1.width == breite && clip1.height == hoehe) ? clip1.ConvertToYV12(matrix = "Rec709", ChromaResample = "Spline64") :  Clip1.Resize()
}

Function AutoFPS (Clip clip0, string afps, int fpsn, int fpsd) {
    rate1 = (afps == "Auto") ? (Round(Float(clip0.framerate * 1000)) / 1000) / 2 : nop() 
    rate2 = (afps == "Auto") ? Round(clip0.framerate) / 2 : nop()
    rate = (afps == "Auto") ? (rate1 == rate2) ? 1 : 1001 : (afps == "Igno.") ? clip0.frameratedenominator : fpsd
    ratefaktor = (afps == "Auto") ? (rate == 1001) ? 1000 : 1 : nop()
    clip0 = (afps == "Auto") ? (rate == 1001) ? clip0.AssumeFPS(Round(clip0.Framerate) * 1000, rate) : clip0.AssumeFPS(round(clip0.framerate), rate) : (afps == "Igno.") ? clip0.AssumeFPS(clip0.frameratenumerator, rate) : clip0.AssumeFPS(fpsn, rate)
    Return clip0
}

Function Cropping (Clip clip0, int cl, int co, int cr, int cu) {
    clip0 = (clip0.IsRGB32() == True) ? clip0.ConvertToRGB24() : clip0
    Return (cl != 0 || co != 0 || cr != 0 || cu != 0) ? clip0.Crop(cl, co, cr, cu) : clip0
}

Function Resize (Clip clip1) {
    clip1 = (AR == 1) ? ((float(Clip1.height * breite) / clip1.width) / 2 == round((float(Clip1.height * breite) / clip1.width) / 2)) ? ((float(Clip1.width * hoehe) / clip1.height) / 2 == round((float(Clip1.width * hoehe) / clip1.height) / 2)) ? clip1 : clip1.ConvertToRGB24() : clip1.ConvertToRGB24() : clip1
    clip1 = (AR == 1) ? (((clip1.width * hoehe) / clip1.height > breite) ? Clip1.Spline64Resize(breite, ceil(float(Clip1.height * breite) / clip1.width)) : Clip1.Spline64Resize(ceil(float(clip1.width * hoehe) / clip1.height), hoehe)) : clip1.Spline64Resize(breite, hoehe).ConvertToYV12(matrix = "Rec709", ChromaResample = "Spline64")
    back = (AR == 1) ? (0 == 1) ? ImageReader("", 0, clip1.framecount - 1, clip1.framerate).ChangeFPS(clip1.frameratenumerator, clip1.frameratedenominator).Spline64Resize(breite, hoehe).ConvertToYV12(matrix = "Rec709", ChromaResample = "Spline64") : BlankClip(clip1, width = breite, height = hoehe, pixel_type = "YV12").KillAudio() : clip1
    Return (AR == 1) ? Overlay(back, clip1, (back.width - clip1.width) / 2, (back.height - clip1.height) / 2) : clip1
}
