Function DJ_Get-ADPwdLastSet
{
	<#
		.SYNOPSIS
		Gets last AD password change for specified user	
	
		.DESCRIPTION
		Gets last AD password change for specified user
	
		.EXAMPLE
		DJ_Get-ADPwdLastSet -SamAccountName jsmith
		jsmith, bjones | DJ_Get-ADPwdLastSet
		
		.NOTES
		Author: Delonte E. Johnson
	
	#>
	
	[cmdletbinding()]
	
	param
	(
		[parameter(Mandatory=$true, ValueFromPipeline=$true)][string[]]$SamAccountName
	)
	
	begin { }
	
	process
	{
		$user = Get-ADUser "$SamAccountName" -Properties *
		
		If ($user.pwdlastset -ne $null)
		{
			$DateTime = [wmi]::new().ConvertFromDateTime($user.pwdlastset)
			[wmi]::new().ConvertToDateTime($DateTime)
		}
		Else
		{
			Write-Error 'Unable to retrieve password last set date. Check to make sure your account has the appropriate permissions to view this information'	
		}
		
	}
	
	end { }
}