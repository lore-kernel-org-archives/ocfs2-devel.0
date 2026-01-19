Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC5E224B05
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768833813; cv=none; b=dSX5uKouTRx4N5GlSZJgu1F6KQvWUrN5uzsroO3D2UShfkO9ZsdnZ/0sfkX2/EH6yiZUXusOzf7Q3+P30oZ558VXqd0ohWXpmQU28hn2wW92T6qn0ySmAdrNgBlBt4RdlDvWzkdXPQFRj2Uo/b/70drzIvrXa95kqBrzvTkGm3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768833813; c=relaxed/simple;
	bh=r74QiyMl8GoaFf+6OYnD/LWemt+AkwY8ZRYKU002DU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GL4OnFM2I7zQrJn5MOVpO5TH3U6fMgmTKngy9rMlZU5esumHzzcxagAc0CV3+h+Ivk1i3dy+SSx0fnByyJvNmVEHt42mKgmeYl8DF8C9KtDEWsbVezWb+qvcWoLUN1lcrbAesreA87606lbvuXJAQNmz/bcMYvHYGiORutxr8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AjEYnIMX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AjEYnIMX"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47ee598d00fso2934495e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 06:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768833810; x=1769438610; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RR1qVFyAeEiUAQEUT2CsZi2+KLdkWNNKKDhRLKnjZFk=;
        b=AjEYnIMX9+eY/hh8igQz6rjZHhk2R/6KWdxxyg/NMTooo1iJ1lx19u1bL7YkQ/zPbi
         8TNSXVjK8npFweTRybn6b6WHxAhJgipr7VGxvNjCI0Y8r2HrO1ARIF47pfMLtkyMpc8T
         CveLqxuyMI5YUaWaAWTB5Sk6SCX2YaX5TcI04P6Q9YkQ8dsW8YVAHNNT68I1eiVfz0pb
         mIA2utIUTubQjO/UzmDt1RnRf7wOah2qFVTrbNDVC7xQ4zB27aI/sbLb0MPhMCuSmAIl
         XkulIX65+yehTnI0xXUs6xV0pVW8kgPmLC3KpFrOLh7gRVssPN4VhYLPg/4+8EDYoOa5
         3UNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768833810; x=1769438610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RR1qVFyAeEiUAQEUT2CsZi2+KLdkWNNKKDhRLKnjZFk=;
        b=BZ9Lg5fR7+3FO26iO8SrYDVjjGLyqd1+rJ+H6uCFOykqF/O0DDmE3GBPuLutb4Ryc3
         NglSQ++BsD4UvdnhztStGXddT8ZGbcDCsJ5QVl9Rv4Bz4BTXuaNFI6vDcdIZ+FFYQKtL
         vyCbIbmWLPsbQAJIGMLP5H0RZMnXxmzkhGdHunCA54Ps+UeZIuwaKz600pxvdKyxRHQu
         ZuQxLaafoNTejwzpf44pNteFWXtTIB4BoaIx0CUce0O+fwWsckFUL6SrDN5XH+vl7a1E
         nrXWWLkrSWc7X4RlEMYCnraGwM5D+1Chxlg2rTGb9VK5Y/ZnB1dSO2z8lDw7bGbhc6nS
         5TlA==
X-Forwarded-Encrypted: i=1; AJvYcCVK4v3Ly8VSswTtuotPIJ+khc+12noEMOAvbBhK7IO/Pvmlj7dIKqKlVyCBwvse0PSz7HMQdrTzLzn3NQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBUDLUpWGoA2v27VFukk4UV5z4fOYb+muZfMFns6kG80Zk5bqu
	DT/ULwPJ+E76KgVuiFGiMp2vF5q7j1jMpB6fHkYjHaatRbRWNdoxjg//YhlEjvJveAU=
X-Gm-Gg: AY/fxX6s65MwAXNgODdopTVcQ1fK9ZWyLoeFm5cnueZL7ywgPounOIJmDnVpEqzkzBi
	Z5y+WvPqLF3IzYB5Y45CbVDhDWqupAPpMKWqp9pDoHk3Jw33lOReQdhdJls4jbgOSIbV2pTgE6/
	B14ELrDysJMKZzmhW1UbcLnJo3U2FVlVaxRV+Pe3BRXcCXJBGffu0p7PdwlVu7p0K9OIE2faQOI
	VqYl87utyROEyTpJiSRRBxqOQcy+ONRyoE3rZ+AVkrwvAIUTZqpDYMt/ZodqPdB1x2h0bILfn3B
	uwYoO/3f/Ke7QChO9buVG8wBsOAvdl2ZwiGmzVVkkDzwMfQxjNNz5TOACGgA7h4xknN4SglwFN7
	Mby+XJtWQootjbHlfqQSOXSfk2wlMrBVf6ECQVwhygxVfeA50GATHwVDjVj682IzOUdszWczJO2
	LVA7LwVLdRjQ==
X-Received: by 2002:a05:600c:4f4f:b0:475:d7b8:8505 with SMTP id 5b1f17b1804b1-4801e3743famr93063515e9.7.1768833810529;
        Mon, 19 Jan 2026 06:43:30 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dedacsm97891305ad.58.2026.01.19.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:43:29 -0800 (PST)
Date: Mon, 19 Jan 2026 22:43:26 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: markus.elfring@web.de, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] ocfs2: fix NULL pointer dereference in
 ocfs2_get_refcount_rec
Message-ID: <5bflve5fog7jreyjzn4po47t2wzd6vomsmlkd6km44joogcybl@6vd2h5orgwge>
References: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
 <20260118190523.42581-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118190523.42581-1-jiashengjiangcool@gmail.com>

On Sun, Jan 18, 2026 at 07:05:23PM +0000, Jiasheng Jiang wrote:
> In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
> If the extent list is empty (el->l_next_free_rec == 0), the loop skips
> assignment, leaving 'rec' as NULL and 'found' as 0.
> 
> Currently, the code skips the 'if (found)' block but proceeds directly to
> dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
> NULL pointer dereference panic.

Do you have reproduction steps to support your analysis?

there are two types of 'rb': leaf or tree.
the check 'if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL))'
handles leaf case and returns to the caller.
the subsequent code handles the 'tree' type, therefore, in theory,
el->l_next_free_rec should be ">= 1", and the execution should enter the
for-loop to assign the 'rec'.

Thanks,
Heming

> 
> This patch adds an 'else' branch to the 'if (found)' check. If no valid
> record is found, it reports a filesystem error and exits, preventing
> the invalid memory access.
> 
> Fixes: e73a819db9c2 ("ocfs2: Add support for incrementing refcount in the tree.")
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
> Changelog:
> 
> v1 -> v2:
> 
> 1. Add a Fixes tag.
> ---
>  fs/ocfs2/refcounttree.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index c92e0ea85bca..464bdd6e0a8e 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
>  
>  		if (cpos_end < low_cpos + len)
>  			len = cpos_end - low_cpos;
> +	} else {
> +		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
> +				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
> +				  low_cpos);
> +		goto out;
>  	}
>  
>  	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
> -- 
> 2.25.1
> 
> 
