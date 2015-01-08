From: alex chen <alex.chen@huawei.com>
Date: Thu, 8 Jan 2015 17:31:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix snprintf format specifier in
	dlmdebug.c
Message-ID: <54AE4E6D.6050902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use snprintf format specifier "%lu" instead of "%ld" for
argument of type 'unsigned long'.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 149eb55..8251360 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -406,7 +406,7 @@ static int debug_purgelist_print(struct dlm_ctxt *dlm, char *buf, int len)
 	}
 	spin_unlock(&dlm->spinlock);

-	out += snprintf(buf + out, len - out, "Total on list: %ld\n", total);
+	out += snprintf(buf + out, len - out, "Total on list: %lu\n", total);

 	return out;
 }
@@ -464,7 +464,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 	spin_unlock(&dlm->master_lock);

 	out += snprintf(buf + out, len - out,
-			"Total: %ld, Longest: %ld\n", total, longest);
+			"Total: %lu, Longest: %lu\n", total, longest);
 	return out;
 }

-- 
1.8.4.3
