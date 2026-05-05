$ErrorActionPreference = "Continue"
$referencePath = "Reference"
$minerUPath = "MinerU"

# PDF to folder mapping (PDF name prefix -> folder name pattern)
$mapping = @{
    'DBF_宝天曼' = '*宝天曼*'
    'DBF_小浪底' = '*小浪底*'
    'DBF_帽儿山' = '*帽儿山*'
    'EBF_儋州' = '*儋州*'
    'EBF_哀牢山' = '*哀牢山*'
    'EBF_西双版纳_橡胶林' = '*橡胶林_西双版纳*'
    'EBF_西双版纳_热带雨林' = '*热带雨林_西双版纳*'
    'EBF_金佛山' = '*金佛山*'
    'ENF_千烟洲' = '*千烟洲*'
    'ENF_呼中' = '*呼中*'
    'GRA_三江源-垂穗披碱草' = '*三江源*'
    'GRA_元江' = '*元江*'
    'GRA_多伦' = '*多伦*'
    'GRA_当雄' = '*当雄*'
    'GRA_海北_高寒草甸' = '*高寒草甸_海北*'
    'GRA_若尔盖' = '*若尔盖*'
    'GRA_那曲' = '*那曲*'
    'GRA_锡林浩特-典型草原' = '*典型草原_锡林浩特*'
    'GRA_锡林浩特_2006' = '*刈割草原_锡林浩特*'
    'MF_长白山' = '*长白山*'
    'MF_鼎湖山' = '*鼎湖山*'
    'SAV_达茂' = '*达茂*'
    'WET_崇明东滩' = '*崇明东滩*'
    'WET_洞庭湖' = '*洞庭湖*'
    'WET_海北_高寒湿地' = '*高寒湿地_海北*'
    'WET_盘锦-芦苇湿地' = '*芦苇湿地_盘锦*'
    'WSA_普定' = '*普定*'
    'WSA_海北_高寒灌丛' = '*高寒灌丛_海北*'
    'WSA_燕山' = '*燕山*'
}

$pdfs = Get-ChildItem -Path $referencePath -Filter "*.pdf"

foreach ($pdf in $pdfs) {
    $moved = $false
    foreach ($key in $mapping.Keys) {
        if ($pdf.Name -like "$key*") {
            $pattern = $mapping[$key]
            $targetFolders = Get-ChildItem -Directory -Path $minerUPath -Filter $pattern
            
            if ($targetFolders.Count -eq 1) {
                $targetFolder = $targetFolders[0].FullName
                $targetPath = Join-Path $targetFolder $pdf.Name
                Write-Host "Moving '$($pdf.Name)' -> '$targetFolder'"
                Move-Item -Path $pdf.FullName -Destination $targetPath -Force
                $moved = $true
                break
            } elseif ($targetFolders.Count -gt 1) {
                Write-Host "WARNING: Multiple matches for '$($pdf.Name)': $($targetFolders.Name -join ', ')"
            } else {
                Write-Host "WARNING: No folder found for '$($pdf.Name)' with pattern '$pattern'"
            }
        }
    }
    if (-not $moved) {
        Write-Host "WARNING: No mapping matched for '$($pdf.Name)'"
    }
}

Write-Host "Done!"
