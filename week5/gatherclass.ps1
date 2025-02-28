function gatherClasses(){
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.36/Courses.html

    $trs = $page.ParsedHtml.getElementsByTagName('tr')

    $FullTable = @()

    for ($i = 1; $i -lt $trs.length; $i++) { 

        $tds = $trs[$i].getElementsByTagName('td')
        $Times = $tds[5].innerText.Split('-')

        $FullTable += [PSCustomObject]@{
            "Class Code"   = $tds[0].innerText;
            "Title"        = $tds[1].innerText;
            "Days"         = $tds[4].innerText;
            "Time Start"   = $Times[0].Trim();
            "Time End"     = $Times[1].Trim();
            "Instructor"   = $tds[6].innerText;
            "Location"     = $tds[9].innerText;
        }
    }
    
    return $FullTable
}

function daysTranslator($FullTable){

    for ($i = 0; $i -lt $FullTable.length; $i++){
        $Days = @()

        if ($FullTable[$i].Days -like "*M*") { $Days += "Monday" }

        if ($FullTable[$i].Days -like "*T[,W,F]*") { $Days += "Tuesday"} 
    
        elseif ($FullTable[$i].Days -like "*T*") {$Days += "Tuesday" }
      
        if ($FullTable[$i].Days -like "*W*") { $Days += "Wednesday" }

        if ($FullTable[$i].Days -like "*Th*") { $Days += "Thursday" }

        if ($FullTable[$i].Days -like "*F*") { $Days += "Friday" }

        $FullTable[$i].Days = $Days
    }

    return $FullTable
}
