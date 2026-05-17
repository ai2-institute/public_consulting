$root = Get-Location

Get-ChildItem -Recurse -File | ForEach-Object {
    $full = $_.FullName
    if ($full.Length -gt 240) {
        $dir = $_.DirectoryName
        $name = $_.BaseName
        $ext = $_.Extension

        # shrink to 120 chars max
        $short = $name.Substring(0, [Math]::Min(120, $name.Length)) + $ext

        $newPath = Join-Path $dir $short

        Write-Host "Renaming:`n$full`n -> $newPath`n"

        Rename-Item -LiteralPath $full -NewName $short
    }
}
