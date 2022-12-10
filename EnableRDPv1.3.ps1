$TSName = 'fDenyTSConnections'
$TSKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
$Regvalue =@($null)
$Regvalue =@(Get-ItemPropertyValue -Path $TSKey -Name "$TSName")

$RDPFirewallRule = $null
$RDPFirewallRule = @{}
 
$RDPShadow = Get-NetFirewallRule -DisplayName "Remote Desktop - Shadow (TCP-In)" | Select-Object Name, Enabled
$RDPTCP = Get-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)" | Select-Object Name, Enabled
$RDPUDP = Get-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)" | Select-Object Name, Enabled

$RDPRules =@($RDPShadow, $RDPTCP, $RDPUDP)


ForEach ($Rule in $RDPRules)
{
    $RDPFirewallRule.add($Rule.name,$Rule.enabled)
}


if (($RDPFirewallRule.Values) -contains "False")
{
    Set-NetFirewallRule -DisplayName "Remote Desktop - Shadow (TCP-In)" -Enabled True
    Set-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)" -Enabled True
    Set-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)" -Enabled True
}


if (($Regvalue) -contains "1"){

    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0 -Force | Out-Null

} 


else
{
    Write-Output "RDP is enabled."
}
