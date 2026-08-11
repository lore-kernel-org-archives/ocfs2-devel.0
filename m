Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC6E3BAD9B
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431436; cv=none; b=jbvno3Qkd/IhI0Bg5pETj9XV3tr+Y83UByVa+WPQuCqVX7Gk5MdDdSGpRx+ABe3VKA6a+6D1cozb6K5ZFraje7wfySMYSFjcGa8bM3aGDJWp/gte8B+/dawzxSgTp2ODH/bvzbxM91k61AxbSwy3V6mUaebYldLgRrMOIlEEYLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431436; c=relaxed/simple;
	bh=k/LxVz0LmpND7hlsXVFeH24XJBqvIdBaXTbDcnohfUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCoiA5jyzbaXVYEzhiQI6n/pNqcJribUMyhVHM9x3Ecu/H/g0A9csPl04wXt9/r+RgbsAOaty/XXjOFzkyDRY8JkXqj0iJ6kaQyXAMRW6scKxZkQH3ZLUNjlxAz/fz1/xM0Km2GKw+eE/bEXGUE5lQmrlDG14dj70FZnM60LlkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R53p2jkt; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R53p2jkt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786431428; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GLjydHmq/L7vPEMLuzBxoHyb1ughObd8IWBHKNXCs8U=;
	b=R53p2jktAJEAeb2mne/h0GPCA5YQDu1SWiQFK2nRtN04rxYem/G+Jm/SmTJ8m8Hvd4/TvLTp7IWdLWmEIEvcmEHyuyVQEsOuVuh8961mamb47FEVDhIYnlkK67kpQSwSabemQdSK4sNKrIIa1ogY2qIK3iZFLn2qPg6YMz/ZEQg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X8nOSTo_1786431426;
Received: from 30.221.129.51(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8nOSTo_1786431426 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Aug 2026 14:57:07 +0800
Message-ID: <2927fd14-46be-4cb1-8dac-0f4249f16014@linux.alibaba.com>
Date: Tue, 11 Aug 2026 14:57:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate la_size before ocfs2_clear_local_alloc()
To: Dmitry Morgun <d.morgun@ispras.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20260810113508.8513-1-d.morgun@ispras.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260810113508.8513-1-d.morgun@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/10/26 7:35 PM, Dmitry Morgun wrote:
> la_size, like the dirty flag, is read from disk. If dirty != 0,
> ocfs2_begin_local_alloc_recovery() is always called, which
> immediately invokes ocfs2_clear_local_alloc(). At this point,
> ocfs2_clear_local_alloc() uses la_size as the loop bound without
> validating it first. If la_size is corrupted, the loop writes past
> the end of la_bitmap and may eventually start writing into memory
> that has already been freed.
> 
> BUG: KASAN: use-after-free in ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
> BUG: KASAN: use-after-free in ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
> CPU: 1 PID: 2386 Comm: syz.2.190 Not tainted 6.1.174-syzkaller-00520-g10c505401422 #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
>  ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
>  ocfs2_check_volume fs/ocfs2/super.c:2448 [inline]
>  ocfs2_mount_volume fs/ocfs2/super.c:1819 [inline]
>  ocfs2_fill_super+0x2033/0x3dc0 fs/ocfs2/super.c:1082
>  mount_bdev+0x356/0x410 fs/super.c:1443
>  legacy_get_tree+0x108/0x220 fs/fs_context.c:632
>  vfs_get_tree+0x8e/0x300 fs/super.c:1573
>  do_new_mount fs/namespace.c:3078 [inline]
>  path_mount+0x6af/0x1f70 fs/namespace.c:3408
>  do_mount fs/namespace.c:3421 [inline]
>  __do_sys_mount fs/namespace.c:3629 [inline]
>  __se_sys_mount fs/namespace.c:3606 [inline]
>  __x64_sys_mount+0x283/0x300 fs/namespace.c:3606
>  do_syscall_x64 arch/x86/entry/common.c:46 [inline]
>  do_syscall_64+0x35/0x80 fs/namespace.c:76
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> The validation of la_size currently exists only in
> ocfs2_load_local_alloc(), but that function is called after
> ocfs2_clear_local_alloc(). As a result, memory corruption occurs
> before the invalid value is detected and -EINVAL is returned.
> 
> Adding the same validation to ocfs2_begin_local_alloc_recovery()
> before calling ocfs2_clear_local_alloc() prevents the out-of-bounds
> write by failing the recovery early with -EINVAL.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: ccd979bdbce9 ("OCFS2: The Second Oracle Cluster Filesystem")
> Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
> ---
> A similar issue also exists in ocfs2_complete_local_alloc_recovery().
> The i_total and la_bm_off fields are also read from disk and used as
> loop bounds and offsets without prior validation. With a corrupted
> filesystem image, they could lead to similar out-of-bounds accesses
> during the completion of local alloc recovery. Therefore, a more
> complete solution would be to introduce a shared validation helper
> for all relevant on-disk local alloc fields (la_size, i_total,
> la_bm_off, and others) and invoke it before starting the recovery
> process.
> 
> This patch fixes only the reported reproducer, triggered 
> by an invalid la_size. Other fields like i_total and la_bm_off are
> still unvalidated, so a similarly corrupted image could trigger 
> an analogous bug elsewhere. Maintainers' input would be welcome 
> on whether a shared validation helper is preferred over targeted 
> per-field fixes.
> 

I think we can validate localalloc inode during block read in
ocfs2_validate_inode_block(), which will drop the duplicate code in
callers.

BTW, it seems you post it into a wrong maillist. Please use
ocfs2-devel@lists.linux.dev instead.

Thanks,
Joseph

>  fs/ocfs2/localalloc.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c4426d12a..ce03903ed 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -481,6 +481,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
>  	struct buffer_head *alloc_bh = NULL;
>  	struct inode *inode = NULL;
>  	struct ocfs2_dinode *alloc;
> +	struct ocfs2_local_alloc *la;
>  
>  	trace_ocfs2_begin_local_alloc_recovery(slot_num);
>  
> @@ -512,6 +513,16 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
>  	memcpy((*alloc_copy), alloc_bh->b_data, alloc_bh->b_size);
>  
>  	alloc = (struct ocfs2_dinode *) alloc_bh->b_data;
> +	la = OCFS2_LOCAL_ALLOC(alloc);
> +
> +	if ((la->la_size == 0) ||
> +		(le16_to_cpu(la->la_size) > ocfs2_local_alloc_size(inode->i_sb))) {
> +		mlog(ML_ERROR, "Local alloc size is invalid (la_size = %u)\n",
> +			le16_to_cpu(la->la_size));
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>  	ocfs2_clear_local_alloc(alloc);
>  
>  	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);

