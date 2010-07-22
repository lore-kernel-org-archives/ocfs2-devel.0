From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Thu, 22 Jul 2010 13:26:11 +0800
Subject: [Ocfs2-devel] [PATCH V2] Fix the nested PR lock calling issue
In-Reply-To: <4C473BE2.8000608@oracle.com>
References: <20100721144805.GA12822@linux-jjzhang>
	<20100721151701.GA3579@laptop.jp.oracle.com>
	<20100721160542.GA19036@linux-jjzhang>
	<4C473BE2.8000608@oracle.com>
Message-ID: <20100722052611.GA13238@linux-jjzhang>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 21, 2010 at 11:26:42AM -0700, Sunil Mushran wrote:
> Why not add _ocfs2_get_acl() that does the same without
> taking the cluster locks?

Good suggestion! It will make the code much clearer. I attached the
improved patch as below. One thing I'm not sure is do we need to
exchange the function name '_ocfs2_get_acl' and 'ocfs2_get_acl_nolock'
as well? I'm not sure which is better, so just add a function
_ocfs2_get_acl() in this patch now.

Many thanks for your review and comments;)

Thanks,
Jiaju

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
---
 fs/ocfs2/acl.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index da70229..b85e092 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -138,6 +138,29 @@ static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
 	return acl;
 }
 
+static struct posix_acl *_ocfs2_get_acl(struct inode *inode, int type)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	struct posix_acl *acl;
+	int ret;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return NULL;
+
+	ret = ocfs2_read_inode_block(inode, &di_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		acl = ERR_PTR(ret);
+		return acl;
+	}
+
+	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
+
+	brelse(di_bh);
+
+	return acl;
+}
 
 /*
  * Get posix acl.
@@ -290,7 +313,7 @@ static int ocfs2_set_acl(handle_t *handle,
 
 int ocfs2_check_acl(struct inode *inode, int mask)
 {
-	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl = _ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
 
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
