function SendAlertEmail($Body) {
    $From = "suat.gungor@mymail.champlain.edu"
    $To = "suat.gungor@mymail.champlain.edu"
    $Subject = "Suspicious Activity"

    $Password = "otjkimdjzidjaaxv" | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" `
    -Port 587 -UseSsl -Credential $Credential
}

SendAlertEmail "Body of email"