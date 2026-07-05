# Kanagawa Mint-Csupo — abstract wallpaper set (spec v1.3.0)
# Renders: csupo.png, seigaiha.png, gridwave.png, prompt.png (all 3840x2160)
Add-Type -AssemblyName System.Drawing
function C($hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function CA($a, $hex) { $c = C $hex; [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B) }
$out = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$W = 3840; $H = 2160

# ================= 1. CSUPO — Klasky-Csupo memphis shapes =================
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.Clear((C '#1f1f28'))
$rand = New-Object System.Random(1991)
$palette = @('#54e3b2', '#b06ecf', '#ff9e3b', '#e46876', '#7e9cd8', '#98bb6c', '#e6c384')
# scattered funky shapes: donuts, squiggles, zigzags, plus-signs, quarter arcs
foreach ($i in 1..34) {
    $hex = $palette[$rand.Next($palette.Count)]
    $x = $rand.Next(80, $W - 300); $y = $rand.Next(80, $H - 300)
    $kind = $rand.Next(5)
    switch ($kind) {
        0 { # donut
            $r = $rand.Next(50, 150)
            $pen = New-Object System.Drawing.Pen((CA 210 $hex), ($r/3))
            $g.DrawEllipse($pen, $x, $y, $r, $r)
        }
        1 { # squiggle
            $pen = New-Object System.Drawing.Pen((CA 220 $hex), $rand.Next(10, 22))
            $pen.StartCap='Round'; $pen.EndCap='Round'
            $pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
            for ($k = 0; $k -lt 7; $k++) { $pts.Add([System.Drawing.PointF]::new($x + $k*45, $y + $rand.Next(-55, 55))) }
            $g.DrawCurve($pen, $pts.ToArray(), 0.9)
        }
        2 { # zigzag
            $pen = New-Object System.Drawing.Pen((CA 220 $hex), $rand.Next(8, 18))
            $pen.StartCap='Round'; $pen.EndCap='Round'
            $pts = @()
            for ($k = 0; $k -lt 6; $k++) { $pts += [System.Drawing.Point]::new($x + $k*50, $y + $(if ($k % 2) { 60 } else { 0 })) }
            $g.DrawLines($pen, $pts)
        }
        3 { # plus sign
            $t = $rand.Next(16, 34); $len = $rand.Next(60, 120)
            $b = New-Object System.Drawing.SolidBrush(CA 200 $hex)
            $g.FillRectangle($b, $x - $len/2, $y - $t/2, $len, $t)
            $g.FillRectangle($b, $x - $t/2, $y - $len/2, $t, $len)
        }
        4 { # quarter arc
            $r = $rand.Next(80, 200)
            $pen = New-Object System.Drawing.Pen((CA 190 $hex), $rand.Next(12, 26))
            $g.DrawArc($pen, $x, $y, $r, $r, $rand.Next(0, 360), 100)
        }
    }
}
# big anchor shapes: one large mint donut + violet blob outline
$pen = New-Object System.Drawing.Pen((CA 235 '#54e3b2'), 90)
$g.DrawEllipse($pen, 2650, 1300, 620, 620)
$pen = New-Object System.Drawing.Pen((CA 200 '#b06ecf'), 34)
$g.DrawEllipse($pen, 350, 250, 500, 380)
$bmp.Save("$out\csupo.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ================= 2. SEIGAIHA — classic overlapping wave-scale pattern ==
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.Clear((C '#16161d'))
$R = 260; $stepX = $R; $stepY = [int]($R * 0.38)
$rings = @('#1f1f28', '#223249', '#2d4f67', '#1a1a22')
$row = 0
for ($cy = -$R; $cy -lt ($H + $R); $cy += $stepY) {
    $off = $(if ($row % 2) { $stepX / 2 } else { 0 })
    for ($cx = -$R + $off; $cx -lt ($W + $R); $cx += $stepX) {
        # each scale: concentric filled arcs, largest first
        for ($k = 0; $k -lt 4; $k++) {
            $rr = $R/2 - $k * 30
            if ($rr -le 0) { continue }
            $b = New-Object System.Drawing.SolidBrush(C $rings[$k])
            $g.FillEllipse($b, $cx - $rr, $cy - $rr, 2*$rr, 2*$rr)
        }
        # mint rim on the outermost edge, subtle
        $pen = New-Object System.Drawing.Pen((CA 70 '#54e3b2'), 4)
        $g.DrawEllipse($pen, $cx - $R/2, $cy - $R/2, $R, $R)
    }
    $row++
}
# one hero scale in full mint, golden-ratio position
$cx = 2370; $cy = 830
for ($k = 0; $k -lt 4; $k++) {
    $rr = $R/2 - $k * 30
    $b = New-Object System.Drawing.SolidBrush($(if ($k % 2) { C '#16161d' } else { C '#54e3b2' }))
    $g.FillEllipse($b, $cx - $rr, $cy - $rr, 2*$rr, 2*$rr)
}
$bmp.Save("$out\seigaiha.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ================= 3. GRIDWAVE — synthwave horizon grid =================
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $rect)
$horizon = 1280
# striped sun on the horizon, centered
$sunR = 520; $sunX = 1920; $sunY = $horizon
$sunPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$sunPath.AddEllipse($sunX - $sunR, $sunY - $sunR, 2*$sunR, 2*$sunR)
$clip = New-Object System.Drawing.Region($sunPath)
$clip.Intersect((New-Object System.Drawing.Region(New-Object System.Drawing.Rectangle(0, 0, $W, $horizon))))
$g.Clip = $clip
$sunTop = $sunY - $sunR; $sunD = 2 * $sunR
$sunRect2 = New-Object System.Drawing.Rectangle(0, $sunTop, $W, $sunD)
$sunGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($sunRect2, (C '#e6c384'), (C '#ff9e3b'), 90.0)
$g.FillRectangle($sunGrad, 0, $sunTop, $W, $sunD)
$bgB = New-Object System.Drawing.SolidBrush(C '#1a1a22')
$y = $sunY - 300; $gap = 8
while ($y -lt $sunY) { $g.FillRectangle($bgB, 0, $y, $W, $gap); $y += 80; $gap += 10 }
$g.ResetClip()
# ground
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#181820')), 0, $horizon, $W, $H - $horizon)
# perspective grid: verticals converging to vanishing point
$vpX = 1920
foreach ($i in -24..24) {
    $xBottom = $vpX + $i * 240
    $pen = New-Object System.Drawing.Pen((CA 130 '#54e3b2'), 3)
    $g.DrawLine($pen, $vpX, $horizon, $xBottom, $H)
}
# horizontals, spacing expands toward viewer
$yy = 0.0; $step = 6.0
while (($horizon + $yy) -lt $H) {
    $pen = New-Object System.Drawing.Pen((CA ([int](60 + 140 * $yy / ($H - $horizon))) '#54e3b2'), 3)
    $g.DrawLine($pen, 0, $horizon + $yy, $W, $horizon + $yy)
    $yy = $yy * 1.28 + $step
}
# horizon line, full mint
$g.DrawLine((New-Object System.Drawing.Pen((C '#54e3b2'), 6)), 0, $horizon, $W, $horizon)
# violet star specks
$rand = New-Object System.Random(2077)
foreach ($i in 1..60) {
    $sb = New-Object System.Drawing.SolidBrush(CA ($rand.Next(40, 130)) '#b06ecf')
    $g.FillEllipse($sb, $rand.Next(0, $W), $rand.Next(0, 900), $rand.Next(2, 6), $rand.Next(2, 6))
}
$bmp.Save("$out\gridwave.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# ================= 4. PROMPT — ultra-minimal terminal glyph =============
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode = 'AntiAlias'
$g.Clear((C '#1f1f28'))
# giant chevron prompt, centered-left, golden ratio height
$pen = New-Object System.Drawing.Pen((C '#54e3b2'), 70)
$pen.StartCap = 'Round'; $pen.EndCap = 'Round'; $pen.LineJoin = 'Round'
$cx = 1560; $cy = 1080; $s = 220
$g.DrawLines($pen, @(
    [System.Drawing.Point]::new($cx - $s, $cy - $s),
    [System.Drawing.Point]::new($cx + $s - 60, $cy),
    [System.Drawing.Point]::new($cx - $s, $cy + $s)
))
# blinking cursor block, parchment
$g.FillRectangle((New-Object System.Drawing.SolidBrush(C '#c8c093')), $cx + $s + 160, $cy - 150, 170, 300)
# faint ink wave along the very bottom for brand continuity
$pts = New-Object 'System.Collections.Generic.List[System.Drawing.PointF]'
for ($x = -10; $x -le ($W + 10); $x += 60) {
    $pts.Add([System.Drawing.PointF]::new($x, 2080 + 30 * [Math]::Sin(($x/3840.0)*6.28318*1.6)))
}
$wp = New-Object System.Drawing.Pen((CA 60 '#54e3b2'), 4)
$g.DrawCurve($wp, $pts.ToArray(), 0.5)
$bmp.Save("$out\prompt.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved: csupo, seigaiha, gridwave, prompt"
