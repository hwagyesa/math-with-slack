#!/usr/bin/env bash

################################################################################
# Rendered math (MathJax) with Slack's desktop client
################################################################################
#
# Slack (https://slack.com) does not display rendered math. This script
# injects MathJax (https://www.mathjax.org) into Slack's desktop client,
# which allows you to write nice-looking inline- and display-style math
# using familiar TeX/LaTeX syntax.
#
# https://github.com/fsavje/math-with-slack
#
# MIT License, Copyright 2017-2018 Fredrik Savje
#
################################################################################


## Constants

## Main

SLACK_DIRECT_LOCAL_SETTINGS="~/Library/Application\ Support/Slack/local-settings.json"
SLACK_STORE_LOCAL_SETTINGS="~/Library/Containers/com.tinyspeck.slackmacgap/Data/Library/Application\ Support/Slack/local-settings.json"
OSX_SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
LINUX_SLACK_RESOURCES_DIR="/usr/lib/slack/resources"
UPDATE_ONLY="false"

echo && echo "This script requires sudo privileges." && echo "You'll need to provide your password."

type npx
if [[ "$?" != "0" ]]; then echo "Please install Node for your OS.  macOS users will also need to install Homebrew from https://brew.sh"; fi
if [[ -f $SLACK_DIRECT_LOCAL_SETTINGS ]]; then sed -i 's/"bootSonic":"once"/"bootSonic":"never"/g' $SLACK_DIRECT_LOCAL_SETTINGS; fi
if [[ -f $SLACK_STORE_LOCAL_SETTINGS ]]; then sudo sed -i 's/"bootSonic":"once"/"bootSonic":"never"/g' $SLACK_STORE_LOCAL_SETTINGS; fi

if [[ -d $OSX_SLACK_RESOURCES_DIR ]]; then SLACK_RESOURCES_DIR=$OSX_SLACK_RESOURCES_DIR; fi
if [[ -d $LINUX_SLACK_RESOURCES_DIR ]]; then SLACK_RESOURCES_DIR=$LINUX_SLACK_RESOURCES_DIR; fi
if [[ "$1" == "-u" ]]; then UPDATE_ONLY="true"; fi

SLACK_SSB_INTEROP="$SLACK_RESOURCES_DIR/app.asar.unpacked/dist/ssb-interop.bundle.js"
SLACK_MATHJAX_SCRIPT="$SLACK_RESOURCES_DIR/math-with-slack.js"

if [[ "$UPDATE_ONLY" == "true" ]]; then echo && echo "Updating Dark Theme Code for Slack... "; fi
if [[ "$UPDATE_ONLY" == "false" ]]; then echo && echo "Adding Dark Theme Code to Slack... "; fi

echo "This script requires sudo privileges." && echo "You'll need to provide your password."

## Write main script

cat <<EOF > $SLACK_MATHJAX_SCRIPT
// math-with-slack $MWS_VERSION
// https://github.com/fsavje/math-with-slack

document.addEventListener('DOMContentLoaded', function() {
  var mathjax_config = document.createElement('script');
  mathjax_config.type = 'text/x-mathjax-config';
  mathjax_config.text = \`
    MathJax.Hub.Config({
      messageStyle: 'none',
      extensions: ['tex2jax.js'],
      jax: ['input/TeX', 'output/HTML-CSS'],
      tex2jax: {
        displayMath: [['\$\$', '\$\$']],
        element: 'msgs_div',
        ignoreClass: 'ql-editor',
        inlineMath: [['\$', '\$']],
        processEscapes: true,
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
      },
      TeX: {
        extensions: ['AMSmath.js', 'AMSsymbols.js', 'color.js',
          'AMScd.js', 'noErrors.js', 'noUndefined.js'],
        Macros: {
          N: "\\\\\\\\mathbb{N}",
          Z: "\\\\\\\\mathbb{Z}",
          Q: "\\\\\\\\mathbb{Q}",
          R: "\\\\\\\\mathbb{R}",
          reals: "\\\\\\\\mathbb{R}",
          C: "\\\\\\\\mathbb{C}",
          Var: "\\\\\\\\operatorname{Var}",
          bb: "\\\\\\\\mathbb",
          mb: "\\\\\\\\boldsymbol",
          mc: "\\\\\\\\mathcal",
          mf: "\\\\\\\\mathfrak",
          mr: "\\\\\\\\mathrm",
          rm: "\\\\\\\\mathrm",
          wh: "\\\\\\\\widehat",
          wt: "\\\\\\\\widetilde",
          ol: "\\\\\\\\overline",
          v: "\\\\\\\\mathbf",
          c: "\\\\\\\\mathcal",
          tp: "\^{\\\\\\\\mkern+2mu T}",
          inv: "\^{-1}",
          eps: "\\\\\\\\epsilon",
          veps: "\\\\\\\\varepsilon",
          vphi: "\\\\\\\\varphi",
          One: "\\\\\\\\mathbf 1",
          Zero: "\\\\\\\\mathbf 0",
          indicator: ["\\\\\\\\operatorname{\\\\\\\\mathbb 1}_{#1}",1],
          ind: ["\\\\\\\\operatorname{\\\\\\\\mathbb 1}_{#1}",1],
          rank: "\\\\\\\\operatorname{rank}",
          tr: "\\\\\\\\operatorname{tr}",
          supp: "\\\\\\\\operatorname{supp}",
          conv: "\\\\\\\\operatorname{conv}",
          Bd: "\\\\\\\\operatorname{bd}",
          Cl: "\\\\\\\\operatorname{cl}",
          Dom: "\\\\\\\\operatorname{dom}",
          Epi: "\\\\\\\\operatorname{epi}",
          Aff: "\\\\\\\\operatorname{aff}",
          Cone: "\\\\\\\\operatorname{cone}",
          Int: "\\\\\\\\operatorname{int}",
          Relint: "\\\\\\\\operatorname{relint}",
          Span: "\\\\\\\\operatorname{span}",
          Diam: "\\\\\\\\operatorname{diam}",
          dist: "\\\\\\\\operatorname{dist}",
          vect: "\\\\\\\\operatorname{vec}",
          vol: "\\\\\\\\operatorname{vol}",
          E: "\\\\\\\\operatorname{\\\\\\\\mathbb E}",
          P: "\\\\\\\\operatorname{\\\\\\\\mathbb P}",
          var: "\\\\\\\\operatorname{var}",
          cov: "\\\\\\\\operatorname{cov}",
          diag: "\\\\\\\\operatorname{diag}",
          sign: "\\\\\\\\operatorname{sign}",
          grad: "\\\\\\\\operatorname{grad}",
          Hess: "\\\\\\\\operatorname{Hess}",
          mini: "\\\\\\\\operatorname{minimize}",
          maxi: "\\\\\\\\operatorname{maximize}",
          st: "\\\\\\\\operatorname{subject\\\\\\\\; to}",
          im: "\\\\\\\\mathrm i",
          iu: "\\\\\\\\hat{\\\\\\\\mathfrak i}",
          indep:"\\\\\\\\perp\\\\\\\\!\\\\\\\\!\\\\\\\\!\\\\\\\\perp",
          norm: ["\\\\\\\\left\\\\\\\\lVert #1 \\\\\\\\right\\\\\\\\rVert",1],
          abs: ["\\\\\\\\left\\\\\\\\lvert #1 \\\\\\\\right\\\\\\\\rvert", 1],
          innerprod: ["\\\\\\\\left\\\\\\\\langle #1, #2\\\\\\\\right\\\\\\\\rangle", 2],
          ip: ["\\\\\\\\left\\\\\\\\langle #1, #2\\\\\\\\right\\\\\\\\rangle", 2],
          prob: ["\\\\\\\\operatorname{\\\\\\\\mathbb{P}}\\\\\\\\left[ #1 \\\\\\\\right]",1],
          expect: ["\\\\\\\\operatorname{\\\\\\\\mathbb{E}}\\\\\\\\left[ #1 \\\\\\\\right]",1],
          set: ["\\\\\\\\left\\\\\\\\{ #1 \\\\\\\\right\\\\\\\\}", 1],
          condset: ["\\\\\\\\left\\\\\\\\{ #1 \\\\\\\\;\\\\\\\\middle|\\\\\\\\; #2 \\\\\\\\right\\\\\\\\}", 2],
          ceil: ["\\\\\\\\left\\\\\\\\lceil #1 \\\\\\\\right\\\\\\\\rceil",1],
          floor: ["\\\\\\\\left\\\\\\\\lfloor #1 \\\\\\\\right\\\\\\\\rfloor",1]
        }
      }
    });
  \`;

  var mathjax_observer = document.createElement('script');
  mathjax_observer.type = 'text/x-mathjax-config';
  mathjax_observer.text = \`
    var target = document.querySelector('#messages_container');
    var options = { attributes: false, childList: true, characterData: true, subtree: true };
    var observer = new MutationObserver(function (r, o) { MathJax.Hub.Queue(['Typeset', MathJax.Hub]); });
    observer.observe(target, options);
  \`;

  var mathjax_script = document.createElement('script');
  mathjax_script.type = 'text/javascript';
  mathjax_script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/MathJax.js';

  document.head.appendChild(mathjax_config);
  document.head.appendChild(mathjax_observer);
  document.head.appendChild(mathjax_script);
});
EOF

if [[ "$UPDATE_ONLY" == "false" ]]; then
  # Unpack Asar Archive for Slack
  sudo npx asar extract $SLACK_RESOURCES_DIR/app.asar $SLACK_RESOURCES_DIR/app.asar.unpacked

  # Add JS Code to Slack
  sudo tee -a "$SLACK_SSB_INTEROP" < $SLACK_MATHJAX_SCRIPT

  # Pack the Asar Archive for Slack
  sudo npx asar pack $SLACK_RESOURCES_DIR/app.asar.unpacked $SLACK_RESOURCES_DIR/app.asar
fi

echo && echo "Done! After executing this script restart Slack for changes to take effect."
