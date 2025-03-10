﻿. (Join-Path $PSScriptRoot gatherclas.ps1)

$FullTable = gatherClasses

$updatedClasses = daysTranslator $FullTable

$updatedClasses | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | Where-Object { $_.Instructor -like "Furkan Paligu" }

$FullTable = gatherClasses

$FullTable = daysTranslator $FullTable

$FullTable | Where-Object { ($_.Location -eq "JOYC 310") -and ($_.Days -like "*Monday*") } |
    Sort-Object "Time Start" |
    Select-Object "Time Start", "Time End", "Class Code" 
 

 $ITInstructors = $FullTable | Where-Object {
               ( $_."Class Code" -like "SYS*") -or
               ( $_."Class Code" -like "NET*") -or
               ( $_."Class Code" -like "SEC*") -or
               ( $_."Class Code" -like "FOR*") -or
               ( $_."Class Code" -like "CSI*") -or
               ( $_."Class Code" -like "DAT*")
    } |
    Select-Object "Instructor" |
    Sort-Object "Instructor" -Unique

$ITInstructors

$groupinsturctor = $FullTable |
    Where-Object { $_.Instructor -in $ITInstructors.Instructor } |
    Group-Object -Property "Instructor" | Select-Object Count, Name | Sort-Object Count -Descending

$groupinsturctor