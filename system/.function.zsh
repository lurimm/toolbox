# Opens github to create a pull request
function openpr() {
  # github_url and branch_name are piping the result of each command with the "|" sign.
  github_url=`git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's#.net:#.net/#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/'`;
  branch_name=`git symbolic-ref HEAD | cut -d"/" -f 3,4`;
  pr_url=$github_url"/compare/"$branch_name
  echo "Pull request url: $pr_url"
  open $pr_url;
}

# Run git push and then immediately open the Pull Request URL
function create-pr() {
  git push origin HEAD

  if [ $? -eq 0 ]; then # Checks the exit status of the last command, which is the one above ^^ "git push origin HEAD". If the status is equal(-eq) to 0, it means success.
    openpr
  else
    echo 'failed to push commits and open a pull request.';
  fi
}

# A prettified log of my PATH
function show-path() {
  RED="\033[1;31m"
  GREEN="\033[1;32m"
  NOCOLOR="\033[0m"
  UNDERLINE="\033[4m"
  str=$PATH
  IFS=':' # space is set as delimiter

  echo ""
  echo "${GREEN}Home directory or '~/' --> ${NOCOLOR} $HOME"

  read -rA arrOfFiles <<< "$str" # str is read into an array (arrOfFiles) as tokens (empty space) separated by IFS. Note: in bash it can be "read -ra" but ZSH for some requires a capital "A".
  echo ""
  echo "${RED}Your executable files in PATH:${NOCOLOR}"
  echo ""

  for i in "${arrOfFiles[@]}"; do # access each element of array
    echo " - $i"
  done

  echo ""
  echo "${GREEN}Original PATH string${NOCOLOR} --> $PATH"
  IFS=""
}

function open-project() {
  jump $1
  atom $PWD
}
