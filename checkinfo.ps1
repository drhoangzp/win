# Lấy thông tin hệ thống bằng Get-CimInstance
$systemInfo = Get-CimInstance Win32_OperatingSystem
$bios = Get-WmiObject -Class Win32_BIOS

# Hiển thị thông tin hệ thống
Write-Host ""
Write-Host "Time: $($health.Time)"
Write-Host ""
Write-Host "Serial Number: $($bios.SerialNumber)"
Write-Host "Operating System: $($systemInfo.Caption)"

# Lấy thông tin hệ thống bằng Get-CimInstance
$operatingSystem = Get-CimInstance Win32_OperatingSystem
$computerSystem = Get-CimInstance Win32_ComputerSystem
$physicalMemory = Get-CimInstance Win32_PhysicalMemory
$diskDrive = Get-CimInstance Win32_DiskDrive
$battery = Get-CimInstance Win32_Battery
$processor = Get-CimInstance Win32_Processor

# Hiển thị thông tin hệ thống
Write-Host "Hostname: $($computerSystem.Name)"
Write-Host "Model: $($computerSystem.Model)"
Write-Host "Operating System: $($operatingSystem.Caption)"
Write-Host "Version: $($operatingSystem.Version)"
Write-Host "Build Number: $($operatingSystem.BuildNumber)"
Write-Host "Service Pack: $($operatingSystem.ServicePackMajorVersion).$($operatingSystem.ServicePackMinorVersion)"
Write-Host "Installed RAM: $([math]::round($physicalMemory.Capacity / 1GB, 2)) GB"

# Lấy thông tin ổ cứng
Write-Host "Disk Drive:"
foreach ($drive in $diskDrive) {
    Write-Host "  Model: $($drive.Model)"
    Write-Host "  Type: $($drive.MediaType)"
    Write-Host "  Capacity: $([math]::round($drive.Size / 1GB, 2)) GB"
}

# Lấy thông tin CPU
Write-Host "Processor: $($processor.Name)"
Write-Host "  Architecture: $($processor.Architecture)"
Write-Host "  Cores: $($processor.NumberOfCores)"
Write-Host "  Threads: $($processor.NumberOfLogicalProcessors)"

# Lấy thông tin pin
if ($battery) {
    Write-Host "Battery:"
    Write-Host "  Battery Status: $($battery.BatteryStatus)"
    Write-Host "  Remaining Capacity: $($battery.EstimatedChargeRemaining)%"
} else {
    Write-Host "Battery information not available."
}
