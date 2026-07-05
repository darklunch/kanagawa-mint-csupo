Add-Type -AssemblyName System.Drawing
function C($hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function CA($a, $hex) { $c = C $hex; [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B) }

function New-WavePoints($baseY, $amp, $phase) {
    $pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
    for ($x = -100; $x -le 3940; $x += 60) {
        $yy = $baseY + $amp * [Math]::Sin(($x/3840.0)*6.28318*1.6 + $phase) + ($amp*0.35) * [Math]::Sin(($x/3840.0)*6.28318*4.2 + $phase*1.7)
        $pts.Add([System.Drawing.PointF]::new($x, $yy))
    }
    ,$pts.ToArray()
}
function Add-Wave($g, $baseY, $amp, $fillColor, $crestColor, $crestWidth, $phase) {
    $pts = New-WavePoints $baseY $amp $phase
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddCurve($pts, 0.5)
    $path.AddLine(3940, 2260, -100, 2260)
    $path.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush($fillColor)), $path)
    if ($crestColor) {
        $p = New-Object System.Drawing.Pen($crestColor, $crestWidth)
        $p.StartCap='Round'; $p.EndCap='Round'
        $g.DrawCurve($p, $pts, 0.5)
    }
}

$W = 3840; $H = 2160

# ============ Variant 1: MINIMAL â€” flat ink, one mint crest ============
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.Clear((C '#1f1f28'))
Add-Wave $g 1950 60 (CA 255 '#181820') (CA 255 '#54e3b2') 8 2.6
Add-Wave $g 2070 45 (CA 255 '#16161d') (CA 90  '#54e3b2') 5 0.8
$rand = New-Object System.Random(1993)
foreach ($i in 1..25) {
    $fb = New-Object System.Drawing.SolidBrush(CA ($rand.Next(40,140)) '#54e3b2')
    $g.FillEllipse($fb, $rand.Next(0,$W), (1930 + $rand.Next(0,200)), $rand.Next(3,8), $rand.Next(3,8))
}
$bmp.Save('C:\Users\Casey\Documents\Kanagawa Mint-Csupo\kmc-wallpaper-minimal.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ============ Variant 2: DUSK â€” violet haze, higher seas, no sun ============
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $rect)
# violet dusk haze band across upper sky
$hazeRect = New-Object System.Drawing.Rectangle(0, 150, $W, 1000)
$haze = New-Object System.Drawing.Drawing2D.LinearGradientBrush($hazeRect, (CA 0 '#b06ecf'), (CA 0 '#b06ecf'), 90.0)
$cb = New-Object System.Drawing.Drawing2D.ColorBlend(3)
$cb.Colors = @((CA 0 '#b06ecf'), (CA 36 '#b06ecf'), (CA 0 '#b06ecf'))
$cb.Positions = @([single]0, [single]0.55, [single]1)
$haze.InterpolationColors = $cb
$g.FillRectangle($haze, $hazeRect)
# thin crescent moon, parchment
$moonPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$moonPath.AddEllipse(2950, 330, 300, 300)
$inner = New-Object System.Drawing.Drawing2D.GraphicsPath
$inner.AddEllipse(2905, 305, 300, 300)
$moonRegion = New-Object System.Drawing.Region($moonPath)
$moonRegion.Exclude($inner)
$g.FillRegion((New-Object System.Drawing.SolidBrush(CA 220 '#dcd7ba')), $moonRegion)
# stars
$rand = New-Object System.Random(777)
foreach ($i in 1..70) {
    $sb = New-Object System.Drawing.SolidBrush(CA ($rand.Next(30,120)) '#dcd7ba')
    $g.FillEllipse($sb, $rand.Next(0,$W), $rand.Next(0,1100), $rand.Next(2,5), $rand.Next(2,5))
}
# higher, stormier seas
Add-Wave $g 1150 90  (CA 255 '#223249') (CA 70  '#957fb8') 6  1.1
Add-Wave $g 1330 110 (CA 255 '#2d4f67') (CA 120 '#54e3b2') 7  3.3
Add-Wave $g 1530 120 (CA 255 '#223249') (CA 190 '#54e3b2') 9  5.2
Add-Wave $g 1760 130 (CA 255 '#181820') (CA 255 '#54e3b2') 11 0.6
Add-Wave $g 1980 100 (CA 255 '#16161d') (CA 150 '#54e3b2') 8  2.9
foreach ($i in 1..110) {
    $fb = New-Object System.Drawing.SolidBrush(CA ($rand.Next(50,190)) '#54e3b2')
    $g.FillEllipse($fb, $rand.Next(0,$W), (1450 + $rand.Next(0,650)), $rand.Next(3,11), $rand.Next(3,11))
}
$bmp.Save('C:\Users\Casey\Documents\Kanagawa Mint-Csupo\kmc-wallpaper-dusk.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output 'saved both variants'

