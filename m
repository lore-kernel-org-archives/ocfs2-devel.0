From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar 28 18:51:01 2007
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Local mounts should not truncate
	the extent map.
References: <20070329005041.518030000@oracle.com>
Message-ID: <20070329005717.809593000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A local mount can implicitly trust state on the inode.  There are no other
nodes to change the filesystem.  Thus, local mounts should leave the extent
map intact until ->clear_inode().

This fixes a bug where a call to ocfs2_meta_lock_update() can race queries
of the extent map.  A clustered mount only allows one process through
ocfs2_meta_lock_update(), but a local mount allows all processes through.
Thus, one process can be all the way to ocfs2_extent_map_get_blocks() when
a second process is truncating the extent map in ocfs2_meta_lock_update().
That no longer happens because the extent map is unmodified.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e335541..eb1c8fa 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1508,8 +1508,9 @@ static int ocfs2_meta_lock_update(struct
 	ocfs2_metadata_cache_purge(inode);
 
 	/* will do nothing for inode types that don't use the extent
-	 * map (directories, bitmap files, etc) */
-	ocfs2_extent_map_trunc(inode, 0);
+	 * map (bitmap files, etc) */
+	if (!ocfs2_mount_local(osb))
+		ocfs2_extent_map_trunc(inode, 0);
 
 	if (lockres && ocfs2_meta_lvb_is_trustable(inode, lockres)) {
 		mlog(0, "Trusting LVB on inode %llu\n",
-- 
1.4.2.3
