
param (
    [Parameter()]
    [switch]
    $Force
)

Get-ChildItem .\assets | ForEach-Object {
    $Metadata = Get-Content -LiteralPath "$($_.FullName)\metadata.json" -Encoding utf8 | ConvertFrom-Json

    if (!$Force.IsPresent -and !$_.Name.Contains($Metadata.unicode)) {
        return;
    };

    $EmojiName = $Metadata.tts.toString().ToCharArray()
    $EmojiName[0] = $EmojiName[0].toString().ToUpper()
    $EmojiName = $EmojiName -join '' -replace ':|\*', ''
    $Name = "[$($Metadata.group)] $EmojiName - [$($Metadata.unicode)]($($Metadata.glyph))"

    $_ | Rename-Item -NewName $Name

    if (!(Test-Path -LiteralPath "$($_.Parent.FullName)\$Name")) {
        $Name = $Name -replace '\(.*', ''

        $_ | Rename-Item -NewName $Name
    }
}
