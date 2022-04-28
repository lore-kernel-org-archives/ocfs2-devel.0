Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CFDC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1Nnq0kz2Smj1EwPAGxAGq+6YNVUf1kwlPA+VXQwBfIU=;
 b=oEMM5fmQLpNf8FiAmQn89hdEEIQu3nLt6wjLW/zXgIwoCBtT/39suLmA2BDAP/OwG6+kLuB9gfYz
   YKpnz5v+U+wmbkn2dfNbridhY6qzjlYuNkxOFMnDQaiMzDKFz4gK52GoTGv8dNWSz7hLEqVG+yiW
   ynUuCqCnKK22+jZOCzUDU7VAy0iDgNLks5+1PJysNbt2Ypp005NCMzUP5RL9l1+KkB9/N3A1HHCE
   KwNr/eCCCzlCzJboHxAARwAdvlOD08YIBDDAH71Pj+eHhGs9oxtcx8YGp9ngWNQS7PAI5iJjnHyW
   9S9zJX5+aGIZVmpeGC/s+Y/C345VMTAo4EleIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1Nnq0kz2Smj1EwPAGxAGq+6YNVUf1kwlPA+VXQwBfIU=;
 b=jMu1Yg3WyG1Sjz/+qGho1psWp0pK2TVVJRYe8zPJ7MnfVngVgcdtR9qOvGKxdktkzVI/vMmeZyhO
   avoro4HezPLWTZuV2wb+6vE58V9Sa+5qekjPRvtb9Kw1TlesElKRvOxyTkh8B1MG7cHNF33ySlPb
   fNHlDFTFyGLpr6VEeiU+Rw0ds8HwB2yxkyzNbLe7jiRorEK2pyyCG13UNZ7ZMrAsQ2gNJwdcHwx9
   ++81drwkclEGq0tceZz4iLg4BovwZJrOJjX7XR6DaLE3JPn8wZjl515RwH4FKppEKTFZtmOt1wSi
   n/F9hZngh9fDanqNK9ymwpmvYJGmFMOQMRCuig==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB2006G3L3T8KE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 21:59:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1651183174; bh=XTxtQFR11j6hFKAWyIj6UZ354hGPUGzxPMh8nWPUEwg=;
 h=Date:To:From:Subject:From;
 b=2JDjsD/Vh+5dxKVxAy8JH/+SzVojZHzCkq98POAm23DUB5gliqqhNUfVy1TuB2cMu
 0Fu7wDl7nVE2I7yokoZkcvh6kEZJXHcyYh1sPKBDoMxv1qjC8XyUfwdAhLeiIwRrca
 IkC+WApHdu5f2zDFo0v0KfspbmchLWJ6X/H6YU/c=
Date: Thu, 28 Apr 2022 14:59:34 -0700
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220428215934.D012DC385A9@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10331
 signatures=591664
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 priorityscore=60
 lowpriorityscore=0 bulkscore=0 clxscore=184 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280128
Subject: [Ocfs2-devel] +
	ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch	added to -mm tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: RYaL6LnbObPcX_5sl5_ydBpXXGwoxc9J
X-Proofpoint-GUID: RYaL6LnbObPcX_5sl5_ydBpXXGwoxc9J
Reporting-Meta:
 AAHz+cmyrjfHqN5fBwuj0cSaSs7MLRYyqVdPmzpYLy+RAVFd1T3s3f4PCuK4UTHg
 YjoByyO19EDbxKM+bC6CA2s+v5J/03teVzfuD5/whtP/tBlPrHxQl2cgUkMH5NH7
 TEIoVY1X35U9qGgQh0NMz4iEFLvdKSMP1vvhBr5qudFYRbDQGRun6o63XoP2rcgY
 t+A/ByIItW97/QTMaiKBhoTSw8U77VMZVmaVpnAs/sqCoS1AZ/yr6QLaIzSUEVi6
 VbR81UgQjuwjDmid+qnyD/K/iVksnxT+mlmmDPywQqTVtr09r/qFODCdtQ43fEfu
 szE9+fCcbz3bZ2QWlaZLFkBHuKXxEdE9eQOUkkaZWvCRm4r85Vqkio2KJj0gv9ID
 cVBw2oW84O3easc2HkonimJz5dI+QobSlPTJ09Y4Xc/NSZojpeZqoX83hNMqxpm3
 pxTsouiMcXvGZf19TXWKtkj9mfNsp8qUWsw1z4j7DYm2z6yQnOHrSbnx9dvi13CI
 kZ+MYr41QAmya6WSyk3TB6DhXF710kr//1J9Apb0P9tJ


The patch titled
     Subject: ocfs2: fix mounting crash if journal is not alloced
has been added to the -mm tree.  Its filename is
     ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
