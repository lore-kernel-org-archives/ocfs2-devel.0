From: Tao Ma <tao.ma@oracle.com>
Date: Mon Mar  3 01:13:15 2008
Subject: [Ocfs2-devel] [PATCH 2/3] Add ac_alloc_slot in
	ocfs2_alloc_context.V3
In-Reply-To: <20080303090022.GA18049@tma-pc1.cn.oracle.com>
Message-ID: <20080303091230.GA18126@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In inode stealing, we no longer restrict the allocation to
happen in the local node. So it is neccessary for us to add
a new member in ocfs2_alloc_context to indicate which slot
we are using for allocation. We also modify the process of
local alloc so that this member can be used there also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c |    2 ++
 fs/ocfs2/suballoc.c   |    1 +
 fs/ocfs2/suballoc.h   |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index add1ffd..80d1c75 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -526,6 +526,8 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	}
 
 	ac->ac_inode = local_alloc_inode;
+	/* We should never use localalloc from another slot */
+	ac->ac_alloc_slot = osb->slot_num;
 	ac->ac_which = OCFS2_AC_USE_LOCAL;
 	get_bh(osb->local_alloc_bh);
 	ac->ac_bh = osb->local_alloc_bh;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 3be4e73..33d5573 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -424,6 +424,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	}
 
 	ac->ac_inode = alloc_inode;
+	ac->ac_alloc_slot = slot;
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(fe)) {
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 8799033..544c600 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -36,6 +36,7 @@ typedef int (group_search_t)(struct inode *,
 struct ocfs2_alloc_context {
 	struct inode *ac_inode;    /* which bitmap are we allocating from? */
 	struct buffer_head *ac_bh; /* file entry bh */
+	u32    ac_alloc_slot;   /* which slot are we allocating from? */
 	u32    ac_bits_wanted;
 	u32    ac_bits_given;
 #define OCFS2_AC_USE_LOCAL 1
-- 
1.5.3.GIT
