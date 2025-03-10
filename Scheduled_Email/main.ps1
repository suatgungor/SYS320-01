. (Join-Path $PSScriptRoot configuration.ps1)
. (Join-Path $PSScriptRoot Email.ps1)
. (Join-Path $PSScriptRoot Scheduler.ps1)
. (Join-Path $PSScriptRoot atRiskUser.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Show Configuration`n"
$Prompt += "2 - Change Configuration`n"
$Prompt += "3 - Exit`n"


$looping = $true
$Failed = atRiskUsers
$configuration = readConfiguration  
if ($Failed.Count -gt 0) {
    SendAlertEmail ($Failed | Format-Table | Out-String)
}
ChooseTimeToRun $configuration.ExecutionTime

while($looping){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 1){
        Write-Host "Showing the configuration"

        $config = readConfiguration

        $config | Format-Table -AutoSize
    }

    elseif($choice -eq 2){

         changeConfiguration

    }
        elseif($choice -eq 3){
        Write-Host "BYE!"
        $looping = $false 
    }
    }