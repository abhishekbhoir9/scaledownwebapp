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
    [ValidateNotNullOrEmpty()]
    [guid]
    $TenantId,

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
#Install-Module -Name AzureRM -AllowClobber
#Import-Module -Name AzureRM
# Deployment Variables
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUserName, $GlobalAdminPassword) # Creating the GlobalAdmin credential object

Login-AzureRmAccount -Credential $credential -TenantId $TenantId
#-SubscriptionId $SubscriptionId 

$AzureSubscriptions = Get-AzureRMSubscription -TenantId $TenantId
foreach ($subscription in $AzureSubscriptions) 
   {
    	Select-AzureRmSubscription -SubscriptionId $subscription.Id -TenantId $TenantId
	#-TenantId c7f41dc4-b09e-4561-99de-efd4f9592fec
    
	 $app_services_plans = Get-AzureRmAppServicePlan
         foreach ($app in $app_services_plans) 
        {

         $id = ($app).ID
	     $rgposition = $id.Split("/")
	     $rg = $rgposition[4]
         $values = $app.Tags
            #scale down web app to Free Tier
            if ($app.ServerFarmWithRichSkuName -eq 'appserviceplanforwebappfree')
            { 
                foreach ($value in $values){
                if(-Not ($value.Values -eq "Do not scale down"))
                {
                $name = $app.ServerFarmWithRichSkuName
                Set-AzureRmAppServicePlan -Name $name -ResourceGroupName $rg -Tier "Free"
                }
               }
            }
	        if ($app.ServerFarmWithRichSkuName -eq 'scaledownsaasplan')
            {
                foreach ($value in $values){
                if(-Not ($value.Values -eq "Do not scale down"))
                {
                $name = $app.ServerFarmWithRichSkuName
                Set-AzureRmAppServicePlan -Name $name -ResourceGroupName $rg -Tier "Free"
                }
               }

            } 
        }
    
    }




    # # Stop Deployment Transcript
   # Stop-Transcript

    # ############### End of Script ###############
