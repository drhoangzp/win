# Lấy thông tin hệ thống bằng Get-CimInstance
$systemInfo = Get-CimInstance Win32_OperatingSystem
$bios = Get-WmiObject -Class Win32_BIOS

# Hiển thị thông tin hệ thống
Write-Host "Serial Number: $($bios.SerialNumber)"
Write-Host "Operating System: $($systemInfo.Caption)"
Write-Host "Version: $($systemInfo.Version)"
Write-Host "Build Number: $($systemInfo.BuildNumber)"
Write-Host "Service Pack: $($systemInfo.ServicePackMajorVersion).$($systemInfo.ServicePackMinorVersion)"
Write-Host "Installed RAM: $([math]::round($systemInfo.TotalVisibleMemorySize / 1MB, 2)) GB"
Write-Host "Free Physical Memory: $([math]::round($systemInfo.FreePhysicalMemory / 1MB, 2)) GB"
Write-Host "Free Virtual Memory: $([math]::round($systemInfo.FreeVirtualMemory / 1MB, 2)) GB"