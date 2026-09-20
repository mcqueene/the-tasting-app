# https://dnsrobot.net/blog/att-dns-servers#change-dns-windows

# PowerShell: set DNS on the active adapter
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses '1.1.1.1','1.0.0.1'

# Flush the resolver cache and verify
Clear-DnsClientCache
Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex