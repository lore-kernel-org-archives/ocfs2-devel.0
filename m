From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 11 Jan 2010 18:37:50 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix refcnt leak on
	ocfs2_fast_follow_link() error path
Message-ID: <87eilwjxmu.fsf@devron.myhome.or.jp>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org


If ->follow_link handler return the error, it should decrement
nd->path refcnt. But, ocfs2_fast_follow_link() doesn't decrement.

This patch fix it by using usual nd_set_link() style error handling,
instead of playing with nd->path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/ocfs2/symlink.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/symlink.c~namei-ocfs2-follow_link-fix fs/ocfs2/symlink.c
--- linux-2.6/fs/ocfs2/symlink.c~namei-ocfs2-follow_link-fix	2010-01-12 00:15:14.000000000 +0900
+++ linux-2.6-hirofumi/fs/ocfs2/symlink.c	2010-01-12 00:15:14.000000000 +0900
@@ -137,20 +137,20 @@ static void *ocfs2_fast_follow_link(stru
 	}
 
 	memcpy(link, target, len);
-	nd_set_link(nd, link);
 
 bail:
+	nd_set_link(nd, status ? ERR_PTR(status) : link);
 	brelse(bh);
 
 	mlog_exit(status);
-	return status ? ERR_PTR(status) : link;
+	return NULL;
 }
 
 static void ocfs2_fast_put_link(struct dentry *dentry, struct nameidata *nd, void *cookie)
 {
-	char *link = cookie;
-
-	kfree(link);
+	char *link = nd_get_link(nd);
+	if (!IS_ERR(link))
+		kfree(link);
 }
 
 const struct inode_operations ocfs2_symlink_inode_operations = {
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
