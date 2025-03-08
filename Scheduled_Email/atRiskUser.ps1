. (Join-Path $PSScriptRoot Email.ps1)
function getFailedLogins($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-$timeBack") | Where { $_.InstanceID -eq "4625" }

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account = ""
    $domain = ""

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"

    if ($usrlines.Count -gt 1) {
        $usr = $usrlines[1].Split(":")[1].trim()
    } else {
        $usr = "Unknown"
    }

    if ($dmnlines.Count -gt 1) {
        $dmn = $dmnlines[1].Split(":")[1].trim()
    } else {
        $dmn = "Unknown"
    }

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }
    }

    return $failedloginsTable
}

function atRiskUsers() {
    $failedLogins = getFailedLogins 90

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
    foreach ($user in $userFailures.Keys) {
        if ($userFailures[$user] -gt 5) { 
            $atRiskUsers += [PSCustomObject]@{
                "User" = $user
                "Failed Logins" = $userFailures[$user]
            }
        }
    }

    if ($atRiskUsers.Count -gt 0) {
        Write-Host "Sending Alert Email for At-Risk Users..." | Out-String

        $emailBody = "At-Risk Users Report:`n`n"
        foreach ($user in $atRiskUsers) {
            $emailBody += "User: $($user.User) - Failed Logins: $($user.'Failed Logins')`n"
        }

        SendAlertEmail $emailBody 
    } else {
        Write-Host "No at-risk users found in the last 90 days." | Out-String
    }

    return $atRiskUsers
}
