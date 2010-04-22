From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:25 +0800
Subject: [Ocfs2-devel] [PATCH 11/17] ocfs2: Don't relink cluster groups when
	allocating discontig block groups
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-11-git-send-email-tao.ma@oracle.com>
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
index 9113da9..b3053da 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -610,6 +610,14 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
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
