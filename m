From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 11 Mar 2010 18:30:11 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Always try for maximum bits with new
	local alloc windows
Message-ID: <20100312023011.GR11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What we were doing before was to ask for the current window size as the
maximum allocation. This had the effect of limiting the amount of allocation
we could get for the local alloc during times when the window size was
shrunk due to fragmentation. In some cases, that could actually *increase*
fragmentation by artificially limiting the number of bits we can accept. So
while we still want to ask for a minimum number of bits equal to window
size, there is no reason why we should limit the number of bits the local
alloc should accept. Hence always allow the maximum number of local alloc
bits.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 9ab9d33..955a60b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,7 +1002,7 @@ static int ocfs2_local_alloc_reserve_for_window(struct ocfs2_super *osb,
 	}
 
 retry_enospc:
-	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
+	(*ac)->ac_bits_wanted = osb->local_alloc_default_bits;
 
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status == -ENOSPC) {
@@ -1069,7 +1069,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	/* we used the generic suballoc reserve function, but we set
 	 * everything up nicely, so there's no reason why we can't use
 	 * the more specific cluster api to claim bits. */
-	status = ocfs2_claim_clusters(osb, handle, ac, osb->local_alloc_bits,
+	status = ocfs2_claim_clusters(osb, handle, ac, osb->local_alloc_default_bits,
 				      &cluster_off, &cluster_count);
 	if (status == -ENOSPC) {
 retry_enospc:
@@ -1087,6 +1087,8 @@ retry_enospc:
 		mlog(ML_NOTICE, "LASTATE: tryalloc (nested) %u bits\n",
 		     osb->local_alloc_bits);
 
+		ac->ac_bits_wanted = osb->local_alloc_default_bits;
+
 		status = ocfs2_claim_clusters(osb, handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
-- 
1.6.4.2
