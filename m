Return-Path: <SRS0=bArw=O5=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0E1C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Oct 2021 14:51:42 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15DA960F57
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Oct 2021 14:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 15DA960F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1998ka9M027945;
	Sat, 9 Oct 2021 14:51:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bk2pt956p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Oct 2021 14:51:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 199EovrX040556;
	Sat, 9 Oct 2021 14:51:39 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bk2dkr3nk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 09 Oct 2021 14:51:39 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mZDhK-0002Ln-Oj; Sat, 09 Oct 2021 07:51:38 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <vvidic@valentin-vidic.from.hr>) id 1mZDhI-0002Km-33
	for ocfs2-devel@oss.oracle.com; Sat, 09 Oct 2021 07:51:36 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 199EoBXp112362
	for <ocfs2-devel@oss.oracle.com>; Sat, 9 Oct 2021 14:51:35 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bk14bsskf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 09 Oct 2021 14:51:31 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1994A8ub006267
	for <ocfs2-devel@oss.oracle.com>; Sat, 9 Oct 2021 14:51:30 GMT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [109.200.23.17])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bk2n6ngmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 09 Oct 2021 14:51:29 +0000
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 5DB0E72A3; Sat,  9 Oct 2021 16:51:21 +0200 (CEST)
From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Date: Sat,  9 Oct 2021 16:50:06 +0200
Message-Id: <20211009145006.3478-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <faceeac2-7419-e500-12ba-ab11b915e660@linux.alibaba.com>
References: <faceeac2-7419-e500-12ba-ab11b915e660@linux.alibaba.com>
MIME-Version: 1.0
X-Source-IP: 109.200.23.17
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10132
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	clxscore=259
	impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
	lowpriorityscore=0
	mlxscore=0 adultscore=0 bulkscore=0 priorityscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110090107
X-Spam: Clean
Cc: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: cleanup journal init and shutdown
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10132 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110090107
X-Proofpoint-GUID: 8ne3Th2ZpTqhphgsdPClI1WaQvEcZWyf
X-Proofpoint-ORIG-GUID: 8ne3Th2ZpTqhphgsdPClI1WaQvEcZWyf

Allocate and free struct ocfs2_journal in ocfs2_journal_init and
ocfs2_journal_shutdown. Init and release of system inodes references
the journal so reorder calls to make sure they work correctly.

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
v2: use osb->journal and cleanup commented up_write call

 fs/ocfs2/inode.c   |  4 ++--
 fs/ocfs2/journal.c | 26 +++++++++++++++++++++-----
 fs/ocfs2/journal.h |  3 +--
 fs/ocfs2/super.c   | 40 +++-------------------------------------
 4 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index bc8f32fab964..6c2411c2afcf 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -125,7 +125,6 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
-	journal_t *journal = OCFS2_SB(sb)->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -172,10 +171,11 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	 * part of the transaction - the inode could have been reclaimed and
 	 * now it is reread from disk.
 	 */
-	if (journal) {
+	if (osb->journal) {
 		transaction_t *transaction;
 		tid_t tid;
 		struct ocfs2_inode_info *oi = OCFS2_I(inode);
+		journal_t *journal = osb->journal->j_journal;
 
 		read_lock(&journal->j_state_lock);
 		if (journal->j_running_transaction)
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4f15750aac5d..b9c339335a53 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -810,19 +810,34 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
 	write_unlock(&journal->j_state_lock);
 }
 
-int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
+int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 {
 	int status = -1;
 	struct inode *inode = NULL; /* the journal inode */
 	journal_t *j_journal = NULL;
+	struct ocfs2_journal *journal = NULL;
 	struct ocfs2_dinode *di = NULL;
 	struct buffer_head *bh = NULL;
-	struct ocfs2_super *osb;
 	int inode_lock = 0;
 
-	BUG_ON(!journal);
+	/* initialize our journal structure */
+	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
+	if (!journal) {
+		mlog(ML_ERROR, "unable to alloc journal\n");
+		status = -ENOMEM;
+		goto done;
+	}
+	osb->journal = journal;
+	journal->j_osb = osb;
 
-	osb = journal->j_osb;
+	atomic_set(&journal->j_num_trans, 0);
+	init_rwsem(&journal->j_trans_barrier);
+	init_waitqueue_head(&journal->j_checkpointed);
+	spin_lock_init(&journal->j_lock);
+	journal->j_trans_id = 1UL;
+	INIT_LIST_HEAD(&journal->j_la_cleanups);
+	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
+	journal->j_state = OCFS2_JOURNAL_FREE;
 
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
@@ -1028,9 +1043,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
-//	up_write(&journal->j_trans_barrier);
 done:
 	iput(inode);
+	kfree(journal);
+	osb->journal = NULL;
 }
 
 static void ocfs2_clear_journal_error(struct super_block *sb,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index d158acb8b38a..8dcb2f2cadbc 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -167,8 +167,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
-int    ocfs2_journal_init(struct ocfs2_journal *journal,
-			  int *dirty);
+int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
 			  int full);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5c914ce9b3ac..1286b88b6fa1 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1894,8 +1894,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
-	ocfs2_journal_shutdown(osb);
-
 	ocfs2_sync_blockdev(sb);
 
 	ocfs2_purge_refcount_trees(osb);
@@ -1918,6 +1916,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_release_system_inodes(osb);
 
+	ocfs2_journal_shutdown(osb);
+
 	/*
 	 * If we're dismounting due to mount error, mount.ocfs2 will clean
 	 * up heartbeat.  If we're a local mount, there is no heartbeat.
@@ -2016,7 +2016,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
-	struct ocfs2_journal *journal;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2197,33 +2196,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
-	/* FIXME
-	 * This should be done in ocfs2_journal_init(), but unknown
-	 * ordering issues will cause the filesystem to crash.
-	 * If anyone wants to figure out what part of the code
-	 * refers to osb->journal before ocfs2_journal_init() is run,
-	 * be my guest.
-	 */
-	/* initialize our journal structure */
-
-	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
-	if (!journal) {
-		mlog(ML_ERROR, "unable to alloc journal\n");
-		status = -ENOMEM;
-		goto bail;
-	}
-	osb->journal = journal;
-	journal->j_osb = osb;
-
-	atomic_set(&journal->j_num_trans, 0);
-	init_rwsem(&journal->j_trans_barrier);
-	init_waitqueue_head(&journal->j_checkpointed);
-	spin_lock_init(&journal->j_lock);
-	journal->j_trans_id = (unsigned long) 1;
-	INIT_LIST_HEAD(&journal->j_la_cleanups);
-	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
-	journal->j_state = OCFS2_JOURNAL_FREE;
-
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2404,7 +2376,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 						  * ourselves. */
 
 	/* Init our journal object. */
-	status = ocfs2_journal_init(osb->journal, &dirty);
+	status = ocfs2_journal_init(osb, &dirty);
 	if (status < 0) {
 		mlog(ML_ERROR, "Could not initialize journal!\n");
 		goto finally;
@@ -2513,12 +2485,6 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
 	kfree(osb->osb_orphan_wipes);
 	kfree(osb->slot_recovery_generations);
-	/* FIXME
-	 * This belongs in journal shutdown, but because we have to
-	 * allocate osb->journal at the start of ocfs2_initialize_osb(),
-	 * we free it here.
-	 */
-	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	kfree(osb->vol_label);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
