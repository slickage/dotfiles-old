# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -Fhs --color"
  alias l="gls -lAhs --color"
  alias ll="gls -lhs --color"
  alias la='gls -Ahs --color'
fi
