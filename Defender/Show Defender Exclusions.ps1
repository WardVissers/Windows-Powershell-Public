# Show Path en Process from Defender
$computer = $env:computername
$exclusions = Get-MpPreference
$exclusions.ExclusionPath | Out-File "C:\temp\$computer`_path.txt"
$exclusions.ExclusionProcess | Out-File "C:\temp\$computer`_process.txt"