param (
    [Parameter(Mandatory=$false)]
    $webhook_url
)

# Notification Webhook function
function Send-notification {
    param (
        [Parameter(Mandatory=$true)]
        $pretext,
        [Parameter(Mandatory=$true)]
        $text,
        [Parameter(Mandatory=$true)]
        $color,
        [Parameter(Mandatory=$false)]
        $webhook_url
    )

    
    $body = ConvertTo-Json @{
        pretext = "$pretext"
        text = "$text"
        color = "$color"
    }
    try {
        Invoke-RestMethod -uri $webhook_url -Method Post -body $body -ContentType 'application/json' | Out-Null
    } catch {
        Write-Error (": Update went wrong...")
    }
  }
  
  
  Send-notification `
    -pretext  "This is a title" `
    -text "                                    
    This is some text
    and some information" `
    -color "#ff0000" #Red: #ff0000 #Green: #008000