From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:49 -0700
Subject: [Ocfs2-devel] [PATCH 16/17] configfs: call drop_link() to cleanup
	after create_link() failure
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-17-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Louis Rilling <Louis.Rilling@kerlabs.com>

From: Louis Rilling <Louis.Rilling@kerlabs.com>

When allow_link() succeeds but create_link() fails, the subsystem is not
informed of the failure.

This patch fixes this by calling drop_link() on create_link() failures.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/symlink.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index faeb441..0004d18 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -140,8 +140,12 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 		goto out_put;
 
 	ret = type->ct_item_ops->allow_link(parent_item, target_item);
-	if (!ret)
+	if (!ret) {
 		ret = create_link(parent_item, target_item, dentry);
+		if (ret && type->ct_item_ops->drop_link)
+			type->ct_item_ops->drop_link(parent_item,
+						     target_item);
+	}
 
 	config_item_put(target_item);
 	path_put(&nd.path);
-- 
1.5.4.1
