# Use the official Windows Server Core image as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set up environment variables
ENV VS_INSTALLER_URL=https://download.visualstudio.microsoft.com/download/pr/12345678-1234-1234-1234-123456789012/1234567890abcdef1234567890abcdef/vs_Enterprise.exe
ENV VS_VERSION=17.9

# Download and install Visual Studio 2022
RUN powershell -Command \
    Invoke-WebRequest -Uri $env:VS_INSTALLER_URL -OutFile vs_installer.exe ; \
    Start-Process -Wait -FilePath .\vs_installer.exe -ArgumentList '--quiet', '--norestart', '--wait', '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktop', '--add', 'Microsoft.VisualStudio.Workload.NetWeb' ; \
    Remove-Item -Force vs_installer.exe

# Install additional tools (e.g., .NET SDK, NuGet)
RUN powershell -Command \
    Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1 ; \
    .\dotnet-install.ps1 -Channel 6.0 -InstallDir "C:\Program Files\dotnet" ; \
    Remove-Item -Force dotnet-install.ps1

# Set up the entry point
CMD ["cmd"]
