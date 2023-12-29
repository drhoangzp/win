# Lấy thông tin hệ thống bằng Get-CimInstance
$systemInfo = Get-CimInstance Win32_OperatingSystem
$bios = Get-WmiObject -Class Win32_BIOS

# Lấy thời gian hiện tại
$currentTime = Get-Date

# Hiển thị thời gian
Write-Host ""
Write-Host "Current Time: $($currentTime.ToString('yyyy-MM-dd HH:mm:ss'))"

# Lấy thông tin hệ thống bằng Get-CimInstance
$computerSystem = Get-CimInstance Win32_ComputerSystem

# Hiển thị thông tin hệ thống
Write-Host ""
Write-Host "Hostname: $($computerSystem.Name)"
Write-Host ""
Write-Host "Model: $($computerSystem.Model)"
Write-Host ""
Write-Host "Serial Number: $($bios.SerialNumber)"
Write-Host ""
Write-Host "Operating System: $($systemInfo.Caption)"
Write-Host ""
# Lấy thông tin về hệ thống
$operatingSystem = Get-CimInstance Win32_OperatingSystem

# Hiển thị thông tin về Registered Owner và Registered Organization
Write-Host "Registered Owner: $($operatingSystem.RegisteredUser)"
Write-Host "Registered Organization: $($operatingSystem.Organization)"

Write-Host ""
# Lấy thông tin về BIOS
$BIOS = Get-CimInstance Win32_BIOS

# Hiển thị thông tin về BIOS
Write-Host "BIOS Version: $($BIOS.Version)"
Write-Host ""
Write-Host "RAM :"
# Lấy thông tin về bộ nhớ vật lý
$physicalMemory = Get-WmiObject -Class Win32_PhysicalMemory

# Hiển thị thông tin với điều kiện chuyển đổi SMBIOSMemoryType và Capacity
$physicalMemory | ForEach-Object {
    $memoryType = $_.SMBIOSMemoryType
    $memoryTypeText = if ($memoryType -eq 26) { "DDR4" } elseif ($memoryType -eq 24) { "DDR3" } else { "Unknown" }
    
    $capacityGB = [math]::round($_.Capacity / 1GB, 0)
    $capacityText = "$capacityGB GB"
    
    $_ | Select-Object DeviceLocator, PartNumber, @{Name='Capacity'; Expression={$capacityText}}, Speed, @{Name='MemoryType'; Expression={$memoryTypeText}}
} | Format-Table
Write-Host "ROM :"

# Lấy thông tin về ổ cứng
$diskDrive = Get-CimInstance Win32_DiskDrive

# Hiển thị thông tin với đơn vị GB trong một bảng
$diskDrive | ForEach-Object {
    $model = $_.Model
    $type = $_.MediaType
    $capacityGB = [math]::round($_.Size / 1GB, 2)

    # Hiển thị thông tin trong bảng
    $_ | Select-Object @{Name='Model'; Expression={$model}}, @{Name='Type'; Expression={$type}}, @{Name='Capacity (GB)'; Expression={$capacityGB}}
} | Format-Table

Write-Host "CPU :"
# Lấy thông tin về bộ xử lý
$processor = Get-CimInstance Win32_Processor

# Hiển thị thông tin với đơn vị GB trong một bảng
$processor | ForEach-Object {
    $processorName = $_.Name
    $numberOfCores = $_.NumberOfCores
    $numberOfLogicalProcessors = $_.NumberOfLogicalProcessors

    # Hiển thị thông tin trong bảng
    $_ | Select-Object @{Name='Processor Name'; Expression={$processorName}}, @{Name='Cores'; Expression={$numberOfCores}}, @{Name='Threads'; Expression={$numberOfLogicalProcessors}}
} | Format-Table

# Lấy thông tin về card mạng có địa chỉ IP
$networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }

# Hiển thị thông tin về card mạng trong một bảng
$networkAdapters | ForEach-Object {
    $adapterName = $_.Description
    $adapterType = $_.Caption

    # Lấy địa chỉ IPv4 và IPv6 (nếu có)
    $ipv4Address = $_.IPAddress | Where-Object { $_ -like '*.*.*.*' }
    $ipv6Address = $_.IPAddress | Where-Object { $_ -like '*:*' }

    Write-Host "Network Adapter:"
    Write-Host "  Adapter Name: $($adapterName)"
    Write-Host "  Adapter Type: $($adapterType)"

    # Hiển thị thông tin IPv4
    if ($ipv4Address -ne $null) {
        Write-Host "  IPv4 Address: $($ipv4Address -join ', ')"
    }

    # Hiển thị thông tin IPv6
    if ($ipv6Address -ne $null) {
        Write-Host "  IPv6 Address: $($ipv6Address -join ', ')"
    }
} | Format-Table

# Lấy thông tin pin
powercfg /batteryreport /xml /output batteryreport.xml

$battery = [xml](Get-Content batteryreport.xml)

try {
    $health = [pscustomobject]@{
        Type               = $battery.BatteryReport.Batteries.Battery.Id;
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity;
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity;
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100);
    }
    Write-Host ""
    Write-Host "Battery:"
    Write-Host "  Type: $($health.Type)"
    Write-Host "  Design Capacity: $($health.DesignCapacity) mWh"
    Write-Host "  Full Charge Capacity: $($health.FullChargeCapacity) mWh"
    Write-Host "  Max Capacity: $($health.MaxCapacity)%"
    Write-Host "  Failure Capacity: $($health.FailureCapacity)%"
    Write-Host ""

} catch {
    $health1 = [pscustomobject]@{
        Type               = $battery.BatteryReport.Batteries.Battery.Id[0];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[0];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100);
    }

    $health2 = [pscustomobject]@{
        Type               = $battery.BatteryReport.Batteries.Battery.Id[1];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[1];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100);
    }

    Write-Host ""
    Write-Host "Battery 1:"
    Write-Host "  Type: $($health1.Type)"
    Write-Host "  Design Capacity: $($health1.DesignCapacity) mWh"
    Write-Host "  Full Charge Capacity: $($health1.FullChargeCapacity) mWh"
    Write-Host "  Max Capacity: $($health1.MaxCapacity)%"
    Write-Host "  Failure Capacity: $($health1.FailureCapacity)%"
    Write-Host ""
    Write-Host "Battery 2:"
    Write-Host "  Type: $($health2.Type)"
    Write-Host "  Design Capacity: $($health2.DesignCapacity) mWh"
    Write-Host "  Full Charge Capacity: $($health2.FullChargeCapacity) mWh"
    Write-Host "  Max Capacity: $($health2.MaxCapacity)%"
    Write-Host "  Failure Capacity: $($health2.FailureCapacity)%"
    Write-Host ""
}
