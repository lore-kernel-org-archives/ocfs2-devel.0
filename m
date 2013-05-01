From: Qijiang (Joseph) <joseph.qi@huawei.com>
Date: Wed, 01 May 2013 04:06:48 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible memory leak in
	dlm_process_recovery_data
Message-ID: <51182BCE12D4834EA8164B99A509EABB32CDA65F@szxeml521-mbs.china.huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  We create newlock each time in dlm_process_recovery_data, but we don't free it when it is bad, and then it will lead to memory leak.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

---
 fs/ocfs2/dlm/dlmrecovery.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index eeac97b..93de2e0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1974,6 +1974,12 @@ skip_lvb:
                 res->lockname.len, res->lockname.name, ml->node);
            dlm_lockres_set_refmap_bit(dlm, res, ml->node);
            added++;
+       } else {
+           /* should free newlock if it is bad */
+           if (newlock) {
+               dlm_lock_put(newlock);
+               newlock = NULL;
+           }
        }
        spin_unlock(&res->spinlock);
    }
--
1.7.9.7
