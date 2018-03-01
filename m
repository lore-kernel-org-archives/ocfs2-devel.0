From: piaojun <piaojun@huawei.com>
Date: Thu, 1 Mar 2018 17:26:12 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: don't handle migrate lockres if
 already in shutdown
Message-ID: <5A97C734.5020705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We should not handle migrate lockres if we are already in
'DLM_CTXT_IN_SHUTDOWN', as that will cause lockres remains after
leaving dlm domain. At last other nodes will get stuck into infinite
loop when requsting lock from us.

    N1                             N2 (owner)
                                   touch file

access the file,
and get pr lock

umount

migrate all lockres

                                   umount and migrate lockres to N1

leave dlm domain, but
the lockres left
unexpectedly, because
migrate task has passed

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmdomain.c   | 14 ++++++++++++++
 fs/ocfs2/dlm/dlmdomain.h   |  1 +
 fs/ocfs2/dlm/dlmrecovery.c |  9 +++++++++
 3 files changed, 24 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index e1fea14..3b7ec51 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -675,6 +675,20 @@ static void dlm_leave_domain(struct dlm_ctxt *dlm)
 	spin_unlock(&dlm->spinlock);
 }

+int dlm_joined(struct dlm_ctxt *dlm)
+{
+	int ret = 0;
+
+	spin_lock(&dlm_domain_lock);
+
+	if (dlm->dlm_state == DLM_CTXT_JOINED)
+		ret = 1;
+
+	spin_unlock(&dlm_domain_lock);
+
+	return ret;
+}
+
 int dlm_shutting_down(struct dlm_ctxt *dlm)
 {
 	int ret = 0;
diff --git a/fs/ocfs2/dlm/dlmdomain.h b/fs/ocfs2/dlm/dlmdomain.h
index fd6122a..2f7f60b 100644
--- a/fs/ocfs2/dlm/dlmdomain.h
+++ b/fs/ocfs2/dlm/dlmdomain.h
@@ -28,6 +28,7 @@
 extern spinlock_t dlm_domain_lock;
 extern struct list_head dlm_domains;

+int dlm_joined(struct dlm_ctxt *dlm);
 int dlm_shutting_down(struct dlm_ctxt *dlm);
 void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
 					int node_num);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ec8f758..9b3bc66 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1378,6 +1378,15 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	if (!dlm_grab(dlm))
 		return -EINVAL;

+	if (!dlm_joined(dlm)) {
+		mlog(ML_ERROR, "Domain %s not joined! "
+				"lockres %.*s, master %u\n",
+				dlm->name, mres->lockname_len,
+				mres->lockname, mres->master);
+		dlm_put(dlm);
+		return -EINVAL;
+	}
+
 	BUG_ON(!(mres->flags & (DLM_MRES_RECOVERY|DLM_MRES_MIGRATION)));

 	real_master = mres->master;
-- 
