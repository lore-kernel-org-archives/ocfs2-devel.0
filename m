From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:07 -0700
Subject: [Ocfs2-devel] [patch 14/22] ocfs2: add the missing return value
	check of ocfs2_xattr_get_clusters
Message-ID: <20130827210507.E085331C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: add the missing return value check of ocfs2_xattr_get_clusters

In ocfs2_xattr_value_attach_refcount(), if error occurs when calling
ocfs2_xattr_get_clusters(), it will go with unexpected behavior since
local variables p_cluster, num_clusters and ext_flags are declared without
initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters
+++ a/fs/ocfs2/xattr.c
@@ -5881,6 +5881,10 @@ static int ocfs2_xattr_value_attach_refc
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
 					       &num_clusters, el, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
 
 		cpos += num_clusters;
 		if ((ext_flags & OCFS2_EXT_REFCOUNTED))
_
