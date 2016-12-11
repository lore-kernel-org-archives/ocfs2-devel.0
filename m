From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sun, 11 Dec 2016 13:52:57 -0800
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2/reflink: fix file block size
	reporting
In-Reply-To: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
Message-ID: <148149317758.31093.14955725683270205488.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

Some of the reflink tests try to require a specific filesystem block
size so that they can test file block manipulation functions.  That's
straightforward for most filesystems but ocfs2 throws in the additional
twist that data fork block mappings are stored in units of clusters, not
blocks, which causes these reflink tests to fail.

Therefore, introduce a new helper that retrieves the file minimum block
size and adapt the reflink tests to use that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   21 +++++++++++++++++++--
 tests/generic/205 |    2 +-
 tests/generic/206 |    2 +-
 tests/generic/216 |    2 +-
 tests/generic/217 |    2 +-
 tests/generic/218 |    2 +-
 tests/generic/220 |    2 +-
 tests/generic/222 |    2 +-
 tests/generic/227 |    2 +-
 tests/generic/229 |    2 +-
 tests/generic/238 |    2 +-
 11 files changed, 29 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index 2639fbd..30111d4 100644
--- a/common/rc
+++ b/common/rc
@@ -925,7 +925,7 @@ _scratch_mkfs_blocksized()
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
 	;;
     ocfs2)
-	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize -C $blocksize $SCRATCH_DEV
 	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
@@ -3029,13 +3029,30 @@ _sysfs_dev()
 	echo /sys/dev/block/$_maj:$_min
 }
 
+# Get the minimum block size of a file.  Usually this is the
+# minimum fs block size, but some filesystems (ocfs2) do block
+# mappings in larger units.
+get_file_block_size()
+{
+	if [ -z $1 ] || [ ! -d $1 ]; then
+		echo "Missing mount point argument for get_file_block_size"
+		exit 1
+	fi
+	if [ "$FSTYP" = "ocfs2" ]; then
+		stat -c '%o' $1
+	else
+		stat -f -c '%S' $1
+	fi
+}
+
+# Get the minimum block size of an fs.
 get_block_size()
 {
 	if [ -z $1 ] || [ ! -d $1 ]; then
 		echo "Missing mount point argument for get_block_size"
 		exit 1
 	fi
-	echo `stat -f -c %S $1`
+	stat -f -c %S $1
 }
 
 get_page_size()
diff --git a/tests/generic/205 b/tests/generic/205
index cfda8c3..7889ca4 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -60,7 +60,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/206 b/tests/generic/206
index 909956f..f82e146 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/216 b/tests/generic/216
index d9b868a..cbff75f 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/217 b/tests/generic/217
index 65113d9..5f59fd8 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/218 b/tests/generic/218
index 21029ef..bdce367 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/220 b/tests/generic/220
index c54bf06..29d2f04 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/222 b/tests/generic/222
index d7ee57e..3052a22 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/227 b/tests/generic/227
index fa6a33e..18441cf 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/229 b/tests/generic/229
index 3e2c6f4..99eb774 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/238 b/tests/generic/238
index a2f44e8..5419a30 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
