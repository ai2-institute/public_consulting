# Изходна директория за всички файлове
$destination = "C:\Users\jasen\OneDrive\Documents\New project 2\strategy_reg_downloads\flat"

# Създава директорията ако не съществува
if (!(Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination | Out-Null
}

# Коренова директория за обхождане
$source = "C:\Users\jasen\OneDrive\Documents\New project 2\strategy_reg_downloads\_monitor\consultations"

# Разширения за търсене
$extensions = @("*.md", "*.json", "*.txt")

foreach ($ext in $extensions) {
    Get-ChildItem -Path $source -Recurse -File -Filter $ext | ForEach-Object {

        # Ако има файлове със същото име — добавя timestamp
        $targetFile = Join-Path $destination $_.Name

        if (Test-Path $targetFile) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $extension = $_.Extension
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"

            $targetFile = Join-Path $destination "$name-$timestamp$extension"
        }

        Copy-Item $_.FullName -Destination $targetFile
    }
}

Write-Host "Готово. Всички md/json/txt файлове са копирани в $destination"