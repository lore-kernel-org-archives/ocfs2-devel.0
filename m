Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2361B36F419
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 07:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791617907; cv=none; b=MW/Yysl46dPP52zMmR/iAoEXDUo2HzF0MFy1z/DM8A5EaCaRYSxV7dTjl5kcHK5B+0HSUDThuY+6OG18LdwYlI5kfEqZkKz9j3k8dpJ/7wrGiOyb5h+H3g8XjMqvV3hbNFnwbVjnBsOBzycs/7VHpAMnPWv5UoO3PtvK/KH54A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791617907; c=relaxed/simple;
	bh=HrNtqZGMJwHAHK27VJ1CwFKK7rixvgcxmfh56RdnLq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H06WqjaPIj683WsybfAAC1Us5BUMAsG4TeK7J7nbdiPe+Lj1HkcE0ohksGjBQjzTqMOOnZemZU0jhEkdmmR8Xh14gtw9iFTkT4nANNRtPrEzt1dIpuqjbm2rWl1gBZKBNHauR+0EwEpSRXkYJyLKHWDuuI3MlOft3KydRc18H8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T1asUT1A; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T1asUT1A"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1819024e9so474965e9.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 00:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791617904; x=1792222704; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=icy62ZS1ngYq12CKSGVk1ttF9vUahbM+7mKp/fS2KJ4=;
        b=T1asUT1AOQHZFBHRQSeF5KUUyAJ2IoOaQOKeyqC98Bohh+3Rt02dpV6DtqQSWXvWTP
         ayDkK/oLAe2Zm8qrl1LgtQE/Pn9vY5yKIyomzjtt7wPqLYJhsuVs8PyEbRvlrdZpf4Yu
         dfvFDFhGFay4/VuZiiSZT8XRCawlBJvjbCQkChQtWIGSGRius/0IxKXseLIIOfqE/mXq
         HmAPItvUipdU7zM2rYEUUxn7Htsook7dCBuOR7k9+hO6eFvOkGQFEf7P2nV0AvSL//oF
         eSxTPnyagJusB4lp/Pe5g54owSzOpRqOEv0IT4Ynwsj41CLUNneqfUQ40QZVFE3uYXj4
         BhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791617904; x=1792222704;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=icy62ZS1ngYq12CKSGVk1ttF9vUahbM+7mKp/fS2KJ4=;
        b=E1FYi3BRguEDgXP/pqxd2uCEXinUdeBRaUXB0AieuZOp38VmoNmxW/VcNhK8B6kXuP
         J+5K4bq59AKeyswlMzcdbgZYPS1C+UpMG5VGAQI45VNaI3XsXTtWpQwh3OzyMVsH4LyK
         ZFRfdWZTKlc/TFcsU0xIEcgIMkLgaKkvIKGAn2OU2vOnUfrDa1ca7I413h7x2HvOsW6D
         R0uWeQ5VuCmerB0ljsAxdsPzowyL5jTvxX2ItMvwV2blQfngVWupBjUbyI5uBmVO+qGB
         G+vlLs5taKZX1FHq4sljPmZoLDkjJa9sqxtA2ygTjJxRxtUgJJL0C21WINHArT6kYKtB
         lesw==
X-Forwarded-Encrypted: i=1; AKwUvBwK8S15Bu1wzbZuaaGAA93YG1wlJitL1nwBHVnGbfPxeSxd8VF4kcUptcMev3qK1L9qfluspW//lAOKdg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJLNo6LuS7NWmb+i7ywWsmqi+KZWzsd7DInXlJ3SS1EzDsa10ju
	6sw4RbYlpG3noSStzZP8KUY5/Z5HcfbUU8VV+UK9uD5YY3HEZdIbftXZue/hAFln6ik=
X-Gm-Gg: AYBFou0bqHQnSE2UatDaxwfKFvLDyc3cFHxcWmvK70czlJGr4Ey+phNuc6uFszGN+W2
	IEZDWr0GHk2SKLowjqDwRjKGeXKrxOlQ8iOf+BSPXx3MGXxImbLJzkgAhbhDjT41nkuf3N2NQSo
	222i3rCttTa/orMlXx3rXm9ZQcgJf0FsAVfGXCsuMFEa1juRWhGok9+XdxWeU1bY1K9Dso3mIqs
	uxjj20sM+5LvGAECgfcsL1k99fqD4oqgjpuu8oNtWapwk1Nu+r8XeztaTdrbaa6XN9C1mDYV6gD
	cVd8FLdWvBA2p7yyaQCdC/0B4ZxH25SSgnuiaCMRCZDcll0moCVZIJxRsCOQS++SKstACNavOXD
	PaX0x7nupr3kPNP43IDXOxV7JsyKPshu525WCyMTFxKQphFQq6MLDSvZHSgzbbQrNQXIcevLcWi
	YSXjTIayAdaIahlOpQMb5yQKCHu5iMz8vB1xdkc7GEwHKxK3gc8WUHs8NzzSEwTX/SjA12mqIz6
	Bl+CkY=
X-Received: by 2002:a05:600c:1e0f:b0:4a1:8469:e6c8 with SMTP id 5b1f17b1804b1-4a18e46f48fmr76946365e9.1.1791617904172;
        Sat, 10 Oct 2026 00:38:24 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab50ce9d98sm5322288a91.9.2026.10.10.00.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 00:38:22 -0700 (PDT)
Date: Sat, 10 Oct 2026 15:38:18 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	akpm@linux-foundation.org, ghe@suse.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Subject: Re: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs
 attributes
Message-ID: <asnqJTe50D-EuhTb@p15>
References: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>

On Fri, Oct 09, 2026 at 06:04:49PM +0800, Cen Zhang wrote:
> ocfs2_filecheck_create_sysfs() initializes the filecheck allocation
> before calling kobject_init_and_add(), but assigns entry->fs_fcheck
> only after that call returns. The default attribute group can already
> be visible while registration is in progress. A concurrent read can
> therefore enter ocfs2_filecheck_attr_show() with a NULL fs_fcheck and
> try to lock its fc_lock.
> 
> Assign the initialized owner before adding the kobject, so every
> activated attribute has valid state. Clear the pointer when addition
> fails, preserving the existing teardown guard and error cleanup.
> 
> A controlled probe-instrumented test kernel with the original OCFS2
> registration ordering produced this Oops during a concurrent sysfs read:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
>   RIP: 0010:kasan_byte_accessible+0x15/0x30
>   Call Trace:
>    <TASK>
>    __kasan_check_byte+0x13/0x50
>    lock_acquire+0x113/0x300
>    _raw_spin_lock+0x31/0x40
>    ocfs2_filecheck_attr_show+0x138/0x5f0
>    ocfs2_filecheck_show+0x5d/0x90
>    sysfs_kf_seq_show+0x1d3/0x360
>    seq_read_iter+0x480/0x1110
>    kernfs_fop_read_iter+0x419/0x5a0
>    vfs_read+0x7d2/0xc20
>    ksys_read+0x111/0x200
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>   Modules linked in:
> 
> Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/ocfs2/filecheck.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index be713d7d24a76b9aa8fcded3d83b3d91d124eb6e..862c1ee7099c943b2e3e57e31f887380c6dc8a88 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -181,2 +181,4 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  
> +	/* Publish the initialized owner before activating its sysfs callbacks. */
> +	entry->fs_fcheck = fcheck;
>  	entry->fs_kobj.kset = osb->osb_dev_kset;
> @@ -186,2 +188,3 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  	if (ret) {
> +		entry->fs_fcheck = NULL;

setting to NULL is unnecessary, it becomes a harmless dangling pointer here.
Other code looks good to me.

Thanks,
Heming
>  		kobject_put(&entry->fs_kobj);
> @@ -191,3 +194,2 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  
> -	entry->fs_fcheck = fcheck;
>  	return 0;
> 
