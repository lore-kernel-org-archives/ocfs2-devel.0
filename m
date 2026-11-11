Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794384806;
	b=LJfqoCH8v+n1Cy8ZAG157NrVPWl4D4ZJdOOcvA5x+9BQltNgupFWKJDsjoZZE0NqE9TW
	 wcirKmTI3W3TBaak6nJaoFOFtPylJPwVee4Bm5Af41diTnd+nSmO6Ebtb8ZyRnoWK8LPQ
	 ZNrHdmL6rs8nHTx29jrrecZXEI6TJsyiEXxFg/WNwpoUE0MudBXdhU/u6JXVUq0c3I7h3
	 Th7cjs6J6YoKDnIYVwXilqOIKswmJN2qYfVDh0lGvPAMv6k8TWYdDdnl4aEO4XCY4MIeZ
	 7LvmIZMpH+91idWLYQxcwxuYE9wjQwz9NvnFIPHnC/MGdYhVORxtHFgqdIOAtGiLKKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794384806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=DgQI3xxkFFA7BhKNt2RfO4arKL4tKgGT+HlK8U19YZw=;
	b=QRdJcA1x0aTWdi9zP6RJUJcTa1tWGfNaz94Nx2ZiUz+3NBnjBRCoypeviFTlxwUNUyrX
	 XrE+a1UUMNu3tEZlZmIS4+k2RRjBJ6LOLqI1Bj35VFh/eoJqTYcvatevcTsW+9OJkDkbI
	 8QiP/y/u9dUJEvGuoTOpeAFjZB0E9YeRWcRfN7M08GdEAdD24ZfRYSu5L4580flb2foKX
	 e9cwW9aOIUQXM04Xk4gAIssy0i3kmNB+juRftNdQhqL+Awuf2HV+GgXHjHjGDunSUlved
	 Y7k1BwbbLhFUX67ELm/xfbNsx1bekoo0GGbso5ImtZvyZU9mhf4W7b0NcyBwW7xgcsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Br2DpUVj;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B9606A334
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Nov 2026 08:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 360B9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Br2DpUVj
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b5853f3d8bso67028a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 11 Nov 2026 00:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794384804; x=1794989604; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DgQI3xxkFFA7BhKNt2RfO4arKL4tKgGT+HlK8U19YZw=;
        b=Br2DpUVjdg2NIGXpZW0UmBRpX0M5J0lpCMSUYyR9pzZ8ApOyvzpQpsGCScBfPoqu2I
         xsGxFO1PzQRsn7OduypC4+dafIPM+Dvo9Kw9qXo00Zd7sKXhGpgNvnR/7GX9mMGEAGz2
         2Okv8083UJldAmtCd1VZ7pitwZbn2VoX7HSv7GHxYwS/dGp3zm1BQGapwkle2s3G5yP2
         xMybrGh93zi5kuhKx6ccDcQLvYHA5kbXnUNzuS10dZ8SwbWAWZPKaOHVHhBAa21wqzA5
         5LPAfRNCxNmb9lol5aFDA55OHUbdFgbhKVSdJr9kQUq19NcnDj5RPitTY224WehgyMqK
         GNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794384804; x=1794989604;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DgQI3xxkFFA7BhKNt2RfO4arKL4tKgGT+HlK8U19YZw=;
        b=PcFwg+9hpsJ8h2d2xJAMUB9aobJAsKan5V4N9KdtNQ2PiEa23FLCFV0UH/bupwLYhc
         uubyAWwvLWleR4CNSK2DmZ1MeQUQieOGNT9VWZHfC3VsXFxzJzV0h1zQ6zJo0CgL0ptI
         /5oTMkkiQN0XjkiYreexm0iK/RtrRHJ+Q8ryrvgtrEYjhDiGj8oD5WH6P5A1wJKST/78
         dkQVlz+3hcrJ+uKSkQRYjAf9fEuvE7esGaUEhAdfELdjhLYJ4X68GeP4r7IkPR54PFXS
         SS/wAb68GJ/sOJkY0iQAaoRMurIv1b+fghq6X9F051pfLDFYFkw/N1FzJeHjnSWo+5yM
         mnxQ==
X-Forwarded-Encrypted: i=1; AL+hErFpwy97lZS85/qtCSPnDTpuCiqJ533B1Tb+pa/6XgAeNqczpdLgHk2mWTbMKSfAJP4RUr6GCegnoFEUmw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/h5vtKEXyMCjySu7Ue6LIIP4ExhfSuZwHX2nkGabGN/3E1wFsv
	dPRW6WiI+JGzMu9jFA5ODcSW1A7R5YjOaNN/k4KeEGl7BOG5+b5li6EEXfQkddbx1gs=
X-Gm-Gg: AYBFou00nPwsY0+DuGe+jl3CYGjWYoG8ztYCBNlTpYCkuJ740t1QGfrIyf5pdt4eP5S
	dgBOx/9jegxlXEzJfuI5ODknmA52IRm/K+rkk5i/OGEo6XDD1dCO8MZPenNlp8uRcsw3d3rUPaG
	d7cH/OFnJ1gMnA1mkhY7Y7+TnD6kAJbM14lozjf/mVboDHPpAGaGkrNauBNQPuOLkFbCLFyEYqY
	ndG9GDDY1c6/nDfQcsESxBD4xYbzrxDujqaRLFebYreqKCdJGyCqE6BTdzrYsgBfN1Q0QJlrYwK
	Q2TL9sgeVAjhka66ykfWyX9Zd3bM+bAwZ43YUWe+8u1BatU6H5zSpMSkihOPi7GOsEQMAN1CZe3
	s58r3pz57WCmflsqkIvtHV5smraDc8EeyfTYbboWbmuLAWF/ZW9Ab+ExNPyF1/wdiS9uYRlFg/b
	abK2pq7iekZ92uDg1BSC2q8pxuc7t6CFHi3w1jO/L64fvOdAsaxPBFapGGixl7OvIitcrVlWXbG
	WTmsp57Ip/irGTrPUB8UEO6TZ56+CmCyhdmOSXTAxsztEIL6S+lyG3CGQQTyr0cVc3eO1bGpMD5
	VUbgvBGxqbuWG/2/0dW76LQF2A/kDMMOpYo=
X-Received: by 2002:a17:906:3ce2:b0:c4d:1768:48eb with SMTP id a640c23a62f3a-c5066ae6ba4mr117518566b.2.1794384804465;
        Wed, 11 Nov 2026 00:13:24 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa1b27cdsm1775739b3a.19.2026.11.11.00.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 00:13:23 -0800 (PST)
Message-ID: <a5576744-0984-462f-8f85-aa71151b277c@suse.com>
Date: Wed, 11 Nov 2026 16:13:19 +0800
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
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 yangwenfang <vicky.yangwenfang@huawei.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+42984127d45ad96219de@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261111023444.22688-1-zhiyuanzhang912@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261111023444.22688-1-zhiyuanzhang912@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/26 10:34, Zhiyuan Zhang wrote:
> From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
> 
> syzbot reported a kernel BUG in the ocfs2 write fault path:
> 
>    (syz.0.17,5578,0):ocfs2_write_end_nolock:1945 ERROR: status = -30
>    kernel BUG at fs/ocfs2/mmap.c:106!
>    Call Trace:
>     do_page_mkwrite+0x147/0x310 mm/memory.c:3879
>     do_shared_fault mm/memory.c:6145 [inline]
>     handle_mm_fault+0x1a53/0x3750 mm/memory.c:6943
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

looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> 
> Notes:
>      Testing: syzbot C reproducer in QEMU (x86_64) on a defconfig-based
>      kernel with KASAN, lockdep, DEBUG_VM and hung task detection enabled
>      (not syzbot's own config).
>      
>       - Unpatched: BUG in 3 of 3 runs, within 22 iterations.
>       - Patched: 437 iterations over 3 runs hit the failing write_end 21
>         times (11 x -EROFS, 10 x -EIO), all ending in SIGBUS, with no BUG,
>         KASAN, lockdep, DEBUG_VM or hung task report.
>       - Negative control: without the folio_unlock(), inode eviction hangs
>         on the locked folio in truncate_inode_pages_range() in 3 of 3 runs
>         that hit the error.
>      
>      Not tested on a clustered mount.
>      
>      AI assistants were used to analyse the report, to write the patch
>      and the changelog, and to run the tests above.
>      
>      ocfs2_dio_wr_get_block() has the same BUG_ON(ret != len).  It is left
>      alone here because the pending "migrates ocfs2 DIO from buffer_head to
>      iomap" series removes that function.
> 
>   fs/ocfs2/mmap.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 6c570157caf1..1c03f45e8965 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -103,7 +103,17 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
>   		goto out;
>   	}
>   	err = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
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
>   	ret = VM_FAULT_LOCKED;
>   out:
>   	return ret;
> 
> base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620

