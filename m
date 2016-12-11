From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sun, 11 Dec 2016 13:53:04 -0800
Subject: [Ocfs2-devel] [PATCH 3/7] reflink: fix quota tests to work properly
In-Reply-To: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
Message-ID: <148149318401.31093.3864124073555352683.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

Fix the reflink quota tests to su to the fsgqa user so that we actually
test enforcement of quotas.  Seems that XFS enforces user quotas even
if root is writing to a user file, whereas everything else lets root
writes through.  Also clean up some of the variable usage and
_require_user.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/305     |    2 +-
 tests/generic/305.out |   30 +++++++++++++++---------------
 tests/generic/326     |    2 +-
 tests/generic/326.out |   30 +++++++++++++++---------------
 tests/generic/327     |   12 +++++++-----
 tests/generic/327.out |   12 ++++++------
 tests/generic/328     |   14 ++++++++------
 tests/generic/328.out |   28 ++++++++++++++--------------
 8 files changed, 67 insertions(+), 63 deletions(-)


diff --git a/tests/generic/305 b/tests/generic/305
index d73d87f..9c3489b 100755
--- a/tests/generic/305
+++ b/tests/generic/305
@@ -51,7 +51,7 @@ _require_quota
 _require_nobody
 
 _repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+	repquota -O csv $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)' | awk -F ',' '{print $1, $4, $5, $6}'
 }
 rm -f $seqres.full
 
diff --git a/tests/generic/305.out b/tests/generic/305.out
index 0bfd620..fbd4e24 100644
--- a/tests/generic/305.out
+++ b/tests/generic/305.out
@@ -1,22 +1,22 @@
 QA output created by 305
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0
diff --git a/tests/generic/326 b/tests/generic/326
index 8afc6a2..b86f6a2 100755
--- a/tests/generic/326
+++ b/tests/generic/326
@@ -52,7 +52,7 @@ _require_nobody
 _require_odirect
 
 _repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+	repquota -O csv $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)' | awk -F ',' '{print $1, $4, $5, $6}'
 }
 rm -f $seqres.full
 
diff --git a/tests/generic/326.out b/tests/generic/326.out
index e771eb7..de7f20b 100644
--- a/tests/generic/326.out
+++ b/tests/generic/326.out
@@ -1,22 +1,22 @@
 QA output created by 326
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0
diff --git a/tests/generic/327 b/tests/generic/327
index c165ad5..29706e9 100755
--- a/tests/generic/327
+++ b/tests/generic/327
@@ -48,9 +48,10 @@ _require_cp_reflink
 _require_fiemap
 _require_quota
 _require_nobody
+_require_user
 
 _repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+	repquota -O csv $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk -F ',' '{print $1, $4, $5, $6}'
 }
 rm -f $seqres.full
 
@@ -67,19 +68,20 @@ mkdir $testdir
 sz=1048576
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
-chown fsgqa $testdir/file1
+chown $qa_user $testdir/file1
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _repquota
 _scratch_cycle_mount
+quotaon $SCRATCH_MNT 2> /dev/null
 
 echo "Set hard quota to prevent third reflink"
-setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
+setquota -u $qa_user 0 1024 0 0 $SCRATCH_MNT
 _repquota
 
 echo "Try to reflink again"
 touch $testdir/file3
-chown fsgqa $testdir/file3
-_cp_reflink $testdir/file1 $testdir/file3 2>&1 | _filter_scratch
+chown $qa_user $testdir/file3
+su $qa_user -c "cp --reflink=always -f $testdir/file1 $testdir/file3" 2>&1 | _filter_scratch
 _repquota
 
 # success, all done
diff --git a/tests/generic/327.out b/tests/generic/327.out
index 7160ff2..f4e145a 100644
--- a/tests/generic/327.out
+++ b/tests/generic/327.out
@@ -1,12 +1,12 @@
 QA output created by 327
 Format and mount
 Create the original files
-root      --       0       0       0              4     0     0       
-fsgqa     --    2048       0       0              2     0     0       
+root 0 0 0
+fsgqa 2048 0 0
 Set hard quota to prevent third reflink
-root      --       0       0       0              4     0     0       
-fsgqa     +-    2048       0    1024              2     0     0       
+root 0 0 0
+fsgqa 2048 0 1024
 Try to reflink again
 cp: failed to clone 'SCRATCH_MNT/test-327/file3' from 'SCRATCH_MNT/test-327/file1': Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    2048       0    1024              3     0     0       
+root 0 0 0
+fsgqa 2048 0 1024
diff --git a/tests/generic/328 b/tests/generic/328
index 705368e..7800246 100755
--- a/tests/generic/328
+++ b/tests/generic/328
@@ -49,9 +49,10 @@ _require_fiemap
 _require_quota
 _require_nobody
 _require_odirect
+_require_user
 
 _repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+	repquota -O csv $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk -F ',' '{print $1, $4, $5, $6}'
 }
 rm -f $seqres.full
 
@@ -68,28 +69,29 @@ mkdir $testdir
 sz=1048576
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
-chown fsgqa $testdir/file1
+chown $qa_user $testdir/file1
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
 _repquota
 _scratch_cycle_mount
+quotaon $SCRATCH_MNT 2> /dev/null
 
 echo "Set hard quota to prevent rewrite"
-setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
+setquota -u $qa_user 0 1024 0 0 $SCRATCH_MNT
 _repquota
 
 echo "Try to dio write the whole file"
-_pwrite_byte 0x62 0 $sz $testdir/file1 -d 2>&1 >> $seqres.full | \
+su $qa_user -c '$XFS_IO_PROG -d -c "pwrite 0 '$((sz+65536))'" '$testdir'/file1' 2>&1 >> $seqres.full | \
 	_filter_xfs_io_error
 _repquota
 
 echo "Try to write the whole file"
-_pwrite_byte 0x62 0 $sz $testdir/file1 2>&1 >> $seqres.full | \
+su $qa_user -c '$XFS_IO_PROG -c "pwrite 0 '$((sz+65536))'" '$testdir'/file1' 2>&1 >> $seqres.full | \
 	_filter_xfs_io_error
 _repquota
 
 echo "Set hard quota to allow rewrite"
-setquota -u fsgqa 0 8192 0 0 $SCRATCH_MNT
+setquota -u $qa_user 0 8192 0 0 $SCRATCH_MNT
 _repquota
 
 echo "Try to dio write the whole file"
diff --git a/tests/generic/328.out b/tests/generic/328.out
index 4630151..b7fe9f8 100644
--- a/tests/generic/328.out
+++ b/tests/generic/328.out
@@ -1,25 +1,25 @@
 QA output created by 328
 Format and mount
 Create the original files
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0       0              3     0     0       
+root 0 0 0
+fsgqa 3072 0 0
 Set hard quota to prevent rewrite
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Try to dio write the whole file
 pwrite: Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Try to write the whole file
 pwrite: Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Set hard quota to allow rewrite
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
 Try to dio write the whole file
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
 Try to write the whole file
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
