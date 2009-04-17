From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:38 -0700
Subject: [Ocfs2-devel] [PATCH 25/26] ocfs2/dlm: Tweak mle_state output
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-26-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 9405dccfd3201d2b76e120949bec81ba8cfbd2d0

The debugfs file, mle_state, now prints the number of largest number of mles
in one hash link.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index bdf1c78..df52f70 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -494,7 +494,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	struct hlist_head *bucket;
 	struct hlist_node *list;
 	int i, out = 0;
-	unsigned long total = 0;
+	unsigned long total = 0, longest = 0, bktcnt;
 
 	out += snprintf(db->buf + out, db->len - out,
 			"Dumping MLEs for Domain: %s\n", dlm->name);
@@ -506,15 +506,18 @@ static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 			mle = hlist_entry(list, struct dlm_master_list_entry,
 					  master_hash_node);
 			++total;
+			++bktcnt;
 			if (db->len - out < 200)
 				continue;
 			out += dump_mle(mle, db->buf + out, db->len - out);
 		}
+		longest = max(longest, bktcnt);
+		bktcnt = 0;
 	}
 	spin_unlock(&dlm->master_lock);
 
 	out += snprintf(db->buf + out, db->len - out,
-			"Total on list: %ld\n", total);
+			"Total: %ld, Longest: %ld\n", total, longest);
 	return out;
 }
 
-- 
1.5.6.3
