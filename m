From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 11 Nov 2009 22:45:10 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Should error return be negative?
Message-ID: <4AFB3066.4080102@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

The return of a positive error is unusual for oracle:

[roel at zoinx linux-git]$ git grep -n -E "return E[[:upper:]]*;" -- fs/ocfs2/ | wc -l
1
[roel at zoinx linux-git]$ git grep -n -E "return -E[[:upper:]]*;" -- fs/ocfs2/ | wc -l
251

is this maybe required?

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d9fa3d2..0a8a6a4 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2639,7 +2639,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
-		return EAGAIN;
+		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
 
