From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 9 Nov 2016 15:00:17 -0800
Subject: [Ocfs2-devel] [PATCH 7/6] xfstests: fix some minor problems testing
	ocfs2
In-Reply-To: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
References: <147873186646.2820.17513529102740292215.stgit@birch.djwong.org>
Message-ID: <20161109230017.GB21519@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org, eguan@redhat.com
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, fstests <fstests@vger.kernel.org>

There are a a few things about ocfs2 tools that need special-casing in
xfstests, so fix them so that we can start testing ocfs2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/quota |    2 +-
 common/rc    |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/common/quota b/common/quota
index 678bc43..d9bb8d9 100644
--- a/common/quota
+++ b/common/quota
@@ -34,7 +34,7 @@ _require_quota()
 	    _notrun "Installed kernel does not support quotas"
 	fi
 	;;
-    gfs2)
+    gfs2|ocfs2)
 	;;
     xfs)
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
diff --git a/common/rc b/common/rc
index 8e078da..c75b614 100644
--- a/common/rc
+++ b/common/rc
@@ -978,7 +978,7 @@ _scratch_mkfs_sized()
     xfs)
 	def_blksz=`echo $MKFS_OPTIONS|sed -rn 's/.*-b ?size= ?+([0-9]+).*/\1/p'`
 	;;
-    ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4)
+    ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4|ocfs2)
 	def_blksz=`echo $MKFS_OPTIONS| sed -rn 's/.*-b ?+([0-9]+).*/\1/p'`
 	;;
     esac
@@ -1015,6 +1015,9 @@ _scratch_mkfs_sized()
     ext2|ext3|ext4|ext4dev)
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
+    ocfs2)
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+	;;
     udf)
 	$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
@@ -1087,9 +1090,12 @@ _scratch_mkfs_blocksized()
     xfs)
 	_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
 	;;
-    ext2|ext3|ext4|ocfs2)
+    ext2|ext3|ext4)
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
 	;;
+    ocfs2)
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
 	;;
