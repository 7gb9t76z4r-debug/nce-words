Add-Type -AssemblyName System.Drawing

function New-Icon([int]$size, [string]$out) {
  $bmp = New-Object System.Drawing.Bitmap($size, $size)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

  $rect = New-Object System.Drawing.Rectangle(0, 0, $size, $size)
  $c1 = [System.Drawing.Color]::FromArgb(0x1e, 0x3c, 0x72)
  $c2 = [System.Drawing.Color]::FromArgb(0x2a, 0x52, 0x98)
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 45)

  $r = [int]($size * 0.1875); $d = $r * 2
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddArc(0, 0, $d, $d, 180, 90)
  $path.AddArc($size - $d, 0, $d, $d, 270, 90)
  $path.AddArc($size - $d, $size - $d, $d, $d, 0, 90)
  $path.AddArc(0, $size - $d, $d, $d, 90, 90)
  $path.CloseFigure()
  $g.FillPath($brush, $path)

  $gold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(0xff, 0xd1, 0x66))
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

  $f1 = New-Object System.Drawing.Font('Georgia', [int]($size * 0.26), [System.Drawing.FontStyle]::Bold)
  $r1 = New-Object System.Drawing.RectangleF(0, [int]($size * 0.24), $size, [int]($size * 0.34))
  $g.DrawString('NCE', $f1, $gold, $r1, $sf)

  $f2 = New-Object System.Drawing.Font('Microsoft YaHei', [int]($size * 0.15))
  $r2 = New-Object System.Drawing.RectangleF(0, [int]($size * 0.62), $size, [int]($size * 0.22))
  $g.DrawString([char]0x80CC + [char]0x5355 + [char]0x8BCD, $f2, [System.Drawing.Brushes]::White, $r2, $sf)

  $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

New-Icon 192 'D:\kimigongzuo\icons\icon-192.png'
New-Icon 512 'D:\kimigongzuo\icons\icon-512.png'
Write-Output 'icons done'
