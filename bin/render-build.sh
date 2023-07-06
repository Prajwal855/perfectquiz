set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec railsd assets:clean
bundle exec rails db:migrate