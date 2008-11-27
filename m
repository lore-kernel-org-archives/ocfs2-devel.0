From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 26 Nov 2008 16:06:17 -0800
Subject: [Ocfs2-devel] [PATCH 04/13] ocfs2: Explain t_is_new in
	ocfs2_cp_xattr_cluster().
In-Reply-To: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1227744386-10502-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I was unsure of the JOURNAL_ACCESS parameters in
ocfs2_cp_xattr_cluster().  They're based on the function argument
't_is_new', but I couldn't quite figure out how t_is_new mapped to
allocation.  ocfs2_cp_xattr_cluster() actually overwrites the target,
regardless of t_is_new.

Well, I just figured it out.  So I'm adding a big fat comment for those
who come after me.  ocfs2_divide_xattr_cluster() has the same behavior.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 11b518a..cb71dcc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3753,6 +3753,11 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * Hey, if we're overwriting t_bucket, what difference does
+	 * ACCESS_CREATE vs ACCESS_WRITE make?  See the comment in the
+	 * same part of ocfs2_cp_xattr_bucket().
+	 */
 	ret = ocfs2_xattr_bucket_journal_access(handle, t_bucket,
 						new_bucket_head ?
 						OCFS2_JOURNAL_ACCESS_CREATE :
@@ -3924,6 +3929,18 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	if (ret)
 		goto out;
 
+	/*
+	 * Hey, if we're overwriting t_bucket, what difference does
+	 * ACCESS_CREATE vs ACCESS_WRITE make?  Well, if we allocated a new
+	 * cluster to fill, we came here from ocfs2_cp_xattr_cluster(), and
+	 * it is really new - ACCESS_CREATE is required.  But we also
+	 * might have moved data out of t_bucket before extending back
+	 * into it.  ocfs2_add_new_xattr_bucket() can do this - its call
+	 * to ocfs2_add_new_xattr_cluster() may have created a new extent
+	 * and copied out the end of the old extent.  Then it re-extends
+	 * the old extent back to create space for new xattrs.  That's
+	 * how we get here, and the bucket isn't really new.
+	 */
 	ret = ocfs2_xattr_bucket_journal_access(handle, t_bucket,
 						t_is_new ?
 						OCFS2_JOURNAL_ACCESS_CREATE :
-- 
1.5.6.5
