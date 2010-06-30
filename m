From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 30 Jun 2010 20:23:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: don't access beyond bitmap size
Message-ID: <201006301224.o5U1mkX5011318@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm->recovery_map is defined as
	unsigned long recovery_map[BITS_TO_LONGS(O2NM_MAX_NODES)];

We should treat O2NM_MAX_NODES as the bit map size in bits.
This patches fixes a bit operation that takes O2NM_MAX_NODES + 1 as bitmap size.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index f8b75ce..9dfaac7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -463,7 +463,7 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
 		int bit;
 
-		bit = find_next_bit (dlm->recovery_map, O2NM_MAX_NODES+1, 0);
+		bit = find_next_bit (dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit >= O2NM_MAX_NODES || bit < 0)
 			dlm_set_reco_dead_node(dlm, O2NM_INVALID_NODE_NUM);
 		else
-- 
1.6.6.1
