. (Join-Path $PSScriptRoot Midterm.ps1)


$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Challange 1`n"
$Prompt += "2 - Challange 2`n"
$Prompt += "3 - Challange 3`n"
$Prompt += "4 - Exit`n"

$looping = $true


while($looping){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 1){

        $challange1 = Get-IOCs

        Write-Host "This is the output for challange 1: Write a PowerShell function that obtains IOC from the given web page."

        foreach ($line in $challange1) {
            Write-Output $line
        }
    }

    elseif($choice -eq 2){

        $challenge2 = Get-ApacheLogs

        Write-Host "This is the output for challange 2: Write a PowerShell function that obtains apache access logs."

        foreach ($line in $challenge2) {
            Write-Output $line
        }

    }

    elseif($choice -eq 3){

    $logs = Get-ApacheLogs

    $iocs = Get-IOCs

    $suspiciousLogs = Match-LogsWithIOCs -logs $logs -iocs $iocs

    foreach ($line in $suspiciousLogs) {
        Write-Output $line
    }
    }

    elseif($choice -eq 4){
    Write-Host "BYE!"
    $looping = $false 
    }
    }