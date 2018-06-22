Function DJ_Get-SystemInfo
{
    <#
		.SYNOPSIS
		Get basic system info 
	
		.DESCRIPTION
		Captures basic system info using WMI. 
        Captured information includes: Computer Name, Serial Number, Manufacturer, Model, Processor Info, Total Memory, Operating System Info, System Drive Info, Network Adapter Info, Local Date/Time, Last Boot-up Time

		.EXAMPLE
		DJ_Get-SystemInfo -ComputerName 'localhost'
		DJ_Get-SystemInfo -ComputerName 'Computer1', 'Computer2' -Credentials $cred
		'Computer1', 'Computer2' | DJ_Get-SystemInfo | Out-GridView
	
		.NOTES
		Author: Delonte E. Johnson
	#>
    
    [cmdletbinding()]

    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]] $Computername,

        [Parameter()]
		[System.Management.Automation.PSCredential][System.Management.Automation.CredentialAttribute()]$Credential
    )

    Begin { }

    Process
    {
        
        ForEach ($computer in $Computername)
        {
            If ($Credential -eq $null)
            {                                                                                                                                                            
                Try
                {
                    $Computersystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer -ErrorAction Stop
	                $BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName $computer
	                $processor = Get-WmiObject -Class Win32_Processor -ComputerName $computer
	                $memory = Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $computer
	                $operatingsystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
	                $disk = gwmi -Class win32_logicaldisk -ComputerName $computer | where { $_.DeviceID -eq $env:SystemDrive }
	                $adapter = Get-WmiObject -Class win32_NetworkAdapterConfiguration -ComputerName $computer | Where { $_.IPAddress -ne $null }

                    $Props = [ordered]@{
		            'Computer Name' = $computersystem.Name;
		            'Serial Number' = $BIOS.SerialNumber;
		            'Computer Manufacturer' = $computersystem.Manufacturer;
		            'Computer Model' = $computersystem.Model;
		            'System Type' = $computersystem.SystemType;
		            'Processor' = $processor.Name;
		            'Physical Memory' = "{0:N2} GB" -f ($($memory.Capacity | Measure -Sum).Sum/1GB);
		            'Operating System' = $operatingsystem.Caption;
		            'OS Install Date' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.InstallDate);
		            'OS Architecture' = $operatingsystem.OSArchitecture;
		            'OS Version' = $operatingsystem.Version;
		            'Local Date/Time' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.LocalDateTime);
		            'Last Boot-up Time' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.LastBootUpTime);
		            'System Drive' = $disk.DeviceID;
		            'Disk Size' = "{0:N2} GB" -f ($disk.Size/1GB);
		            'Free Space' = "{0:N2} GB" -f ($disk.FreeSpace/1GB);
		            'Network Adapter' = $adapter.Description;
		            'MAC Address' = $adapter.MACAddress;
		            'IPv4 Address' = $adapter.IPAddress[0];
		            'Subnet (IPv4)' = $adapter.IPSubnet[0];
		            'Gateway (IPv4)' = $adapter.DefaultIPGateway[0];
		            'DNS Domain' = $adapter.DNSDomain}
	
                }
                Catch
                {
                    Write-Error $_

                }#End Try

            }#End If ($Credential -eq $null)
            Else
            {
                Try
                {
                    $Computersystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer -Credential $Credential -ErrorAction Stop
	                $BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName $computer -Credential $Credential
	                $processor = Get-WmiObject -Class Win32_Processor -ComputerName $computer -Credential $Credential
	                $memory = Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $computer -Credential $Credential
	                $operatingsystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer -Credential $Credential
	                $disk = gwmi -Class win32_logicaldisk -ComputerName $computer -Credential $Credential | where { $_.DeviceID -eq $env:SystemDrive }
	                $adapter = Get-WmiObject -Class win32_NetworkAdapterConfiguration -ComputerName $computer -Credential $Credential | Where { $_.IPAddress -ne $null }

                    $Props = [ordered]@{
		            'Computer Name' = $computersystem.Name;
		            'Serial Number' = $BIOS.SerialNumber;
		            'Computer Manufacturer' = $computersystem.Manufacturer;
		            'Computer Model' = $computersystem.Model;
		            'System Type' = $computersystem.SystemType;
		            'Processor' = $processor.Name;
		            'Physical Memory' = "{0:N2} GB" -f ($($memory.Capacity | Measure -Sum).Sum/1GB);
		            'Operating System' = $operatingsystem.Caption;
		            'OS Install Date' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.InstallDate);
		            'OS Architecture' = $operatingsystem.OSArchitecture;
		            'OS Version' = $operatingsystem.Version;
		            'Local Date/Time' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.LocalDateTime);
		            'Last Boot-up Time' = [System.Management.ManagementDateTimeConverter]::ToDateTime($operatingsystem.LastBootUpTime);
		            'System Drive' = $disk.DeviceID;
		            'Disk Size' = "{0:N2} GB" -f ($disk.Size/1GB);
		            'Free Space' = "{0:N2} GB" -f ($disk.FreeSpace/1GB);
		            'Network Adapter' = $adapter.Description;
		            'MAC Address' = $adapter.MACAddress;
		            'IPv4 Address' = $adapter.IPAddress[0];
		            'Subnet (IPv4)' = $adapter.IPSubnet[0];
		            'Gateway (IPv4)' = $adapter.DefaultIPGateway[0];
		            'DNS Domain' = $adapter.DNSDomain}
	
                }
                Catch
                {
                    Write-Error $_

                }#End Try

            }#End Else

            $ComputerObject = New-Object PSObject -Property $Props
            $ComputerObject

        }#End ForEach

    }#End Process

    End { }

}