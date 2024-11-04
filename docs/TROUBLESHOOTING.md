## Package problems (general)
Be aware that this package uses NPM workspaces, if you skipped the repo orientation in `README.md`, you should read it before doing deep troubleshooting on package problems.

## Error 401 trying to run NPM commands
You need to have npm authentication set up to pull private packages, if not you'll get 401 errors. This should not be occuring for local builds, in which case check that all `package.json`
files are set to `0.0.0-developoment` and not trying to pull from the remote registry. If you are getting this while trying to release Qbit, refer to the admin guides for releases.

## Python Setup
This package presumes you have pyenv installed and initiated. Init is usually done by including `eval "$(pyenv init -)"` in your shell profile; or you can run it manually every time you
want to work on Qbit.

## VSCode can't find Qbit
Symptom: VSCode throws error `CANNOT FIND MODULE '@<package>/react' or its corresponding type delaration. ts(2307) Fix: `cmd + shift + p`, then run: `Developer: Reload Window`
