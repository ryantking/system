# Justfile for System management

deps:
  brew bundle install --no-upgrade --file=hack/Brewfile

tf layer *args:
  doppler run \
    --name-transformer tf-var -- \
    tofu -chdir=terraform/live/{{layer}} {{args}}
