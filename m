From: Gang He <ghe@suse.com>
Date: Mon, 22 May 2017 12:54:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a static checker warning
Message-ID: <1495428877-7440-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

This patch will fix a static checker warning, this warning was
caused by commit d56a8f32e4c662509ce50a37e78fa66c777977d3. after
apply this patch, the error return value will not be NULL(zero).

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 382401d..1a1e007 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -136,7 +136,7 @@ struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 			 int sysfile_type)
 {
-	int rc = 0;
+	int rc = -ESTALE;
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
-- 
1.8.5.6
