From: Gang He <ghe@suse.com>
Date: Wed, 24 Jun 2015 13:24:20 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: create/remove sysfile for online
	file check
In-Reply-To: <1435123461-3525-1-git-send-email-ghe@suse.com>
References: <1435123461-3525-1-git-send-email-ghe@suse.com>
Message-ID: <1435123461-3525-4-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, ghe@suse.com, rgoldwyn@suse.de
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Create online file check sysfile when ocfs2 mount,
remove the related sysfile when ocfs2 umount.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 403c566..7213a94 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -74,6 +74,7 @@
 #include "suballoc.h"
 
 #include "buffer_head_io.h"
+#include "filecheck.h"
 
 static struct kmem_cache *ocfs2_inode_cachep;
 struct kmem_cache *ocfs2_dquot_cachep;
@@ -1202,6 +1203,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
+	ocfs2_filecheck_create_sysfs(sb);
+
 	return status;
 
 read_super_error:
@@ -1658,6 +1662,7 @@ static void ocfs2_put_super(struct super_block *sb)
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
+	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
-- 
2.1.2
