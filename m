Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C3CC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 12:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QuHkQdSEEMHdDuTmwe6b9fBCsQWrT6i7MOThZbURt3g=;
 b=m0+Zn/hsEj50lLX6/O6LAbCQnI8lUK48TjnICdnaIXBj0bRUUXdWNG+g7/DQEWWsYYH4t1szAend
   k8Z5YZOQUaj1tBK8qSxMuPm7tcFFp59aZvUpV/JGIpZmsRzQLAewtBWiTFBhd6X6S3x/BfkyLoPw
   YYZz2wOlE8z+gd+i9+cpYzkZNkk1aDe7g3bUbnx7ANuz7Aztg1I/qN0a72VGFdi+hF1T2+gFE0rP
   d61JHSqVeP+/izkncLvVqCkibT3huvX6diP8w8SyDE78N8cohqY4haVAq8J7LT+wP5XoLFUsijOd
   y6ayPop7ExL2Shc1mDlFHAoJR1XTW7cC2ZEDtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QuHkQdSEEMHdDuTmwe6b9fBCsQWrT6i7MOThZbURt3g=;
 b=PIo5LpXy2we0oZK7BWFjWZmU/PxI1yzZUYZvxqgSle0DNLSfar13FRegOX7Ar2mSsKSdBjUdxhu0
   QS+osxtwCaVfHIFb2duPjdMj6VEw1zrg9H0+pkqZtABeo80zgmrg770ErkJ5BbAehnAZuOCasPEs
   4F5JilvnytoX5+W/i50lRbQ5Lp6x3Jzoi3OGjGabmxFUpbPa7MPyCppUdHa7+tNFRcvZk+L1M+ro
   OYmDmmdS0y7CdBOV+tvt+pnkPPhV+kuwvftzspk8PMhMkjBJg7FkaQ/IPVafvGssC9BxUzRpjLLv
   snEdSxnUPKq2o+2WUVekl1V7BhYNtnQ96fjBAA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CO51OVTL80@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 12:07:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1654517134; bh=M6OSWfA/gARuYZytT1wXpBV7uKI+PabmMfuvuBaeT88=;
 h=From:To:Cc:Subject:Date:From;
 b=HdxYHjlh2flEfBFP/MKXE6zVS0EIWvYqP14Xw2MeemoxgafP2pNVEJQX2IUDF/FVu
 r4GenOP465BgeUWscxezvYJ1Wd4/sPgrU31qzFuTlUcEFcilqhXuy0HpKJv8J+Zuv3
 E9TXb10E0LQLG7k4653mrYh36kXvMSMZAAwVo8rA+r7uf83qyShlK5RZurPAcgjH7W
 xuDpCijNoM0nMO82gPGLhQrQ1kOemftNSP1CdZe5LdTD1VLIkQqjzixEQE1rsDdly9
 rBaGIwQm3+6gC5k0Ycq9CzUKtwDLMhT9YKaS9Bw+U6UoClhHSJBNusYg1sDanvEZO+
 yEziTfJR16Mwg==
To: stable-commits@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date: Mon,  6 Jun 2022 08:05:31 -0400
Message-id: <20220606120531.159267-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10369
 signatures=594849
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix mounting crash if journal is not	alloced" has been added to the
 5.17-stable tree
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: xqTI4yZozdvwqBhM6eDlSdtbMGnwseWN
X-Proofpoint-ORIG-GUID: xqTI4yZozdvwqBhM6eDlSdtbMGnwseWN
Reporting-Meta:
 AAEt7Z7OKN+1/ssn1+Hmr4MX3eZMKsiDXJuHJjLNKoSvwmSplpKKLQJJsuQtSyYM
 n8CXjffgjJHRVZw2nOSHfVT8+q61K9nqu6X1TrWNudO4iJaG0U+O4byEhol8uAZc
 9iZW1Ob/npj33p+Pxr1TiWScJFzMJOu5RVKA0ONMBaWjWw6sCHzRE6yHww80fIme
 FEJcSoY8/dUu5L0x21ow2+K0qmbop6mX6kn9oDXlu+5XIxIMWaN9KCEPJPxaPOe7
 AAmwA6UpiEPzrNX3qWybWZGfJwDdYoI1phYEOnMaEzegag1/OQKO1QVmSBtXkrCQ
 K3I/SkxPoRZ4Azekg8iRIiKIQwk98uLzQ23spkKtXPk/vEdjhe9dAtNkoyjzwNcV
 dd/9s+nDW872FF/n/DfsP4H5KcT9aKXwNuFaz+ULlHwrthfwLTp0gECVzUQrxtgX
 vQTOQ1STC9CdXZ72JbfD5qRUkHA6YWS4BbnY3tEf81/7kX0SHltMUUYPUqX4oZTE
 yasPmzDclmS5uBQqvZS7NAjmoPVxiTyDbQqrO8XPRg==

This is a note to let you know that I've just added the patch titled

    ocfs2: fix mounting crash if journal is not alloced

to the 5.17-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
and it can be found in the queue-5.17 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 08264af8936842881b84c2aeb91273ab0e3fcfea
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
index 6c2411c2afcf..fb090dac21d2 100644
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
index 8bde30fa5387..4a3d625772fc 100644
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
