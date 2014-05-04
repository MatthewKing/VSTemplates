# Get the ID and security principal of the current user account.
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
     
# Check to see if we are currently running "as Administrator".
if (!($myWindowsPrincipal.IsInRole($adminRole)))
{
    # Relaunch as administrator.
    $psi = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $psi.Arguments = $MyInvocation.MyCommand.Definition
    $psi.Verb = "runas"
    [System.Diagnostics.Process]::Start($psi)
           
    # Exit from the current, unelevated, process.
    Exit
}

# Set up directories and aliases.
$SourceDirectory = Join-Path (Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path) '..\source'
$ProgramFilesDirectory = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]
$VisualStudioDirectory = Join-Path $ProgramFilesDirectory 'Microsoft Visual Studio 11.0\Common7\IDE'
$ItemTemplatesDirectory = Join-Path $VisualStudioDirectory 'ItemTemplates\CSharp\Code\1033'
Set-Alias devenv (Join-Path $VisualStudioDirectory 'devenv.exe')

# Install Class item template.
Write-Host "Installing Class item template..."
if ((Test-Path "$ItemTemplatesDirectory\Class\Class.cs") -and !(Test-Path "$ItemTemplatesDirectory\Class\Class.cs.original"))
{
    Move-Item "$ItemTemplatesDirectory\Class\Class.cs" "$ItemTemplatesDirectory\Class\Class.cs.original"
    Write-Host "Backed up 'Class.cs' as 'Class.cs.original'."
}
if ((Test-Path "$ItemTemplatesDirectory\Class\Class.vstemplate") -and !(Test-Path "$ItemTemplatesDirectory\Class\Class.vstemplate.original"))
{
    Move-Item "$ItemTemplatesDirectory\Class\Class.vstemplate" "$ItemTemplatesDirectory\Class\Class.vstemplate.original"
    Write-Host "Backed up 'Class.vstemplate' as 'Class.vstemplate.original'."
}
Copy-Item "$SourceDirectory\Class.cs" "$ItemTemplatesDirectory\Class\Class.cs"
Write-Host "Installed new 'Class.cs'."
Copy-Item "$SourceDirectory\Class.vstemplate" "$ItemTemplatesDirectory\Class\Class.vstemplate"
Write-Host "Installed new 'Class.vstemplate'."
Write-Host "Done."
Write-Host

# Install Interface item template.
Write-Host "Installing Interface item template..."
if ((Test-Path "$ItemTemplatesDirectory\Interface\Interface.cs") -and !(Test-Path "$ItemTemplatesDirectory\Interface\Interface.cs.original"))
{
    Move-Item "$ItemTemplatesDirectory\Interface\Interface.cs" "$ItemTemplatesDirectory\Interface\Interface.cs.original"
    Write-Host "Backed up 'Interface.cs' as 'Interface.cs.original'."
}
if ((Test-Path "$ItemTemplatesDirectory\Interface\Interface.vstemplate") -and !(Test-Path "$ItemTemplatesDirectory\Interface\Interface.vstemplate.original"))
{
    Move-Item "$ItemTemplatesDirectory\Interface\Interface.vstemplate" "$ItemTemplatesDirectory\Interface\Interface.vstemplate.original"
    Write-Host "Backed up 'Interface.vstemplate' as 'Interface.vstemplate.original'."
}
Copy-Item "$SourceDirectory\Interface.cs" "$ItemTemplatesDirectory\Interface\Interface.cs"
Write-Host "Installed new 'Interface.cs'."
Copy-Item "$SourceDirectory\Interface.vstemplate" "$ItemTemplatesDirectory\Interface\Interface.vstemplate"
Write-Host "Installed new 'Interface.vstemplate'."
Write-Host "Done."
Write-Host

# Rebuild template cache.
Write-Host "Rebuilding devenv template cache..."
devenv /installvstemplates | Out-Null
Write-Host "Done."