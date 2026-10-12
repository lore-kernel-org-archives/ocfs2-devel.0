Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8B73AF660
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 05:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791782025; cv=none; b=oVmjzpBEE6Eu0VVkzxn53RvLxLkroUlO/7vVgTgeP3QPkSJKmvcMV08gb5lLdzJ0amvBiDQ+PtXVk3cdpC6vByBN1STTRYvZORd3WzDESvotQMCtj6Wz9HMTjIaNJh3wuvDl42OiAuEaelUE6k5BbuTZz2IuQv0ZaibfnTa2fdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791782025; c=relaxed/simple;
	bh=XI8VQgarRwz2lLcCnF58W//Y+83iyDUxIh1oKJoNjHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+RtRhzuigqkiw6qGSgggp+JHWs8NSMNhyqRoHEkxHZxb71RZQVXXDekG1YmNWsDBJR5Vug/pvt8RHCvw6T+2rgPwaFg2s5RHhuRlOpE46MQhieIfVGGVkIe5pWA7paHgsuFx/CNV+uwDzUiajv6o1MeML0aXuTPoZlsG4JgCGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G3JRqelV; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G3JRqelV"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48b127f1cc8so159335f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 22:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791782021; x=1792386821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FepuHsUKJH2n5sn1wcnKpoTPrhYmHNv1ggg3wXE/7Qg=;
        b=G3JRqelVS6BDIQlhfxUhpSKFMy+zTdduT2TvRrLfLUyrbNbALdvs6KXBGw47r+kDsE
         kiMeBGLJp5R037E0pnovZo8sRZT91Ylj27xaqZRAdYR1RBPxjpJm4kmEIw9LpoMRhT0K
         lUv/FdLoPzlRuLeIls6wWAdn83DRsLPL0/xLw52io6vgQdfij3HIVitWVzOwlwyO9G3V
         3LiP6+i6YR7G74veXaGu7lTxxuhCkG4wBMxDXxTULPY5bly6fQk1kqSywKILB0ZsMQVV
         pT40LyZ4kQQ+O/80Ts9BeooHoz+LI+cvkYS2UebjRSJRApa2Y6BukUmo1zJbU2+J4CVG
         CtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791782021; x=1792386821;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FepuHsUKJH2n5sn1wcnKpoTPrhYmHNv1ggg3wXE/7Qg=;
        b=0D5HcLlBX/afCeidGYO+eNU35jHkpQmHVRGfXyYxAd+6awfpvabynZVqeiSwLE7Q/9
         3EhqKRzMxodZFl7++oDB+JNbAkg+64z8hgrlRzXl3qvxcFl6z0tYbFwpnnWWxQpX+Ba8
         SHbeP/mIa0+wZ6N41XlGM51eWMWiViaIapmh9mvkyxMBZxGJ1ZtTSuEPPhMQF/ens9ms
         ZHl4r8EA3pdORCxQo5TnfAm66OX167d0rGzwfyFZqwWr+swtbBfOockYirtmo5nLe5m6
         8Svy+DzxMkWgvKIVgUhjtQxfbwy9KXxNFzp/FVN6WJxpCiNHo+t5IsgvDUr3ZvcikXUW
         nT8Q==
X-Forwarded-Encrypted: i=1; AKwUvByIDPHDo8ijiLcLzQOqxL/ayucXFj0/7eF3KQ0sThj6rYDHVtNv5jyAfPc/aiRIf29khP6vmMgKJ0iOfw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJX8WF7h9X+nA2p6Sf8LnGRaCQQrdcSchBj86Gg2WdmJyZ9rKIc
	jn7/cCbICAD5e2FkmbkLmQuZzsGIAo7x1LN1prsPYUrKqs9TRvE0ldLYPOU43npv7h/C0RTxFy3
	k8dZGRPM=
X-Gm-Gg: AYBFou3EhTisjwlJrRYyzOmPAv/8GGGyp1YIld4/QrNYzygMryNoYA5NRlIyqskv8gW
	nb1LaYHfKHW14Xn6zhNFpY8cooI0IHGbHUf2jr/h/CoraA+I+1cBgYAuVhYXbbzT4ldaGqZztOn
	l3LC2wv0FgQ2RtBinOsGavyrNfUM0kOxC7nQnB90cZrXyWYf9TdM1bt7YjUyzDwRtmCqSBym2s1
	6iaFD8KxhV7UezVIeiStOe3OJPRKtiE5zLcnjor41OBCdPKi1qxv8NuK57NSPiTkYW5DRFZ3iIJ
	EXRFeXSo/kSxNmW569slALwqn0GwPM7nrdsJZIjgXYHMp4DMRul/v55Yi/HNJRpwCqXf1VWrzlK
	FhSse8wCs2NutwZyHsFYkE1VAfgOxfOjhdnDDYJZCgH92/3oC3RXSf6fp7A5GOF17Fs0/Hs9Zn6
	t8fwL4Honw5ETi1rXga2uTjFfmN+EYmpDt2XRomPKa15SBxfvjPRPRJH8CtTpmyfg/nAGp
X-Received: by 2002:a05:600c:4ecc:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4a18e476022mr178212845e9.1.1791782021446;
        Sun, 11 Oct 2026 22:13:41 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab32c0f59bsm9198544a91.0.2026.10.11.22.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 22:13:40 -0700 (PDT)
Date: Mon, 12 Oct 2026 13:13:36 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	akpm@linux-foundation.org, ghe@suse.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Subject: Re: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs
 attributes
Message-ID: <asxsZfHIFiI9k1BD@p15>
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

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
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
>  		kobject_put(&entry->fs_kobj);
> @@ -191,3 +194,2 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  
> -	entry->fs_fcheck = fcheck;
>  	return 0;
> 
