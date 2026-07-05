Add-Type -AssemblyName System.Drawing

$W = 3840; $H = 2160
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'

function C($hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function CA($a, $hex) { $c = C $hex; [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B) }

# --- Sky: vertical gradient sumi ink ---
$skyRect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($skyRect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $skyRect)

# --- Retro 16-bit striped sun (terracotta), upper right ---
$sunX = 2780; $sunY = 640; $sunR = 430
$sunRect = New-Object System.Drawing.Rectangle(($sunX-$sunR), ($sunY-$sunR), (2*$sunR), (2*$sunR))
$sunPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$sunPath.AddEllipse($sunRect)
$g.SetClip($sunPath)
$sunGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($sunRect, (C '#e6c384'), (C '#ff9e3b'), 90.0)
$g.FillRectangle($sunGrad, $sunRect)
# scanline gaps widening toward the bottom of the sun
$bgBrush = New-Object System.Drawing.SolidBrush(C '#1a1a22')
$y = $sunY + 40; $gap = 10
while ($y -lt ($sunY + $sunR)) {
    $g.FillRectangle($bgBrush, ($sunX-$sunR), $y, (2*$sunR), $gap)
    $y += 90; $gap += 12
}
$g.ResetClip()
# faint sun glow ring
$glowPen = New-Object System.Drawing.Pen((CA 40 '#ff9e3b'), 26)
$g.DrawEllipse($glowPen, ($sunX-$sunR-20), ($sunY-$sunR-20), (2*$sunR+40), (2*$sunR+40))

# --- Klasky-Csupo squiggles: loose violet + mint scribbles in the sky ---
$rand = New-Object System.Random(90210)
$sq1 = New-Object System.Drawing.Pen((CA 70 '#b06ecf'), 14); $sq1.StartCap='Round'; $sq1.EndCap='Round'
$sq2 = New-Object System.Drawing.Pen((CA 55 '#54e3b2'), 10); $sq2.StartCap='Round'; $sq2.EndCap='Round'
foreach ($s in @(@(420,380,$sq1), @(1450,260,$sq2), @(950,700,$sq1), @(1900,560,$sq2), @(300,900,$sq2))) {
    $x0 = $s[0]; $y0 = $s[1]; $pen = $s[2]
    $pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
    for ($i = 0; $i -lt 7; $i++) {
        $pts.Add([System.Drawing.PointF]::new($x0 + $i*60, $y0 + $rand.Next(-45, 45)))
    }
    $g.DrawCurve($pen, $pts.ToArray(), 0.9)
}

# --- Wave bands: layered bezier ridges rising from the bottom ---
function Add-Wave($g, $baseY, $amp, $fillColor, $crestColor, $crestWidth, $phase) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
    for ($x = -100; $x -le 3940; $x += 60) {
        $yy = $baseY + $amp * [Math]::Sin(($x/3840.0)*6.28318*1.6 + $phase) + ($amp*0.35) * [Math]::Sin(($x/3840.0)*6.28318*4.2 + $phase*1.7)
        $pts.Add([System.Drawing.PointF]::new($x, $yy))
    }
    $path.AddCurve($pts.ToArray(), 0.5)
    $path.AddLine(3940, 2260, -100, 2260)
    $path.CloseFigure()
    $b = New-Object System.Drawing.SolidBrush($fillColor)
    $g.FillPath($b, $path)
    if ($crestColor) {
        $p = New-Object System.Drawing.Pen($crestColor, $crestWidth)
        $p.StartCap='Round'; $p.EndCap='Round'
        $g.DrawCurve($p, $pts.ToArray(), 0.5)
    }
}

# back to front: deep blues rising to ink, mint crests on the front ridges
Add-Wave $g 1450 70  (CA 255 '#223249') (CA 90  '#7e9cd8') 6  0.0
Add-Wave $g 1580 90  (CA 255 '#2d4f67') (CA 140 '#54e3b2') 7  2.1
Add-Wave $g 1720 100 (CA 255 '#223249') (CA 200 '#54e3b2') 9  4.4
Add-Wave $g 1880 110 (CA 255 '#181820') (CA 255 '#54e3b2') 11 1.2
Add-Wave $g 2040 90  (CA 255 '#16161d') (CA 160 '#54e3b2') 8  3.4

# --- Foam: mint dots scattered along the front crests ---
foreach ($i in 1..90) {
    $fx = $rand.Next(0, $W)
    $fy = 1750 + $rand.Next(0, 360)
    $fr = $rand.Next(3, 11)
    $fa = $rand.Next(50, 190)
    $fb = New-Object System.Drawing.SolidBrush(CA $fa '#54e3b2')
    $g.FillEllipse($fb, $fx, $fy, $fr, $fr)
}

$out = 'C:\Users\Casey\Documents\Kanagawa Mint-Csupo\kmc-wallpaper.png'
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved: $out"
