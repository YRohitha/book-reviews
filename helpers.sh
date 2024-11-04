spacer() {
  COLS=$(tput cols || echo 40)
  for ((x = 0; x < COLS; x++)); do
    printf %s
  done
  echo # new line
}

computerGoesDing() {
  echo -e '\a' # audible ding
}

exitScript() {
  echo "critical error, manual intervention required." # boom
  computerGoesDing
  exit 1
}

echoWarning() {
  # "WARNING" in yellow
  echo -e "\033[1;33mWARNING\033[0m $*"
}

echoError() {
  # "ERROR" in red
  echo -e "\033[1;31mERROR\033[0m $*"
}

checkOS() {
  # where are we...
  case "$(uname -s)" in
    CYGWIN*) DETECTED_OS="cygwin" ;;
    Darwin*) DETECTED_OS="osx" ;;
    Linux*) DETECTED_OS="linux" ;;
    MINGW32*) DETECTED_OS="windows" ;;
    *) DETECTED_OS="ERROR could not detect OS" ;;
  esac
  # Check for WSL (bash-on-ubuntu-on-windows). Note this doesn't differentiate distros, largely assumes Ubuntu
  if [[ $DETECTED_OS = "linux" ]]; then
    if grep --silent 'Microsoft' /proc/sys/kernel/osrelease; then
      DETECTED_OS="wsl"
    fi
  fi
  echo "OS detected: ${DETECTED_OS}"
}

checkCerts(){
  echo "Testing to ensure NODE_EXTRA_CA_CERTS target exists."
  echo "Var set to: $NODE_EXTRA_CA_CERTS"
  if [ -f "$NODE_EXTRA_CA_CERTS" ]; do
    echo "PASS - $NODE_EXTRA_CA_CERTS exists."
  else
    echo "FAIL - $NODE_EXTRA_CA_CERTS does not exist. Aborting."
    exit 1
  fi
}

setOpenCommand() {
  if [[ $DETECTED_OS = "osx" ]]; then
    echo "Setting OSX open command"
    export OPEN_CMD="open"

  elif [[ $DETECTED_OS = "wsl" ]]; then
    echo "Setting WSL open command"
    export OPEN_CMD="/mnt/c/Windows/System32/cmd.exe /c start"

  else
    echo "Unable to automatically open URLs"
    export OPEN_CMD="false"

  fi
}

prompt() {
  while true
  do
    read -rp "$1" answer
    case $answer in
    [yY]* return 0;;
    [nN]* return 1;;
    * ) echo "Y/N";;
    esac
  done
}

continueCheck() {
  if [ "$1" ];then
    echo "$1"
  fi
  prompt "Continue? [Y/N] " && {
    return 0
  }
  spacer
  echo "Action cancelled."
  spacer
  exit 1
}

retry() {
  until "$@"
  do
    sleep 1
    echo "Retrying:" "$@"
  done
  echo "Completed:" "$@"
}

distClean() {
  echo "Deleting ./dist";
  rm -rf ./packages/*
  echo "distClean done";
}

cleanDash() {
  echo "Cleaning ./dash";
  rm -rf ./packages/*
}

nodeClean() {
  echo "node clean"
  echo "deleting node modules...";
  find . -type d -name "node_modules" -exec -rm -rf {} +
}

pyClean() {
  echo "Python clean"
  echo "Deleting env..."
  find . -type d -name "env" -exec -rm -rf {} +
  echo "Deleting __pychache__..."
  find . -type d -name "__pycache__" -exec -rm -rf {} +
  echo "pyClean done";
}

isNodeMajorVersionCorrect() {
  local NVMRC_VERSION
  NVMRC_VERSION="$(< .nvmrc cut -c1-3)"
  local NODE_VERSION
  NODE_VERSION="$(node --version | cut -c1-3)"

  if [[ "NVMRC_VERISON" == "NODE_VERSION" ]]; then
    true
  else
    false
  fi
    return
}

isPythonVersionCorrect() {
  local PYTHONFILE_VERSION
  PYTHONFILE_VERSION="$(cat .python-version)"
  local PYTHON_VERSION
  PYTHON_VERSION="$(python --version | cut -c8-)"

  if [[ "PYTHONFILE_VERSION" == "PYTHON_VERSION" ]];then
    true
  else
    false
  fi
  return
}

pythonCheck() {
  if ! command -v python &> /dev/null
  then
    false
  else
    true
  fi
    return
}

pyenvCheck() {
  if ! command -v pyenv &> /dev/null
  then
    false
  else
    true
  fi
    return
}

stmuxCheck() {
  if ! command -v stmux &> /dev/null
  then
    false
  else
    true
  fi
    return
}

twineCheck() {
  if ! command -v twine &> /dev/null
  then
    false
  else
    true
  fi
    return
}
