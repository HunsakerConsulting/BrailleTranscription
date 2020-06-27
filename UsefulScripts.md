## Set up OpenSUSE 15.2 as Server

#### POWERSHELL 

Extract Multiple .ZIP files into the same directory

```powershell
# File path
$filepath = Get-ChildItem -Path 'C:\Users\<user>\<path>\' -Filter *.zip -Recurse
# convert filepath to NameSpace object
$shell = new-object -com shell.application
# ForEach Loop processes each ZIP file located within the $filepath variable
foreach($file in $filepath)
{
    $zip = $shell.NameSpace($file.FullName)
    foreach($item in $zip.items())
    {
        $shell.Namespace($file.DirectoryName).copyhere($item)
    }
    Remove-Item $file.FullName

```

