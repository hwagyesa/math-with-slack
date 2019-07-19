# Fork of fsavje's `math-with-slack` script with macros added

This repo consists of some changes to fsavje's script to add
support for using macros with `math-with-slack`, as well as a
default set of macros.

Please see the README in fsavje's [repo](https://github.com/fsavje/math-with-slack)
for a much more detailed introduction to `math-with-slack` as
well as credits for contributions.

After the Slack 4.0 update, it seems the old method of installing has broken. I
have hacked fsavje's old install script to include a fix taken from the repo
[slack-dark-mode](https://github.com/LanikSJ/slack-dark-mode), which relies on
having `npm` installed; this can be done using Homebrew on OSX, for
example.

Thanks to [LaurentHayez](https://github.com/LaurentHayez) for
submitting a bug fix. Thanks to [A.
Davison](https://github.com/aday651) for submitting a working
Windows install script. Thanks to [LanikSJ and
others](https://github.com/LanikSJ/slack-dark-mode/issues/80) for describing
how to get things working with Slack 4.0.
