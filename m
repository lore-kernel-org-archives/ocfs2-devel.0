From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 4 Sep 2018 14:55:10 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] add declaration of
	ocfs2_free_local_alloc_bits
In-Reply-To: <20180904041621.16874-2-lchen@suse.com>
References: <20180904041621.16874-1-lchen@suse.com>
	<20180904041621.16874-2-lchen@suse.com>
Message-ID: <20180904145510.9dd257f40514c8c839745bf4@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Larry Chen <lchen@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue,  4 Sep 2018 12:16:20 +0800 Larry Chen <lchen@suse.com> wrote:

> Signed-off-by: Larry Chen <lchen@suse.com>
> ---
>  fs/ocfs2/alloc.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
> index 250bcacdf9e9..5770503b0e36 100644
> --- a/fs/ocfs2/alloc.h
> +++ b/fs/ocfs2/alloc.h
> @@ -323,4 +323,10 @@ int ocfs2_find_cpos_for_left_leaf(struct super_block *sb,
>  int ocfs2_find_subtree_root(struct ocfs2_extent_tree *et,
>  			    struct ocfs2_path *left,
>  			    struct ocfs2_path *right);
> +
> +int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
> +				handle_t *handle,
> +				struct ocfs2_alloc_context *ac,
> +				u32 bit_off,
> +				u32 num_bits);
>  #endif /* OCFS2_ALLOC_H */

It's already declared in fs/ocfs2/localalloc.h - why not include that?

I did this with the other patch and all seems well:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fix-clusters-leak-in-ocfs2_defrag_extent-fix

include localalloc.h, reduce scope of data_ac

Cc: Larry Chen <lchen@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/move_extents.c~fix-clusters-leak-in-ocfs2_defrag_extent-fix
+++ a/fs/ocfs2/move_extents.c
@@ -25,6 +25,7 @@
 #include "ocfs2_ioctl.h"
 
 #include "alloc.h"
+#include "localalloc.h"
 #include "aops.h"
 #include "dlmglue.h"
 #include "extent_map.h"
@@ -227,7 +228,6 @@ static int ocfs2_defrag_extent(struct oc
 	u32 new_phys_cpos, new_len;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
 	int need_free = 0;
-	struct ocfs2_alloc_context *data_ac;
 
 	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
 		BUG_ON(!ocfs2_is_refcount_inode(inode));
@@ -345,7 +345,8 @@ static int ocfs2_defrag_extent(struct oc
 
 out_commit:
 	if (need_free && context->data_ac) {
-		data_ac = context->data_ac;
+		struct ocfs2_alloc_context *data_ac = context->data_ac;
+
 		if (context->data_ac->ac_which == OCFS2_AC_USE_LOCAL)
 			ocfs2_free_local_alloc_bits(osb, handle, data_ac,
 					new_phys_cpos, new_len);
_
