Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFB4C4167B
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2k4hI19G2K8xtjqDy3UH53KlRYjddG2GDlGIoSk8QOI=;
 b=z65jC+PanarEWu1Iy72dezQTvI0SYwzysj25oaBFMOSPfCbVTxKs+eX6kHFv5xbblMD83h7G5zHK
   6TzyFH9xb32u39dqMQA9qM3j7E925zWA1Bqo78Afur+Y60brcbN6erTdb7/7z44+WDsjegrWJCTT
   oZqhKXX59IFrdSGOojk3aR7Whdd9XpkwyOkHMB+prxBd3YkTx9g9Pj4n7ix37BqJ4xKXvytjU1hm
   rhgSUL9UUR+WILM8tEffF24RBvGemSEzyLWJyzt9D8+ZyeSTJ3vZ2XKE38cqDAJTRMCSsoC9dp2v
   FmUNQ/Ekf7gh/tQd6RCW1YHnIAdeXQC++CNHJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2k4hI19G2K8xtjqDy3UH53KlRYjddG2GDlGIoSk8QOI=;
 b=huCIcB1aXI8Z53BRVwcp4duEp1GEqrrVjixdeKzlci7MQx4PpefIK5Z9inZjs+MT8Og2IcWOv71Q
   343cn3C//TZUmmC9EfodYAynhV6bteIUPvhKVBB7gzbucgVAOsGbGTgPd1L/cHHwOpw+F8PjaDrc
   2cDyzzGWoeStxFWoyiqz6crGQLEIywwUmdFPrhfuhVtWrn1RYN9h1TJJUtrKLVuJRsi9956IAdMP
   cITAYvs1BMi4/iPePeyWNS61xplnEOq+/qjdXMJPaculElCkWJMuLhMBcajnojthWxaClJDu/H5R
   +FZ++VMzSLupVbD7MBpgA5cz2sEmxUgM8lTJqQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBN00F9FFXJG070@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 May 2022 04:17:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1652156248; bh=CahpGoQCPIwcxFcsLeR3iscm5vxdGT7BywDe530NrCM=;
 h=Date:To:From:Subject:From;
 b=WKDMtDlO7yWoDw3H3QTy9zKF0VXV6M6FiEH0QZWXD4J8TQsCZaJqkcBcHsgsXb+Sf
 FuTj/eCoWpDJZje90y6gjdeyqmpucrzZd6T/CYdTZoOElt+BQNXLVfZ/C0KAwIn9WN
 hwWDs5ddkXy5dgm5PWmNLpZFnW+b8a2vggPf+k4c=
Date: Mon, 09 May 2022 21:17:27 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220510041728.165E3C385C7@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10342
 signatures=593155
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 spamscore=0 priorityscore=266 lowpriorityscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=193 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100018
Subject: [Ocfs2-devel] [merged mm-nonmm-stable]
	ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch	removed from -mm tree
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: -WuBujnLQpkwNgCYkySvKDGDSq10A-dT
X-Proofpoint-ORIG-GUID: -WuBujnLQpkwNgCYkySvKDGDSq10A-dT
Reporting-Meta:
 AAHEZa0Q0VEKQ/M/DUt7kN6op10IbHWHRTVVK7XmtOQFMrvgRIaw7Np03Wab2DPh
 YU2p6qksIfc1g4CVT/0EMbCkCV5ebpDSipsYnqCsTcobUw2t/+UgoHdOcZtWLv0u
 2oW8AUZ6EKQVmol0r3mr8GdEWcTdYVRaLXN2CCl9cL3AMcpXZ5i0sg1eJjv9M4GG
 8iKNFcR/wWrNo2hJkz8wQTbzg71iHQ+AaFFtXbsqp1knxKM66vTDLOR5K6I2Upnr
 oVw0Tzs7xeE+VEyK5xORxd6Taohkjr2vwdu6YVAA7HI4PeD6FEkO3BClikuAweNz
 jok1gFygSSMgBbakea8upITo4U/G4EVZi5PucyaqgQf6Mx8R7mxiKF8eQ8rnCys6
 +F0J3q5mYUOcaGNvUy/PRh6LEq9oCPCCwJOLBQ6fNoZc3Crxnu5UvJphqCNhTEPm
 6zVAJOpHgupwD1UkZI5TCjGTXdRfcQArPtngO8+C0Yx2O2bYaYc9CApnYJpSFX33
 0zQgKylsOEBUGaVQIl0iYUHz7D6Htag4dacragKoinI=


The quilt patch titled
     Subject: ocfs2: fix mounting crash if journal is not alloced
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix mounting crash if journal is not alloced

Patch series "rewrite error handling during mounting stage".


This patch (of 5):

After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
journal init later than before, it makes NULL pointer access in free
routine.

Crash flow:

ocfs2_fill_super
 + ocfs2_mount_volume
 |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
 |  + ...
 |  + ocfs2_check_volume //no chance to init osb->journal
 |
 + ...
 + ocfs2_dismount_volume
    ocfs2_release_system_inodes
      ...
       evict
        ...
         ocfs2_clear_inode
          ocfs2_checkpoint_inode
           ocfs2_ci_fully_checkpointed
            time_after(journal->j_trans_id, ci->ci_last_trans)
             + journal is empty, crash!

For fixing, there are three solutions:

1> Partly revert commit da5e7c87827e8

   For avoiding kernel crash, this make sense for us.  We only
   concerned whether there has any non-system inode access before dlm
   init.  The answer is NO.  And all journal replay/recovery handling
   happen after dlm & journal init done.  So this method is not graceful
   but workable.

2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)

   The fix code is special for mounting phase, but it will continue
   working after mounting stage.  In another word, this method adds
   useless code in normal inode free flow.

3> Do directly free inode in mounting phase

   This method is brutal/complex and may introduce unsafe code,
   currently maintainer didn't like.

At last, we chose method <1> and did partly reverted job.  We reverted
journal init codes, and kept cleanup codes flow.

Link: https://lkml.kernel.org/r/20220424130952.2436-1-heming.zhao@suse.com
Link: https://lkml.kernel.org/r/20220424130952.2436-2-heming.zhao@suse.com
Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    4 ++--
 fs/ocfs2/journal.c |   33 +++++++++++++++++++++++----------
 fs/ocfs2/journal.h |    2 ++
 fs/ocfs2/super.c   |   15 +++++++++++++++
 4 files changed, 42 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-fix-mounting-crash-if-journal-is-not-alloced
+++ a/fs/ocfs2/inode.c
@@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	journal_t *journal = osb->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	 * part of the transaction - the inode could have been reclaimed and
 	 * now it is reread from disk.
 	 */
-	if (osb->journal) {
+	if (journal) {
 		transaction_t *transaction;
 		tid_t tid;
 		struct ocfs2_inode_info *oi = OCFS2_I(inode);
-		journal_t *journal = osb->journal->j_journal;
 
 		read_lock(&journal->j_state_lock);
 		if (journal->j_running_transaction)
--- a/fs/ocfs2/journal.c~ocfs2-fix-mounting-crash-if-journal-is-not-alloced
+++ a/fs/ocfs2/journal.c
@@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocf
 	write_unlock(&journal->j_state_lock);
 }
 
-int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+/*
+ * alloc & initialize skeleton for journal structure.
+ * ocfs2_journal_init() will make fs have journal ability.
+ */
+int ocfs2_journal_alloc(struct ocfs2_super *osb)
 {
-	int status = -1;
-	struct inode *inode = NULL; /* the journal inode */
-	journal_t *j_journal = NULL;
-	struct ocfs2_journal *journal = NULL;
-	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *bh = NULL;
-	int inode_lock = 0;
+	int status = 0;
+	struct ocfs2_journal *journal;
 
-	/* initialize our journal structure */
 	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
 	if (!journal) {
 		mlog(ML_ERROR, "unable to alloc journal\n");
 		status = -ENOMEM;
-		goto done;
+		goto bail;
 	}
 	osb->journal = journal;
 	journal->j_osb = osb;
@@ -839,6 +837,21 @@ int ocfs2_journal_init(struct ocfs2_supe
 	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
+bail:
+	return status;
+}
+
+int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
+{
+	int status = -1;
+	struct inode *inode = NULL; /* the journal inode */
+	journal_t *j_journal = NULL;
+	struct ocfs2_journal *journal = osb->journal;
+	struct ocfs2_dinode *di = NULL;
+	struct buffer_head *bh = NULL;
+	int inode_lock = 0;
+
+	BUG_ON(!journal);
 	/* already have the inode for our journal */
 	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
 					    osb->slot_num);
--- a/fs/ocfs2/journal.h~ocfs2-fix-mounting-crash-if-journal-is-not-alloced
+++ a/fs/ocfs2/journal.h
@@ -154,6 +154,7 @@ int ocfs2_compute_replay_slots(struct oc
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
  *
+ *  ocfs2_journal_alloc    - Initialize skeleton for journal structure.
  *  ocfs2_journal_init     - Initialize journal structures in the OSB.
  *  ocfs2_journal_load     - Load the given journal off disk. Replay it if
  *                          there's transactions still in there.
@@ -167,6 +168,7 @@ int ocfs2_compute_replay_slots(struct oc
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
+int    ocfs2_journal_alloc(struct ocfs2_super *osb);
 int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
--- a/fs/ocfs2/super.c~ocfs2-fix-mounting-crash-if-journal-is-not-alloced
+++ a/fs/ocfs2/super.c
@@ -2195,6 +2195,15 @@ static int ocfs2_initialize_super(struct
 
 	get_random_bytes(&osb->s_next_generation, sizeof(u32));
 
+	/*
+	 * FIXME
+	 * This should be done in ocfs2_journal_init(), but any inode
+	 * writes back operation will cause the filesystem to crash.
+	 */
+	status = ocfs2_journal_alloc(osb);
+	if (status < 0)
+		goto bail;
+
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
@@ -2483,6 +2492,12 @@ static void ocfs2_delete_osb(struct ocfs
 
 	kfree(osb->osb_orphan_wipes);
 	kfree(osb->slot_recovery_generations);
+	/* FIXME
+	 * This belongs in journal shutdown, but because we have to
+	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
+	 * we free it here.
+	 */
+	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	kfree(osb->vol_label);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
