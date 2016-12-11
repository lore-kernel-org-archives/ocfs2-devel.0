From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sun, 11 Dec 2016 13:53:28 -0800
Subject: [Ocfs2-devel] [PATCH 7/7] xfs/ext4: check negative inode size
In-Reply-To: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
References: <148149316504.31093.16129068344227450710.stgit@birch.djwong.org>
Message-ID: <148149320892.31093.18280644018166858868.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: ocfs2-devel@oss.oracle.com, fstests@vger.kernel.org

Craft a malicious filesystem image with a negative inode size,
then try to trigger a kernel DoS by appending data to the file.
Ideally this should trigger verifier errors instead of hanging.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/400   |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/401   |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/group |    2 ++
 tests/xfs/400    |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/401    |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group  |    2 ++
 6 files changed, 290 insertions(+)
 create mode 100755 tests/ext4/400
 create mode 100755 tests/ext4/401
 create mode 100755 tests/xfs/400
 create mode 100755 tests/xfs/401


diff --git a/tests/ext4/400 b/tests/ext4/400
new file mode 100755
index 0000000..5857549
--- /dev/null
+++ b/tests/ext4/400
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FSQA Test No. 400
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016-2017 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext2 ext3 ext4
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+
+echo "Corrupt filesystem"
+_scratch_unmount
+debugfs -w -R "sif /a size -1" $SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/401 b/tests/ext4/401
new file mode 100755
index 0000000..ee7ecf3
--- /dev/null
+++ b/tests/ext4/401
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FSQA Test No. 401
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016-2017 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext2 ext3 ext4
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+
+echo "Corrupt filesystem"
+_scratch_unmount
+debugfs -w -R "sif /a size 0xFFFFFFFFFFFFFE00" $SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=direct,append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/group b/tests/ext4/group
index 53fe03e..43b2d06 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -34,3 +34,5 @@
 306 auto rw resize quick
 307 auto ioctl rw
 308 auto ioctl rw prealloc quick
+400 dangerous_fuzzers
+401 dangerous_fuzzers
diff --git a/tests/xfs/400 b/tests/xfs/400
new file mode 100755
index 0000000..498c024
--- /dev/null
+++ b/tests/xfs/400
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 400
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016-2017 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+inum=$(stat -c "%i" $testdir/a)
+
+echo "Corrupt filesystem"
+_scratch_unmount
+_scratch_xfs_db -x -c "inode ${inum}" -c 'write core.size -- -1' >> $seqres.full
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/401 b/tests/xfs/401
new file mode 100755
index 0000000..41b262d
--- /dev/null
+++ b/tests/xfs/401
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 401
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016-2017 Oracle, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+inum=$(stat -c "%i" $testdir/a)
+
+echo "Corrupt filesystem"
+_scratch_unmount
+_scratch_xfs_db -x -c "inode ${inum}" -c 'write core.size -- -1' >> $seqres.full
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=direct,append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/group b/tests/xfs/group
index c237b50..10ba27b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -334,3 +334,5 @@
 345 auto quick clone
 346 auto quick clone
 347 auto quick clone
+400 dangerous_fuzzers
+401 dangerous_fuzzers
