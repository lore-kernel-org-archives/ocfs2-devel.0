From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 26 Feb 2015 13:01:46 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make append_dio an incompat feature
Message-ID: <20150226210146.GL21790@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It turns out that making this feature ro_compat isn't quite enough to
prevent accidental corruption on mount from older kernels. Ocfs2 (like other
file systems) will process orphaned inodes even when the user mounts in 'ro'
mode. So for the case of a filesystem not knowing the append_dio feature,
mounting the filesystem could result in orphaned-for-dio files being
deleted, which we clearly don't want.

So instead, turn this into an incompat flag.

Btw, this is kind of my fault - initially I asked that we add a flag to
cover the feature and even suggested that we use an ro flag. It wasn't until
I was looking through our commits for v4.0-rc1 that I realized we actually want
this to be incompat.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/ocfs2.h    |  2 +-
 fs/ocfs2/ocfs2_fs.h | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8490c64..460c6c3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -502,7 +502,7 @@ static inline int ocfs2_writes_unwritten_extents(struct ocfs2_super *osb)
 
 static inline int ocfs2_supports_append_dio(struct ocfs2_super *osb)
 {
-	if (osb->s_feature_ro_compat & OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_APPEND_DIO)
 		return 1;
 	return 0;
 }
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 20e37a3..db64ce2 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -102,11 +102,11 @@
 					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
 					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
 					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
-					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
+					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO \
+					 | OCFS2_FEATURE_INCOMPAT_APPEND_DIO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -179,6 +179,11 @@
 #define OCFS2_FEATURE_INCOMPAT_CLUSTERINFO	0x4000
 
 /*
+ * Append Direct IO support
+ */
+#define OCFS2_FEATURE_INCOMPAT_APPEND_DIO	0x8000
+
+/*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
  */
@@ -200,10 +205,6 @@
 #define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
 #define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004
 
-/*
- * Append Direct IO support
- */
-#define OCFS2_FEATURE_RO_COMPAT_APPEND_DIO	0x0008
 
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
-- 
2.1.2
