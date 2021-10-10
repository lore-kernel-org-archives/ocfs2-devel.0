Return-Path: <SRS0=I/Mm=O6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF10DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 10 Oct 2021 13:12:09 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F49061076
	for <ocfs2-devel@archiver.kernel.org>; Sun, 10 Oct 2021 13:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4F49061076
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19A9u5xW023821;
	Sun, 10 Oct 2021 13:12:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bkwyug8sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Oct 2021 13:12:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19ADAwBx110287;
	Sun, 10 Oct 2021 13:12:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bkyv71duq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 10 Oct 2021 13:12:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mZYZU-0005gs-SU; Sun, 10 Oct 2021 06:08:56 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mZYZ0-0005fx-L4
	for ocfs2-devel@oss.oracle.com; Sun, 10 Oct 2021 06:08:26 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19AD6xSn103680
	for <ocfs2-devel@oss.oracle.com>; Sun, 10 Oct 2021 13:08:26 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3bkyv71bv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 10 Oct 2021 13:08:25 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19A7j7YX005569
	for <ocfs2-devel@oss.oracle.com>; Sun, 10 Oct 2021 13:08:24 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bkv2ft9jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 10 Oct 2021 13:08:24 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UrGOroP_1633871286; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UrGOroP_1633871286) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 10 Oct 2021 21:08:07 +0800
To: Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
References: <faceeac2-7419-e500-12ba-ab11b915e660@linux.alibaba.com>
	<20211009145006.3478-1-vvidic@valentin-vidic.from.hr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <91ecfefc-f67e-c3ba-207d-8514a1bd8312@linux.alibaba.com>
Date: Sun, 10 Oct 2021 21:08:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211009145006.3478-1-vvidic@valentin-vidic.from.hr>
Content-Language: en-US
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	malwarescore=0 clxscore=240
	adultscore=0 spamscore=0 priorityscore=0 suspectscore=0
	lowpriorityscore=0
	impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
	definitions=main-2110100092 domainage_hfrom=8214
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: cleanup journal init and
	shutdown
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110100092
X-Proofpoint-ORIG-GUID: PbN99Ye9OnyUitv1DeVqLMOM57dLKjfR
X-Proofpoint-GUID: PbN99Ye9OnyUitv1DeVqLMOM57dLKjfR



On 10/9/21 10:50 PM, Valentin Vidic wrote:
> Allocate and free struct ocfs2_journal in ocfs2_journal_init and
> ocfs2_journal_shutdown. Init and release of system inodes references
> the journal so reorder calls to make sure they work correctly.
> 
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

Looks good.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2: use osb->journal and cleanup commented up_write call
> 
>  fs/ocfs2/inode.c   |  4 ++--
>  fs/ocfs2/journal.c | 26 +++++++++++++++++++++-----
>  fs/ocfs2/journal.h |  3 +--
>  fs/ocfs2/super.c   | 40 +++-------------------------------------
>  4 files changed, 27 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index bc8f32fab964..6c2411c2afcf 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -125,7 +125,6 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;
> -	journal_t *journal = OCFS2_SB(sb)->journal->j_journal;
>  
>  	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
>  			       sysfile_type);
> @@ -172,10 +171,11 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	 * part of the transaction - the inode could have been reclaimed and
>  	 * now it is reread from disk.
>  	 */
> -	if (journal) {
> +	if (osb->journal) {
>  		transaction_t *transaction;
>  		tid_t tid;
>  		struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +		journal_t *journal = osb->journal->j_journal;
>  
>  		read_lock(&journal->j_state_lock);
>  		if (journal->j_running_transaction)
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 4f15750aac5d..b9c339335a53 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -810,19 +810,34 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
>  	write_unlock(&journal->j_state_lock);
>  }
>  
> -int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
> +int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  {
>  	int status = -1;
>  	struct inode *inode = NULL; /* the journal inode */
>  	journal_t *j_journal = NULL;
> +	struct ocfs2_journal *journal = NULL;
>  	struct ocfs2_dinode *di = NULL;
>  	struct buffer_head *bh = NULL;
> -	struct ocfs2_super *osb;
>  	int inode_lock = 0;
>  
> -	BUG_ON(!journal);
> +	/* initialize our journal structure */
> +	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
> +	if (!journal) {
> +		mlog(ML_ERROR, "unable to alloc journal\n");
> +		status = -ENOMEM;
> +		goto done;
> +	}
> +	osb->journal = journal;
> +	journal->j_osb = osb;
>  
> -	osb = journal->j_osb;
> +	atomic_set(&journal->j_num_trans, 0);
> +	init_rwsem(&journal->j_trans_barrier);
> +	init_waitqueue_head(&journal->j_checkpointed);
> +	spin_lock_init(&journal->j_lock);
> +	journal->j_trans_id = 1UL;
> +	INIT_LIST_HEAD(&journal->j_la_cleanups);
> +	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
> +	journal->j_state = OCFS2_JOURNAL_FREE;
>  
>  	/* already have the inode for our journal */
>  	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
> @@ -1028,9 +1043,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>  
>  	journal->j_state = OCFS2_JOURNAL_FREE;
>  
> -//	up_write(&journal->j_trans_barrier);
>  done:
>  	iput(inode);
> +	kfree(journal);
> +	osb->journal = NULL;
>  }
>  
>  static void ocfs2_clear_journal_error(struct super_block *sb,
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index d158acb8b38a..8dcb2f2cadbc 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -167,8 +167,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
>   *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
>   */
>  void   ocfs2_set_journal_params(struct ocfs2_super *osb);
> -int    ocfs2_journal_init(struct ocfs2_journal *journal,
> -			  int *dirty);
> +int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
>  void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
>  int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
>  			  int full);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 5c914ce9b3ac..1286b88b6fa1 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1894,8 +1894,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	/* This will disable recovery and flush any recovery work. */
>  	ocfs2_recovery_exit(osb);
>  
> -	ocfs2_journal_shutdown(osb);
> -
>  	ocfs2_sync_blockdev(sb);
>  
>  	ocfs2_purge_refcount_trees(osb);
> @@ -1918,6 +1916,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  
>  	ocfs2_release_system_inodes(osb);
>  
> +	ocfs2_journal_shutdown(osb);
> +
>  	/*
>  	 * If we're dismounting due to mount error, mount.ocfs2 will clean
>  	 * up heartbeat.  If we're a local mount, there is no heartbeat.
> @@ -2016,7 +2016,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	int i, cbits, bbits;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
>  	struct inode *inode = NULL;
> -	struct ocfs2_journal *journal;
>  	struct ocfs2_super *osb;
>  	u64 total_blocks;
>  
> @@ -2197,33 +2196,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>  
> -	/* FIXME
> -	 * This should be done in ocfs2_journal_init(), but unknown
> -	 * ordering issues will cause the filesystem to crash.
> -	 * If anyone wants to figure out what part of the code
> -	 * refers to osb->journal before ocfs2_journal_init() is run,
> -	 * be my guest.
> -	 */
> -	/* initialize our journal structure */
> -
> -	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
> -	if (!journal) {
> -		mlog(ML_ERROR, "unable to alloc journal\n");
> -		status = -ENOMEM;
> -		goto bail;
> -	}
> -	osb->journal = journal;
> -	journal->j_osb = osb;
> -
> -	atomic_set(&journal->j_num_trans, 0);
> -	init_rwsem(&journal->j_trans_barrier);
> -	init_waitqueue_head(&journal->j_checkpointed);
> -	spin_lock_init(&journal->j_lock);
> -	journal->j_trans_id = (unsigned long) 1;
> -	INIT_LIST_HEAD(&journal->j_la_cleanups);
> -	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
> -	journal->j_state = OCFS2_JOURNAL_FREE;
> -
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
>  
> @@ -2404,7 +2376,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>  						  * ourselves. */
>  
>  	/* Init our journal object. */
> -	status = ocfs2_journal_init(osb->journal, &dirty);
> +	status = ocfs2_journal_init(osb, &dirty);
>  	if (status < 0) {
>  		mlog(ML_ERROR, "Could not initialize journal!\n");
>  		goto finally;
> @@ -2513,12 +2485,6 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>  
>  	kfree(osb->osb_orphan_wipes);
>  	kfree(osb->slot_recovery_generations);
> -	/* FIXME
> -	 * This belongs in journal shutdown, but because we have to
> -	 * allocate osb->journal at the start of ocfs2_initialize_osb(),
> -	 * we free it here.
> -	 */
> -	kfree(osb->journal);
>  	kfree(osb->local_alloc_copy);
>  	kfree(osb->uuid_str);
>  	kfree(osb->vol_label);
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
