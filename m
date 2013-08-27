From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:00 -0700
Subject: [Ocfs2-devel] [patch 08/22] ocfs2: ac_bits_wanted should be
	local_alloc_bits when returns -ENOSPC
Message-ID: <20130827210500.E6D8D5A4276@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: ac_bits_wanted should be local_alloc_bits when returns -ENOSPC

There is an issue in reserving and claiming space for localalloc, When
localalloc space is not enough, it would claim space from global_bitmap. 
And if there is not enough free space in global_bitmap, the size of
claiming space would set to half of orignal size and retry.

The issue is as follows: osb->local_alloc_bits is set to half of orignal
size in ocfs2_recalc_la_window(), but ac->ac_bits_wanted is set to
osb->local_alloc_default_bits which is not changed.  localalloc always
reserves and claims local_alloc_default_bits space and returns ENOSPC.

So, ac->ac_bits_wanted should be osb->local_alloc_bits which would be
changed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc
+++ a/fs/ocfs2/localalloc.c
@@ -1082,7 +1082,7 @@ static int ocfs2_local_alloc_reserve_for
 	}
 
 retry_enospc:
-	(*ac)->ac_bits_wanted = osb->local_alloc_default_bits;
+	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status == -ENOSPC) {
 		if (ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_ENOSPC) ==
@@ -1154,7 +1154,7 @@ retry_enospc:
 		    OCFS2_LA_DISABLED)
 			goto bail;
 
-		ac->ac_bits_wanted = osb->local_alloc_default_bits;
+		ac->ac_bits_wanted = osb->local_alloc_bits;
 		status = ocfs2_claim_clusters(handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
_
