$root = "C:\Users\jasen\OneDrive\Documents\New project 2\strategy_reg_downloads\_monitor\consultations"
$zipDir = Join-Path $root "zipper"

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (!(Test-Path $zipDir)) {
    New-Item -ItemType Directory -Path $zipDir | Out-Null
}

$folders = Get-ChildItem -Path $root -Directory

foreach ($folder in $folders) {

    if ($folder.Name -eq "zipper") { continue }

    $zipPath = Join-Path $zipDir ($folder.Name + ".zip")

    if (Test-Path $zipPath) {
        Write-Host "Skip: $zipPath"
        continue
    }

    Write-Host "Zipping (flat): $($folder.Name)"

    $files = Get-ChildItem -Path $folder.FullName -File -Recurse

    if ($files.Count -eq 0) {
        Write-Host "Skip empty: $($folder.Name)"
        continue
    }

    $zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')

    $names = @{}

    foreach ($file in $files) {

        $name = $file.Name

        # Проверка за дубликати
        if ($names.ContainsKey($name)) {
            Write-Warning "Duplicate file name detected: $name → skipping file: $($file.FullName)"
            continue
        }

        $names[$name] = $true

        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zip,
            $file.FullName,
            $name,
            [System.IO.Compression.CompressionLevel]::Optimal
        )
    }

    $zip.Dispose()
}