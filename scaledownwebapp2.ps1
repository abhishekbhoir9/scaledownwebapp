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
Install-Module -Name AzureRM -AllowClobber
Import-Module -Name AzureRM
# Deployment Variables
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUserName, $GlobalAdminPassword) # Creating the GlobalAdmin credential object

Login-AzureRmAccount -Credential $credential -SubscriptionId $SubscriptionId 

$AzureSubscriptions = Get-AzureRMSubscription
foreach ($subscription in $AzureSubscriptions) 
   {
    	Select-AzureRmSubscription -SubscriptionName $subscription.Name
    
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
	    if ($app.ServerFarmWithRichSkuName -eq 'scaledownsaasplan') 
            { #$app.ServerFarmWithRichSkuName
                $name = $app.ServerFarmWithRichSkuName
                Set-AzureRmAppServicePlan -Name $name -ResourceGroupName $rg -Tier "Free"
            }
        }
    
    }




    # # Stop Deployment Transcript
   # Stop-Transcript

    # ############### End of Script ###############
