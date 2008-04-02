From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:56 -0700
Subject: [Ocfs2-devel] [PATCH 46/62] ocfs2/dlm: Move dlm_print_one_mle()
	from dlmmaster.c to dlmdebug.c
In-Reply-To: <1207167413855-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
Message-ID: <12071674151752-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch helps in consolidating debugging related functions in dlmdebug.c.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c  |  154 ++++++++++++++++++++++++---------------------
 fs/ocfs2/dlm/dlmdebug.h  |    2 +
 fs/ocfs2/dlm/dlmmaster.c |   89 +--------------------------
 3 files changed, 85 insertions(+), 160 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index a109005..58e4579 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -268,11 +268,6 @@ const char *dlm_errname(enum dlm_status err)
 }
 EXPORT_SYMBOL_GPL(dlm_errname);
 
-
-#ifdef CONFIG_DEBUG_FS
-
-static struct dentry *dlm_debugfs_root = NULL;
-
 /* NOTE: This function converts a lockname into a string. It uses knowledge
  * of the format of the lockname that should be outside the purview of the dlm.
  * We are adding only to make dlm debugging slightly easier.
@@ -299,6 +294,88 @@ static int stringify_lockname(const char *lockname, int locklen,
 	return out;
 }
 
+static int stringify_nodemap(unsigned long *nodemap, int maxnodes,
+			     char *buf, int len)
+{
+	int out = 0;
+	int i = -1;
+
+	while ((i = find_next_bit(nodemap, maxnodes, i + 1)) < maxnodes)
+		out += snprintf(buf + out, len - out, "%d ", i);
+
+	return out;
+}
+
+static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
+{
+	int out = 0;
+	unsigned int namelen;
+	const char *name;
+	char *mle_type;
+
+	if (mle->type != DLM_MLE_MASTER) {
+		namelen = mle->u.name.len;
+		name = mle->u.name.name;
+	} else {
+		namelen = mle->u.res->lockname.len;
+		name = mle->u.res->lockname.name;
+	}
+
+	if (mle->type == DLM_MLE_BLOCK)
+		mle_type = "BLK";
+	else if (mle->type == DLM_MLE_MASTER)
+		mle_type = "MAS";
+	else
+		mle_type = "MIG";
+
+	out += stringify_lockname(name, namelen, buf + out, len - out);
+	out += snprintf(buf + out, len - out,
+			"\t%3s\tmas=%3u\tnew=%3u\tevt=%1d\tuse=%1d\tref=%3d\n",
+			mle_type, mle->master, mle->new_master,
+			!list_empty(&mle->hb_events),
+			!!mle->inuse,
+			atomic_read(&mle->mle_refs.refcount));
+
+	out += snprintf(buf + out, len - out, "Maybe=");
+	out += stringify_nodemap(mle->maybe_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Vote=");
+	out += stringify_nodemap(mle->vote_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Response=");
+	out += stringify_nodemap(mle->response_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "Node=");
+	out += stringify_nodemap(mle->node_map, O2NM_MAX_NODES,
+				 buf + out, len - out);
+	out += snprintf(buf + out, len - out, "\n");
+
+	out += snprintf(buf + out, len - out, "\n");
+
+	return out;
+}
+
+void dlm_print_one_mle(struct dlm_master_list_entry *mle)
+{
+	char *buf;
+
+	buf = (char *) get_zeroed_page(GFP_NOFS);
+	if (buf) {
+		dump_mle(mle, buf, PAGE_SIZE - 1);
+		free_page((unsigned long)buf);
+	}
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static struct dentry *dlm_debugfs_root = NULL;
+
 #define DLM_DEBUGFS_DIR				"o2dlm"
 #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
 #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
@@ -326,18 +403,6 @@ static void dlm_debug_get(struct dlm_debug_ctxt *dc)
 	kref_get(&dc->debug_refcnt);
 }
 
-static int stringify_nodemap(unsigned long *nodemap, int maxnodes,
-			     char *buf, int len)
-{
-	int out = 0;
-	int i = -1;
-
-	while ((i = find_next_bit(nodemap, maxnodes, i + 1)) < maxnodes)
-		out += snprintf(buf + out, len - out, "%d ", i);
-
-	return out;
-}
-
 static struct debug_buffer *debug_buffer_allocate(void)
 {
 	struct debug_buffer *db = NULL;
@@ -455,61 +520,6 @@ static struct file_operations debug_purgelist_fops = {
 /* end - purge list funcs */
 
 /* begin - debug mle funcs */
-static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
-{
-	int out = 0;
-	unsigned int namelen;
-	const char *name;
-	char *mle_type;
-
-	if (mle->type != DLM_MLE_MASTER) {
-		namelen = mle->u.name.len;
-		name = mle->u.name.name;
-	} else {
-		namelen = mle->u.res->lockname.len;
-		name = mle->u.res->lockname.name;
-	}
-
-	if (mle->type == DLM_MLE_BLOCK)
-		mle_type = "BLK";
-	else if (mle->type == DLM_MLE_MASTER)
-		mle_type = "MAS";
-	else
-		mle_type = "MIG";
-
-	out += stringify_lockname(name, namelen, buf + out, len - out);
-	out += snprintf(buf + out, len - out,
-			"\t%3s\tmas=%3u\tnew=%3u\tevt=%1d\tuse=%1d\tref=%3d\n",
-			mle_type, mle->master, mle->new_master,
-			!list_empty(&mle->hb_events),
-			!!mle->inuse,
-			atomic_read(&mle->mle_refs.refcount));
-
-	out += snprintf(buf + out, len - out, "Maybe=");
-	out += stringify_nodemap(mle->maybe_map, O2NM_MAX_NODES,
-				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
-
-	out += snprintf(buf + out, len - out, "Vote=");
-	out += stringify_nodemap(mle->vote_map, O2NM_MAX_NODES,
-				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
-
-	out += snprintf(buf + out, len - out, "Response=");
-	out += stringify_nodemap(mle->response_map, O2NM_MAX_NODES,
-				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
-
-	out += snprintf(buf + out, len - out, "Node=");
-	out += stringify_nodemap(mle->node_map, O2NM_MAX_NODES,
-				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
-
-	out += snprintf(buf + out, len - out, "\n");
-
-	return out;
-}
-
 static int debug_mle_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 {
 	struct dlm_master_list_entry *mle;
diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
index 8857743..d34a62a 100644
--- a/fs/ocfs2/dlm/dlmdebug.h
+++ b/fs/ocfs2/dlm/dlmdebug.h
@@ -25,6 +25,8 @@
 #ifndef DLMDEBUG_H
 #define DLMDEBUG_H
 
+void dlm_print_one_mle(struct dlm_master_list_entry *mle);
+
 #ifdef CONFIG_DEBUG_FS
 
 struct dlm_debug_ctxt {
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 94cadcb..efc015c 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -48,6 +48,7 @@
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
+#include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
 #include "cluster/masklog.h"
@@ -91,94 +92,6 @@ static inline int dlm_mle_equal(struct dlm_ctxt *dlm,
 	return 1;
 }
 
-#define dlm_print_nodemap(m)  _dlm_print_nodemap(m,#m)
-static void _dlm_print_nodemap(unsigned long *map, const char *mapname)
-{
-	int i;
-	printk("%s=[ ", mapname);
-	for (i=0; i<O2NM_MAX_NODES; i++)
-		if (test_bit(i, map))
-			printk("%d ", i);
-	printk("]");
-}
-
-static void dlm_print_one_mle(struct dlm_master_list_entry *mle)
-{
-	int refs;
-	char *type;
-	char attached;
-	u8 master;
-	unsigned int namelen;
-	const char *name;
-	struct kref *k;
-	unsigned long *maybe = mle->maybe_map,
-		      *vote = mle->vote_map,
-		      *resp = mle->response_map,
-		      *node = mle->node_map;
-
-	k = &mle->mle_refs;
-	if (mle->type == DLM_MLE_BLOCK)
-		type = "BLK";
-	else if (mle->type == DLM_MLE_MASTER)
-		type = "MAS";
-	else
-		type = "MIG";
-	refs = atomic_read(&k->refcount);
-	master = mle->master;
-	attached = (list_empty(&mle->hb_events) ? 'N' : 'Y');
-
-	if (mle->type != DLM_MLE_MASTER) {
-		namelen = mle->u.name.len;
-		name = mle->u.name.name;
-	} else {
-		namelen = mle->u.res->lockname.len;
-		name = mle->u.res->lockname.name;
-	}
-
-	mlog(ML_NOTICE, "%.*s: %3s refs=%3d mas=%3u new=%3u evt=%c inuse=%d ",
-		  namelen, name, type, refs, master, mle->new_master, attached,
-		  mle->inuse);
-	dlm_print_nodemap(maybe);
-	printk(", ");
-	dlm_print_nodemap(vote);
-	printk(", ");
-	dlm_print_nodemap(resp);
-	printk(", ");
-	dlm_print_nodemap(node);
-	printk(", ");
-	printk("\n");
-}
-
-#if 0
-/* Code here is included but defined out as it aids debugging */
-
-static void dlm_dump_mles(struct dlm_ctxt *dlm)
-{
-	struct dlm_master_list_entry *mle;
-	
-	mlog(ML_NOTICE, "dumping all mles for domain %s:\n", dlm->name);
-	spin_lock(&dlm->master_lock);
-	list_for_each_entry(mle, &dlm->master_list, list)
-		dlm_print_one_mle(mle);
-	spin_unlock(&dlm->master_lock);
-}
-
-int dlm_dump_all_mles(const char __user *data, unsigned int len)
-{
-	struct dlm_ctxt *dlm;
-
-	spin_lock(&dlm_domain_lock);
-	list_for_each_entry(dlm, &dlm_domains, list) {
-		mlog(ML_NOTICE, "found dlm: %p, name=%s\n", dlm, dlm->name);
-		dlm_dump_mles(dlm);
-	}
-	spin_unlock(&dlm_domain_lock);
-	return len;
-}
-EXPORT_SYMBOL_GPL(dlm_dump_all_mles);
-
-#endif  /*  0  */
-
 static struct kmem_cache *dlm_lockres_cache = NULL;
 static struct kmem_cache *dlm_lockname_cache = NULL;
 static struct kmem_cache *dlm_mle_cache = NULL;
-- 
1.5.4.1
