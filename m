From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 23 Jun 2014 18:44:06 +0200
Subject: [Ocfs2-devel] [PATCH 1/1] fs/ocfs2/slot_map.c: replace count*size
	kzalloc by kcalloc
Message-ID: <1403541846-11025-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

kcalloc manages count*sizeof overflow.

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/slot_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 1424c15..a88b2a4 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -382,7 +382,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
 	trace_ocfs2_map_slot_buffers(bytes, si->si_blocks);
 
-	si->si_bh = kzalloc(sizeof(struct buffer_head *) * si->si_blocks,
+	si->si_bh = kcalloc(si->si_blocks, sizeof(struct buffer_head *),
 			    GFP_KERNEL);
 	if (!si->si_bh) {
 		status = -ENOMEM;
-- 
1.8.4.5
