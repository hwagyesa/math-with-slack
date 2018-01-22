@ECHO OFF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Rendered math (MathJax) with Slack's desktop client
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Slack (https://slack.com) does not display rendered math. This script
:: injects MathJax (https://www.mathjax.org) into Slack's desktop client,
:: which allows you to write nice-looking inline- and display-style math
:: using familiar TeX/LaTeX syntax.
::
:: https://github.com/fsavje/math-with-slack
::
:: MIT License, Copyright 2017 Fredrik Savje
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: Constants

SET "MWS_VERSION=v0.2.2"


:: User input

SET "UNINSTALL="
SET "SLACK_DIR="

:parse
IF "%~1" == "" GOTO endparse
IF "%~1" == "-u" (
	SET UNINSTALL=%~1
) ELSE (
	SET SLACK_DIR=%~1
)
SHIFT
GOTO parse
:endparse


:: Try to find slack if not provided by user

IF "%SLACK_DIR%" == "" (
	FOR /F %%t IN ('DIR /B /OD %UserProfile%\AppData\Local\slack\app-?.*.*') DO (
		SET SLACK_DIR=%UserProfile%\AppData\Local\slack\%%t\resources\app.asar.unpacked\src\static
	)
)


:: Check so installation exists

IF "%SLACK_DIR%" == "" (
	ECHO Cannot find Slack installation.
	PAUSE & EXIT /B 1
)

IF NOT EXIST "%SLACK_DIR%" (
	ECHO Cannot find Slack installation at: %SLACK_DIR%
	PAUSE & EXIT /B 1
)

IF NOT EXIST "%SLACK_DIR%\ssb-interop.js" (
	ECHO Cannot find Slack file: %SLACK_DIR%\ssb-interop.js
	PAUSE & EXIT /B 1
)


ECHO Using Slack installation at: %SLACK_DIR%


:: Remove previous version

IF EXIST "%SLACK_DIR%\math-with-slack.js" (
	DEL "%SLACK_DIR%\math-with-slack.js"
)


:: Restore previous injections

CALL :restore_file "%SLACK_DIR%\ssb-interop.js"
IF %ERRORLEVEL% NEQ 0 ( PAUSE & EXIT /B 1 )

CALL :restore_file "%SLACK_DIR%\ssb-interop-lite.js"
IF %ERRORLEVEL% NEQ 0 ( PAUSE & EXIT /B 1 )


:: Are we uninstalling?

IF "%UNINSTALL%" == "-u" (
	ECHO math-with-slack has been uninstalled. Please restart the Slack client.
	PAUSE & EXIT /B 0
)


:: Write main script

>"%SLACK_DIR%\math-with-slack.js" (
	ECHO.// math-with-slack %MWS_VERSION%
	ECHO.// https://github.com/fsavje/math-with-slack
	ECHO.
	ECHO.document.addEventListener('DOMContentLoaded', function(^) {
	ECHO.  var mathjax_config = document.createElement('script'^);
	ECHO.  mathjax_config.type = 'text/x-mathjax-config';
	ECHO.  mathjax_config.text = `
	ECHO.    MathJax.Hub.Config({
	ECHO.      messageStyle: 'none',
	ECHO.      extensions: ['tex2jax.js'],
	ECHO.      jax: ['input/TeX', 'output/HTML-CSS'],
	ECHO.      tex2jax: {
	ECHO.        displayMath: [['\$\$', '\$\$']],
	ECHO.        element: 'msgs_div',
	ECHO.        ignoreClass: 'ql-editor',
	ECHO.        inlineMath: [['\$', '\$']],
	ECHO.        processEscapes: true,
	ECHO.        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
	ECHO.      },
	ECHO.      TeX: {
	ECHO.        extensions: ['AMSmath.js', 'AMSsymbols.js', 'noErrors.js', 'noUndefined.js'],
  ECHO.        Macros: {
  ECHO.          N: "\\\\\\\\mathbb{N}",
  ECHO.          Z: "\\\\\\\\mathbb{Z}",
  ECHO.          Q: "\\\\\\\\mathbb{Q}",
  ECHO.          R: "\\\\\\\\mathbb{R}",
  ECHO.          C: "\\\\\\\\mathbb{C}",
  ECHO.          bb: "\\\\\\\\mathbb",
  ECHO.          mb: "\\\\\\\\boldsymbol",
  ECHO.          mc: "\\\\\\\\mathcal",
  ECHO.          mf: "\\\\\\\\mathfrak",
  ECHO.          wh: "\\\\\\\\widehat",
  ECHO.          wt: "\\\\\\\\widetilde",
  ECHO.          ol: "\\\\\\\\overline",
  ECHO.          v: "\\\\\\\\mathbf",
  ECHO.          c: "\\\\\\\\mathcal",
  ECHO.          tp: "\^{\\\\\\\\mkern+2mu T}",
  ECHO.          inv: "\^{-1}",
  ECHO.          eps: "\\\\\\\\epsilon",
  ECHO.          veps: "\\\\\\\\varepsilon",
  ECHO.          vphi: "\\\\\\\\varphi",
  ECHO.          One: "\\\\\\\\mathbf 1",
  ECHO.          Zero: "\\\\\\\\mathbf 0",
  ECHO.          indicator: ["\\\\\\\\operatorname{\\\\\\\\mathbb 1}_{#1}",1],
  ECHO.          ind: ["\\\\\\\\operatorname{\\\\\\\\mathbb 1}_{#1}",1],
  ECHO.          rank: "\\\\\\\\operatorname{rank}",
  ECHO.          tr: "\\\\\\\\operatorname{tr}",
  ECHO.          supp: "\\\\\\\\operatorname{supp}",
  ECHO.          conv: "\\\\\\\\operatorname{conv}",
  ECHO.          Bd: "\\\\\\\\operatorname{bd}",
  ECHO.          Cl: "\\\\\\\\operatorname{cl}",
  ECHO.          Dom: "\\\\\\\\operatorname{dom}",
  ECHO.          Epi: "\\\\\\\\operatorname{epi}",
  ECHO.          Aff: "\\\\\\\\operatorname{aff}",
  ECHO.          Cone: "\\\\\\\\operatorname{cone}",
  ECHO.          Int: "\\\\\\\\operatorname{int}",
  ECHO.          Relint: "\\\\\\\\operatorname{relint}",
  ECHO.          Span: "\\\\\\\\operatorname{span}",
  ECHO.          Diam: "\\\\\\\\operatorname{diam}",
  ECHO.          dist: "\\\\\\\\operatorname{dist}",
  ECHO.          vect: "\\\\\\\\operatorname{vec}",
  ECHO.          vol: "\\\\\\\\operatorname{vol}",
  ECHO.          E: "\\\\\\\\operatorname{\\\\\\\\mathbb E}",
  ECHO.          P: "\\\\\\\\operatorname{\\\\\\\\mathbb P}",
  ECHO.          var: "\\\\\\\\operatorname{var}",
  ECHO.          cov: "\\\\\\\\operatorname{cov}",
  ECHO.          diag: "\\\\\\\\operatorname{diag}",
  ECHO.          sign: "\\\\\\\\operatorname{sign}",
  ECHO.          grad: "\\\\\\\\operatorname{grad}",
  ECHO.          Hess: "\\\\\\\\operatorname{Hess}",
  ECHO.          mini: "\\\\\\\\operatorname{minimize}",
  ECHO.          maxi: "\\\\\\\\operatorname{maximize}",
  ECHO.          st: "\\\\\\\\operatorname{subject\\\\\\\\; to}",
  ECHO.          im: "\\\\\\\\mathrm i",
  ECHO.          iu: "\\\\\\\\hat{\\\\\\\\mathfrak i}",
  ECHO.          indep:"\\\\\\\\perp\\\\\\\\!\\\\\\\\!\\\\\\\\!\\\\\\\\perp",
  ECHO.          innerprod: ["\\\\\\\\left\\\\\\\\langle #1, #2\\\\\\\\right\\\\\\\\rangle", 2],
  ECHO.          ip: ["\\\\\\\\left\\\\\\\\langle #1, #2\\\\\\\\right\\\\\\\\rangle", 2],
  ECHO.          prob: ["\\\\\\\\operatorname{\\\\\\\\mathbb{P}}\\\\\\\\left[ #1 \\\\\\\\right]",1],
  ECHO.          expect: ["\\\\\\\\operatorname{\\\\\\\\mathbb{E}}\\\\\\\\left[ #1 \\\\\\\\right]",1],
  ECHO.          set: ["\\\\\\\\left\\\\\\\\{ #1 \\\\\\\\right\\\\\\\\}", 1],
  ECHO.          condset: ["\\\\\\\\left\\\\\\\\{ #1 \\\\\\\\;\\\\\\\\middle|\\\\\\\\; #2 \\\\\\\\right\\\\\\\\}", 2],
  ECHO.          norm: ["\\\\\\\\left\\\\\\\\lVert #1 \\\\\\\\right\\\\\\\\rVert",1],
  ECHO.          abs: ["\\\\\\\\left\\\\\\\\lvert #1 \\\\\\\\right\\\\\\\\rvert", 1],
  ECHO.          ceil: ["\\\\\\\\left\\\\\\\\lceil #1 \\\\\\\\right\\\\\\\\rceil",1],
  ECHO.          floor: ["\\\\\\\\left\\\\\\\\lfloor #1 \\\\\\\\right\\\\\\\\rfloor",1]
  ECHO.        }
	ECHO.      }
	ECHO.    }^);
	ECHO.  `;
	ECHO.  var mathjax_script = document.createElement('script'^);
	ECHO.  mathjax_script.type = 'text/javascript';
	ECHO.  mathjax_script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js';
	ECHO.  document.head.appendChild(mathjax_config^);
	ECHO.  document.head.appendChild(mathjax_script^);
	ECHO.
	ECHO.  var target = document.querySelector('#messages_container'^);
	ECHO.  var options = { attributes: false, childList: true, characterData: true, subtree: true };
	ECHO.  var observer = new MutationObserver(function (r, o^) { MathJax.Hub.Queue(['Typeset', MathJax.Hub]^); }^);
	ECHO.  observer.observe(target, options^);
	ECHO.}^);
)


:: Inject code loader

CALL :inject_loader "%SLACK_DIR%\ssb-interop.js"
IF %ERRORLEVEL% NEQ 0 ( PAUSE & EXIT /B 1 )

CALL :inject_loader "%SLACK_DIR%\ssb-interop-lite.js"
IF %ERRORLEVEL% NEQ 0 ( PAUSE & EXIT /B 1 )


:: We're done

ECHO math-with-slack has been installed. Please restart the Slack client.
PAUSE & EXIT /B 0


:: Functions

:restore_file
FINDSTR /R /C:"math-with-slack" "%~1" >NUL
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%~1.mwsbak" (
		MOVE /Y "%~1.mwsbak" "%~1" >NUL
	) ELSE (
		ECHO Cannot restore from backup. Missing file: %~1.mwsbak
		EXIT /B 1
	)
) ELSE (
	IF EXIST "%~1.mwsbak" (
		DEL "%~1.mwsbak"
	)
)
EXIT /B 0
:: end restore_file


:inject_loader
:: Check so not already injected
FINDSTR /R /C:"math-with-slack" "%~1" >NUL
IF %ERRORLEVEL% EQU 0 (
	ECHO File already injected: %~1
	EXIT /B 1
)

:: Make backup
IF NOT EXIST "%~1.mwsbak" (
	COPY "%~1" "%~1.mwsbak" >NUL
) ELSE (
	ECHO Backup already exists: %~1.mwsbak
	EXIT /B 1
)

:: Inject loader code
>>"%~1" (
	ECHO.
	ECHO.// ** math-with-slack %MWS_VERSION% ** https://github.com/fsavje/math-with-slack
	ECHO.var mwsp = path.join(__dirname, 'math-with-slack.js'^).replace('app.asar', 'app.asar.unpacked'^);
	ECHO.require('fs'^).readFile(mwsp, 'utf8', (e, r^) =^> { if (e^) { throw e; } else { eval(r^); } }^);
)

EXIT /B 0
:: end inject_loader
