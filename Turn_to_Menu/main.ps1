. (Join-Path $PSScriptRoot ApacheLogs1.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Display last 10 Apache logs`n"
$Prompt += "2 - Display last 10 failed logins`n"
$Prompt += "3 - List At-Risk Users`n"
$Prompt += "4 - Visit champlain.edu`n"
$Prompt += "5 - Exit`n"


$looping = $true

while($looping){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 1){
        Write-Host "Showing last 10 Apache logs..."
            ApacheLogs1 | Select-Object -Last 10 | Format-Table -AutoSize
        
    }

    elseif($choice -eq 2){

         $numFailures = Read-Host "Enter the number of failed logins you want to see"

         Write-Host "These are the last $numFailures failed attempts"
         $failedLogins = getFailedLogins 90  
         $failedLogins | Select-Object -Last $numFailures | Format-Table
    }

    elseif($choice -eq 3){
           
        $days = Read-Host "How many days do you wana check for a failed login attemp"
        $failedLogins = getFailedLogins $days

        $userFailures = @{}

        foreach ($entry in $failedLogins) {
            $user = $entry.User
            if ($userFailures.ContainsKey($user)) {
                $userFailures[$user] += 1
            } else {
                $userFailures[$user] = 1
            }
        }

        $atRiskUsers = @()
        $dayscheck = Read-Host "How many failed login attemps do you wana check for"
        foreach ($user in $userFailures.Keys) {
            if ($userFailures[$user] -gt $dayscheck) {
                $atRiskUsers += "$user - Failed Logins: $($userFailures[$user])"
            }
        }

        if ($atRiskUsers.Count -gt 0) {
            Write-Host "At-Risk Users (More than $dayscheck failed logins in the last $days days):"
            $atRiskUsers | ForEach-Object { Write-Host $_ }
            
            Write-Host "These are the failed attempts..."

            $failedLogins | Select-Object -Last $dayscheck | Format-Table
        } else {
            Write-Host "No at-risk users found in the last $days days."
        }
    }
    elseif($choice -eq 4){
        $chromeProcess = Get-Process 'chrome' -ErrorAction SilentlyContinue

        if ($chromeProcess) {
            $chromeProcess | Stop-Process
        }
        else {
            Write-Host "Opening champlain.edu"
            Start-Process "chrome.exe" "https://www.champlain.edu"
        }
        }
    elseif($choice -eq 5){
        Write-Host "BYE!"
        $looping = $false 
    }
    }