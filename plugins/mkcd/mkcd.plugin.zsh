# make a directory and cd into it
#
# param:  path to create
# $ mkcd foo
# $ mkcd /tmp/img/photos/large

function mkcd ()
{
  mkdir -p "$*"
  cd "$*"
}