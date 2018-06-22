Function DJ_Get-ADUser
{
    <#
		.SYNOPSIS
		Gets user information from Active Directory
	
		.DESCRIPTION
		Gets user information from Active Directory

		.EXAMPLE
		DJ_Get-ADUser -SamAccountName jsmith		
		DJ_Get-ADUser -Filter (John* | *Smith)	
		'jsmith', 'djones' | DJ_Get-ADUser | Out-GridView
	
		.NOTES
		Author: Delonte E. Johnson
	#>
	
	[cmdletbinding()]
	
	Param
	(
		[Parameter(Mandatory = $false, ValueFromPipeline = $true)]
		[string[]]$SamAccountName,
		[Parameter(Mandatory = $false)]
		[string]$Filter
	)
	
	Begin {	}
	
	Process
	{			
		If ($SamAccountName -ne $null)
		{
			Foreach ($Sam in $SamAccountName)
			{
				Get-ADUser "$Sam"
			}
		}
		ElseIf ($Filter -ne $null)
		{
			Get-ADUser -Filter "name -like '$Filter'"
		}
		Else
		{
			Write-Error 'No input provided. Please specify Sam Account Name, Full Name, or First/Last Name.'
		}
		
	}
	
	End { }
	
}