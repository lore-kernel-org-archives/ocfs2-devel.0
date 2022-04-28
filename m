Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFC7C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+IQZoq71eLWeCEX7AF66Me4gM9ndpuSIvO33u2OBDEA=;
 b=DQg1g6rt98yTzAs7kNZA7wiv8f3UDZnBxJ/vG5xmBw1eh9Ox7SJgCOgrj1Q9t8jhyW/G7LfHww4K
   DfHoQY22j3WiWOcUVtuO8HDuGkinuzEsh6BVYRT65Vr/wbUqRk2SKU5RqRjNlaR0OcevTaMPmDmf
   QeD6WmWppgfsrNs0vSJh4Jjy8/Ai27j13+ygbw/Mrj0RQ63PdqCpgE4eC3k97iRBY7/XryBFLk0t
   H/tCz/e9efEZWwseSolRXGyC2JKXBDE6xmXqEaLNbw+EVSEpvTBxBw1jPLuDjkcx0K9wAv1qZXL8
   HFi2oh+hHaoC1SIyqzYcs4LATBAba3DxIzPspg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+IQZoq71eLWeCEX7AF66Me4gM9ndpuSIvO33u2OBDEA=;
 b=a7P8Rg3a/FhpGDliX28ORIGBEMDKDyC7dL5hJygYBHRotWhMYXBxsYByFrGq/+j4AYIR1IdqIp8k
   +/0BWBGksbeXPb6dAhqM+VCU7QfUUpJyPt1gqXStDKKhP1f+a1lkIkweG3H+u+v01iSwplTDlNnG
   ACX7vRGr9J49uGBQg6KQv+ohbEeiSKt+if3Z3mcszjFLs9+BRKjN+xPbib3e0fn5+GbdVJpMFH9R
   LOf5yoLEx3I3dVEouyUAlOyG6WqmxUaF/3EF8sr974YiuWwDQjfnUDH3l8zCosfAZdPLYDL4TjEz
   REOuFuIxiFn296ZYh0dOldxs+SyGWl/kIrZv9g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB100GMPRVJMK90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 11:28:31 +0000 (GMT)
Message-id: <ddae3796-68c4-0dc9-3720-d91a9f45bc37@linux.alibaba.com>
Date: Thu, 28 Apr 2022 19:28:13 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-2-heming.zhao@suse.com>
In-reply-to: <20220424130952.2436-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=-1 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280070 domainage_hfrom=8414
Subject: Re: [Ocfs2-devel] [PATCH v3 1/5] ocfs2: fix mounting crash if journal
 is not alloced
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBaXuI9_1651145293;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: vLZsWGEhbF2p-k6d4vqEB6DcfKqXPdz8
X-Proofpoint-ORIG-GUID: vLZsWGEhbF2p-k6d4vqEB6DcfKqXPdz8
Reporting-Meta:
 AAFyIc2oUm/LHl6SqcvvBM7PfIO35ZE7jwCTjPh5gpvVYGINmE/YzpfIw0PrHKFU
 7CwvoyDckRc6mm/cOEWV7Yv1ueHVv8cgeQ8KjhAVQ4ii1pYtvc5eZpKJQbN7A6hB
 kYphYbp3vXRiOfxAbBAvha4iHjDkI8HAyfq+hT6sbiOUdYUTe2k1PFqSXBCe5+7n
 Vm+PRoVxL4bmU/kcb5kYO8egE7J+FIKX0KSBcGTSp1aNdGAkSCco/N2dMxs4hvr9
 4clqNZbrco8BDSiuHjMs1eC4ZFuBCvES4tctQF4pSdxY6N9pM+sdvNr3h7SjkoyX
 hG1kL+buXTBn67Mag1/4f95e/4VWBSYgCcnXoBOuDiApS1r458pjUUVQnpZn+enD
 LTI5CVKPucqw/EoSxlV8bpXHz8oSD/iFyUMi97huxgqvDs6zUWEMPfhNR8fYoN82
 IX5kWY4Cvb9LsmJIQP8dLi7hm/LEvx6bzyALTnJMqMOaOgL394nhP/9b2HZmHHzN
 6WaMolz4/ERK6JVrWMn2sw2uSfLw4Y3z7GKuKaCQoJ4=



On 4/24/22 9:09 PM, Heming Zhao wrote:
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
> 1> Partly revert commit da5e7c87827e8
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
> At last, we chose method <1> and did partly reverted job.
> We reverted journal init codes, and kept cleanup codes flow.
> 
> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c   |  4 ++--
>  fs/ocfs2/journal.c | 33 +++++++++++++++++++++++----------
>  fs/ocfs2/journal.h |  2 ++
>  fs/ocfs2/super.c   | 15 +++++++++++++++
>  4 files changed, 42 insertions(+), 12 deletions(-)
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
> index 1887a2708709..fa87d89cf754 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -810,22 +810,20 @@ void ocfs2_set_journal_params(struct ocfs2_super *osb)
>  	write_unlock(&journal->j_state_lock);
>  }
>  
> -int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
> +/*
> + * alloc & initialize skeleton for journal structure.
> + * ocfs2_journal_init() will make fs have journal ability.
> + */
> +int ocfs2_journal_alloc(struct ocfs2_super *osb)
>  {
> -	int status = -1;
> -	struct inode *inode = NULL; /* the journal inode */
> -	journal_t *j_journal = NULL;
> -	struct ocfs2_journal *journal = NULL;
> -	struct ocfs2_dinode *di = NULL;
> -	struct buffer_head *bh = NULL;
> -	int inode_lock = 0;
> +	int status = 0;
> +	struct ocfs2_journal *journal;
>  
> -	/* initialize our journal structure */
>  	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
>  	if (!journal) {
>  		mlog(ML_ERROR, "unable to alloc journal\n");
>  		status = -ENOMEM;
> -		goto done;
> +		goto bail;
>  	}
>  	osb->journal = journal;
>  	journal->j_osb = osb;
> @@ -839,6 +837,21 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
>  	journal->j_state = OCFS2_JOURNAL_FREE;
>  
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
> +{
> +	int status = -1;
> +	struct inode *inode = NULL; /* the journal inode */
> +	journal_t *j_journal = NULL;
> +	struct ocfs2_journal *journal = osb->journal;
> +	struct ocfs2_dinode *di = NULL;
> +	struct buffer_head *bh = NULL;
> +	int inode_lock = 0;
> +
> +	BUG_ON(!journal);
>  	/* already have the inode for our journal */
>  	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
>  					    osb->slot_num);
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 8dcb2f2cadbc..969d0aa28718 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -154,6 +154,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
>   *  Journal Control:
>   *  Initialize, Load, Shutdown, Wipe a journal.
>   *
> + *  ocfs2_journal_alloc    - Initialize skeleton for journal structure.
>   *  ocfs2_journal_init     - Initialize journal structures in the OSB.
>   *  ocfs2_journal_load     - Load the given journal off disk. Replay it if
>   *                          there's transactions still in there.
> @@ -167,6 +168,7 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
>   *  ocfs2_start_checkpoint - Kick the commit thread to do a checkpoint.
>   */
>  void   ocfs2_set_journal_params(struct ocfs2_super *osb);
> +int    ocfs2_journal_alloc(struct ocfs2_super *osb);
>  int    ocfs2_journal_init(struct ocfs2_super *osb, int *dirty);
>  void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
>  int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 477cdf94122e..311433c69a3f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2195,6 +2195,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>  
> +	/*
> +	 * FIXME
> +	 * This should be done in ocfs2_journal_init(), but any inode
> +	 * writes back operation will cause the filesystem to crash.
> +	 */
> +	status = ocfs2_journal_alloc(osb);
> +	if (status < 0)
> +		goto bail;
> +
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
>  
> @@ -2483,6 +2492,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
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
