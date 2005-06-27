From: James Morris <jmorris@redhat.com>
Date: Mon Jun 27 01:18:07 2005
Subject: [Ocfs2-devel] [PATCH 1/3] kfree() cleanups
Message-ID: <Xine.LNX.4.44.0506270215590.31257-100000@thoron.boston.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I noticed a bunch of these type of things while reviewing the code.

Some testing on a single node.

Please review.

Signed-off-by: James Morris <jmorris@redhat.com>

---

 fs/ocfs2/cluster/heartbeat.c |    3 +--
 fs/ocfs2/cluster/tcp.c       |    6 ++----
 fs/ocfs2/dlm/dlmdebug.c      |    3 +--
 fs/ocfs2/dlm/dlmdomain.c     |    4 +---
 fs/ocfs2/dlm/dlmrecovery.c   |    6 ++----
 fs/ocfs2/journal.c           |    7 ++-----
 fs/ocfs2/localalloc.c        |    6 ++----
 fs/ocfs2/super.c             |    6 ++----
 fs/ocfs2/vote.c              |    6 ++----
 9 files changed, 15 insertions(+), 32 deletions(-)

diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/cluster/heartbeat.c linux-2.6.12-mm2.w/fs/ocfs2/cluster/heartbeat.c
--- linux-2.6.12-mm2.s/fs/ocfs2/cluster/heartbeat.c	2005-06-27 00:23:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/cluster/heartbeat.c	2005-06-27 00:55:46.000000000 -0400
@@ -781,8 +781,7 @@ static void o2hb_region_release(struct c
 	if (reg->hr_bdev)
 		blkdev_put(reg->hr_bdev);
 
-	if (reg->hr_slots)
-		kfree(reg->hr_slots);
+	kfree(reg->hr_slots);
 	kfree(reg);
 }
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/cluster/tcp.c linux-2.6.12-mm2.w/fs/ocfs2/cluster/tcp.c
--- linux-2.6.12-mm2.s/fs/ocfs2/cluster/tcp.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/cluster/tcp.c	2005-06-27 00:57:19.000000000 -0400
@@ -879,10 +879,8 @@ out:
 	o2net_proc_del_nst(&nst); /* must be before dropping sc and node */
 	if (sc)
 		sc_put(sc);
-	if (iov)
-		kfree(iov);
-	if (msg)
-		kfree(msg);
+	kfree(iov);
+	kfree(msg);
 	if (node) {
 		o2net_complete_nsw(node, &nsw, 0, 0, 0);
 		o2nm_node_put(node);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmdebug.c linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmdebug.c
--- linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmdebug.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmdebug.c	2005-06-27 00:57:46.000000000 -0400
@@ -336,8 +336,7 @@ static int dlm_trigger_migration(const c
 	ret = len;
 
 leave:
-	if (buf)
-		kfree(buf);
+	kfree(buf);
 	return ret;
 }
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmdomain.c linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmdomain.c
--- linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmdomain.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmdomain.c	2005-06-27 00:58:18.000000000 -0400
@@ -195,9 +195,7 @@ static void dlm_free_ctxt_mem(dlm_ctxt *
 	if (dlm->resources)
 		free_page((unsigned long) dlm->resources);
 
-	if (dlm->name)
-		kfree(dlm->name);
-
+	kfree(dlm->name);
 	kfree(dlm);
 }
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmrecovery.c linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmrecovery.c
--- linux-2.6.12-mm2.s/fs/ocfs2/dlm/dlmrecovery.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/dlm/dlmrecovery.c	2005-06-27 00:59:25.000000000 -0400
@@ -1087,10 +1087,8 @@ int dlm_mig_lockres_handler(o2net_msg *m
 leave:
 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 	}
 
 	mlog_exit(ret);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/journal.c linux-2.6.12-mm2.w/fs/ocfs2/journal.c
--- linux-2.6.12-mm2.s/fs/ocfs2/journal.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/journal.c	2005-06-27 01:00:24.000000000 -0400
@@ -934,11 +934,8 @@ static void ocfs2_queue_recovery_complet
 		/* Though we wish to avoid it, we are in fact safe in
 		 * skipping local alloc cleanup as fsck.ocfs2 is more
 		 * than capable of reclaiming unused space. */
-		if (la_dinode)
-			kfree(la_dinode);
-
-		if (tl_dinode)
-			kfree(tl_dinode);
+		kfree(la_dinode);
+		kfree(tl_dinode);
 
 		mlog_errno(-ENOMEM);
 		return;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c	2005-06-27 01:01:25.000000000 -0400
@@ -292,8 +292,7 @@ bail:
 	if (local_alloc_inode)
 		iput(local_alloc_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	mlog_exit_void();
 }
@@ -947,8 +946,7 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	if (ac)
 		ocfs2_free_alloc_context(ac);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/super.c linux-2.6.12-mm2.w/fs/ocfs2/super.c
--- linux-2.6.12-mm2.s/fs/ocfs2/super.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/super.c	2005-06-27 01:02:37.000000000 -0400
@@ -1418,8 +1418,7 @@ static int ocfs2_check_volume(ocfs2_supe
 		mlog_errno(status);
 
 finally:
-	if (local_alloc)
-		kfree(local_alloc);
+	kfree(local_alloc);
 
 	mlog_exit(status);
 	return status;
@@ -1447,8 +1446,7 @@ static void ocfs2_delete_osb(ocfs2_super
 	 * we free it here.
 	 */
 	kfree(osb->journal);
-	if (osb->local_alloc_copy)
-		kfree(osb->local_alloc_copy);
+	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	memset(osb, 0, sizeof(ocfs2_super));
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/vote.c linux-2.6.12-mm2.w/fs/ocfs2/vote.c
--- linux-2.6.12-mm2.s/fs/ocfs2/vote.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/vote.c	2005-06-27 01:03:19.000000000 -0400
@@ -974,8 +974,7 @@ int ocfs2_request_mount_vote(ocfs2_super
 	}
 
 bail:
-	if (request)
-		kfree(request);
+	kfree(request);
 
 	return status;
 }
@@ -1007,8 +1006,7 @@ int ocfs2_request_umount_vote(ocfs2_supe
 	}
 
 bail:
-	if (request)
-		kfree(request);
+	kfree(request);
 
 	return status;
 }
