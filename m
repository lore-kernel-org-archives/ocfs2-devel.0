From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sun, 11 Dec 2016 13:53:10 -0800
Subject: [Ocfs2-devel] [PATCH 4/7] reflink: fix space consumption tests
In-Reply-To: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
Message-ID: <148149319048.31093.2083894591825614863.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

Some of the tests try to check that we can't COW when we're out of
space, but some tricky filesystems make this hard because writing N
blocks doesn't increase used blocks by N....

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate   |   14 ++++++++++++++
 tests/generic/171 |    5 ++---
 tests/generic/173 |    5 ++---
 tests/generic/174 |    5 ++---
 tests/generic/282 |    3 +--
 5 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/common/populate b/common/populate
index d0003c5..9811d21 100644
--- a/common/populate
+++ b/common/populate
@@ -30,6 +30,20 @@ _require_xfs_db_blocktrash_z_command() {
 	$XFS_DB_PROG -x -f -c 'blocktrash -z' "${TEST_DEV}" | grep -q 'nothing on stack' || _notrun "blocktrash -z not supported"
 }
 
+# Eat free space until we can't anymore.
+_consume_free_space() {
+	dir=$1
+
+	old_nr_free=0
+	nr_free=$(stat -f -c '%f' $dir)
+	x=0
+	while [ $nr_free -gt 0 ] && [ $old_nr_free != $nr_free ]; do
+		$XFS_IO_PROG -f -c "pwrite -b 4194304 0 $((blksz * nr_free))" $dir/eat_my_space.$((x++))
+		old_nr_free=$nr_free
+		nr_free=$(stat -f -c '%f' $dir)
+	done
+}
+
 # Attempt to make files of "every" format for data, dirs, attrs etc.
 # (with apologies to Eric Sandeen for mutating xfser.sh)
 
diff --git a/tests/generic/171 b/tests/generic/171
index b01dbd5..d96fd17 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -41,6 +41,7 @@ _cleanup()
 . ./common/filter
 . ./common/attr
 . ./common/reflink
+. ./common/populate
 
 # real QA test starts here
 _supported_os Linux
@@ -75,9 +76,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free=$(stat -f -c '%f' $testdir)
-touch $testdir/file0 $testdir/file1
-_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
+_consume_free_space $testdir >> $seqres.full 2>&1
 sync
 
 echo "CoW the big file"
diff --git a/tests/generic/173 b/tests/generic/173
index e35597f..20c6091 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -41,6 +41,7 @@ _cleanup()
 . ./common/filter
 . ./common/attr
 . ./common/reflink
+. ./common/populate
 
 # real QA test starts here
 _supported_os Linux
@@ -75,9 +76,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free=$(stat -f -c '%f' $testdir)
-touch $testdir/file0 $testdir/file1
-_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
+_consume_free_space $testdir >> $seqres.full 2>&1
 sync
 
 echo "mmap CoW the big file"
diff --git a/tests/generic/174 b/tests/generic/174
index 38fad1d..d811307 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -41,6 +41,7 @@ _cleanup()
 . ./common/filter
 . ./common/attr
 . ./common/reflink
+. ./common/populate
 
 # real QA test starts here
 _supported_os Linux
@@ -76,9 +77,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
 sync
 
 echo "Allocate the rest of the space"
-nr_free=$(stat -f -c '%f' $testdir)
-touch $testdir/file0 $testdir/file1
-_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
+_consume_free_space $testdir >> $seqres.full 2>&1
 sync
 
 echo "CoW the big file"
diff --git a/tests/generic/282 b/tests/generic/282
index 6452025..8a30811 100755
--- a/tests/generic/282
+++ b/tests/generic/282
@@ -80,8 +80,7 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 sync
 _dmerror_load_error_table
-urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" $testdir/file2 > $TEST_DIR/mwrite.out 2>&1)
-cat $TEST_DIR/mwrite.out | tee -a $seqres.full
+$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
 _dmerror_load_working_table
 rm -rf $testdir/file2 >> $seqres.full 2>&1
 _dmerror_unmount
