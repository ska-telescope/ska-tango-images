#!/usr/bin/env bash

# Generate Makefile to add targets for all tests in tests/test_basic.py
#
# Usage:
#
#   images-with-tests
#
# This script queries pytest to find all the tests we have and adds a Makefile
# rule for them.  This is using the oci-test-image macro defined in the
# Makefile.
#
# Invoking the test through the Makefile allows the target to depend on the
# build receipts, meaning that the image gets rebuilt before the test if
# required.
#
# This is mostly to speed up local workflows, so if we cannot find pytest we
# generate an empty file.

if [ $# -ne 0 ]; then
    echo "Usage:"
    echo -e "\t$0"
    exit 1
fi

MKFILE=build/deps/images-with-tests
echo > $MKFILE ""

if ! which pytest > /dev/null; then
    exit 0
fi

get-tests()
{
    pytest --collect-only tests/test_basics.py | \
        awk 'match($0, "<Function test_(.*)>$", a) {print a[1]}' | \
        tr '_' '-'
}

for image in $(get-tests); do
    echo >> $MKFILE "\$(eval \$(call oci-test-image,${image}))"
done
