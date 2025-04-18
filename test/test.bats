setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # ... the remaining setup is unchanged

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

teardown() {
    : # Look Ma! No cleanup!
}

@test "can run our script" {
    run ./file-managment/get-content-creation-time.sh "202001019"
    assert_output 'Wed Jan  1 00:00:00 EST 2020'

    run ./file-managment/get-content-creation-time.sh 20200101
    assert_output 'Wed Jan  1 00:00:00 EST 2020'

    run ./file-managment/get-content-creation-time.sh "20240522_124640.jpg"
    assert_output 'Wed May 22 00:00:00 EDT 2024'

    # run ./file-managment/get-content-creation-time.sh "20240522_124640.jpg"
    # assert_output 'Wed May 22 00:00:00 EDT 2024'

    # run ./file-managment/get-content-creation-time.sh 0

    # run ./file-managment/get-content-creation-time.sh
    # assert_output --partial ''
}
