From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:08 +0800
Subject: [Ocfs2-devel] [PATCH 11/15] ocfs2: Don't relink cluster groups when
	allocating discontig block groups
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-11-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joel Becker <joel.becker@oracle.com>

We don't have enough credits, and the filesystem is in a full state
anyway.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/suballoc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 679ac4d..0d2cd75 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -613,6 +613,14 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 		goto bail;
 	}
 
+	/*
+	 * We're going to be grabbing from multiple cluster groups.
+	 * We don't have enough credits to relink them all, and the
+	 * cluster groups will be staying in cache for the duration of
+	 * this operation.
+	 */
+	ac->ac_allow_chain_relink = 0;
+
 	/* Claim the first region */
 	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
 					      &bit_off, &num_bits);
-- 
1.5.5
