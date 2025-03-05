function ApacheLogs1() { 
    $logsNotFormatted = Get-Content C:\xampp\apache\logs\access.log 
    $stableRecords = @()

    for ($i=0; $i -lt $logsNotFormatted.Count; $i++) {
        $words = $logsNotFormatted[$i] -split " "

        $stableRecords += [PSCustomObject]@{
            "IP"        = $words[0]
            "Time"      = $words[3].Trim("[")
            "Method"    = $words[5].Trim('"')
            "Page"      = $words[6]
            "Protocol"  = $words[7].Trim('"')
            "Response"  = $words[8]
            "Referrer"  = $words[10].Trim('"')
            "Client"    = $words[11..($words.Count - 1)] -join " "
        }
    }

    return $stableRecords | Where-Object { $_.IP -like "10.*" } | Select-Object -Last 10
}
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}

function getFailedLogins($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.InstanceID -eq "4625" }

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account=""
    $domain="" 

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }

    }

    return $failedloginsTable
}

$stableRecords = ApacheLogs1 $stableRecords | Format-Table -AutoSize -Wrap