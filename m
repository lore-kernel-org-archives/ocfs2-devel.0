From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:05 -0700
Subject: [Ocfs2-devel] [PATCH 55/62] ocfs2: Add ac_alloc_slot in
	ocfs2_alloc_context
In-Reply-To: <12071674312495-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
	<1207167425415-git-send-email-mfasheh@suse.com>
	<1207167427753-git-send-email-mfasheh@suse.com>
	<12071674291040-git-send-email-mfasheh@suse.com>
	<12071674312495-git-send-email-mfasheh@suse.com>
Message-ID: <12071674333467-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

In inode stealing, we no longer restrict the allocation to
happen in the local node. So it is neccessary for us to add
a new member in ocfs2_alloc_context to indicate which slot
we are using for allocation. We also modify the process of
local alloc so that this member can be used there also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |    2 ++
 fs/ocfs2/suballoc.c   |    1 +
 fs/ocfs2/suballoc.h   |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ab83fd5..b6d0719 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -523,6 +523,8 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
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
1.5.4.1
