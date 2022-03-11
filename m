Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118F8C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 11 Mar 2022 02:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d+245t8vgNGKjTJIxeMdBnwnKJhlkVKdwIU/vAIMp28=;
 b=JAWVUd+VZge9aq5y3J2F04q5XV2IhBaYIsNzLsNuTUn/91iTYhleBfMmfYIeLcznJ6Z7PEraN/6L
   SRTJKBZswz+P4f14XCiCzaDvdpS4BtP8a2eNRznkG0yOeuS0RILWpJhpx1HbeD0B3rEiRUaCxb+S
   IqU95ov2FNS5bZtIo7f85ilmlDodpL4lfsyGZOZiJ5qf+5WGAoHgf6k7SpfAJt89rDAgjPG5c15W
   wWNwz4Diok/HOJ+ZKhGQUt54lQZXSBRy9/u/UIxE8dcTBr1LkBE33NKkkcFPh3vEyJDFJ0KQajZ8
   vOqLv5ayFFbmoH78p+EuIG9IvkgjJvqQqmkYBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d+245t8vgNGKjTJIxeMdBnwnKJhlkVKdwIU/vAIMp28=;
 b=c2I3EzI35OvFsvn0HtosC4KcuO0+H4fErxbe2ji7usSKCVXIOLk6yXXnnnszd5SkTxJbHJp/Zb/0
   jLTgv/bXyF9C4mbhRfV2PGgzLzuU/A9yefnGxOQu2u3bqhs19i2iMo37whOhHHjFTinOSBJljUNN
   yD7CfnpUk83wG0ihiQ6EUdAu9vL2jTJHagai4qAuN3pJJaT0zxBy+JnCRMm7dq3tAn2QozBlj89n
   oSdLTbnKO2NtbcaTIx1fsqcPQi7Mzrc8qjrnqNNaptsI/05BoNZTlXe78zi3kSf/GIaus+V9Z7au
   rs4qHxh9ohtSu1KR8vcKrFESgPKH/YW2nJh71Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8K00P6174K4J40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 11 Mar 2022 02:33:56 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <e66d10f3-cec7-0564-260a-3c441bebcdd6@linux.alibaba.com>
Date: Fri, 11 Mar 2022 10:33:38 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220310105850.1817-1-heming.zhao@suse.com>
In-reply-to: <20220310105850.1817-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282
 signatures=692556
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 priorityscore=30
 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=275 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110011 domainage_hfrom=8366
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix kernel crash after mounting
 when dlm doesn't ready
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R271e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V6r0EtS_1646966018;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 5FdCIqyh-2Y5Kd7vfom4l3LzKEkqquWN
X-Proofpoint-ORIG-GUID: 5FdCIqyh-2Y5Kd7vfom4l3LzKEkqquWN
Reporting-Meta:
 AAHVBoTbFDIFC9lH0D8i9uTeYQUSmmxlnrauyFCGeshi+U58FTeDmqsD5TVPUyBL
 jGq2NX3bsXEyxG81KecUPl0gNRUIm1eM2ZZhx3vOOvKVtXn69W1NLQWOaW0bI83e
 TwAwfWFJ8Xd81H59L7j1v2IVljshU4Qm9qR0X4m4B4W4uUtWPhl1IZ6tqXYY7l0A
 E+wjcHMqtK5Gqr9Im0lNfTRTNFoBAbM39APHDTa8s1iSWzgbmbhRc0aVuOHQJ7wY
 n9rFyEZqGrf9n512k4oyBUybHw37MdqtAdlNFdCxjXhjwkcJqv3PZHbins0dh3GA
 Oku4iKTjM2GUlN/VYIEOQkAO7jNs170xr0/4UJv7CaI+2bAWm/gc9vMfoZvQhyex
 tx4H2sdH9A5zXMS9sYPIoOKyzSAcqT9KB3FVPlJsPNiksN4zlJxi6HjaJLdNmPqP
 vfLZIMJnHAWf47e+qUNTxCBls+Xm2dlgssutSeHflyB+v4OkPJAc5FPMdzq9fJCf
 9FUW9Sb7DkIHB/2QR7p/tbvvPILcha7Cb0rR6u1qiLk=

Hi,
To prevent the crash, I think these changes are fine.
But it looks wried to spread the check of ocfs2 journal.
Can we intialize the ocfs2 journal much earlier?

Thanks,
Joseph

On 3/10/22 6:58 PM, Heming Zhao wrote:
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
>   CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40...e84
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
>   tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb --cluster-name=ocfstst
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
> The fix should assess osb->journal before journal operation. And the fix
> should be only related with abnormal case before ocfs2_journal_init().
> 
> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2: revise commit log
>     add checking in ocfs2_dismount_volume()
> ---
>  fs/ocfs2/inode.c   | 3 ++-
>  fs/ocfs2/journal.h | 2 +-
>  fs/ocfs2/super.c   | 7 ++++---
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 6c2411c2afcf..3826ab7eab3e 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1205,7 +1205,8 @@ static void ocfs2_clear_inode(struct inode *inode)
>  	 * the journal is flushed before journal shutdown. Thus it is safe to
>  	 * have inodes get cleaned up after journal shutdown.
>  	 */
> -	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
> +	if (osb->journal)
> +		jbd2_journal_release_jbd_inode(osb->journal->j_journal,
>  				       &oi->ip_jinode);
>  }
>  
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 8dcb2f2cadbc..1610d49b4112 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -189,7 +189,7 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
>  {
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_mount_local(osb))
> +	if (!osb->journal || ocfs2_mount_local(osb))
>  		return;
>  
>  	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 2772dec9dcea..01f1ab7c8de8 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1886,9 +1886,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	/* Wait for worker to be done with the work structure in osb */
>  	cancel_work_sync(&osb->dquot_drop_work);
>  
> -	ocfs2_shutdown_local_alloc(osb);
> -
> -	ocfs2_truncate_log_shutdown(osb);
> +	if (osb->journal) {
> +		ocfs2_shutdown_local_alloc(osb);
> +		ocfs2_truncate_log_shutdown(osb);
> +	}
>  
>  	/* This will disable recovery and flush any recovery work. */
>  	ocfs2_recovery_exit(osb);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
