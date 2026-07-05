# Kanagawa Mint-Csupo — variety wallpaper set (spec v1.3.0)
# Renders: greatwave.png, torii.png, pixel.png, bamboo.png, circuit.png (3840x2160)
Add-Type -AssemblyName System.Drawing
function C($hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function CA($a, $hex) { $c = C $hex; [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B) }
function SB($color) { New-Object System.Drawing.SolidBrush($color) }
function PEN($color, $w) { $p = New-Object System.Drawing.Pen($color, $w); $p.StartCap='Round'; $p.EndCap='Round'; $p.LineJoin='Round'; $p }
$out = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$W = 3840; $H = 2160

function New-Canvas($bgHex) {
    $script:bmp = New-Object System.Drawing.Bitmap($W, $H)
    $script:g = [System.Drawing.Graphics]::FromImage($script:bmp)
    $script:g.SmoothingMode = 'AntiAlias'
    $script:g.Clear((C $bgHex))
}
function Save-Canvas($name) {
    $script:bmp.Save("$out\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $script:g.Dispose(); $script:bmp.Dispose()
    Write-Output "  $name.png"
}

# ============ 1. GREATWAVE — Hokusai-style claw wave, mint on ink ============
New-Canvas '#1f1f28'
# sky gradient
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $rect)
# distant striped sun (small, like the print's Fuji position) — clear of the crest
$g.FillEllipse((SB (C '#e6c384')), 3140, 420, 300, 300)
$g.FillRectangle((SB (C '#1f1f28')), 3140, 560, 300, 8)
$g.FillRectangle((SB (C '#1f1f28')), 3140, 604, 300, 12)
# the big claw wave: body swept up from the left, curling over to the right
$wave = New-Object System.Drawing.Drawing2D.GraphicsPath
$wave.AddBezier(0, 2160, 100, 1500, 300, 1100, 900, 900)
$wave.AddBezier(900, 900, 1500, 700, 2200, 500, 2450, 620)
$wave.AddBezier(2450, 620, 2700, 740, 2650, 980, 2380, 1010)   # curl over
$wave.AddBezier(2380, 1010, 2500, 1120, 2350, 1300, 2050, 1280) # under-curl
$wave.AddBezier(2050, 1280, 1500, 1400, 900, 1700, 600, 2160)
$wave.CloseFigure()
$g.FillPath((SB (C '#223249')), $wave)
# inner wave shading bands
$inner = New-Object System.Drawing.Drawing2D.GraphicsPath
$inner.AddBezier(0, 2160, 200, 1650, 500, 1350, 1050, 1150)
$inner.AddBezier(1050, 1150, 1600, 950, 2100, 850, 2250, 950)
$inner.AddBezier(2250, 950, 1900, 1150, 1300, 1500, 800, 2160)
$inner.CloseFigure()
$g.FillPath((SB (C '#2d4f67')), $inner)
# crest outline in mint
$g.DrawBezier((PEN (C '#54e3b2') 14), 0, 2160, 100, 1500, 300, 1100, 900, 900)
$g.DrawBezier((PEN (C '#54e3b2') 14), 900, 900, 1500, 700, 2200, 500, 2450, 620)
$g.DrawBezier((PEN (C '#54e3b2') 14), 2450, 620, 2700, 740, 2650, 980, 2380, 1010)
# foam claws: hooked arcs hanging off the curl
$rand = New-Object System.Random(1831)
foreach ($i in 0..14) {
    $fx = 2380 - $i * 120 + $rand.Next(-30, 30)
    $fy = 1000 + [int](($i % 5) * 26) + $rand.Next(-20, 20)
    $fr = $rand.Next(28, 78)
    $g.DrawArc((PEN (CA 230 '#54e3b2') 10), $fx, $fy, $fr, $fr, 300, 220)
}
# foam dots spray
foreach ($i in 1..160) {
    $fx = $rand.Next(400, 2800); $fy = $rand.Next(500, 1250)
    if (($fy - 500) -gt (($fx - 400) * 0.3)) { continue }  # keep spray near the crest
    $fa = $rand.Next(60, 220); $fr = $rand.Next(4, 14)
    $g.FillEllipse((SB (CA $fa '#dcd7ba')), $fx, $fy, $fr, $fr)
}
# secondary swell bottom right
$swell = New-Object System.Drawing.Drawing2D.GraphicsPath
$swell.AddBezier(2400, 2160, 2700, 1800, 3200, 1650, 3840, 1750)
$swell.AddLine(3840, 2160, 2400, 2160)
$swell.CloseFigure()
$g.FillPath((SB (C '#181820')), $swell)
$g.DrawBezier((PEN (CA 200 '#54e3b2') 10), 2400, 2160, 2700, 1800, 3200, 1650, 3840, 1750)
Save-Canvas 'greatwave'

# ============ 2. TORII — gate silhouette, striped sun, reflection ============
New-Canvas '#1f1f28'
$rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (C '#16161d'), (C '#1f1f28'), 90.0)
$g.FillRectangle($sky, $rect)
$waterY = 1500
# big striped sun behind the gate
$sunR = 560; $sunX = 1920; $sunTop = $waterY - 2 * $sunR + 160
$sunPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$sunD = 2 * $sunR
$sunPath.AddEllipse($sunX - $sunR, $sunTop, $sunD, $sunD)
$clip = New-Object System.Drawing.Region($sunPath)
$clipRect = New-Object System.Drawing.Rectangle(0, 0, $W, $waterY)
$clip.Intersect((New-Object System.Drawing.Region($clipRect)))
$g.Clip = $clip
$sunRect = New-Object System.Drawing.Rectangle(0, $sunTop, $W, $sunD)
$sunGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($sunRect, (C '#e6c384'), (C '#ff9e3b'), 90.0)
$g.FillRectangle($sunGrad, $sunRect)
$bgB = SB (C '#1a1a22')
$y = $sunTop + 420; $gap = 10
while ($y -lt $waterY) { $g.FillRectangle($bgB, 0, $y, $W, $gap); $y += 95; $gap += 12 }
$g.ResetClip()
# water
$g.FillRectangle((SB (C '#16161d')), 0, $waterY, $W, $H - $waterY)
# sun reflection: broken horizontal mint/amber slats
$rand = New-Object System.Random(555)
foreach ($i in 0..26) {
    $ry = $waterY + 30 + $i * 22
    $rw = 700 - $i * 22 + $rand.Next(-60, 60)
    if ($rw -lt 40) { continue }
    $rx = 1920 - $rw / 2 + $rand.Next(-40, 40)
    $ra = 190 - $i * 6
    $g.FillRectangle((SB (CA $ra '#ff9e3b')), $rx, $ry, $rw, 8)
}
# torii gate silhouette (ink, mint edge-light)
$ink = SB (C '#16161d')
$mintPen = PEN (CA 220 '#54e3b2') 6
# pillars (slightly tapered)
$pillar1 = @([System.Drawing.Point]::new(1280, 640), [System.Drawing.Point]::new(1360, 640), [System.Drawing.Point]::new(1390, 1500), [System.Drawing.Point]::new(1250, 1500))
$pillar2 = @([System.Drawing.Point]::new(2480, 640), [System.Drawing.Point]::new(2560, 640), [System.Drawing.Point]::new(2590, 1500), [System.Drawing.Point]::new(2450, 1500))
$g.FillPolygon($ink, $pillar1); $g.FillPolygon($ink, $pillar2)
# kasagi (top lintel with upswept ends) + shimaki below it
$kasagi = New-Object System.Drawing.Drawing2D.GraphicsPath
$kasagi.AddBezier(1050, 560, 1500, 500, 2340, 500, 2790, 560)
$kasagi.AddLine(2790, 640, 1050, 640)
$kasagi.CloseFigure()
$g.FillPath($ink, $kasagi)
$g.FillRectangle($ink, 1120, 660, 1600, 60)
# nuki (lower crossbar)
$g.FillRectangle($ink, 1180, 980, 1480, 70)
# gakuzuka (center strut)
$g.FillRectangle($ink, 1885, 720, 70, 260)
# mint edge light on the kasagi top
$g.DrawBezier($mintPen, 1050, 560, 1500, 500, 2340, 500, 2790, 560)
# gate reflection (dim, wobbling)
foreach ($seg in @(@(1250, 1390), @(2450, 2590))) {
    for ($ry = 0; $ry -lt 380; $ry += 26) {
        $rxOff = $rand.Next(-14, 14)
        $rw2 = $seg[1] - $seg[0] - 40
        $g.FillRectangle((SB (CA (70 - [int]($ry/8)) '#54e3b2')), $seg[0] + 20 + $rxOff, $waterY + 40 + $ry, $rw2, 10)
    }
}
Save-Canvas 'torii'

# ============ 3. PIXEL — 16-bit sunset mountains, chunky blocks ============
New-Canvas '#16161d'
$px = 40  # pixel block size
$cols = [int]($W / $px); $rows = [int]($H / $px)
# banded sky: ink -> violet -> terracotta near horizon (posterized rows)
$skyBands = @('#16161d','#16161d','#16161d','#1a1a22','#1a1a22','#1f1f28','#1f1f28','#2a2a37','#2a2a37','#38284a','#38284a','#4a2f5c','#553060','#6a3d5c','#8a4a50','#b06ecf')
for ($r = 0; $r -lt 34; $r++) {
    $bandIdx = [Math]::Min($r * 16 / 34, 15)
    $g.FillRectangle((SB (C $skyBands[[int]$bandIdx])), 0, $r * $px, $W, $px)
}
$horizon = 34 * $px  # 1360
# chunky pixel sun
$rand = New-Object System.Random(1994)
$sunCX = 48; $sunCY = 26; $sunR2 = 9
for ($cy = $sunCY - $sunR2; $cy -le $sunCY + $sunR2; $cy++) {
    for ($cx = $sunCX - $sunR2; $cx -le $sunCX + $sunR2; $cx++) {
        $dx = $cx - $sunCX; $dy = $cy - $sunCY
        if (($dx*$dx + $dy*$dy) -le ($sunR2*$sunR2) -and ($cy * $px) -lt $horizon) {
            if (($cy % 3) -eq 0 -and $cy -gt $sunCY) { continue }  # scanline gaps
            $sunHex = $(if ($cy -lt $sunCY) { '#e6c384' } else { '#ff9e3b' })
            $g.FillRectangle((SB (C $sunHex)), $cx * $px, $cy * $px, $px, $px)
        }
    }
}
# pixel stars (single blocks, dithered)
foreach ($i in 1..40) {
    $sx = $rand.Next(0, $cols); $sy = $rand.Next(0, 20)
    $g.FillRectangle((SB (CA 120 '#dcd7ba')), $sx * $px, $sy * $px, [int]($px/2), [int]($px/2))
}
# three mountain layers, stepped silhouettes
function Draw-PixelRange($seedY, $rough, $hex, $seed) {
    $r2 = New-Object System.Random($seed)
    $level = $seedY
    for ($cx = 0; $cx -lt $cols; $cx++) {
        $level += $r2.Next(-$rough, $rough + 1)
        if ($level -lt 20) { $level = 20 }
        if ($level -gt ($rows - 4)) { $level = $rows - 4 }
        for ($cy = $level; $cy -lt $rows; $cy++) {
            $script:g.FillRectangle((SB (C $hex)), $cx * $px, $cy * $px, $px, $px)
        }
    }
}
Draw-PixelRange 30 2 '#223249' 71
Draw-PixelRange 38 2 '#1a1a22' 72
Draw-PixelRange 46 1 '#16161d' 73
# mint pixel ridge line on the front range
$r3 = New-Object System.Random(73)
$level = 46
for ($cx = 0; $cx -lt $cols; $cx++) {
    $level += $r3.Next(-1, 2)
    if ($level -lt 20) { $level = 20 }
    if ($level -gt ($rows - 4)) { $level = $rows - 4 }
    $g.FillRectangle((SB (C '#54e3b2')), $cx * $px, $level * $px, $px, [int]($px/2))
}
Save-Canvas 'pixel'

# ============ 4. BAMBOO — stalks with mint edge light ============
New-Canvas '#1a1a22'
$rand = New-Object System.Random(4242)
# back layer: dim stalks
foreach ($i in 1..9) {
    $bx = $rand.Next(0, $W); $bw = $rand.Next(60, 110)
    $g.FillRectangle((SB (C '#16161d')), $bx, 0, $bw, $H)
}
# mid + front stalks with nodes and mint rim
$stalks = @(340, 820, 1350, 1980, 2520, 3100, 3560)
foreach ($bx in $stalks) {
    $bw = $rand.Next(120, 190)
    $lean = $rand.Next(-60, 60)
    $seg = $rand.Next(420, 560)
    $poly = @(
        [System.Drawing.Point]::new($bx, 0), [System.Drawing.Point]::new($bx + $bw, 0),
        [System.Drawing.Point]::new($bx + $bw + $lean, $H), [System.Drawing.Point]::new($bx + $lean, $H))
    $g.FillPolygon((SB (C '#1f1f28')), $poly)
    # mint rim on the lit side
    $rim = PEN (CA 150 '#54e3b2') 7
    $g.DrawLine($rim, $bx + $bw, 0, $bx + $bw + $lean, $H)
    # nodes: horizontal ridges with patina highlight
    $ny = $rand.Next(80, 300)
    while ($ny -lt $H) {
        $frac = $ny / $H
        $nx = $bx + [int]($lean * $frac)
        $g.FillRectangle((SB (C '#16161d')), $nx - 6, $ny, $bw + 12, 26)
        $g.FillRectangle((SB (CA 190 '#7aa89f')), $nx - 6, $ny + 26, $bw + 12, 6)
        $ny += $seg
    }
}
# leaves: slender mint/patina ellipses at angles
foreach ($i in 1..26) {
    $lx = $rand.Next(0, $W); $ly = $rand.Next(0, 700)
    $lw = $rand.Next(160, 300); $lh = $rand.Next(34, 56)
    $ang = $rand.Next(-70, 70)
    $leafHex = $(if ($i % 3 -eq 0) { '#54e3b2' } else { '#7aa89f' })
    $la = $rand.Next(70, 170)
    $state = $g.Save()
    $g.TranslateTransform($lx, $ly); $g.RotateTransform($ang)
    $g.FillEllipse((SB (CA $la $leafHex)), 0, 0, $lw, $lh)
    $g.Restore($state)
}
Save-Canvas 'bamboo'

# ============ 5. CIRCUIT — mint traces on deep ink ============
New-Canvas '#16161d'
$rand = New-Object System.Random(8080)
$grid = 120
# faint substrate grid
$gridPen = New-Object System.Drawing.Pen((CA 14 '#54e3b2'), 1)
for ($x = 0; $x -le $W; $x += $grid) { $g.DrawLine($gridPen, $x, 0, $x, $H) }
for ($y = 0; $y -le $H; $y += $grid) { $g.DrawLine($gridPen, 0, $y, $W, $y) }
# traces: manhattan paths with 45-degree corners, node pads at ends
foreach ($i in 1..46) {
    $tx = $rand.Next(2, 30) * $grid; $ty = $rand.Next(2, 16) * $grid
    $traceHex = switch ($rand.Next(6)) { 0 { '#b06ecf' } 1 { '#2d4f67' } default { '#54e3b2' } }
    $ta = $rand.Next(90, 220)
    $pen = PEN (CA $ta $traceHex) 8
    $ptList = New-Object 'System.Collections.Generic.List[System.Drawing.Point]'
    $ptList.Add([System.Drawing.Point]::new($tx, $ty))
    $dir = $rand.Next(4)  # 0=E 1=W 2=S 3=N
    foreach ($stepN in 1..$rand.Next(3, 7)) {
        $len = $rand.Next(2, 6) * $grid
        switch ($dir) {
            0 { $tx += $len } 1 { $tx -= $len } 2 { $ty += $len } 3 { $ty -= $len }
        }
        $tx = [Math]::Max(60, [Math]::Min($W - 60, $tx))
        $ty = [Math]::Max(60, [Math]::Min($H - 60, $ty))
        $ptList.Add([System.Drawing.Point]::new($tx, $ty))
        $dir = $(if ($dir -lt 2) { $rand.Next(2, 4) } else { $rand.Next(0, 2) })  # alternate axis
    }
    $g.DrawLines($pen, $ptList.ToArray())
    # pads: donut at start, filled dot at end
    $p0 = $ptList[0]; $p1 = $ptList[$ptList.Count - 1]
    $g.DrawEllipse((PEN (CA $ta $traceHex) 8), $p0.X - 18, $p0.Y - 18, 36, 36)
    $g.FillEllipse((SB (CA $ta $traceHex)), $p1.X - 14, $p1.Y - 14, 28, 28)
}
# one hero chip: parchment rectangle with mint pins, off-center
$chipX = 2560; $chipY = 760; $chipW = 420; $chipH = 420
$g.FillRectangle((SB (C '#1f1f28')), $chipX, $chipY, $chipW, $chipH)
$g.DrawRectangle((PEN (C '#54e3b2') 10), $chipX, $chipY, $chipW, $chipH)
$g.DrawRectangle((PEN (CA 90 '#54e3b2') 4), $chipX + 40, $chipY + 40, $chipW - 80, $chipH - 80)
foreach ($k in 0..6) {
    $pinOff = 40 + $k * 56
    $g.FillRectangle((SB (C '#c8c093')), $chipX + $pinOff, $chipY - 34, 24, 34)
    $g.FillRectangle((SB (C '#c8c093')), $chipX + $pinOff, $chipY + $chipH, 24, 34)
    $g.FillRectangle((SB (C '#c8c093')), $chipX - 34, $chipY + $pinOff, 34, 24)
    $g.FillRectangle((SB (C '#c8c093')), $chipX + $chipW, $chipY + $pinOff, 34, 24)
}
Save-Canvas 'circuit'
Write-Output 'variety set complete'
