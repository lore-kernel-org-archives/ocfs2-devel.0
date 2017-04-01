From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 1 Apr 2017 11:42:36 +0000
Subject: [Ocfs2-devel] [DRAFT] ocfs2: commit the transtion before goto out
 to avoid blocked.
Message-ID: <71604351584F6A4EBAE558C676F37CA4C4B0CA35@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, 

For the commit: 2b0ad0085aa47ace4756aa501274a7de0325c09c 

Mar 31 14:42:59 wy-ost209 kernel: [795291.811547] OCFS2: ERROR (device dm-11): ocfs2_block_group_clear_bits: Group descriptor # 33030144 has bit count 32256 but claims 32294 are freed. num_bits 48
Mar 31 14:42:59 wy-ost209 kernel: [795291.811574] File system is now read-only due to the potential of on-disk corruption. Please run fsck.ocfs2 once the file system is unmounted.
Mar 31 14:42:59 wy-ost209 kernel: [795291.811591] (libvirtd,1223183,4):_ocfs2_free_suballoc_bits:2502 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811605] (libvirtd,1223183,4):_ocfs2_free_suballoc_bits:2525 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811619] (libvirtd,1223183,4):_ocfs2_free_clusters:2588 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811632] (libvirtd,1223183,4):_ocfs2_free_clusters:2597 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811646] (libvirtd,1223183,4):ocfs2_replay_truncate_records:5996 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811660] (libvirtd,1223183,4):__ocfs2_flush_truncate_log:6062 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811675] (libvirtd,1223183,4):ocfs2_remove_btree_range:5769 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811689] (libvirtd,1223183,4):ocfs2_commit_truncate:7194 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811722] (libvirtd,1223183,4):ocfs2_truncate_for_delete:607 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811736] (libvirtd,1223183,4):ocfs2_wipe_inode:776 ERROR: status = -30
Mar 31 14:42:59 wy-ost209 kernel: [795291.811746] (libvirtd,1223183,4):ocfs2_delete_inode:1066 ERROR: status = -30


ocfs2_replay_truncate_records
    ocfs2_start_trans
	   down_read(&osb->journal->j_trans_barrier)
	
	Something is wrong, so it goes out. 
	The ocfs2_commit_trans is not called, so up_read is not called, as to cause the node blocked.
	
	ocfs2_commit_trans(osb, handle)
		up_read(&journal->j_trans_barrier)
		

So we have a patch to avoid it.


From 9ae1f5550c4743356f68685276ffcddecf698e9d Mon Sep 17 00:00:00 2001
From: guozhonghua <guozhonghua@h3c.com>
Date: Sat, 1 Apr 2017 19:30:54 +0800
Subject: [PATCH] If there is error in the function
 ocfs2_replay_truncate_records, the function
 ocfs2_commit_trans should be called before return to avoid
 node blocked


Signed-off-by: guozhonghua <guozhonghua@h3c.com>
---
 fs/ocfs2/alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index fb15a96..dc52f7a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5953,6 +5953,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
+			ocfs2_commit_trans(osb, handle);
 			goto bail;
 		}
 
@@ -5977,6 +5978,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 						     num_clusters);
 			if (status < 0) {
 				mlog_errno(status);
+				ocfs2_commit_trans(osb, handle);
 				goto bail;
 			}
 		}
-- 
1.7.9.5
