<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.EXAMPLE

.EXAMPLE

#>

[CmdletBinding()]
param
(
    # Enter Subscription Id for deployment.
    [Parameter(Mandatory=$true)]
    [Alias("Subscription")]
    [ValidateNotNullOrEmpty()]
    [guid]
    $SubscriptionId,

    # Enter AAD Username with Owner permission at subscription level and Global Administrator at AAD level.
    [Parameter(Mandatory=$true)]
    [Alias("Username")]
    [ValidateNotNullOrEmpty()]
    [string]
    $GlobalAdminUserName,

    # Enter AAD Username password as securestring.
    [Parameter(Mandatory=$true)]
    [Alias("Password")]
    [ValidateNotNullOrEmpty()]
    [securestring]
    $GlobalAdminPassword
)

# Deployment Variables
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUserName, $GlobalAdminPassword) # Creating the GlobalAdmin credential object

try {
    Write-Verbose "Connecting to the Global Administrator Account for Subscription $subscriptionId."
    Login-AzureRmAccount -Credential $credential -Subscription $subscriptionId -ErrorAction Stop
    Write-Verbose "Established connection to Global Administrator Account."
}
catch {
    Throw "Failed to connect to the Global Administrator Account. Run 'Login-AzureRmAccount -Subscription $subscriptionId' to manually troubleshoot."
}

         $app_services_plans = Get-AzureRmAppServicePlan
         foreach ($app in $app_services_plans) 
        {   
         $id = ($app).ID
	     $rgposition = $id.Split("/")
	     $rg = $rgposition[4]
            #scale down web app to Free Tier
            if ($app.ServerFarmWithRichSkuName -eq 'appserviceplanforwebappfree') 
            { #$app.ServerFarmWithRichSkuName
                $name = $app.ServerFarmWithRichSkuName
                Set-AzureRmAppServicePlan -Name $name -ResourceGroupName $rg -Tier "Free"
            }
        }


    # # Stop Deployment Transcript
    Stop-Transcript

    # ############### End of Script ###############
