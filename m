From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Feb 2011 14:25:25 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Move kmalloc() outside the
	spinlock
In-Reply-To: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
References: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1298327125-4045-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_query_region_handler(), move the kmalloc outside the spinlock.
This allows us to use GFP_KERNEL instead of GFP_ATOMIC.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 7e38a07..99805d5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -926,9 +926,10 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 }
 
 static int dlm_match_regions(struct dlm_ctxt *dlm,
-			     struct dlm_query_region *qr)
+			     struct dlm_query_region *qr,
+			     char *local, int locallen)
 {
-	char *local = NULL, *remote = qr->qr_regions;
+	char *remote = qr->qr_regions;
 	char *l, *r;
 	int localnr, i, j, foundit;
 	int status = 0;
@@ -957,13 +958,8 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 		r += O2HB_MAX_REGION_NAME_LEN;
 	}
 
-	local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
-	if (!local) {
-		status = -ENOMEM;
-		goto bail;
-	}
-
-	localnr = o2hb_get_all_regions(local, O2NM_MAX_REGIONS);
+	localnr = min(O2NM_MAX_REGIONS, locallen/O2HB_MAX_REGION_NAME_LEN);
+	localnr = o2hb_get_all_regions(local, (u8)localnr);
 
 	/* compare local regions with remote */
 	l = local;
@@ -1012,8 +1008,6 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 	}
 
 bail:
-	kfree(local);
-
 	return status;
 }
 
@@ -1075,6 +1069,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 {
 	struct dlm_query_region *qr;
 	struct dlm_ctxt *dlm = NULL;
+	char *local = NULL;
 	int status = 0;
 	int locked = 0;
 
@@ -1083,6 +1078,13 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
 	     qr->qr_domain);
 
+	/* buffer used in dlm_mast_regions() */
+	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
+	if (!local) {
+		status = -ENOMEM;
+		goto bail;
+	}
+
 	status = -EINVAL;
 
 	spin_lock(&dlm_domain_lock);
@@ -1112,13 +1114,15 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
 		goto bail;
 	}
 
-	status = dlm_match_regions(dlm, qr);
+	status = dlm_match_regions(dlm, qr, local, sizeof(qr->qr_regions));
 
 bail:
 	if (locked)
 		spin_unlock(&dlm->spinlock);
 	spin_unlock(&dlm_domain_lock);
 
+	kfree(local);
+
 	return status;
 }
 
-- 
1.7.1
