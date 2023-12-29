# Lấy thông tin hệ thống bằng Get-CimInstance
$systemInfo = Get-CimInstance Win32_OperatingSystem
$bios = Get-WmiObject -Class Win32_BIOS


# Lấy thông tin hệ thống bằng Get-CimInstance
$computerSystem = Get-CimInstance Win32_ComputerSystem

# Hiển thị thông tin hệ thống
Write-Host ""
Write-Host "Time: $($health.Time)"
Write-Host ""
Write-Host "Hostname: $($computerSystem.Name)"
Write-Host ""
Write-Host "Model: $($computerSystem.Model)"
Write-Host ""
Write-Host "Serial Number: $($bios.SerialNumber)"
Write-Host ""
Write-Host "Operating System: $($systemInfo.Caption)"
Write-Host ""
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
Write-Host "ROM"

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

# Lấy thông tin pin
powercfg /batteryreport /xml /output batteryreport.xml

$battery = [xml](Get-Content batteryreport.xml)

try {
    $health = [pscustomobject]@{
        Time               = $battery.BatteryReport.ReportInformation.ScanTime;
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
        Time               = $battery.BatteryReport.ReportInformation.ScanTime;
        Type               = $battery.BatteryReport.Batteries.Battery.Id[0];
        Manufacturer       = $battery.BatteryReport.Batteries.Battery.Manufacturer[0];
        ManufactureDate    = $battery.BatteryReport.Batteries.Battery.ManufactureDate[0];
        SerialNumber       = $battery.BatteryReport.Batteries.Battery.SerialNumber[0];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[0];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100);
        CycleCount         = $battery.BatteryReport.Batteries.Battery.CycleCount[0];
    }

    $health2 = [pscustomobject]@{
        Type               = $battery.BatteryReport.Batteries.Battery.Id[1];
        Manufacturer       = $battery.BatteryReport.Batteries.Battery.Manufacturer[1];
        ManufactureDate    = $battery.BatteryReport.Batteries.Battery.ManufactureDate[1];
        SerialNumber       = $battery.BatteryReport.Batteries.Battery.SerialNumber[1];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[1];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100);
        CycleCount         = $battery.BatteryReport.Batteries.Battery.CycleCount[1];
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
