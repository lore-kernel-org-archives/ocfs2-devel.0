From: Joe Perches <joe@perches.com>
Date: Mon, 15 Nov 2010 03:06:01 -0000
Subject: [Ocfs2-devel] [PATCH 36/44] fs/ocfs2: Remove unnecessary semicolons
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Message-ID: <e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/refcounttree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b5f9160..da14a42 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3704,7 +3704,7 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 	context->cow_start = cow_start;
 	context->cow_len = cow_len;
 	context->ref_tree = ref_tree;
-	context->ref_root_bh = ref_root_bh;;
+	context->ref_root_bh = ref_root_bh;
 	context->cow_object = xv;
 
 	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
-- 
1.7.3.1.g432b3.dirty
