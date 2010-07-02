From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 2 Jul 2010 15:39:24 -0700
Subject: [Ocfs2-devel] [PATCH] tailtest: Add a test for the tail zeroing bug
Message-ID: <20100702223924.GB5800@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This test tests tail zeroing by writing a byte at the start of a new
file, then writing another byte at various offsets.

Currently, the test uses 4K/1M filesystems.  The offsets are 10M, 1M,
512K, and 1K.  This tests a new write location well past the existing
extent, right after the existing extent, in the middle of the existing
extent but past the last valid block of the file, and inside the last
valid block of the file.

Each offset is tested twice.  First with truncation out to the new
location, then without truncation.  This tests zeroing via truncate and
zeroing via write.

The full set of tests is run on four different filesystem
configurations: sparse,inline-data sparse,noinline-data
nosparse,inline-data and nosparse,noinline-data.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 programs/tailtest/tailtest |  179 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100755 programs/tailtest/tailtest

diff --git a/programs/tailtest/tailtest b/programs/tailtest/tailtest
new file mode 100755
index 0000000..5bf70f7
--- /dev/null
+++ b/programs/tailtest/tailtest
@@ -0,0 +1,179 @@
+#!/bin/bash
+#
+# Test for the ocfs2 tail zero bug
+#
+
+_IMAGE=""
+_MOUNTPOINT=""
+_LOOP=""
+
+cleanup()
+{
+    [ -d "$_MOUNTPOINT" ] && umount "$_MOUNTPOINT"
+    [ -d "$_MOUNTPOINT" ] && rmdir "$_MOUNTPOINT"
+    [ -n "$_LOOP" ] && losetup -d "$_LOOP"
+    [ -n "$_IMAGE" ] && rm -f "$_IMAGE"
+}
+trap "exitcode=\$?; cleanup 2>/dev/null && exit \$exitcode" 0
+trap "cleanup; die \"Signal caught, exiting\"" 1 2 13 15
+
+die()
+{
+    [ -n "$*" ] && echo "$@" >&2
+    exit 1
+}
+
+make_image()
+{
+    local image="$1"
+
+    dd if=/dev/urandom of="$image" bs=1M count=1 seek=10000 conv=notrunc 2>/dev/null ||
+        die "Unable to create image \"$image\""
+    dd if=/dev/urandom of="$image" bs=1M count=200 conv=notrunc 2>/dev/null ||
+        die "Unable to poison the start of image \"$image\""
+    losetup -f --show "$image" || die "Unable to attach loopback device"
+}
+
+make_fs()
+{
+    local device="$1"
+    local mountpoint="$2"
+    local extra_features="$3"
+    case "$extra_features" in
+        ,*) ;;
+        *)
+            extra_features=",$extra_features"
+            ;;
+    esac
+
+    mkfs -t ocfs2 -C 1M \
+        --fs-features=local"$extra_features" "$device" ||
+        die "Unable to create ocfs2 filesystem"
+    mount -t ocfs2 "$device" "$mountpoint" ||
+        die "Unable to mount ocfs2 filesystem"
+}
+
+clean_one_test()
+{
+    for f in "$@"
+    do
+        megs="$(ls -l "$f" | awk '{printf "%lu", ($5 + 1048576 - 1) / 1048576}')"
+        [ -z "$megs" ] && die "Unable to clean test file \"$f\""
+        dd if=/dev/urandom of="$f" bs=1M count="${megs}" 2>/dev/null ||
+            die "Unable to scribble over test file \"$f\""
+        rm -f "$f" || die "Unable to remove test file \"$f\""
+    done
+}
+
+run_one_test()
+{
+    local device="$1"
+    local mountpoint="$2"
+    local offset="$3"
+    local trunc=""
+    [ "$4" = "true" ] && trunc="conv=notrunc"
+
+    local testfile="${mountpoint}/testfile"
+    local comparefile="${mountpoint}/diff"
+    local expectedfile="${mountpoint}/expected-$offset"
+
+    echo "Testing seek=$offset $trunc ..."
+    echo -n 'a' | dd of="$testfile" bs=1 count=1 2>/dev/null
+    umount "$mountpoint" || die "Unable to unmount \"$mountpoint\""
+    mount -t ocfs2 "$device" "$mountpoint" ||
+        die "Unable to remount \"$mountpoint\""
+    echo -n 'a' | dd of="$testfile" bs=1 count=1 seek=$offset $trunc 2>/dev/null
+    dd if="$testfile" bs=1M count=1 2>/dev/null | hexdump -C >"$comparefile"
+    if diff -q "$comparefile" "$expectedfile" >/dev/null 2>&1;
+    then
+        echo "    Test passed."
+    else
+        echo "    Test failed.  Extent contents:"
+        cat "$comparefile"
+    fi
+
+    echo "Cleaning up after test ..."
+    clean_one_test "$testfile" "$comparefile"
+}
+
+setup_expected()
+{
+    local mountpoint="$1"
+
+    cat >"${mountpoint}/expected-10M" <<EOCAT
+00000000  61 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |a...............|
+00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+*
+00100000
+EOCAT
+    [ $? = 0 ] || die "Unable to create \"expected-10M\""
+
+    cp "${mountpoint}/expected-10M" "${mountpoint}/expected-1M" ||
+        die "Unable to create \"expected-1M\""
+
+    cat >"${mountpoint}/expected-512K" <<EOCAT
+00000000  61 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |a...............|
+00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+*
+00080000  61                                                |a|
+00080001
+EOCAT
+    [ $? = 0 ] || die "Unable to create \"expected-512K\""
+
+    cat >"${mountpoint}/expected-1K" <<EOCAT
+00000000  61 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |a...............|
+00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+*
+00000400  61                                                |a|
+00000401
+EOCAT
+    [ $? = 0 ] || die "Unable to create \"expected-1K\""
+
+}
+
+run_tests()
+{
+    local device="$1"
+    local mountpoint="$2"
+    local extra_features="$3"
+
+    echo "Generating filesystem ..."
+    make_fs "$device" "$mountpoint" $extra_features ||
+        die "Unable to create ocfs2 filesystem"
+    setup_expected "$mountpoint"
+
+    local offset
+    for offset in 10M 1M 512K 1K
+    do
+        run_one_test "$device" "$mountpoint" "$offset" "false"
+        run_one_test "$device" "$mountpoint" "$offset" "true"
+    done
+
+    echo "Destroying filesystem ..."
+    umount "$mountpoint" || die "Unable to unmount filesystem"
+    dd if=/dev/urandom of="$device" bs=1M count=1 2>/dev/null ||
+        die "Unable to reset device"
+}
+
+main()
+{
+    echo "Generating image ..."
+    _IMAGE="$(mktemp ${TMPDIR:-/tmp}/tailtest-image.XXXXXX 2>/dev/null)"
+    [ -z "$_IMAGE" ] && die "Unable to create image file"
+    _LOOP="$(make_image "$_IMAGE")"
+    [ -z "$_LOOP" ] && die "Unable to attach loopback device"
+
+    _MOUNTPOINT="$(mktemp -d ${TMPDIR:-/tmp}/tailtest-mountpoint.XXXXXX 2>/dev/null)"
+    [ -z "$_MOUNTPOINT" ] && die "Unable to create mountpoint"
+
+    run_tests "$_LOOP" "$_MOUNTPOINT" "sparse,inline-data"
+    run_tests "$_LOOP" "$_MOUNTPOINT" "sparse,noinline-data"
+    run_tests "$_LOOP" "$_MOUNTPOINT" "nosparse,inline-data"
+    run_tests "$_LOOP" "$_MOUNTPOINT" "nosparse,noinline-data"
+
+    return 0
+}
+
+main "$@"
+exit $?
+
-- 
1.7.1


-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
