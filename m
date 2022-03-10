Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D09C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 04:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=82MmCKSzJpQtoSmiRiKp3sC1k6oLj3adgjhIO0MkQ/E=;
 b=VoTCX6GyL9+Glu/OHRyoaiIj5MNneNGV1l4qO2Se/YDPs20zJz1f6U1mOXwIUcDzSNVZMqNVUhO4
   /a8tfXWOe/rIqUFCoiQOL7yXByt+LE7NzcTtxl3oxUQwV8CYLZ5akr6uS9Ebf4HyImntogmB7Lwd
   K4Xj1EV93Si9Ujl+34MocGkE1CqEVmmz1LN4QHUpqZ8cGiocqHEY67ajZUrGOD3Wu7TnrmoZpN3L
   HevYdVDTzzDyXvKAuXbVE/iYExfZWj6kKFMyV1pyhyapVXPcZ0jAMCeRzVPFNQnWSZndhmgUB176
   vss1YCt7oJhEebNQ2Pzl5ugEwch5uJ1rCI9kIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=82MmCKSzJpQtoSmiRiKp3sC1k6oLj3adgjhIO0MkQ/E=;
 b=a4M0wif3Blu6228rDDKskEOhd3Afm+f7YTzB+iPlt800QkNhMvxO//cZfvqpnda5jLjmfVbQtGEM
   XpnIFtQbX38nFHdkq+hG+oTEQPVZk9Hs17CDN9/VCiGtxgRxF8+98gsMq9onn+DIyhINfX3zqrNn
   9sL/4EEJZqyLB7TkQ/rkIUJ3DCHKWanMZjZ96s9J3hGS9fryF1qEQjPIwP2DLrbskxvYg0lCrK+1
   JTT9wH5yXyrdE2ps6mdZwUBIp+X2eK7PAPXEHGfBWjXSazQVRDVvOFc1WEMD2J7wKBFfIobT3vGf
   NW23v0C5NmXzxGZ0fscpoxhPqg761ljUAAhQ4Q==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8I00G4YGG9JNC0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 04:00:09 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <9db2a983-361d-8e14-277c-e0c34740004e@linux.alibaba.com>
Date: Thu, 10 Mar 2022 11:59:40 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220309133020.1869-1-heming.zhao@suse.com>
In-reply-to: <20220309133020.1869-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=30
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 clxscore=254 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100019 domainage_hfrom=8365
Subject: Re: [Ocfs2-devel] [PATCH] fix kernel crash after mounting when dlm
	doesn't ready
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V6mwP7Q_1646884780;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: NAltN9ZlvbdejOIA8_W8wowAj4Yr933T
X-Proofpoint-GUID: NAltN9ZlvbdejOIA8_W8wowAj4Yr933T
Reporting-Meta:
 AAHXngj4FNz5uv2S6uTIZK/cLKQfkWcEZqF2N+EaXsABKDLPPLRPLMgL0A6vPi9e
 d3+nZ7M8QWwiQeZ39HvqTC4rnyawxhcHLWUxNHFyzJqM4ZPhJY1WVvp27DJkI1qP
 jI9KqMQYR5OhF78IKqANx9RuqmmtcbZDgbI+nf/ByOutQ3MuO4e7uZrChhoPxMiR
 L9zvHJau9rPQRijpv89IMDN/eKYd7M7peCVuI3v9SLmCze9D6AmyiV96SaBVWju+
 VYWTkHmd94ljEF07MpERDV40VTAU7v6SMe94M2UjG/nZEOABf1ypLOq8FrosmEfh
 ru+8bLkYJp0qA2mMUx6/wBh/xPPzVxK0CfEkdOhbjAq0Vydk97t8T1/8MHgLYc4l
 /+4Ceo+EoeYct8GB17NoW3vKjydGuYkzvC1zacJn2JoAhbg5jqFza1FzFvNj2c4/
 ID2+RMCesU+wXHs6EyQWLhBo6KSLexylv2dAWaEJkN8z/NIHbraALcTyp+wKXa4E
 ccU78czJgXvFEi4/sk45RJmH4vFPx9L25rsPtbKnbyfW+w==

It looks this issue is introduced by the following commit:
da5e7c87827e ocfs2: cleanup journal init and shutdown

Before that, journal was initialized in ocfs2_initialize_super().

On 3/9/22 9:30 PM, Heming Zhao wrote:
> How to trigger:
> 
>  tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>  tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>             --cluster-name=ocfstst
>             == there is no dlm running ==
>  tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>             == kernel crash ==
> 
> Crash log
> 
> ```
> kernel: DLM installed
> kernel: ocfs2: Registered cluster interface user
> kernel: dlm: no local IP address has been set
> kernel: dlm: cannot start dlm lowcomms -107
> kernel: (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
> kernel: (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
> kernel: (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
> kernel: BUG: kernel NULL pointer dereference, address: 0000000000000030
> kernel: #PF: supervisor read access in kernel mode
> kernel: #PF: error_code(0x0000) - not-present page
> kernel: PGD 0 P4D 0
> kernel: Oops: 0000 [#1] PREEMPT SMP NOPTI
> kernel: CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1 openSUSE Tumbleweed b40a195b7ff0f3399a616c3290f963c4ad189e84
> kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
> kernel: RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
> kernel: Code: 24 e8 9b 68 04 00 48 c7 c7 70 88 db c0 48 8b 80 98 03 00
> 00 48 8b 80 70 01 00 00 48 89 44 24 08 e8 3c 50 d8 d8 48 8b 44 24 08
> <48> 8b 48 30 49 39 4f c8 0f 88 ff 00 00 00 48 c>
> kernel: RSP: 0018:ffffbbf000847bf0 EFLAGS: 00010246
> kernel: RAX: 0000000000000000 RBX: ffff95f6834b8000 RCX: 0000000000000000
> kernel: RDX: 0000000000000001 RSI: ffff95f6a1fbcbe0 RDI: ffffffffc0db8870
> kernel: RBP: ffff95f6a1fbc6b8 R08: 00000ab5a9371b7a R09: 0000000000000230
> kernel: R10: ffffbbf000847bc0 R11: ffffffffc0d53ea0 R12: ffff95f6a1fbc560
> kernel: R13: ffff95f6a1fbc408 R14: ffff95f6834b8000 R15: ffff95f6a1fbc908
> kernel: FS:  00007f366f151740(0000) GS:ffff95f6fdc00000(0000) knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 0000000000000030 CR3: 0000000003fcc004 CR4: 0000000000370ef0
> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> kernel: Call Trace:
> kernel:  <TASK>
> kernel:  ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
> kernel:  evict+0xc0/0x1c0
> kernel:  ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
> kernel:  ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
> kernel:  ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
> kernel:  mount_bdev+0x182/0x1b0
> kernel:  ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
> kernel:  legacy_get_tree+0x24/0x40
> kernel:  vfs_get_tree+0x22/0xb0
> kernel:  path_mount+0x465/0xac0
> kernel:  __x64_sys_mount+0x103/0x140
> kernel:  do_syscall_64+0x59/0x80
> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
> kernel:  ? do_syscall_64+0x69/0x80
> kernel:  ? syscall_exit_to_user_mode+0x18/0x40
> kernel:  ? do_syscall_64+0x69/0x80
> kernel:  ? exc_page_fault+0x68/0x150
> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> ```
> 
> Analysis:
> 
> ocfs2_fill_super
>  ocfs2_mount_volume
>   ocfs2_dlm_init //failed, journal still doesn't be initized.
>    goto read_super_error
This is not a part of call trace, I don't think it is needed here.

>     ocfs2_dismount_volume
>      ocfs2_release_system_inodes
>       ...
>        evict
>         ...
>          ocfs2_clear_inode
>           ocfs2_checkpoint_inode
>            ocfs2_ci_fully_checkpointed
>             time_after(journal->j_trans_id, ci->ci_last_trans)
>              + journal is empty, crash!
> 

Suggest we use the following way to description this commit:
<call trace>
<reproducer>
<your analysis and how to fix>

BTW, as I mentioned at the first, a fixes tag should be mentioned here.
Could you also please check all possible use of journal during
ocfs2_dismount_volume()?

Thanks,
Joseph

> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c   | 3 ++-
>  fs/ocfs2/journal.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
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

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
