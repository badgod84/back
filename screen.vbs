Set s=CreateObject("WScript.Shell")
Set f=CreateObject("Scripting.FileSystemObject")
p=f.GetSpecialFolder(2)&"\shot.ps1"
Set w=f.CreateTextFile(p,1)
w.WriteLine "Add-Type -AssemblyName System.Windows.Forms,System.Drawing"
w.WriteLine "$b=[Windows.Forms.Screen]::PrimaryScreen.Bounds"
w.WriteLine "$i=New-Object Drawing.Bitmap $b.Width,$b.Height"
w.WriteLine "$g=[Drawing.Graphics]::FromImage($i)"
w.WriteLine "$g.CopyFromScreen($b.Location,[Drawing.Point]::Empty,$b.Size)"
w.WriteLine "$i.Save((Join-Path $env:TEMP 'screenshot.png'),'Png')"
w.WriteLine "$g.Dispose();$i.Dispose()"
w.Close
s.Run "powershell -ep bypass -f """&p&"""",0,True
f.DeleteFile p
