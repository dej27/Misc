Function DJ_Out-BASE64
{
	<#
		.SYNOPSIS
		Outputs base64 encoded string	
	
		.DESCRIPTION
		Takes in unicode string then transforms into base64 string
	
		.EXAMPLE
		DJ_Out-BASE64 -InputString 'test'
		'test' | DJ_Out-BASE64
	
		.NOTES
		Author: Delonte E Johnson
	#>
	
	[cmdletbinding()]
	
	Param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[string]$InputString
	)
	
	Begin { }
	
	Process
	{
		[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($InputString))
	}
	
	End { }
}