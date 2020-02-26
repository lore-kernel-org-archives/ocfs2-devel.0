From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 26 Feb 2020 09:53:08 +0300
Subject: [Ocfs2-devel] [PATCH v2 1/4] lockres_seq_next should increase
	position index
In-Reply-To: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
References: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
Message-ID: <a04e19a1-eb43-4a15-b6f8-b09a97a58ca4@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!L2HMxpDQh7db9dQNbu_Tp0uSxEzRVFvZ0bxczbKOsvt3hiKOnWevYToiSclR_wkhhve7qA$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index c5c6efb..3e395cd 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -590,6 +590,7 @@ static void lockres_seq_stop(struct seq_file *m, void *v)
 
 static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	(*pos)++;
 	return NULL;
 }
 
-- 
1.8.3.1
