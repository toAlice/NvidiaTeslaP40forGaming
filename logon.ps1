# copied from stackoverflow
# gain administrator privilege. useful when manually running the script.
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
    $arguments = "& '" +$myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# I'm not sure but this script may also work for other Tesla GPUs like P4. 
$DevName = "*Tesla P40*"
# the ending four digits could also be 0001, 0002, etc.
$RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\'

$RegProps = @(
	@{ # Required.
		Name = 'GridLicensedFeatures'
		PropertyType = 'DWORD'
		Value = 0x07
	}
    @{ # Required.
		Name = 'AdapterType'
		PropertyType = 'DWORD'
		Value = 0x00
	}
	@{ # Recommended. Having this will disable the virtual display provided by nVidia.
		Name = 'EnableMsHybrid'
		PropertyType = 'DWORD'
		Value = 0x01
	}
	@{ # Optional.
		Name = 'FeatureScore'
		PropertyType = 'DWORD'
		Value = 0xD1
	}
)


if (Test-Path $RegPath) {
	foreach ($RegProp in $RegProps) { 
		New-ItemProperty -Path $RegPath @RegProp -Force 
	}

	# Re-enable the device(s). consider using pnputil instead if there're multiple P40 GPUs in your system.
	Get-PnpDevice -FriendlyName $DevName | Disable-PnpDevice -Confirm:$false
	Get-PnpDevice -FriendlyName $DevName | Enable-PnpDevice -Confirm:$false

	# Reset AdapterType. 
	Set-ItemProperty -Path $RegPath -Name "AdapterType" -Value 2
}
