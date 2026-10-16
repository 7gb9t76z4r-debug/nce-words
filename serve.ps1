$root = 'D:\kimigongzuo'
$port = 8642
$mime = @{
  '.html'       = 'text/html; charset=utf-8'
  '.js'         = 'text/javascript; charset=utf-8'
  '.json'       = 'application/json; charset=utf-8'
  '.css'        = 'text/css; charset=utf-8'
  '.webmanifest'= 'application/manifest+json'
  '.png'        = 'image/png'
  '.svg'        = 'image/svg+xml'
}

$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $port)
$listener.Start()
Write-Output "listening on 0.0.0.0:$port"

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $requestLine = $reader.ReadLine()
    while ($true) {
      $line = $reader.ReadLine()
      if ([string]::IsNullOrEmpty($line)) { break }
    }

    $status = 200
    $bytes = $null
    $ctype = 'application/octet-stream'

    if ($requestLine -match '^GET\s+([^\s?]+)') {
      $rel = [System.Uri]::UnescapeDataString($Matches[1]).TrimStart('/').Replace('/', '\')
      if ([string]::IsNullOrEmpty($rel)) { $rel = 'index.html' }
      $file = [System.IO.Path]::GetFullPath((Join-Path $root $rel))
      if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        if ($mime.ContainsKey($ext)) { $ctype = $mime[$ext] }
      } else {
        $status = 404
      }
    } else {
      $status = 400
    }

    if ($null -eq $bytes) { $bytes = [System.Text.Encoding]::UTF8.GetBytes("$status Not Found") }
    $header = "HTTP/1.1 $status OK`r`nContent-Type: $ctype`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    $stream.Write($bytes, 0, $bytes.Length)
  } catch {} finally {
    $client.Close()
  }
}
