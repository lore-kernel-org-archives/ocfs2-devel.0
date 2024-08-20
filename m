Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626B818E370
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724153532; cv=none; b=sVO/hyuso3JRidKPSt/FySh3wn/wiEAoOCS3RyoIaUqqByT0Y2iKhS1RnBlDPq22dEB1I0/2AOWrjBcbSwhRuByCMEceXSbl6drmM9UQ5Us7kkBtJO/FRaeAwuGHSd/WPWcXGUKfsfsDCECfhWkiR59Pz1phSwDJskq/8gQpRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724153532; c=relaxed/simple;
	bh=/NEEXoU7cN84Cc0lPoORDgJ/bZuFQM/jQxKs3CTG6BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=seeDXM9nAwbx/xdhIoFfNm/ZggHIOxjjdUGZ5oEgkF0fp/e8V2uUGGm+8WuR3UfEAwuT3GCp4MUyOrm/RjZ+1c9S9HHLsycIYQ0HCBvfsOC/n9ToAtK5I56T5aiW4fQZ5Upcf/UhAmSQLseI0X3BXXSEqT3k8HkFVdbgzwnIx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aE8t97g/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aE8t97g/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3718ea278a8so581435f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 04:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724153529; x=1724758329; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=klUHlM+lvRCjI1JDvDMDWuADlMNeKPhZGgQeek32rrE=;
        b=aE8t97g/Vs7fTrtb0MUB2+NKBhKEWmeOfq5IhczWgUa3/jtrL4NiWrH9V+oPlDjL0X
         2r+a0fdf5zLwwZd3ajJ1A+SWSHC3vd+5sSkx/tCUUWpR+b3ovNYBe7SwQwVShfTKQbzG
         E2rBB2t81ENyKNoNuPDN4AiYdZDwghtFq1TxJmBXMXwp0oQzFhxHDGg5Aa4h2KKhPSOO
         3Ag+aOKA7n2XoMCiH5yIOnZfQumDkayou//x8NNAn6gk1643NAWl68tjdRLqEoYGVU/z
         ixDmABHQw6y4GRTc6uPc1PMsO4P1UI1mk5yzDQu9594INRvXSEKy2AyOCxdww+OKiyjm
         6Spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724153529; x=1724758329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klUHlM+lvRCjI1JDvDMDWuADlMNeKPhZGgQeek32rrE=;
        b=kBxDJQNjcLNPVaKTwxl8dvmGK+XFgnaFRN2MjOH+cv0zMaAfHdEdwEllKdSava3Fl7
         E1JaF33Hzha0sBrfePqgrqLoiVr6qxa/XclbP0PpM1dalHVjMC+G8zVOxX43uBmiiin6
         T1faS/TYPa/SvORo2zXyUrzr9oxSO4XVnXAN578ngtZfB4ww832dYvZ0lIlZzQQO/VMq
         sIW78N73rmBZ12bi/lpqEWBpCLB6N4Ym/9RHkHoTj+suUyHtruNqC6Ali8g8hfc52yDY
         OsLlNtO+qGUARTAOdTAcDxN30YUmlzHiFHJgRcZ8yEUm5FKINR3hnUrzvX4WJDFURDi2
         h0tg==
X-Forwarded-Encrypted: i=1; AJvYcCWp3LRV9S1vXsEdCWt0hmtDw6ZPz1PQ4581Qpq27qFq8NuosG9c3/qm08Z2ebpq8TRFGbnsmqmLivpClw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6nFhh4mkwzpW4JypehG+Te/175G7kGUbnbyVnNnWufwB07gTu
	GjtyyPxMCOcrRTLzD8j0xNE0jV9aRBzwHd75zSQUrdsyviEuoQAmqJSXo4EmUr8=
X-Google-Smtp-Source: AGHT+IFe6UqPkZ/6faH/rOIEKAsRbPKV+z7PDLxqzU4epWauYJ+IjaWsJm8efnmozk5MbJ6Th4zkkA==
X-Received: by 2002:a5d:5f8b:0:b0:368:4c5:12ec with SMTP id ffacd0b85a97d-3719468bb8emr5637683f8f.8.1724153528257;
        Tue, 20 Aug 2024 04:32:08 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0319a74sm76412785ad.92.2024.08.20.04.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 04:32:07 -0700 (PDT)
Message-ID: <e6f16317-6d11-4f14-ba88-6c7b33276285@suse.com>
Date: Tue, 20 Aug 2024 19:32:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
 <20240820094512.2228159-1-lizhi.xu@windriver.com>
 <20240820094512.2228159-2-lizhi.xu@windriver.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240820094512.2228159-2-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 17:45, Lizhi Xu wrote:
> In the for-loop after the 'read_failure' label, the condition
> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
> When this contidion is true, this for-loop will call ocfs2_set_buffer
> _uptodate(ci, bh), which then triggers a NULL pointer access error.
> 
> Changes from V2:
> * Make the code more concise
> 
> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

I didn't give you my "Reviewed-by" tag for this patch, and you
can add my tag only after I send it to you.
(take easy, you can get my "Reviewed-by" tag now.)
Please remember this rule for next time.

Another issue with this mail is that the change log should be
placed before the file list, not in the commit message section.

ref: Documentation/process/submitting-patches.rst

Thanks,
Heming

> ---
>   fs/ocfs2/buffer_head_io.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index e62c7e1de4eb..8f714406528d 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   		/* Always set the buffer in the cache, even if it was
>   		 * a forced read, or read-ahead which hasn't yet
>   		 * completed. */
> -		ocfs2_set_buffer_uptodate(ci, bh);
> +		if (bh)
> +			ocfs2_set_buffer_uptodate(ci, bh);
>   	}
>   	ocfs2_metadata_cache_io_unlock(ci);
>   

