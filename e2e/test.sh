#!/usr/bin/env bats

function q () {
  if [[ ! -z $IS_CI ]]; then
    echo "Running in CI mode"
    chmod +x $BATS_TEST_DIRNAME/../_release/platform-linux-x64/q
    run "$BATS_TEST_DIRNAME/../_release/platform-linux-x64/q" "$@"
  else
    run "$BATS_TEST_DIRNAME/../_build/default/bin/q.exe" "$@"
  fi
}

@test "json call works ok" {
  q '.first.name' $BATS_TEST_DIRNAME/mock.json
  [ "$status" -eq 0 ]
  [ "$output" = '"John Doe"' ]
}

@test "inline call works ok" {
  q --kind="inline" '.' '{ "a": 1 }'
  [ "$status" -eq 0 ]
  [ "$output" = '{ "a": 1 }' ]
}

@test "non defined field gives back null" {
  q '.wat' $BATS_TEST_DIRNAME/mock.json
  [ "$status" -eq 0 ]
  [ "$output" = "null" ]
}