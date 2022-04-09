Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29414C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 10 Apr 2022 08:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p2X8d58lnmp+a6UqaO4+MRkmzDDnlYxXZGBBV85FxfU=;
 b=1aJ5UjmR/ERER9ATcaeK8WYmFjMZXy5p0fE78dQQTHLiHGJgulGwTv8XT/csfZuBZpsGGSU4uHS7
   FowIJCfm7PX13hFz9mn0WhToSWeqXaavcZnoYqf1CaoYoapQjBgUdR6rGEOo5ZEP2+Y/WOgk7+nR
   jSwSaFPzsLkrsoBFlFtG1zP1LobexXco0rVHzV8LHy6skEiKugRcievFc5HnNEJD9iq9ct7CSIFw
   +oSCB7oQBDO2rzt2JgP/IEei0auTFAL3AYHa0UmJHNPQvCpPokbQECjRvsvjWYpP/0uB3nS/hsR9
   r/LvoFT+CParGX/YaTOHn3VgzhK1lCRjTMa7pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p2X8d58lnmp+a6UqaO4+MRkmzDDnlYxXZGBBV85FxfU=;
 b=qX8mNEOlNw/fr1jdTNU5Phd/TsK5t4gC7jMryN/NS7iIhnZqYB/e0dxsX78W4ayU33mYdjrzQmb9
   lpK5D1vJJ18wjsjv6QcbdNK5Gr+quvSuDiUyuMXwtFP+hY1af+WzHNMeTc8IR49DqJ00s/atig+S
   iiKLn0xF/45XQY7KPk4qQc/gEvxQS+5+s7ga54pXqr+1j1wD9sfmExe5UmQzGnBPnzq5R3r10tP0
   MXo8MMJr0Ro8yk69sbK5Resaaws3QQZaWJqpkdRsScyGubgsFH2CrA9WvONLZFA0LFJEYKCl2NWf
   z8CeteS23REPts5i8NM27/KfWUj1/OuGF2oxWA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA4001456OJZJ70@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 10 Apr 2022 08:09:55 +0000 (GMT)
Message-id: <7a09992f-8eb5-b3c8-5c5e-0dd7f275fe8f@linux.alibaba.com>
Date: Sat, 9 Apr 2022 21:11:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-2-heming.zhao@suse.com>
In-reply-to: <20220408103012.1419-2-heming.zhao@suse.com>
X-Source-IP: 47.90.199.15
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=0 mlxlogscore=999 clxscore=106
 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090087 domainage_hfrom=8395
Subject: Re: [Ocfs2-devel] [PATCH v1 1/5] ocfs2: partly revert da5e7c87827e8
 for mounting crash issue
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9aTBAO_1649509885;
X-ServerName: out199-15.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1CDaBuzL1rY6LmpEXKTpVXO3gynGTZ22
X-Proofpoint-GUID: 1CDaBuzL1rY6LmpEXKTpVXO3gynGTZ22
Reporting-Meta:
 AAGNEKyCym5fbtLU25TSiFnSQJxoU4xGL5XeNupHUd/qJgJC325zLycjcPS/n530
 4+0jqoU3lubMyBXmKuqt3kWWct/iOGA8zJmbjuYU/DfDjEWDhtFl6bZbCIODfnOQ
 LhSig3EzuBecgmGBc02cK4vj8ahoyocLKn3H7a8Ws9he/5L4DRuH6bil3VhiDUNY
 0PNM6BEqFnt+Q9oe/5696pomFPYi+1cpfJHCn9EP7wUx84ROQJPrre6b4LTo+g4t
 XmaXBAo/gi5UsaXABieKZ6UkMFQ75xqnXRD+7528L/LVsQF6NRiqQOa6/bUcc5vQ
 OAc0eumdJfDUq5DhSmdsc6SC99b3HnhnzO/4+iJrMZv/rLA3XjuL4GMJB9L3rLjl
 Z5voD8RoHOtnHkoFzPYR17MWS1L0y41J7ZKpKubEi/QzuJR528OQYx1EZTyrzk7u
 dQhIqvRLaIzuiqftnDFQtw8z18NmSlS2aaBPzOv1e+LEAsMpuP/iKZChb0Rq8Fg0
 UIRxXecaxUFvmoRPd6LHqvV3W/LqAXjL5g6C7/u6YoQ4

Suggest rename the subject, something like
ocfs2: fix mount crash if journal is not alloced

On 4/8/22 6:30 PM, Heming Zhao wrote:
> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
> journal init later than before, it makes NULL pointer access in free
> routine.
> 
> Crash flow:
> 
> ocfs2_fill_super
>  + ocfs2_mount_volume
>  |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
>  |  + ...
>  |  + ocfs2_check_volume //no chance to init osb->journal
>  |
>  + ...
>  + ocfs2_dismount_volume
>     ocfs2_release_system_inodes
>       ...
>        evict
>         ...
>          ocfs2_clear_inode
>           ocfs2_checkpoint_inode
>            ocfs2_ci_fully_checkpointed
>             time_after(journal->j_trans_id, ci->ci_last_trans)
>              + journal is empty, crash!
> 
> For fixing, there are three solutions:
> 
> 1> Revert commit da5e7c87827e8
> 
> For avoiding kernel crash, this make sense for us. We only concerned
> whether there has any non-system inode access before dlm init. The
> answer is NO. And all journal replay/recovery handling happen after
> dlm & journal init done. So this method is not graceful but workable.
> 
> 2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)
> 
> The fix code is special for mounting phase, but it will continue
> working after mounting stage. In another word, this method adds useless
> code in normal inode free flow.
> 
> 3> Do directly free inode in mounting phase
> 
> This method is brutal/complex and may introduce unsafe code, currently
> maintainer didn't like.
> 
> At last, we chose method <1> and partly reverted commit da5e7c87827e8.
> We reverted journal init code, and kept cleanup code flow.
> 
> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c   |  4 ++--
>  fs/ocfs2/journal.c | 21 +--------------------
>  fs/ocfs2/super.c   | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 5739dc301569..bb116c39b581 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;
> +	journal_t *journal = osb->journal->j_journal;
>  
>  	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
>  			       sysfile_type);
> @@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	 * part of the transaction - the inode could have been reclaimed and
>  	 * now it is reread from disk.
>  	 */
> -	if (osb->journal) {
> +	if (journal) {
>  		transaction_t *transaction;
>  		tid_t tid;
>  		struct ocfs2_inode_info *oi = OCFS2_I(inode);
> -		journal_t *journal = osb->journal->j_journal;
>  
>  		read_lock(&journal->j_state_lock);
>  		if (journal->j_running_transaction)
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 1887a2708709..afb85de3bb60 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -815,30 +815,11 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  	int status = -1;
>  	struct inode *inode = NULL; /* the journal inode */
>  	journal_t *j_journal = NULL;
> -	struct ocfs2_journal *journal = NULL;
> +	struct ocfs2_journal *journal = osb->journal;
>  	struct ocfs2_dinode *di = NULL;
>  	struct buffer_head *bh = NULL;
>  	int inode_lock = 0;
>  
> -	/* initialize our journal structure */
> -	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
> -	if (!journal) {
> -		mlog(ML_ERROR, "unable to alloc journal\n");
> -		status = -ENOMEM;
> -		goto done;
> -	}
> -	osb->journal = journal;
> -	journal->j_osb = osb;
> -
> -	atomic_set(&journal->j_num_trans, 0);
> -	init_rwsem(&journal->j_trans_barrier);
> -	init_waitqueue_head(&journal->j_checkpointed);
> -	spin_lock_init(&journal->j_lock);
> -	journal->j_trans_id = 1UL;
> -	INIT_LIST_HEAD(&journal->j_la_cleanups);
> -	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
> -	journal->j_state = OCFS2_JOURNAL_FREE;
> -
>  	/* already have the inode for our journal */
>  	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
>  					    osb->slot_num);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 477cdf94122e..5f63a2333e52 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2015,6 +2015,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	int i, cbits, bbits;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
>  	struct inode *inode = NULL;
> +	struct ocfs2_journal *journal;
>  	struct ocfs2_super *osb;
>  	u64 total_blocks;
>  
> @@ -2195,6 +2196,32 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>  
> +	/* FIXME
> +	 * This should be done in ocfs2_journal_init(), but unknown
> +	 * ordering issues will cause the filesystem to crash.
> +	 * If anyone wants to figure out what part of the code
> +	 * refers to osb->journal before ocfs2_journal_init() is run,
> +	 * be my guest.
> +	 */
> +	/* initialize our journal structure */
> +	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
> +	if (!journal) {
> +		mlog(ML_ERROR, "unable to alloc journal\n");
> +		status = -ENOMEM;
> +		goto bail;
> +	}
> +	osb->journal = journal;
> +	journal->j_osb = osb;
> +
> +	atomic_set(&journal->j_num_trans, 0);
> +	init_rwsem(&journal->j_trans_barrier);
> +	init_waitqueue_head(&journal->j_checkpointed);
> +	spin_lock_init(&journal->j_lock);
> +	journal->j_trans_id = 1UL;
> +	INIT_LIST_HEAD(&journal->j_la_cleanups);
> +	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
> +	journal->j_state = OCFS2_JOURNAL_FREE;
> +
We may fold these into a new function, such as ocfs2_journal_alloc().

Thanks,
Joseph

>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
>  
> @@ -2483,6 +2510,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>  
>  	kfree(osb->osb_orphan_wipes);
>  	kfree(osb->slot_recovery_generations);
> +	/* FIXME
> +	 * This belongs in journal shutdown, but because we have to
> +	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
> +	 * we free it here.
> +	 */
> +	kfree(osb->journal);
>  	kfree(osb->local_alloc_copy);
>  	kfree(osb->uuid_str);
>  	kfree(osb->vol_label);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
