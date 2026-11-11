Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386887;
	b=dOs9bIazQF8VLErKM7RW/zAgkA3/gpmqXSYFqRExeOp9GrX0+CCUglnEeGua0IQgYC0g
	 LYkMvKGHpT9kU2RWdO6DVcmMEZAzA2TScdULx+gp7k/v/Q8MtkdYqz9kJmhdpt5Inh6q1
	 rbQ5WA7s/NDYawtk5B+5XO+2yKo8xO3hFJX9RZyGUwvwhtMpJjx2mUbU8/19/nKzGE4s7
	 V5QoZviFU2eUfGvUuSJBRmeI01y2sDE2dIuk0vVbp0chUIq+ZSZIk1IHYGwAPASynZIxT
	 qWBIFNgh1ypKCNCAs1jA5kIvGBGBXjlsA+dsTc0hdnSmKbQmp5H6hfqcgqbqudAzYgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386887;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=blmHauaC7Hp6K+IDvLelJ5eVBYGSa7O3m7psBls7pXc=;
	b=EgdJpl8iN8jF5VfxVbdKO+77SjohxAnVN+nF7c6MoVNkKFQ5y0OqGPzUsGZ1C4YgeSNG
	 TTIT7FwWJ0PpGaBR8TZJCtyG/PGcx495BFhj5qJ0l6R80nsQtKLUpk9JVHaQuAIQCaYe5
	 RiSq+mW+GpP5XaEeN87M+HeB7nwKnolFjp7WpLmeEETFznV6pWmM9XnLpEaQ/BR2ROxvR
	 eLYURtsy61a8h0fMHR/H1PZP/26Pa2dvd5aj/gzME+pfJPp3hiOoMo3o2lqDfkeZImLoG
	 Hj0t/Z8THpmf+lh1RQn3pZoJBWVexx7p8Tpp0zCCVxhktzZ0s0IXSTHsmSpaAvOVIWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IRG2qH6N;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497D1606A31C
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Nov 2026 08:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 497D1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IRG2qH6N
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794386883; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=blmHauaC7Hp6K+IDvLelJ5eVBYGSa7O3m7psBls7pXc=;
	b=IRG2qH6NuF4wrTdTMO74+/aLOmfegp2GFLzyNPOXkzgqqoh03wKIhBWPrzgGf6MHVAdfcERuv+quPYBTiX6wlwJoNGL/ATC5s6ufXx4TzYt74dWdRsBCZRT7AzUro8PjuyHJ8TS/yYwF03LpWKlxIlOkckBeRT5t4d9EHN9Ypbo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XEYJjsU_1794386881;
Received: from 30.221.145.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEYJjsU_1794386881 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 16:48:01 +0800
Message-ID: <4c1bb9c0-547f-4994-958c-f59ec8b754d2@linux.alibaba.com>
Date: Wed, 11 Nov 2026 16:48:00 +0800
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
Subject: Re: [PATCH] ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when
 write_end fails
To: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 yangwenfang <vicky.yangwenfang@huawei.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+42984127d45ad96219de@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261111023444.22688-1-zhiyuanzhang912@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261111023444.22688-1-zhiyuanzhang912@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/11/26 10:34 AM, Zhiyuan Zhang wrote:
> From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
> 
> syzbot reported a kernel BUG in the ocfs2 write fault path:
> 
>   (syz.0.17,5578,0):ocfs2_write_end_nolock:1945 ERROR: status = -30
>   kernel BUG at fs/ocfs2/mmap.c:106!
>   Call Trace:
>    do_page_mkwrite+0x147/0x310 mm/memory.c:3879
>    do_shared_fault mm/memory.c:6145 [inline]
>    handle_mm_fault+0x1a53/0x3750 mm/memory.c:6943
> 
> __ocfs2_page_mkwrite() calls ocfs2_write_begin_nolock() and then
> ocfs2_write_end_nolock(), and uses BUG_ON() to assert that the latter
> returns the full length.  But ocfs2_write_end_nolock() can fail: since
> commit 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before
> ocfs2_journal_dirty() in ocfs2_write_end_nolock()") it gets journal
> access to the inode buffer again, because the handle may have been
> restarted since ocfs2_write_begin_nolock().  That fails with -EROFS or
> -EIO once the journal has been aborted or jbd2 has seen write errors
> on the device.  The syzbot reproducer gets there by shrinking the
> backing loop device to zero with LOOP_SET_STATUS while writing to a
> shared file mapping.
> 
> Handle the failure instead of crashing.  ocfs2_write_end_nolock()
> leaves the mmap folio locked, because ocfs2_unlock_folios() skips it
> when w_target_locked is set so that it can be returned with
> VM_FAULT_LOCKED, and do_page_mkwrite() does not unlock it either when
> ->page_mkwrite() returns an error.  So unlock it and fail the fault;
> the faulting task gets SIGBUS, like for the other errors in this
> function.
> 
> For an mmap write ocfs2_write_end_nolock() returns either len or a
> negative errno: inline data has already been converted to extents by
> ocfs2_write_begin_nolock(), and copied is equal to len.
> 
> The BUG matters for local mounts, where the filesystem is expected to
> go read-only and keep running after a journal abort.  On clustered
> mounts ocfs2_abort() panics the node anyway as soon as it notices the
> aborted journal.
> 
> Fixes: 7f27ec978b0e ("ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()")
> Reported-by: syzbot+42984127d45ad96219de@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=42984127d45ad96219de
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-fable-5-2
> Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> 
> Notes:
>     Testing: syzbot C reproducer in QEMU (x86_64) on a defconfig-based
>     kernel with KASAN, lockdep, DEBUG_VM and hung task detection enabled
>     (not syzbot's own config).
>     
>      - Unpatched: BUG in 3 of 3 runs, within 22 iterations.
>      - Patched: 437 iterations over 3 runs hit the failing write_end 21
>        times (11 x -EROFS, 10 x -EIO), all ending in SIGBUS, with no BUG,
>        KASAN, lockdep, DEBUG_VM or hung task report.
>      - Negative control: without the folio_unlock(), inode eviction hangs
>        on the locked folio in truncate_inode_pages_range() in 3 of 3 runs
>        that hit the error.
>     
>     Not tested on a clustered mount.
>     
>     AI assistants were used to analyse the report, to write the patch
>     and the changelog, and to run the tests above.
>     
>     ocfs2_dio_wr_get_block() has the same BUG_ON(ret != len).  It is left
>     alone here because the pending "migrates ocfs2 DIO from buffer_head to
>     iomap" series removes that function.
> 
>  fs/ocfs2/mmap.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 6c570157caf1..1c03f45e8965 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -103,7 +103,17 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>  		goto out;
>  	}
>  	err = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
> -	BUG_ON(err != len);
> +	if (err != len) {
> +		/*
> +		 * ocfs2_write_end_nolock() keeps the mmap folio locked so
> +		 * that it can be returned to the VM with VM_FAULT_LOCKED.
> +		 * On failure nobody else will unlock it, so do it here.
> +		 */
> +		folio_unlock(locked_folio);
> +		mlog_errno(err);
> +		ret = vmf_error(err);
> +		goto out;
> +	}
>  	ret = VM_FAULT_LOCKED;
>  out:
>  	return ret;
> 
> base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620

