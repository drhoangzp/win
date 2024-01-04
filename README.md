# Windows
## Kiểm tra pin trong laptop bằng lệnh:
- Nhấn vào chữ copy và paste vào PowerShell hoặc Terminal chạy dưới quyền admin.
```
irm https://raw.githubusercontent.com/drhoangzp/win/main/pin.ps1 | iex
```
## Kiểm tra các thông tin có trong máy tính bằng lệnh:
- Nhấn vào chữ copy và paste vào PowerShell hoặc Terminal chạy dưới quyền admin.
```
irm https://raw.githubusercontent.com/drhoangzp/win/main/checkinfo.ps1 | iex
```
## Những lệnh cơ bản chạy trong CMD:
- Lệnh kiểm tra Windows bản quyền hay crack.
```
slmgr /xpr
```
- Lệnh xem cấu hình trong máy tính.
```
systeminfo
```
- Lệnh cho phép quản trị viên hệ thống điều khiển máy tính từ xa.\
`psexec`
- Lệnh kiểm tra Serial Number trong máy.
```
wmic bios get serialnumber
```
- Lệnh sao chép một hoặc nhiều file hoặc thư mục từ vị trí này sang vị trí khác.\
`xcopy`
- Lệnh quét tất cả các tệp hệ thống được bảo vệ và thay thế các tệp bị hỏng bằng bản sao được lưu trong bộ đệm ẩn nằm trong thư mục đã nén tại %WinDir%\System32\dllcache.
```
sfc /scannow
```
## Những lệnh cơ bản chạy trong PowerShell:
- Lệnh đồng bộ hóa theo cách thủ công trong Azure AD connect.
```
Start-ADSyncSyncCycle –PolicyType Initial
```
## Những lệnh chạy trong cửa sổ Run (windows + R):
- Công cụ DirectX Diagnostic Tool.
```
dxdiag
```
- Công cụ tích hợp sẵn của Windows cho phép bạn chỉnh sửa cài đặt tài khoản người dùng.
```
netplwiz
```
- Công cụ kiểm tra RAM trong máy tính (Lưu ý: khi chạy công cụ này sẽ tiến hành khởi động lại máy).
```
mdsched.exe
```

