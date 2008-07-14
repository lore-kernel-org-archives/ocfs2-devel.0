From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:45 -0700
Subject: [Ocfs2-devel] [PATCH 12/17] configfs: Make configfs_new_dirent()
	return error code instead of NULL
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-13-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Louis Rilling <Louis.Rilling@kerlabs.com>

From: Louis Rilling <Louis.Rilling@kerlabs.com>

This patch makes configfs_new_dirent return negative error code instead of NULL,
which will be useful in the next patch to differentiate ENOMEM from ENOENT.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/dir.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a08e5c2..918a332 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -30,6 +30,7 @@
 #include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
@@ -83,7 +84,7 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 
 	sd = kmem_cache_zalloc(configfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
@@ -129,8 +130,8 @@ int configfs_make_dirent(struct configfs_dirent * parent_sd,
 	struct configfs_dirent * sd;
 
 	sd = configfs_new_dirent(parent_sd, element);
-	if (!sd)
-		return -ENOMEM;
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
 
 	sd->s_mode = mode;
 	sd->s_type = type;
@@ -1277,7 +1278,7 @@ static int configfs_dir_open(struct inode *inode, struct file *file)
 	file->private_data = configfs_new_dirent(parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	return file->private_data ? 0 : -ENOMEM;
+	return IS_ERR(file->private_data) ? PTR_ERR(file->private_data) : 0;
 
 }
 
-- 
1.5.4.1
