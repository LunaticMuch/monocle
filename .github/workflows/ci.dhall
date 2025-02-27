let mk = ./mkCI.dhall

in  { Nix =
        mk.makeNix
          "change-metrics"
          (   mk.elastic-steps
            # [ mk.GithubActions.Step::{
                , name = Some "Build the env"
                , run = Some "nix-build --no-out-link --attr monocle-light.env"
                }
              , mk.GithubActions.Step::{
                , name = Some "Run Test"
                , run = Some
                    "cd haskell; nix-shell --pure --attr ci-shell ../nix/default.nix --command 'env ELASTIC_URL=http://localhost:9200 monocle-ci-run'"
                }
              ]
          )
    }
