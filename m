Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10AEC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/ASFyVxZwV3o7wG/4J1x3Y4df9JPz6CN45Aj1a1fyHI=;
 b=u/PfyLzznk7YR7TgEmQe+fxBTHbVXEEGG9gKeP1SWCkyRcew7HylaHFzZfyFsB0gJlHBFOsNLkGv
   RiF1AKPs3SZhhgDVeGyC9vsKZ4x48wm7pq9sIGIEmsGhH3ihw7n1IZsO1fCCQ+cqbru7UQrfFS6f
   gtEoe7ceA+b5a9ua0qcUjCS+E1IgWQTOaqdgrJy27iDt+2McEMNdwFts36YF5qMMOXFdJGGOk/Cp
   8seVur3nVsyuiGkA162JQCX4buBL6l3Q/ZwMFnHrflwPRYZ8Dhnp9/NyssHeUW9fMiyh0s0s+d4D
   kdm3ihkKk7DrSAoI6NalLqBFSZK0PsGU/qo43Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/ASFyVxZwV3o7wG/4J1x3Y4df9JPz6CN45Aj1a1fyHI=;
 b=C1NEs5Vvm57KbyXfDt+VkhcfkmdbX4a0EZb//andVqqjh/ZsMXeddBl2WLDS7+uYrRs0g44xc9dJ
   ttkc/tWI4h7xBwIt6MhHVw09/jGpcCymZIP/9Qsb9Eyxtj6LhLjjVkfr3VP42RD8oqSnzvTf5SHx
   N6uKb84R0op/qGxaSynxQNqVz2ERMpp1Nn56AipVy62EkkWaTGttFArRILtmwQaBaNy6iLOHE8++
   KEIYUBhlg4TCfMDewIApOQ4/Mx/W45lxb8/EgsVhbSyW5MUBfioKnVa1Rh9X4eKiwc1seRUlr2Cz
   2jDTXzLv3cDHilGN23EbG5rQ6+kPcj61wBNl2A==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD100DWNYZM6090@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 11:09:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1654513743; bh=MruCj8nej3dKAM7adIO1D35vODK2j1fka5uUIKnmzDM=;
 h=From:To:Cc:Subject:Date:From;
 b=MDPIu4EGGUqoK/hhGrM5pj+pZsbpncLnIDb7pZIcdnWzs/j1I/d6GoVTxmW/WjMqg
 KAkuiskB+Nh9JsbULi9631VYTFLViD9SY1vfuk3kj/pnI7u8iSsygDWMbGa1oG0MxM
 b0Cf2xgZOKO3nVYSOE0AipMLF/SgqfVwBjM8ZJLhgkbkgIkimaeXz3kn9Hl0LM4JRh
 /jWZLwKuE05Ej4EvXjqA0Ht8zJ4FcnBFcUXGYCRpI83i2TP5/PHQO68kIfKBcOvx0B
 tixll8i5YBSGTnX9ELVYm77Go14WTEihTqQqPzVco1YsEAaPGfSpwRmogeLqUE7lqZ
 kQtzgTPVZXt9A==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Mon,  6 Jun 2022 07:09:00 -0400
Message-id: <20220606110901.135983-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 145.40.73.55
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10369
 signatures=594849
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix mounting crash if journal is not	alloced" has been added to the
 5.18-stable tree
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
From: Sasha Levin via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Sasha Levin <sashal@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Patchwork-Hint: ignore
X-stable: review
X-ServerName: sin.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: SHQ7uHBZ5CsVTO6TMPm0jj_g0l8wp64Z
X-Proofpoint-ORIG-GUID: SHQ7uHBZ5CsVTO6TMPm0jj_g0l8wp64Z
Reporting-Meta:
 AAHzwHpFNiOUm4PsEg8XyHQKWYvFqZrs71lW6dsKHC6XWsrjvg0fNVMbdDw+sHa8
 YRFv3cSbzquo+dlyBe4XEiG5fyxz1JOn1qM9JCCM+fAiPvCGxcazKbpliJ3QvFzg
 AvEN+6HxwNjpKrPKoG5usf0/4OVAWeXg7g5zQWI6rKPb3uf17B+NjeFGuWDXsgXC
 uPfC+IL3akJoVmfcJPJpeBRyb3GKmZ0h/kXgp9gKe8iCOR9YNJ6sYpoFy0iZcX1P
 cZ8iB0yercr6eYFes5L51WbH6AWLJtpn9xQyDSfOOUNWLVebSa2GmLgNZ6uBsiaM
 fvUbKXmn+9QeJjwFGkHswxP6qcMFhW0Qm+Tzldp+eZK2IRSRt8g9rZcSJ81dYeEP
 yb7b4by1ZSDgzlO8RgS/Lk74xihBOhVh8kaAOJurKY9BTES4FEzl67XSVaKzOQNj
 G38qNnWzpc1ssCtUHS+8SiPRMB38O8NR3Qi6/ydfAvL8cgj0/zwwUIDgWkHkxZ4r
 ioi7LwOIrgM5NqOmYlklLtUQ1Vq9AkSzt9cHxGldR4U=

This is a note to let you know that I've just added the patch titled

    ocfs2: fix mounting crash if journal is not alloced

to the 5.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
and it can be found in the queue-5.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 1a949da1de4e74eddc8eb56723e5d4dabeac9d39
Author: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date:   Fri Apr 29 14:37:58 2022 -0700

    ocfs2: fix mounting crash if journal is not alloced
    
    [ Upstream commit bb20b31dee1a6c329c2f721fbe21c51945cdfc29 ]
    
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
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5739dc301569..bb116c39b581 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
+	journal_t *journal = osb->journal->j_journal;
 
 	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
 			       sysfile_type);
@@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
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
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 1887a2708709..fa87d89cf754 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
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
@@ -839,6 +837,21 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
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
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 8dcb2f2cadbc..969d0aa28718 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -154,6 +154,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
  *
+ *  ocfs2_journal_alloc    - Initialize skeleton for journal structure.
  *  ocfs2_journal_init     - Initialize journal structures in the OSB.
  *  ocfs2_journal_load     - Load the given journal off disk. Replay it if
  *                          there's transactions still in there.
@@ -167,6 +168,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
  *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
  */
 void   ocfs2_set_journal_params(struct ocfs2_super *osb);
+int    ocfs2_journal_alloc(struct ocfs2_super *osb);
 int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 477cdf94122e..311433c69a3f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2195,6 +2195,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
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
 
@@ -2483,6 +2492,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
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

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
