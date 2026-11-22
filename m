Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795360640;
	b=ylBZcZInOft/YT5+4g0vEtj9IYHOJVUMsH8SCZwSVFYvxnf1Tx4ezqyUCJkwc573dMCZ
	 2wbRnRyUcclBRLiZrm+FwNQakZ52HXyC7dIZp9CNfCSw7tOTWZfrRGYemJAz3N0EnuNWB
	 rKdb+tRDz3X1/4wMGwRzSyz7CAzNcpj9dvKoTJVShiZxdspy0RiCznbNg0hGvY2TM6OVs
	 OTQws9Bxlj4QkyVe4lOkeCXPYhB2pN0ZuSlCvOFkoTMG763Jt2g0JKzg6hddfElW0EkHo
	 uk6WsyZUy+KYQg48WL/ag2I6Q77LWUKREIuTsvUmV6SLilMmO00bF1WK9vGcluQGpbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795360640;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fX9h706B7/+t7/LH/7aJa998HS7DuS5ua8wjwXfrMCA=;
	b=Md7H+Icn8TMttl5PfyvswZD4hHcvIi90OC5ESh/7r0FlPeiUAHeLiaY3612u/NZUSkg3
	 ZKZn/eiFQGMr3qSLOTT8zg90W8qqB8tD3j0re/yrFERWCHma7Vwtz/Xua8MvxETtoEhdv
	 J0knPZfhKvq/ZsBfmS1Ydk0VY4uqbB+VuUt1KmmYQz6mtdyfPrOGcE+q/qXmOCwD4kP64
	 F8iKpz+f0maX7rPvNcGgbKKt6Y3kBaYcHIkT9ZkvrEYvx15SpRE7QGMsyJeqIBSP3MTQq
	 JVk9wzEB5RUI03GOokHzZDFMFeSTI70xazHe4BwPTx3Zjt3VxbwfjS4lCNazl+5wfUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aQP4KMvw;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EF1606A330
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 15:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90EF1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aQP4KMvw
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795360633; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fX9h706B7/+t7/LH/7aJa998HS7DuS5ua8wjwXfrMCA=;
	b=aQP4KMvwj5Hn0D9spgkGKjQGG9aQxhk/PCtv1JM9UV6NqV3/NV9IkrTTJTwuDUHl4YUgNAeMi7WPVRcZJGuBERcnVhiqnugTF4Eq9PCPMT9SL2fIXNGBeAXcF3GAkiHTwW9dmxmlELNtCLGLGXmLSUlo9bY3NHNb8TuVmHdR6y4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XFB6iLJ_1795360631;
Received: from 30.180.33.101(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFB6iLJ_1795360631 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 22 Nov 2026 23:17:12 +0800
Message-ID: <86f614dd-c9ee-4bf2-acb8-0ea8b3b5cb45@linux.alibaba.com>
Date: Sun, 22 Nov 2026 23:17:10 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: drain fs_state readers before journal teardown
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/21/26 3:51 PM, Cen Zhang wrote:
> The fs_state debugfs open callback builds a snapshot from mount state,
> including the journal and cluster connection. The file is published
> before ocfs2_mount_volume() and removed after journal and DLM shutdown,
> so an open can overlap teardown on unmount or mount failure.
> 
> Publish fs_state at the successful end of ocfs2_fill_super(), after the
> last fallible mount step. Remove it in ocfs2_put_super() before calling
> ocfs2_dismount_volume(). Debugfs removal excludes new opens and drains
> active callbacks. The release callback only frees the per-open snapshot.
> 
> KASAN reported:
> 
>     BUG: KASAN: slab-use-after-free in ocfs2_osb_debug_open+0x967/0x15e0
>     Read of size 4 at addr ffff888116a56028 by task cat/502
>     ...
>     Freed by task 504:
>      kfree+0x308/0x580
>      ocfs2_journal_shutdown+0x10a/0xc20
>      ocfs2_dismount_volume+0x315/0x940
> 
> Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v3:
> - Create fs_state at the successful end of ocfs2_fill_super() so failed
>   mounts never publish it.
> - Remove fs_state in ocfs2_put_super() before volume teardown so creation
>   and removal are paired at the superblock level (Joseph Qi).
> 
> Changes in v2:
> - Address the osb dereference before BUG_ON(!osb) raised by Sashiko:
>   https://sashiko.dev/#/patchset/98583
> - Remove fs_state after BUG_ON(!osb) in ocfs2_dismount_volume().
> - Trim the KASAN report.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0003-v6-2f69dbb7417fcd537be6@gmail.com
> Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0003-v7-1522d068e5b943786c3e@gmail.com
> 
> This patch was written with assistance from Codex (OpenAI).
> 
>  fs/ocfs2/super.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0af2245ae303..2a58d3cd9690 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1072,9 +1072,6 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
>  						 ocfs2_debugfs_root);
>  
> -	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
> -			    osb, &ocfs2_osb_debug_fops);
> -
>  	if (ocfs2_meta_ecc(osb)) {
>  		ocfs2_initialize_journal_triggers(sb, osb->s_journal_triggers);
>  		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
> @@ -1158,6 +1155,10 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  	/* Start this when the mount is almost sure of being successful */
>  	ocfs2_orphan_scan_start(osb);
>  
> +	/* Publish fs_state only after all fallible mount steps. */
> +	debugfs_create_file("fs_state", 0400, osb->osb_debug_root,
> +			    osb, &ocfs2_osb_debug_fops);
> +
>  	return status;
>  
>  out_dismount:
> @@ -1555,8 +1556,13 @@ static void __exit ocfs2_exit(void)
>  
>  static void ocfs2_put_super(struct super_block *sb)
>  {
> +	struct ocfs2_super *osb = OCFS2_SB(sb);
> +
>  	trace_ocfs2_put_super(sb);
>  
> +	/* Drain fs_state opens before releasing their backing state. */
> +	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
> +
>  	ocfs2_sync_blockdev(sb);
>  	ocfs2_dismount_volume(sb, 0);
>  }

