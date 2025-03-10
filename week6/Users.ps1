

<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for enabled users
****************************** #>
function getEnabledUsers(){

  $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
  return $enabledUsers

}



<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for not enabled users
****************************** #>
function getNotEnabledUsers(){

  $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" } | Select-Object Name, SID
  return $notEnabledUsers

}

function checkUser($name) {
    $userList = net user
    $userLines = $userList -split "`n"
    $userLines = $userLines | Select-Object -Skip 4
    $filteredUsers = @()
    #this was needed since net user was showing the usernames in multiple columns it was having trouble searching but this makes it a list
    #which makes -contains find them easily
    foreach ($line in $userLines) {
        if ($line -match '\S') {
            $filteredUsers += $line -split '\s+'
        }
    }

    if ($filteredUsers -contains $name) {
        return $true
    } else {
        return $false
    }
}


<# ******************************
# Create a function that adds a user
****************************** #>
function createAUser($name, $password){
    
    $convertplain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    )

    # Create user with net user
    cmd /c "net user $name $plainpass /add /Y"

    # Ensure password does not expire
    cmd /c "wmic useraccount where name='$name' set PasswordExpires=false"

    # Disable user upon creation
    cmd /c "net user $name /active:no"

    Write-Host "User '$name' has been created."
}


function checkPassword ($password) {
            if($password.Length -ge 6){
                if($password -match "[A-Za-z]"){
                    if($password -match "[0-9]"){
                        if($password -match "[!@#$%^&*()]"){
                            return $true;
                    }
                  }
                }
                } return $false 
            }



function removeAUser($name){
   
   $userToBeDeleted = Get-LocalUser | Where-Object { $_.name -ilike $name }
   Remove-LocalUser $userToBeDeleted
   
}



function disableAUser($name){
   
   $userToBeDeleted = Get-LocalUser | Where-Object { $_.name -ilike $name }
   Disable-LocalUser $userToBeDeleted
   
}

function getEnabledUsers() {
    $userList = net user
    return $userList
}

