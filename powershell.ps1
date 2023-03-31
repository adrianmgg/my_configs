Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -ShowToolTips

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module posh-git

# https://github.com/rsteube/lazycomplete
$script:lazycomplete_args = @(
	'rustup', 'rustup completions powershell'
	'docker', 'Import-Module DockerCompletion'
	# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#powershell
	'dotnet', 'Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
			param($commandName, $wordToComplete, $cursorPosition)
			dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
				[System.Management.Automation.CompletionResult]::new($_, $_, ''ParameterValue'', $_)
			}
		}',
	'packwiz', 'packwiz completion powershell'
	'npm', 'Import-Module npm-completion'
	'pip', 'pip completion --powershell'  # TODO should also make this work for `-m pip`s
)
lazycomplete @script:lazycomplete_args | Out-String | Invoke-Expression

# # https://github.com/nightroman/PS-GuiCompletion
# Install-GuiCompletion

# # https://github.com/joonro/Get-ChildItemColor
# Import-Module Get-ChildItemColor
