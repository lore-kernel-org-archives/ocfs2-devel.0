From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 5 Mar 2015 20:46:19 +0300
Subject: [Ocfs2-devel] [patch 1/2] ocfs2: dereferencing freed pointers in
	ocfs2_reflink()
In-Reply-To: <20150124193124.GA18322@mwanda>
Message-ID: <20150305174619.GA13294@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
References: <20150124193124.GA18322@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org, ocfs2-devel@oss.oracle.com

The code at the "out" label assumes that "default_acl" and "acl" are
NULL, but actually the pointers can be NULL, unitialized, or freed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ee541f9..df3a500 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4276,7 +4276,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 	error = posix_acl_create(dir, &mode, &default_acl, &acl);
 	if (error) {
 		mlog_errno(error);
-		goto out;
+		return error;
 	}
 
 	error = ocfs2_create_inode_in_orphan(dir, mode,
