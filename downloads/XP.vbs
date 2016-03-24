ON ERROR RESUME NEXT
for each Obj in GetObject("winmgmts:{impersonationLevel=impersonate}").InstancesOf ("win32_WindowsProductActivation")
result = Obj.SetProductKey ("QGR8T3YWQCGG9V6J3VR94BCWT")
if err <> 0 then
WScript.Echo Err.Description, "0x" & Hex(Err.Number)
Err.Clear
end if
Next
