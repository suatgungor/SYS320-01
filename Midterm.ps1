function Get-IOCs {
    $Scraped_page = Invoke-WebRequest -TimeoutSec 10 -Uri "http://10.0.17.6/IOC.html"
    $rows = $Scraped_page.ParsedHtml.getElementsByTagName("tr")
    $results = @()

        for ($i = 1; $i -lt $rows.length; $i++) {
            $cells = $rows[$i].getElementsByTagName("td")

            $pattern = $cells[0].innerText.Trim()
            $desc = $cells[1].innerText.Trim()

            $results += "$pattern`t$desc"
        

    }

    return $results
}

function Get-ApacheLogs {
    $logPath = "C:\Users\champuser\Desktop\Midterm\access.log"
    $results = @()

    foreach ($line in Get-Content $logPath) {
        $parts = $line.Split(" ")

        $ip = $parts[0]
        $time = $line -split "\[|\]" | Select-Object -Index 1
        $method = $parts[5].Trim('"')
        $page = $parts[6]
        $protocol = $parts[7].Trim('"')
        $response = $parts[8]
        $referrer = $line -split '"' | Select-Object -Index 3

        $results += "$ip`t$time`t$method`t$page`t$protocol`t$response`t$referrer"
    }

    return $results
}

function Match-LogsWithIOCs {
    $logs = Get-ApacheLogs
    $iocs = Get-IOCs
    $matched = @()

    foreach ($log in $logs) {
        $fields = $log -split "`t"
        $page = $fields[3]

        foreach ($ioc in $iocs) {
            $iocPattern = ($ioc -split "`t")[0]
            if ($page -like "*$iocPattern*") {
                $matched += $log
                break
            }
        }

    }

    return $matched
}
