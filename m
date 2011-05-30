From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 30 May 2011 14:39:29 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: free memory allocated by
	security_inode_init_security
Message-ID: <1306737569-3919-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The LSM security_inode_init_security() hook allocates memory
for xattr name and value, expecting the caller to release
the memory afterwards.

reported-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 81ecf9c..e9b031e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7215,6 +7215,8 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 
 	ocfs2_inode_unlock(dir, 0);
 	brelse(dir_bh);
+	kfree(si.name);
+	kfree(si.value);
 leave:
 	return ret;
 }
-- 
1.7.4.4
