Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747754;
	b=mjNVFkXt5TzUN+4uBy80VUujDVKb4ZrtmgJEkkxyZiSRAVA02ftEyGthVM/BFGWR5eXH
	 E82+2dnTxqGh+BBeFugn0sW0UkV7ybRMVohKNSnshcKR2tUiKq3rg28zMFXKFTfwfFvvH
	 mwHnxRu2L3i2dVFTJh/I8C8uIuQOKCx2myB+qX91jEQ7E/Y6c1KlxondRfGEiLCKHRqUX
	 aBbOMDw5yYodW/04qSwKp0rYRdFJnTfjTs8wUT5jLHGK26p0+ccKuUQnp6OdnG4nL6AwR
	 Ul33K6tac1Gc26gocTphcZHq7DQVngTTuiQNjRSqoe4JSeoK2q+DYSQV1mSjdzU+Mrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747754;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+BsOQn9fI2fusV92JgJXST2g12Yg/yq3BHWZFI28LzQ=;
	b=lzMXYhADqVWVwstAI1W2JWotAcHagxO1GHbe1U11KomR551whtI8kPe+N4SXMAJL01zO
	 v8c2B0M36Hf/93QumeAWc9Zm8RHEGBeWrQu1OpcMnXhAA17aY79nalGiOX4nccGedbTPr
	 iwFRJETFmPjWqhgVHWCnpsVa85PIOUeS+KsHa5tNfB7tipspNPMJur4glnc/DCIz1zvD2
	 uASL9laUk8Ya1eyomqQBw0ldM6Dq1Ytn8me7z0WWnV0svsy58R5GdCUustjpbCnMdujbG
	 jNiP3RTqX4bMDKA00BD9F8QbT4G/V4rJB2xfRF6n1Fir2+GewAWPfBk0/4BenAVstLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sMVD2Vtd;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312C5606A33B
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 13:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 312C5606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sMVD2Vtd
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794747744; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+BsOQn9fI2fusV92JgJXST2g12Yg/yq3BHWZFI28LzQ=;
	b=sMVD2VtdGg1zjmwhXY8V+xsBqbMOv3nV/7HoZNpf1BkVrj5EGRxU3gYNcQAZoZoWyDjAYtMReiGA5GZ+S6Y/7C/fNhNF4PejOFTWI2AlaMXm5uC/LrSW4Pkxc28FohDkqcTRArcwFH5FUQt+GTt1b7sFyROJs1h9pPSIngk1CWs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XEjuDMt_1794747742;
Received: from 30.180.33.101(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEjuDMt_1794747742 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 15 Nov 2026 21:02:22 +0800
Message-ID: <d7c23cb6-5839-4b42-923e-1a1211cdcd41@linux.alibaba.com>
Date: Sun, 15 Nov 2026 21:02:22 +0800
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
Subject: Re: [PATCH] ocfs2: don't reuse SINGLE_DEPTH_NESTING for unpublished
 inode ip_alloc_sem
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+3f66416993279938e957@syzkaller.appspotmail.com
References: <20261115104656.210945-1-ngocthang2710.1999@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261115104656.210945-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/26 6:46 PM, Nguyen Ngoc Thang wrote:
> Commit c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate
> transactions") made ocfs2_xattr_set_handle() take ip_alloc_sem of a
> not-yet-published inode inside the create transaction, under subclass
> OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1, so lockdep records:
> 
>   sb_internal -> j_trans_barrier -> ip_alloc_sem/1
> 
> But subclass 1 is SINGLE_DEPTH_NESTING, which ocfs2_remap_file_range()
> already uses for the destination inode, and the remap then starts a
> transaction in ocfs2_duplicate_inline_data():
> 
>   ip_alloc_sem/1 -> sb_internal
> 
> Lockdep merges the two and reports a circular dependency.  It cannot
> deadlock, since the unpublished inode is unreachable by anyone else,
> but the warning hides real reports.
> 
> Give the unpublished subclass its own value past SINGLE_DEPTH_NESTING.
> 
> Fixes: c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate transactions")
> Reported-by: syzbot+3f66416993279938e957@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3f66416993279938e957
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

It takes no runtime effect. But the collision is real.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
 
> ---
> Tested in QEMU (x86_64, syzbot config with lockdep) using the syzbot C
> reproducer on top of 23c62304dde2:
>   - before: "possible circular locking dependency" after ~8s
>   - after:  no lockdep report in 3 x 180s runs, debug_locks stays 1;
>             /proc/lockdep shows both ip_alloc_sem/2 (create) and
>             ip_alloc_sem/1 (remap) exercised.
> 
>  fs/ocfs2/xattr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 71e5986bafaa..9f2d5797e4d6 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3867,10 +3867,11 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>   * ip_alloc_sem there adds a transaction -> ip_alloc_sem order that would
>   * form a lockdep cycle with the ip_alloc_sem -> transaction order used
>   * elsewhere, if not for this separate subclass.  The inode is unpublished
> - * so the acquisition can never contend.
> + * so the acquisition can never contend.  It must not collide with the
> + * SINGLE_DEPTH_NESTING subclass ocfs2_remap_file_range() uses.
>   */
>  enum {
> -	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1,
> +	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = SINGLE_DEPTH_NESTING + 1,
>  };
>  
>  /*

