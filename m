From: Larry Chen <lchen@suse.com>
Date: Tue,  4 Sep 2018 12:16:20 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] add declaration of
	ocfs2_free_local_alloc_bits
In-Reply-To: <20180904041621.16874-1-lchen@suse.com>
References: <20180904041621.16874-1-lchen@suse.com>
Message-ID: <20180904041621.16874-2-lchen@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Signed-off-by: Larry Chen <lchen@suse.com>
---
 fs/ocfs2/alloc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 250bcacdf9e9..5770503b0e36 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -323,4 +323,10 @@ int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
 int ocfs2_find_subtree_root(struct ocfs2_extent_tree *et,
 			    struct ocfs2_path *left,
 			    struct ocfs2_path *right);
+
+int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
+				handle_t *handle,
+				struct ocfs2_alloc_context *ac,
+				u32 bit_off,
+				u32 num_bits);
 #endif /* OCFS2_ALLOC_H */
-- 
2.13.7
