Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0912EC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OG8amc+HCklUCjnIAyG6ziBC7GwyC+fNiqXsiViKcD8=;
 b=rsfDJZZh1l8NXdHvaniASe79gjduyMjG7UmT6IKxuPzeIQX432JJAAWijwtGSNwsmapNyA7xBAw6
   I/fU3mJvSQkYbq5J8dI4D0wNFXzgvrgsMeUJoX3TIRIGlTeZ74y4OXzvVFd09jZUj2eNwYCTWQ7X
   YlHDw/mGfVmZszGdQnXB3Jdj/HPvwZKn+XSYrkp9m0gJWz+Y8UAieBCoj7njBfNoyHxtm/BASHii
   Ai2Cz2jHeDa8ulczzp5Nt8nLhMawmTNtS9YZQ3fktDODT8QrPXF1uI6178gPVg0KXD8ENq3/q/fL
   2tVVBjHJQ1YjfctgHfCWh55v5RRzejH+nWXJHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OG8amc+HCklUCjnIAyG6ziBC7GwyC+fNiqXsiViKcD8=;
 b=D3gHVPDpujEMVwU0oa1fTVjRbybm2+a8+J9KhdWNnMQBc5Ta5q4sbf+OrVvcewx3jjPeepoXnaLT
   UNTLWlIjBGtYlWTn6Wfub/lngDjdxrNWYrzwQIOF7BQy/GLTCDGCifq/63/OLcMP72up8unR1iVc
   lI7P0oU9q6UxIPBDYC9xa/6BOvxMmKjF7DmRMRAwMNPkxBoUiLZnsBwsEHmE6PHectryjIqw0+LO
   afousNvCdcjSsRh03zcuM2opt0wIC0OWZerwOuxq71Lq42yS1CNCiAfEpnFb3uAvPNxJ+bnLunWV
   f+FkBQNfc/fokHT13piWjZo0lCE+Bs9zdgPFFw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA900ORVYBBE480@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 10:54:47 +0000 (GMT)
Message-id: <5d25b0a7-2de8-c1fc-0d8c-506ca0b20a95@linux.alibaba.com>
Date: Wed, 13 Apr 2022 18:54:31 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-2-heming.zhao@suse.com>
In-reply-to: <20220413082957.28774-2-heming.zhao@suse.com>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=-12
 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130061 domainage_hfrom=8399
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] ocfs2: fix mounting crash if journal
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9zbPhj_1649847271;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: mB8cm-Yx4a1M7M_4jqIfdkiShalz-kBp
X-Proofpoint-GUID: mB8cm-Yx4a1M7M_4jqIfdkiShalz-kBp
Reporting-Meta:
 AAHTw7qPqKYYMMBuDZBn0++x57Mjip+P+f8dFQrCdLgj99NVqY5oyLihVgyJJN1d
 R6uZWJbxXTvds680tEyr1pnl4ZlIb818+Og7ySDcLfb2jirbUnHrVxsa0V6Ak93g
 s4qu3gxp+K98AkmNuXrKwTsFz/A/DuqurO+QSppEvA+zXskbAtRdD0ug7aDZCIBW
 GMHerjipuHMWa/0GkVY8oF0QfWIOL6MgIBmTeNHE808z9H+ltxBn2TX+Hxf0alPf
 xandCo+tac5Sg7rovm/5NKPBdlBWysxcIQoD+5OX3OYAaH9jRRk2qybv3w/8RG+K
 /0ygLXq7oGXLBLv7AuqDHW9iaIflKEuVwdrCFf+v4DiT4OJJ5a2hewtVGg074hxY
 /mxdHdd9YPA/C4zfOd45WlBw8Omn4H3IshFDn1PIXp0NY16jG6PTBqQSRBLD22JV
 9sN4I/MfT15VFk0Jhg21UcePxlrJsEOpDYE+Fhs8IoyBCheJZ3tpzau1EiP3kWeR
 AjS8VRcNqJKUkYi0HDcD9dgf4zE6VQkXTfVC2dtt4lsX



On 4/13/22 4:29 PM, Heming Zhao wrote:
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
> ---
>  fs/ocfs2/inode.c   |  4 ++--
>  fs/ocfs2/journal.c | 32 ++++++++++++++++++++++----------
>  fs/ocfs2/super.c   | 16 ++++++++++++++++
>  3 files changed, 40 insertions(+), 12 deletions(-)
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
> index 1887a2708709..49255fddce45 100644
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
> @@ -839,6 +837,20 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
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

Better to leave a BUG_ON(!journal) here like before.

>  	/* already have the inode for our journal */
>  	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
>  					    osb->slot_num);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 477cdf94122e..babec2c9d638 100644
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
> @@ -2195,6 +2196,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>  
> +	/*
> +	 * FIXME
> +	 * This should be done in ocfs2_journal_init(), but any inode
> +	 * writes back operation will cause the filesystem to crash.
> +	 */
> +	status = ocfs2_journal_alloc(osb);
> +	if (status)

Explicitly mark 'status < 0'?

Thanks,
Joseph

> +		goto bail;
> +
>  	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>  	init_llist_head(&osb->dquot_drop_list);
>  
> @@ -2483,6 +2493,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
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
