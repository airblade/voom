:: SPDX-License-Identifier: MIT
:: Copyright (c) 2026 Bharatvaj Hemanth <bharatvaj@yahoo.com>

@echo off
setlocal EnableDelayedExpansion

if not defined VOOM_DEFAULT_PROVIDER set VOOM_DEFAULT_PROVIDER=https://github.com

if not defined XDG_CONFIG_HOME set XDG_CONFIG_HOME=%USERPROFILE%\.config
if not defined XDG_DATA_HOME set XDG_DATA_HOME=%USERPROFILE%\.local\share

if not defined VIM_DIR set VIM_DIR=%USERPROFILE%\.vim
if not defined VIM_PLUGINS_DIR set VIM_PLUGINS_DIR=%XDG_DATA_HOME%\vim\pack\voom\start

if not defined VOOM_MANIFEST (
	for /d %%d in ("%XDG_CONFIG_HOME%\vim" "%VIM_DIR%") do (
		if exist "%%~d\plugins" (
			set "VOOM_MANIFEST=%%~d\plugins"
		)
	)
)

if not exist "!VOOM_MANIFEST!" (
	echo Could not locate: '%VOOM_MANIFEST%'. >&2
	exit /b 1
)

goto :main

:voom_sync
setlocal
	if not exist %VIM_PLUGINS_DIR% mkdir %VIM_PLUGINS_DIR%

	cd "%VIM_PLUGINS_DIR%"

	REM WARNING: One empty line and %%d should be present
	for /d %%d in (. "*") do set dirs=!dirs!^

%%d

	for /f "tokens=*" %%j in ('type "%VOOM_MANIFEST%" ^| findstr /v "^#" ^| sort') do (
		for %%I in ("%%j") do set "reponame=%%~nxI"

		if "!reponame:~-4!"==".git" (
			echo '.git' not allowed at end in entry: %%j
			exit /b 1
		)

		if not exist "!reponame!/.git" (
			REM WARNING: One empty line and %%d should be present
			set dirs=!dirs:^

%%d=!
			set jtmp=%%j
			echo v %%j
			if not "y!jtmp:://=!!jtmp:@=!"=="y!jtmp!!jtmp!" (
				git clone -q "%%j"
			) else (
				git clone -q "%VOOM_DEFAULT_PROVIDER%/%%j"
			)
			if ERRORLEVEL 1 (
				exit /b 1
			)
		)

		for /f "tokens=*" %%d in ("!dirs!") do (
			if "%%d"=="!reponame!" (
				REM WARNING: One empty line and %%d should be present
				set dirs=!dirs:^

%%d=!
			)
		)
	)

	for /f "tokens=*" %%d in ("!dirs!") do (
		if not "%%d"=="." (
			echo Removing %%d
			rmdir /s/q "%%d"
		)
	)

	vim -c "helptags ALL" -c quit 2>&1 >nul
endlocal
goto :eof

:voom_update <dir> <quiet> <plugin_name>
setlocal
	cd "%~1"
	for /f "usebackq" %%i in (`git symbolic-ref --short HEAD`) do set "branch=%%i"
	for /f "usebackq tokens=1" %%i in (`git ls-remote --heads origin "!branch!"`) do set "upstream=%%i"
	for /f "usebackq" %%i in (`git rev-parse "!branch!"`) do set "installed=%%i"

	if not "!upstream!"=="!installed!" (
		git pull -q
		for /f "usebackq" %%i in (`git rev-list --left-only --count ^
			"!upstream!"..."!installed!"`) do set "commits=%%i"
		if %2 NEQ 1 (
			for /f "usebackq" %%i in (`git log --oneline ^
				"!installed!".."!upstream!"`) do set "log=%%i"

		)
		echo updated %~3: !commits! commit^(s^)
		if %2 NEQ 1 (
			echo !log!
		)
	)
endlocal
goto :eof

:main
setlocal EnableDelayedExpansion
	if "%~1"=="" (
		call :voom_sync
	) else if "%~1"=="update" (
		REM Arrrggh! Order of flag parsing should be preserved.
		REM If we remove 'update' from args before -q, it is
		REM not possible to safely remove -q with ` -q '.
		set args=%*
		set is_quiet=0
		if "%~2"=="-q" (
			set args=!args: -q =!
			set is_quiet=1
		)
		set "args=!args:~6!"
		for /d %%d in (!args!) do (
			set "repodir=%VIM_PLUGINS_DIR%\%%d"
			if not exist "!repodir!" (
				echo Could not locate: '!repodir!'. >&2
				exit /b 1
			)
			call :voom_update "!repodir!" !is_quiet! "%%d"
		)
	) else if "%~1"=="edit" (
		if not defined EDITOR set EDITOR=vim
		"!EDITOR!" "%VOOM_MANIFEST%"
		call :voom_sync
	) else if "%~1"=="help" (
		echo Usage: voom [update [-q] ^<name^>] [edit]
	) else (
		echo Usage: voom [update [-q] ^<name^>] [edit] >&2
		exit /b 1
	)
endlocal DisableDelayedExpansion
goto :eof

endlocal DisableDelayedExpansion
