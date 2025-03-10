#I tried pushing pushing the configpath into the function but coudlnt get it to work so i used join-path isntead
function readConfiguration { $configPath = (Join-Path $PSScriptRoot "configuration.txt")

    $configData = Get-Content $configPath

    $configObject = [PSCustomObject]@{
        "Days" = $configData[0]
        "ExecutionTime" = $configData[1]
    }

    return $configObject
}

function changeConfiguration {
    $configPath = (Join-Path $PSScriptRoot "configuration.txt")

    $days = Read-Host "Enter the days for when the logs will be obtained"
    $executionTime = Read-Host "Enter the execution time for the script this will be ran daily"

    "$days`n$executionTime" | Set-Content $configPath

    Write-Host "Configuration Changed"
}