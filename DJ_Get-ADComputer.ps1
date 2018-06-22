Function DJ_Get-ADComputer ()
{
	<#
		.SYNOPSIS
		Gets computers from Active Directory 
	
		.DESCRIPTION
		Gets computers from Active Directory 

		.EXAMPLE	
		DJ_Get-ADComputer win10-pc-01
		DJ_Get-ADComputer -Filter win10-pc*

		.NOTES
		Author: Delonte E. Johnson
	#>
	
	[CmdletBinding()]
	
	Param
	(
		[parameter()][string]$Filter	
	)
	
	Begin { }
	
	Process
	{
		Get-ADComputer -filter "name -like '$Filter'"
	}
	
	End { }
	
	
	
	
}