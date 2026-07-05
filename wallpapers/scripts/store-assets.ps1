Add-Type -AssemblyName System.Drawing
function C($hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function CA($a, $hex) { $c = C $hex; [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B) }
$outDir = 'C:\Users\Casey\Documents\Kanagawa Mint-Csupo\kmc-store-assets'
New-Item -ItemType Directory -Force $outDir | Out-Null

function New-WavePts($w, $baseY, $amp, $phase, $freq = 1.6) {
    $pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
    for ($x = -10; $x -le ($w + 10); $x += [Math]::Max(6, [int]($w/64))) {
        $yy = $baseY + $amp * [Math]::Sin(($x/[double]$w)*6.28318*$freq + $phase) + ($amp*0.35) * [Math]::Sin(($x/[double]$w)*6.28318*($freq*2.6) + $phase*1.7)
        $pts.Add([System.Drawing.PointF]::new($x, $yy))
    }
    ,$pts.ToArray()
}
function Add-Wave($g, $w, $h, $baseY, $amp, $fill, $crest, $cw, $phase) {
    $pts = New-WavePts $w $baseY $amp $phase
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddCurve($pts, 0.5)
    $path.AddLine($w + 20, $h + 20, -20, $h + 20)
    $path.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush($fill)), $path)
    if ($crest) {
        $p = New-Object System.Drawing.Pen($crest, $cw); $p.StartCap='Round'; $p.EndCap='Round'
        $g.DrawCurve($p, $pts, 0.5)
    }
}

# ================= icon 128x128 =================
$s = 128
$bmp = New-Object System.Drawing.Bitmap($s, $s)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
# rounded square ink background
$r = 24
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddArc(0, 0, $r, $r, 180, 90); $path.AddArc($s-$r-1, 0, $r, $r, 270, 90)
$path.AddArc($s-$r-1, $s-$r-1, $r, $r, 0, 90); $path.AddArc(0, $s-$r-1, $r, $r, 90, 90)
$path.CloseFigure()
$g.FillPath((New-Object System.Drawing.SolidBrush(C '#1f1f28')), $path)
$g.SetClip($path)
# small terracotta sun
$g.FillEllipse((New-Object System.Drawing.SolidBrush(C '#ff9e3b')), 78, 18, 30, 30)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1f1f28')), 78, 36, 30, 3)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1f1f28')), 78, 42, 30, 4)
# waves
Add-Wave $g $s $s 74 8  (CA 255 '#2d4f67') (CA 200 '#54e3b2') 3 1.2
Add-Wave $g $s $s 92 9  (CA 255 '#223249') (CA 255 '#54e3b2') 4 3.9
Add-Wave $g $s $s 110 7 (CA 255 '#16161d') (CA 160 '#54e3b2') 3 0.4
$g.ResetClip()
$bmp.Save("$outDir\icon-128.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ================= screenshot 1280x800: browser mockup =================
$W = 1280; $H = 800
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'AntiAliasGridFit'
$fontS = New-Object System.Drawing.Font('Consolas', 11)
$fontM = New-Object System.Drawing.Font('Consolas', 13)
$fontL = New-Object System.Drawing.Font('Consolas', 26, [System.Drawing.FontStyle]::Bold)
$parch = New-Object System.Drawing.SolidBrush(C '#c8c093')
$muted = New-Object System.Drawing.SolidBrush(C '#727169')
$mint  = New-Object System.Drawing.SolidBrush(C '#54e3b2')

# frame
$g.Clear((C '#181820'))
# tab strip: inactive tab, active tab
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1a1a22')), 16, 12, 190, 34)
$g.DrawString('new tab', $fontS, $muted, 30, 20)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1f1f28')), 210, 12, 230, 34)
$g.FillRectangle($mint, 210, 12, 230, 3)
$g.DrawString('kanagawa mint-csupo', $fontS, $parch, 222, 20)
# toolbar + omnibox
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1f1f28')), 0, 46, $W, 46)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#16161d')), 90, 54, 1080, 30)
$g.DrawString('https://darklunchstudios.dev/kanagawa-mint-csupo', $fontS, $parch, 102, 61)
$arrowPen = New-Object System.Drawing.Pen((C '#c8c093'), 2)
$g.DrawLine($arrowPen, 30, 69, 46, 69); $g.DrawLine($arrowPen, 38, 62, 30, 69); $g.DrawLine($arrowPen, 38, 76, 30, 69)
$g.DrawLine($arrowPen, 76, 69, 60, 69); $g.DrawLine($arrowPen, 68, 62, 76, 69); $g.DrawLine($arrowPen, 68, 76, 76, 69)

# content: new tab page with wallpaper-style art
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1f1f28')), 0, 92, $W, $H-92)
$g.DrawString('Kanagawa Mint-Csupo', $fontL, $parch, 400, 240)
$g.DrawString('sumi ink  //  parchment  //  electric mint', $fontM, $mint, 448, 300)
# palette swatch row
$sw = @('#16161d','#181820','#1a1a22','#1f1f28','#223249','#2d4f67','#54e3b2','#b06ecf','#ff9e3b','#e6c384','#98bb6c','#e46876','#7e9cd8','#c8c093')
$x = 640 - ($sw.Count * 34) / 2
foreach ($hx in $sw) {
    $g.FillRectangle((New-Object System.Drawing.SolidBrush(C $hx)), $x, 348, 28, 28)
    $x += 34
}
# waves at bottom
Add-Wave $g $W $H 560 34 (CA 255 '#223249') (CA 110 '#7e9cd8') 3 0.4
Add-Wave $g $W $H 620 42 (CA 255 '#2d4f67') (CA 170 '#54e3b2') 4 2.2
Add-Wave $g $W $H 690 46 (CA 255 '#181820') (CA 255 '#54e3b2') 5 4.6
Add-Wave $g $W $H 755 36 (CA 255 '#16161d') (CA 150 '#54e3b2') 4 1.5
$bmp.Save("$outDir\screenshot-1280x800.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ================= small promo tile 440x280 =================
$W = 440; $H = 280
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'AntiAliasGridFit'
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $rect)
$g.FillEllipse((New-Object System.Drawing.SolidBrush(C '#ff9e3b')), 340, 28, 56, 56)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1a1a22')), 340, 62, 56, 5)
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#1a1a22')), 340, 72, 56, 7)
$fontT = New-Object System.Drawing.Font('Consolas', 17, [System.Drawing.FontStyle]::Bold)
$g.DrawString('Kanagawa', $fontT, (New-Object System.Drawing.SolidBrush(C '#c8c093')), 26, 44)
$g.DrawString('Mint-Csupo', $fontT, (New-Object System.Drawing.SolidBrush(C '#54e3b2')), 26, 74)
Add-Wave $g $W $H 168 16 (CA 255 '#223249') (CA 120 '#7e9cd8') 2 0.9
Add-Wave $g $W $H 196 20 (CA 255 '#2d4f67') (CA 190 '#54e3b2') 3 2.8
Add-Wave $g $W $H 228 20 (CA 255 '#181820') (CA 255 '#54e3b2') 3 5.0
Add-Wave $g $W $H 258 14 (CA 255 '#16161d') (CA 150 '#54e3b2') 2 1.7
$bmp.Save("$outDir\promo-440x280.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "assets saved to $outDir"
