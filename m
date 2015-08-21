From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:41:50 -0700
Subject: [Ocfs2-devel] [patch 22/24] ocfs2: create/remove sysfile for online
	file check
Message-ID: <55d79b1e.uA2Uf9CGEO+lUq7a%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: create/remove sysfile for online file check

Create online file check sysfile when ocfs2 mount, remove the related
sysfile when ocfs2 umount.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/super.c~ocfs2-create-remove-sysfile-for-online-file-check fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-create-remove-sysfile-for-online-file-check
+++ a/fs/ocfs2/super.c
@@ -74,6 +74,7 @@
 #include "suballoc.h"
 
 #include "buffer_head_io.h"
+#include "filecheck.h"
 
 static struct kmem_cache *ocfs2_inode_cachep;
 struct kmem_cache *ocfs2_dquot_cachep;
@@ -1204,6 +1205,9 @@ static int ocfs2_fill_super(struct super
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
+	ocfs2_filecheck_create_sysfs(sb);
+
 	return status;
 
 read_super_error:
@@ -1671,6 +1675,7 @@ static void ocfs2_put_super(struct super
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
+	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
_
