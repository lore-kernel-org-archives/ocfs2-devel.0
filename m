From: wengang wang <wen.gang.wang@oracle.com>
Date: Wed Jan 16 22:50:22 2008
Subject: [Ocfs2-devel] [PATCH 1/1]ocfs2: add dlm_ctxt printing for dlm
	debugging
Message-ID: <478EF8F7.2080806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

add dlm_ctxt printing for dlm debugging
cat /proc/fs/ocfs2_dlm/<domain>/ctxt shows dlm_ctxt
after adding this, what stat prints is a subset of what ctxt prints. but stat remains.

this patch is against ocfs2-1.2 svn head.

Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
---
 dlmdebug.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

Index: fs/ocfs2/dlm/dlmdebug.c
===================================================================
--- fs/ocfs2/dlm/dlmdebug.c	(revision 3078)
+++ fs/ocfs2/dlm/dlmdebug.c	(working copy)
@@ -61,6 +61,8 @@ static int dlm_parse_domain_and_lockres(
 
 static int dlm_proc_stats(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
+static int dlm_proc_ctxts(char *page, char **start, off_t off,
+			  int count, int *eof, void *data);
 
 typedef int (dlm_debug_func_t)(const char __user *data, unsigned int len);
 
@@ -120,6 +122,7 @@ static struct file_operations dlm_debug_
 #define OCFS2_DLM_PROC_PATH "fs/ocfs2_dlm"
 #define DLM_DEBUG_PROC_NAME "debug"
 #define DLM_STAT_PROC_NAME  "stat"
+#define DLM_CTXT_PROC_NAME  "ctxt"
 
 static struct proc_dir_entry *ocfs2_dlm_proc;
 
@@ -172,6 +175,61 @@ static int dlm_proc_stats(char *page, ch
 	return len;
 }
 
+static int dlm_proc_ctxts(char *page, char **start, off_t off,
+			  int count, int *eof, void *data)
+{
+	int len = 0, i;
+	struct dlm_ctxt *dlm = data;
+
+	len += sprintf(page + len, "purge=%d, num=%u, key=0x%08x, ",
+			dlm->purge_count, dlm->node_num, dlm->key);
+	len += sprintf(page + len, "joining=%u, reco.new=%u, ",
+			dlm->joining_node, dlm->reco.new_master);
+	len += sprintf(page + len, "reco.dead=%u, reco.state=%u, ",
+			dlm->reco.dead_node, dlm->reco.state);
+	len += sprintf(page + len, "local=%d, remote=%d, ",
+			atomic_read(&dlm->local_resources),
+			atomic_read(&dlm->remote_resources));
+	len += sprintf(page + len, "unknown=%d, refs=%d, ",
+			atomic_read(&dlm->dlm_refs.refcount),
+			atomic_read(&dlm->unknown_resources));
+	len += sprintf(page + len, "state=%d, joins=%u, ",
+			dlm->dlm_state, dlm->num_joins);
+
+	len += sprintf(page + len, "live=");
+	for (i = 0; i < O2NM_MAX_NODES; i++) {
+		if (test_bit(i,dlm->live_nodes_map))
+			len += sprintf(page + len,"%d ",i);
+	}
+	len += sprintf(page + len,", ");
+
+	len += sprintf(page + len, "domain=");
+	for (i = 0; i < O2NM_MAX_NODES; i++) {
+		if (test_bit(i,dlm->domain_map))
+			len += sprintf(page + len,"%d ",i);
+	}
+	len += sprintf(page + len,", ");
+
+	len += sprintf(page + len, "recovery=");
+	for (i = 0; i < O2NM_MAX_NODES; i++) {
+		if (test_bit(i,dlm->recovery_map))
+			len += sprintf(page + len,"%d ",i);
+	}
+	len += sprintf(page + len,"\n");
+
+	if (len <= off + count)
+		*eof = 1;
+	
+	*start = page + off;
+	len -= off;
+	if (len > count)
+		len = count;
+	if(len < 0)
+		len = 0;
+
+	return len;
+}
+
 void dlm_proc_add_domain(struct dlm_ctxt *dlm)
 {
 	struct proc_dir_entry *entry;
@@ -183,6 +241,11 @@ void dlm_proc_add_domain(struct dlm_ctxt
 					       dlm_proc_stats, (char *)dlm);
 		if (entry)
 			entry->owner = THIS_MODULE;
+		entry = create_proc_read_entry(DLM_CTXT_PROC_NAME,
+						S_IFREG | S_IRUGO, dlm->dlm_proc,
+						dlm_proc_ctxts, (char *)dlm);
+		if (entry)
+			entry->owner = THIS_MODULE;
 	}
 }
 
@@ -190,6 +253,7 @@ void dlm_proc_del_domain(struct dlm_ctxt
 {
 	if (dlm->dlm_proc) {
 		remove_proc_entry(DLM_STAT_PROC_NAME, dlm->dlm_proc);
+		remove_proc_entry(DLM_CTXT_PROC_NAME, dlm->dlm_proc);
 		remove_proc_entry(dlm->name, ocfs2_dlm_proc);
 	}
 }
