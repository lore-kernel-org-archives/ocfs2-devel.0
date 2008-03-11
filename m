From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:22 2008
Subject: [Ocfs2-devel] [PATCH 09/18] ocfs2/dlm: fix printk warning
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 3a4780a85d4a160a471ed887bfce58b414f556b1
Author: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 29 Feb 2008 01:56:06 -0800

fs/ocfs2/dlm/dlmdomain.c: In function 'dlm_send_join_cancels':
fs/ocfs2/dlm/dlmdomain.c:983: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'long unsigned int'

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 3cd509b..8861c2d 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -937,7 +937,7 @@ static int dlm_send_join_cancels(struct dlm_ctxt *dlm,
 			 sizeof(unsigned long))) {
 		mlog(ML_ERROR,
 		     "map_size %u != BITS_TO_LONGS(O2NM_MAX_NODES) %u\n",
-		     map_size, BITS_TO_LONGS(O2NM_MAX_NODES));
+		     map_size, (unsigned)BITS_TO_LONGS(O2NM_MAX_NODES));
 		return -EINVAL;
 	}
 
-- 
1.5.3.4
