Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D16C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 20 Mar 2022 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1Sa2+cV+Y6yHXtqTOBV0M2sWdj9ZOzJ8A6+i/OmTyko=;
 b=BgJAzkn7TfsNbbybUtxHGFgU/nXNjK0VvsrinpCCR1M+eNHijPe4/zodqNUg/gdZZJhsCR0Sdl7c
   YuZNJ6/9jyrFJwb4s/1UtaKoE6WzO1bbpYK5ME6r+U+NMF2f3LB2Y8bx8ccFcdmsjipDQiEzEEDJ
   JgK9RnpcdwizYxlSjo/plVUFBC98VQcJ38IjEeUgh3D1fi9c9vlMPAjjsbLJwcEi69ScticKtreO
   Ko8kKZXDZBuWOzfVl7wVRopOJ26V1LihutzBMjse9eoBNCWZ3mpRKroN+uvnyomUUYEDmGoakSXk
   dILZNWiARd+goLco5eefzNOs8zBRm8qNLnfIYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1Sa2+cV+Y6yHXtqTOBV0M2sWdj9ZOzJ8A6+i/OmTyko=;
 b=isO38luwduv1Fh+XDmquSmNxGYEdSMVi0ZtyyWxd+6Y6RPu3gLvNI6IIBy+bOt0qXdE9gsKH7n/I
   a8UcpiM7S9LMB29+s9dPNdaK10rQGoabv7GFepTDu4GCIsMlv9/7rTZqNsx575ts6IK1KcSj+tfN
   gpjvaoYuH2XOv9euvNKD2+kPEvziOWjz00QBexfXEGbAfDGK2U8RSAsAqWagAHqm2tJCAPWtl64C
   IbLKwBsZsON+/oSejt6xHiKT6t9kaE+yF2mvdKbxPU8ZFET8NRB4K4rRipa1sY2orRzPmsPoKp/s
   a/bxImMTUZjH9847BUc6S9whKsY6g0T3OzkWKA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9100NKKQILMB70@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 20 Mar 2022 13:51:57 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
Date: Sun, 20 Mar 2022 21:51:37 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220318150401.2411-1-heming.zhao@suse.com>
In-reply-to: <20220318150401.2411-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 clxscore=182
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200103 domainage_hfrom=8375
Subject: Re: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after
 mounting when journal doesn't ready
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R301e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V7f2KDK_1647784297;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: L4wRlZ1XE-opja0yNEMzBXXo4UtIddGv
X-Proofpoint-ORIG-GUID: L4wRlZ1XE-opja0yNEMzBXXo4UtIddGv
Reporting-Meta:
 AAHNxLv8GK04rdnUGksw0cVb3VaQs98fuF4+sEQqSMOFbSI4BRnfzHX4m4RiB05H
 06Wb2toCgW4k6RKlYRUO33fWf70Yz5WZyYhSYu53sdiCF812t5SzGkBEXKqOX9V+
 YFz01iR4tFmWfNOdApGZlF9FwxkPcfmzi6TjT2DUzuh1jPYeRN0Vng1yamO9oSlm
 u4+tSnji0EqsmJr/2L0x0x6M1fhjckaw7bf7Z7iaVazaFPDEsyAvevJzgCIb5Xnf
 oh4ndJe+VOy2rxAYzGo/4pnTtCJcP0eNYtlHZX1SRTq7iO1lFugHc2FgZfs3AXph
 ndjLVsKjKMwPkPxayZo9Tz/BK0L1uGDlo62aqfRbYeIyUM8Y7a1mXluXoHaDYZEP
 QYsVALJyCQdqfoqMnjInsbI+QfBd04Bq/qDIZ4vcjJYF2Icen2U1GHKNUkpqxPai
 qUT4xtoQYS0pYLomRyO0ighARKOqu6Nz6fMIlZD/Ky7omi+bSEIKVwuY1Ynrv6lz
 jJIRDaZ8FhVULP16LkaaFDskIkZmGuG5Hfa86OsbJ4Q=

I don't think it deserves a complex fix like this.
iput() is a common action and we don't want to re-create a private flow
in ocfs2. Also I think it's not safe.
I suggest we take the way to make sure ocfs2 journal is there as a
prerequisite.

Thanks,
Joseph

On 3/18/22 11:04 PM, Heming Zhao wrote:
> Call trace:
> 
>   ocfs2: Registered cluster interface user
>   dlm: no local IP address has been set
>   dlm: cannot start dlm lowcomms -107
>   (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>   (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>   (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>   BUG: kernel NULL pointer dereference, address: 0000000000000030
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP NOPTI
>   CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1
> openSUSE Tumbleweed b40...e84
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
>   RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>   ...
>   Call Trace:
>    <TASK>
>    ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>    evict+0xc0/0x1c0
>    ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>    ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>    ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>    mount_bdev+0x182/0x1b0
>    ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>    legacy_get_tree+0x24/0x40
>    vfs_get_tree+0x22/0xb0
>    path_mount+0x465/0xac0
>    __x64_sys_mount+0x103/0x140
>    do_syscall_64+0x59/0x80
>    ? syscall_exit_to_user_mode+0x18/0x40
>    ? do_syscall_64+0x69/0x80
>    ? syscall_exit_to_user_mode+0x18/0x40
>    ? do_syscall_64+0x69/0x80
>    ? exc_page_fault+0x68/0x150
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> How to trigger:
> 
>   tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>   tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>              --cluster-name=ocfstst
> 
>              == there is no dlm running ==
>   tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>              == kernel crash ==
> 
> Analysis:
> 
> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
> Journal init later than before, it makes NULL pointer access in free
> routine.
> 
> ocfs2_fill_super
>  + ocfs2_mount_volume
>  |  ocfs2_dlm_init //failed, osb->journal still NULL.
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
> How to fix:
> 
> create a new function _inode_direct_free() to handle journal non-exist
> case.
> 
> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v3: change patch subject
>     change fix method:
>     - v1/v2 focused on the points of accessing osb->journal.
>     - v3 directly free inodes
> v2: revise commit log
>     add checking in ocfs2_dismount_volume()
> ---
>  fs/ocfs2/localalloc.c | 12 ++++++++
>  fs/ocfs2/super.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 75 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5f6bacbeef6b..c7694c2a1000 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -412,6 +412,18 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  		goto out_mutex;
>  	}
>  
> +	if (!osb->journal) {
> +		/* Does here make sense to handle bh? */
> +		if (osb->local_alloc_bh)
> +			brelse(osb->local_alloc_bh);
> +		osb->local_alloc_bh = NULL;
> +		osb->local_alloc_state = OCFS2_LA_UNUSED;
> +
> +		/*  After out_unlock calling iput() is safe, in theory system inode
> +		 * still be hold in dismount flow */
> +		goto out_unlock;
> +	}
> +
>  	/* WINDOW_MOVE_CREDITS is a bit heavy... */
>  	handle = ocfs2_start_trans(osb, OCFS2_WINDOW_MOVE_CREDITS);
>  	if (IS_ERR(handle)) {
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8bde30fa5387..65aedfdcb2f9 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -504,28 +504,79 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>  	return status;
>  }
>  
> +/*
> + * This function does the directly release action, which makes sure
> + * there is no memory & lockres leak for inode.
> + *
> + * How it works:
> + *
> + * refer iput() flow, which will call following key functions:
> + *   ocfs2_drop_inode, ocfs2_evict_inode, ocfs2_clear_inode, ocfs2_free_inode.
> + *
> + * - ocfs2_drop_inode() & ocfs2_clear_inode() are useless when directly remove.
> + * - other ocfs2_xx_inode() should be mentioned in this function.
> + */
> +static void _inode_direct_free(struct ocfs2_super *osb, struct inode *inode)
> +{
> +	int status;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +
> +	/* 1> copy from ocfs2_evict_inode() */
> +	truncate_inode_pages_final(&inode->i_data);
> +
> +	ocfs2_open_unlock(inode);
> +
> +	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
> +	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
> +	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
> +
> +	status = ocfs2_drop_inode_locks(inode);
> +	if (status < 0)
> +		mlog_errno(status);
> +
> +	ocfs2_lock_res_free(&oi->ip_rw_lockres);
> +	ocfs2_lock_res_free(&oi->ip_inode_lockres);
> +	ocfs2_lock_res_free(&oi->ip_open_lockres);
> +	ocfs2_metadata_cache_exit(INODE_CACHE(inode));
> +
> +	oi->ip_flags = 0;
> +	oi->ip_dir_start_lookup = 0;
> +	oi->ip_blkno = 0ULL;
> +
> +	/* 2> free memory */
> +	ocfs2_free_inode(inode);
> +}
> +
> +static void _inode_iput_free(struct ocfs2_super *osb, struct inode *inode)
> +{
> +	iput(inode);
> +}
> +
>  static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
>  {
>  	int i;
>  	struct inode *inode;
> +	void (*_free_inode)(struct ocfs2_super *osb, struct inode *inode);
> +
> +	_free_inode = osb->journal ? _inode_iput_free : _inode_direct_free;
>  
>  	for (i = 0; i < NUM_GLOBAL_SYSTEM_INODES; i++) {
>  		inode = osb->global_system_inodes[i];
>  		if (inode) {
> -			iput(inode);
> +			_free_inode(osb, inode);
>  			osb->global_system_inodes[i] = NULL;
>  		}
>  	}
>  
>  	inode = osb->sys_root_inode;
>  	if (inode) {
> -		iput(inode);
> +		_free_inode(osb, inode);
>  		osb->sys_root_inode = NULL;
>  	}
>  
>  	inode = osb->root_inode;
>  	if (inode) {
> -		iput(inode);
> +		_free_inode(osb, inode);
>  		osb->root_inode = NULL;
>  	}
>  
> @@ -534,7 +585,7 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
>  
>  	for (i = 0; i < NUM_LOCAL_SYSTEM_INODES * osb->max_slots; i++) {
>  		if (osb->local_system_inodes[i]) {
> -			iput(osb->local_system_inodes[i]);
> +			_free_inode(osb, osb->local_system_inodes[i]);
>  			osb->local_system_inodes[i] = NULL;
>  		}
>  	}
> @@ -1870,6 +1921,13 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	osb = OCFS2_SB(sb);
>  	BUG_ON(!osb);
>  
> +	if (!osb->journal) {
> +		ocfs2_shutdown_local_alloc(osb);
> +		ocfs2_recovery_exit(osb);
> +		ocfs2_purge_refcount_trees(osb);
> +		goto put_slot;
> +	}
> +
>  	/* Remove file check sysfs related directores/files,
>  	 * and wait for the pending file check operations */
>  	ocfs2_filecheck_remove_sysfs(osb);
> @@ -1897,6 +1955,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  
>  	ocfs2_purge_refcount_trees(osb);
>  
> +put_slot:
>  	/* No cluster connection means we've failed during mount, so skip
>  	 * all the steps which depended on that to complete. */
>  	if (osb->cconn) {

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
