{ lib, stdenv, git }:
let
  whitelistSource = src: allowedPrefixes:
    builtins.filterSource
      (path: type:
        lib.any
          (allowedPrefix: lib.hasPrefix (toString (src + "/${allowedPrefix}")) path)
          allowedPrefixes)
      src;
in
stdenv.mkDerivation {
  name = "mayastor-version";
  src = whitelistSource ../../. [ ".git" ];
  buildCommand = ''
    cd $src
    export GIT_DIR=".git"
    vers=`${git}/bin/git tag --points-at HEAD`
    if [ -z "$vers" ]; then
      vers=`${git}/bin/git rev-parse --short=12 HEAD`
    fi
    echo -n $vers >$out
  '';
}
