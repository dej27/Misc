Function Get-AddRemovePrograms
{
	<#
		.SYNOPSIS
		Get installed programs on local or remote computer
	
		.DESCRIPTION
		Generates list of installed programs as they appear in the Add Remove Programs control panel applet.
	
		.EXAMPLE
		Get-AddRemovePrograms -ComputerName 'localhost'
		Get-AddRemovePrograms -ComputerName 'localhost' -filter '*adobe*'
		Get-AddRemovePrograms -ComputerName 'Computer1', 'Computer2' -Credentials $cred
		'Computer1', 'Computer2' | Get-AddRemovePrograms | Out-GridView
	
		.NOTES
		Author: Delonte E. Johnson
	
	#>
	
	[CmdletBinding()]

	Param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[string[]]$ComputerName,
		
		[Parameter()]
		[string]$Filter,
		
		[Parameter()]
		[System.Management.Automation.PSCredential][System.Management.Automation.CredentialAttribute()]$Credential	
	)
	
	Begin
	{

	}
	
	Process
	{
		ForEach ($computer in $computername)
		{
			$output = $null
			
			If ($computer -eq 'localhost')
			{
				Write-Verbose "Getting installed programs for '$computer'"
				
				Try
				{
					$output = &{
						$Programs = @();
						$UninstallRegKeys = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
						$UninstallRegKeys += Get-ChildItem -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
						
						ForEach ($UninstallRegKey in $UninstallRegKeys)
						{
							$Installs = Get-ItemProperty -path $UninstallRegKey.PSPath;
							If ($Installs.DisplayName -ne $null -and
								$Installs.UninstallString -ne $null -and
								$Installs.SystemComponent -ne 1 -and
								$Install.WindowsInstaller -ne 1 -and
								$Installs.ParentKeyName -eq $Null -and
								$Installs.ReleaseType -eq $Null)
							{ $Programs += $Installs <#| Select DisplayName, DisplayVersion, Publisher, InstallDate#> }
						}; #End ForEach
						
						$Programs
						
					} #End Scripblock
				}
				Catch
				{
					Write-Error $_
					$output = [PSCustomObject]@{ 'DisplayName' = 'N/A'; 'DisplayVersion' = 'N/A'; 'Publisher' = 'N/A'; 'InstallDate' = 'N/A' }
				} #End Catch
				
			} #End If ($computer -eq 'localhost')
			Else
			{
				If ($credential -ne $null)
				{
					Write-Verbose "Getting installed programs for '$computer'"
					
					Try
					{
						$output = Invoke-Command -ComputerName $computer -Credential $credential -ErrorAction Stop -ScriptBlock `
						{
							$Programs = @();
							$UninstallRegKeys = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
							$UninstallRegKeys += Get-ChildItem -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
							
							ForEach ($UninstallRegKey in $UninstallRegKeys)
							{
								$Installs = Get-ItemProperty -path $UninstallRegKey.PSPath;
								If ($Installs.DisplayName -ne $null -and
									$Installs.UninstallString -ne $null -and
									$Installs.SystemComponent -ne 1 -and
									$Install.WindowsInstaller -ne 1 -and
									$Installs.ParentKeyName -eq $Null -and
									$Installs.ReleaseType -eq $Null)
								{ $Programs += $Installs <#| Select DisplayName, DisplayVersion, Publisher, InstallDate#> }
							}; #End ForEach
							
							$Programs
							
						} #End ScriptBlock
					}
					Catch
					{
						Write-Error $_
						$output = [PSCustomObject]@{ 'DisplayName' = 'N/A'; 'DisplayVersion' = 'N/A'; 'Publisher' = 'N/A'; 'InstallDate' = 'N/A' }
					} #End Catch
					
				} #End If ($credential -ne $null)
				Else
				{
					Write-Verbose "Getting installed programs for '$computer'"
					
					Try
					{
						$output = Invoke-Command -ComputerName $computer -ErrorAction Stop -ScriptBlock `
						{
							$Programs = @();
							$UninstallRegKeys = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
							$UninstallRegKeys += Get-ChildItem -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue
							
							ForEach ($UninstallRegKey in $UninstallRegKeys)
							{
								$Installs = Get-ItemProperty -path $UninstallRegKey.PSPath;
								If ($Installs.DisplayName -ne $null -and
									$Installs.UninstallString -ne $null -and
									$Installs.SystemComponent -ne 1 -and
									$Install.WindowsInstaller -ne 1 -and
									$Installs.ParentKeyName -eq $Null -and
									$Installs.ReleaseType -eq $Null)
								{ $Programs += $Installs <#| Select DisplayName, DisplayVersion, Publisher, InstallDate#> }
							}; #End ForEach
							
							$Programs
							
						} #End ScriptBlock
					}
					Catch
					{
						Write-Error $_
						$output = [PSCustomObject]@{ 'DisplayName' = 'N/A'; 'DisplayVersion' = 'N/A'; 'Publisher' = 'N/A'; 'InstallDate' = 'N/A' }
					} #End Catch
					
				} #End If ($credential -ne $null) Else
				
			} #End If ($computer -eq 'localhost') Else
			
			If ([string]::IsNullOrEmpty($filter))
			{
				Write-Verbose "Display all installed programs for '$computer'"
				$output | sort DisplayName | Select DisplayName, DisplayVersion, Publisher, InstallDate, @{ l = 'Computer'; e = { $computer } }
			}
			else
			{
				Write-Verbose "Displaying all installed programs for '$computer' that meet filter criteria"
				$output | sort DisplayName | Select DisplayName, DisplayVersion, Publisher, InstallDate, @{ l = 'Computer'; e = { $computer } } | where { $_.DisplayName -like "$filter" }
			}
			
		} #End ForEach
		
	} #End Process
	
	End
	{

	}
	
}
