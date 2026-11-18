Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794983040;
	b=lCydQ1GbwIoTSAXGwLWqkW2vnlAiKCVD8ZZQQ8e8NCde4C7or5PFQ6a27h7V2DnZMGVj
	 TAse5B8brg3lL46HOcwoQTBFHgjDJYRGHK+C5naAPCKE1FjQaBDSbsdZ82PnCDsachgXw
	 ZgevyfJrJ9awE4bZtNiUPcWK+QClXty9QF7LL5kIoTSjy+TN+1SGNhjbnM6NEIbiH6Wzk
	 QfGxdFWINB5ETKBePPNH4VcR4hg9GHmT7949dba3xQHmHLc0Dno4j1FdVHVz1MrBQ8GJA
	 ARrTbuya4xCYcNCz/Ex9yPTF0YO2bFpCdGG1mSax9VTMP0glGBdM0TU6k9Y8fnARuUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794983040;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=IGY+5XCwYgg/jBBfd01p4Gr0FmcJavl3l4itexscQ/Y=;
	b=sHNTKQPyFBBnPP4m4K9IZCKbKo1fHWshuN/7wZCkkLBfqpfHOlo75qi+q+mJILMEPuIV
	 rmkjYpX+fDwgasCFH/KHyLtS797VTH+FeKr1iwAaztPLzSQqgyzQ4E3R4JcVD9BaG0RUQ
	 5WcSXyPwAxJ+BWRbLP1FArwM82HK9Ef6+wIpY2iDwwWI5ksdq3t4KbPrfAJ5ifvMwg48H
	 AGt+YLTjvVdsn3EDomyBNA40gF1Ruwf77JKi8RB9+cOXPlgHQxyovKvlUsAA4klX/LFFU
	 nhLOtYoBzXvhjy35OYfVloY9xIUzio1V+cKmc8dKeLTJ5vorwCYrMRrGFmZ+hbssnBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZaggvPi7;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEE4606A31C
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Nov 2026 06:23:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EEE4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZaggvPi7
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794983036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IGY+5XCwYgg/jBBfd01p4Gr0FmcJavl3l4itexscQ/Y=;
	b=ZaggvPi7n4dVzCRN0GMr4W+KYn6nMJnzK7pVH+u2KvY8WYw+hhiiAkzkhJKmhErBsVtmS95Vm6YfxSyC2s/4pfCwrCnZW9NetRrtdCq2HSCgRaCkwMahS9F9uw3nBAEtLE8dTQ6fovhSXUwr9aO5bFelZ8KGKJeAPu/9h/p93io=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XF.iXnn_1794983035;
Received: from 30.221.151.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XF.iXnn_1794983035 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 14:23:55 +0800
Message-ID: <f983496a-7948-46d2-882a-8eed79727805@linux.alibaba.com>
Date: Wed, 18 Nov 2026 14:23:53 +0800
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
Subject: Re: [PATCH] ocfs2: fix local_alloc_bh leak in
 ocfs2_shutdown_local_alloc()
To: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261117145830.59864-1-zhiyuanzhang912@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261117145830.59864-1-zhiyuanzhang912@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/17/26 10:58 PM, Zhiyuan Zhang wrote:
> From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
> 
> ocfs2_shutdown_local_alloc() owns the buffer_head reference stored in
> osb->local_alloc_bh, but only its success path drops it: after clearing
> and journalling the local alloc inode it calls brelse() and clears the
> pointer.  Every error exit after the local allocator has been enabled
> returns with the reference still held:
> 
>   - failure to look up the local alloc or global bitmap system inode
>   - ocfs2_inode_lock() failure on the global bitmap
>   - ocfs2_start_trans() failure, e.g. on an aborted journal
>   - kmemdup() of the local alloc dinode returning NULL
>   - ocfs2_journal_access_di() failure
> 
> Nothing else releases it, so the buffer_head and its page stay pinned
> after the unmount.
> 
> Drop the reference at the common out: label and clear the pointer
> there.  The success path has already set osb->local_alloc_bh to NULL
> before it reaches out:, so nothing is released twice.  The reservation
> path is not affected: it takes its own reference with get_bh() and
> drops it in ocfs2_free_ac_resource().  Also mark the local allocator
> unused when the buffer is dropped, so that a NULL local_alloc_bh is
> never left behind with the allocator still marked as in use.
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: Claude:claude-fable-5-2
> Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> 
> Notes:
>     Testing: QEMU (x86_64), local mount on a loop device, kernel built with
>     KASAN, PROVE_LOCKING, DEBUG_ATOMIC_SLEEP, DEBUG_VM and DEBUG_LIST.  A
>     test-only pr_info() printed the pfn and b_count of local_alloc_bh on
>     entry and exit of ocfs2_shutdown_local_alloc(), and the page was looked
>     up in /proc/kpageflags after umount, losetup -d and drop_caches.
>     
>     All six error exits were exercised, twice per boot, two boots per
>     kernel.  The ocfs2_start_trans() failure is the real one: the loop
>     device is shrunk under the mounted filesystem so that jbd2 aborts the
>     journal.  The other five were forced with a test-only knob.
>     
>      - Unpatched, 24 of 24: the function returns with b_count still 1, and
>        the page is still allocated at the end of the run.
>      - Patched, 24 of 24: the reference is dropped and the page is free.
>      - A clean unmount frees the page on both kernels (8 of 8).
>      - No KASAN, lockdep or other warnings on either kernel.
>     
>     The leak is one page per failed shutdown.  kmemleak does not report it,
>     and neither Buffers in /proc/meminfo nor the buffer_head slab count
>     shows it.
>     
>     AI assistants were used to find the leak, to write the patch and the
>     changelog, and to run the tests above.
> 
>  fs/ocfs2/localalloc.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 82d290cf4432..d8d81cef92fc 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -462,6 +462,17 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	iput(main_bm_inode);
>  
>  out:
> +	/*
> +	 * The success path has already dropped the reference and cleared
> +	 * the pointer, so this is a no-op there.  Every error exit after
> +	 * the local allocator was enabled used to leak local_alloc_bh.
> +	 */
> +	if (osb->local_alloc_bh) {
> +		brelse(osb->local_alloc_bh);
> +		osb->local_alloc_bh = NULL;
> +		osb->local_alloc_state = OCFS2_LA_UNUSED;
> +	}
> +
>  	iput(local_alloc_inode);
>  
>  	kfree(alloc_copy);
> 
> base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4

