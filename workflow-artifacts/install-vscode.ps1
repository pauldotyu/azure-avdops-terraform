# change these based on your storage account deployment
$storageAccountName = 'saethicalbedbuginstalls'
$container = 'installs'
# casing matters!
$file = 'VScode.exe'

Write-Host 'Make a temp directory'
$TempDir = 'c:\temp'
if (-not(Test-Path $TempDir)) {
  New-Item  -ItemType Directory $TempDir
}

try
{
  Write-Host 'Retrieve an access token for storage using user-assigned managed identity'
  $audience = 'https://storage.azure.com'
  $token = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$audience" -Headers @{ 'Metadata' = 'true' }
  Write-Host $token.token_type 'token retrieved'

  Write-Host 'Retrieve installer from storage container'
  $filePath = (Join-Path $TempDir $file)
  $blob = "https://$storageAccountName.blob.core.windows.net/$container/$file"
  Invoke-RestMethod -Method GET -Uri $blob -Headers @{
      'Authorization' = $token.token_type + " " + $token.access_token
      'x-ms-version'  = '2019-02-02'
  } -OutFile $filePath
  Write-Host $filePath 'retrieved'

  # Install app if the file was downloaded properly
  if (Test-Path $filePath) {
    Write-Host 'Install' $file
    # $filePath /?
    $proc = Start-Process -FilePath $filePath -Argument "/VERYSILENT /NORESTART /SP-" -Passthru
    Do {Start-Sleep -Milliseconds 500} Until ($proc.HasExited)
    Write-Host $file 'installed'
  } else {
    throw 'Hmmm, installer not downloaded after all'
  }

  Write-Host 'Clean up temp directory'
  if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse
  }
}
catch
{
   Write-Error "This thing has crashed and burned, nice job!" -ErrorAction Stop
   exit 1  # packer will recognize failure at this point
}
