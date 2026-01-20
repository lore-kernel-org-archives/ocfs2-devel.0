Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24EB4534A3
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 14:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921081; cv=none; b=pLpuhX43uvIHiyl6h/YO5Ovhgrf9w+bQWmu1cP7IB36LLo5krEHBIePydl619yCjazE9ABGOgN66Ge+hCBxh8WGmhzLRfteZr7XYd+mSGvK6BK3CujtyvsKaZDykg9Q+GNk8+V9Cnpbc7RBZnYwJoLyKXDTHQSyQvPBiMe9xX/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921081; c=relaxed/simple;
	bh=DD7TYa/vrf7XCK4wVkxSy70j5MSA4nX3/0O/jE8u4o8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbW4mWA/V5Zw7xHNUh9AxUWOuU6CdbKa3ENcObt9MYuHFbDGqEnHZ0rozIeJDGVq39LF8BTvvhFS8gz599EEB7tx43DAc8rkCeoEa9dgefySZ+BMi9xbeYl7WdDXzNEe1axQwD8lk3dQjuJhfl5bo48TuJMFt6wUcmOqQBAMrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dWAI+On0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dWAI+On0"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47eda5806d7so3201175e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 06:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768921077; x=1769525877; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=18x+c6+0fc04P7y2GlPAQVpKxeva8U8BVju4xXG9/dA=;
        b=dWAI+On0dJAlaQe1cYHepIhOMq45zGv7X3aO5ColwNF8JcDM+/GMSgmNNreE68Smwx
         vbsXJA9OotLtLJVB+OYkzvnMNo2uuXCrBDOq5nbLs58AbQ6mB6zVyJZ+t0eRXOHdpaaQ
         8PnIDzMMbjGgBmThs8t/ZMyWRohZ9iq5Qf+KbGxyGkFc/COY7JKFd8AJqPa/IYpRDlmm
         JD3btQykSzudY0+pKMo/Ihy5AHmTp4kXZvLcQvapxi2BEs3sAA4ebEuR8kV73A6mkFEf
         c8+Z0OyFIWFaJ3fp5dpGS0Y8l89nVZTuhKbE0ESUQ3ZLVbMGQHDG2onncKad94o7cV4b
         4yeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768921077; x=1769525877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=18x+c6+0fc04P7y2GlPAQVpKxeva8U8BVju4xXG9/dA=;
        b=whtJEsqPW+6VjQAZpfK81MivN+/gvQkuAVrul90vL4r0OJf3afxgcS9tdBsgZC+jck
         gmgsqyizikjYgVAW0Oiou1Lou0Ak4FRHqlJlOCpTxKpABCWf6vsr3lI4HG27CJHXrVcO
         zqK+CaVkEWmhtv+f2ErH38ZWvTKJ/pWlDzFHPwTy2OftK9JAZKGo4rPr1NvgjTAekQnc
         O9OcoXyk+vOm3qes1tp3G1EwdIReV6hZ/r7t/WH+kIGEtKpzkIR6Fi2AcICb9rnpwHic
         nFCz6+Lhbh/HCsfciw7E773BWAo1SS+Um5EuCepcbU546gMrIESsQBfamMzAFrMbBeAl
         sCOg==
X-Forwarded-Encrypted: i=1; AJvYcCXSrREh4RM9xMWK4Xb0yFOb+gRBQbk7VHaRnqK7vpurHs6XY8BPVAe8KTo2HDKK7etiu3VC1zfoZTfmUg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm6oBCdYKv7KZWmEOHKkwcUHFcigNBQwxJA5rhq5hCFEbYLPiA
	1Lvz7hZi166MRxvZt3vkgrQzAop2AaRL4KfINB7mSjrz40n5gwTENfYUgs93JxEveNChw9wXsKM
	f6O1VjD0=
X-Gm-Gg: AY/fxX4C5dcSmaKsfj8CzSx3bBt4j8bi8/UtJsxxMsMXM8DsySF9YzTcxEJ7HRAqvE0
	NC9hlqewUNQPsaF9GgTWQUh3sHjq6dR3rYApSS6kvQqpe0ctVZx2H4qdGk5EWOyzrwdY1TCqUG7
	tPWHgvhCF2nGGlo13SK74itKPZgf1/bTrhogoJhFXIwPkIroHX8h6q6meOxtMrK4NmtcwXH7Pv4
	KVLqYKvZ5DeVWDxGUFDPOQ4zouoQacC5qqYjHbAmRv/ZPj5TbfAYUewXU3mZZdEf7pXTpcWT6SM
	8pQ4Lpw7lyUcdVyj6tUSXWQunGg/agto3VZSSrx/1es+wW+saLu1H4msz91IEN0mTY5z5Yindac
	fG4+zDpF/KvmCGxMXNjIT1QIyLr7mQGaoJrNbo89Ej5sIxisBtsIfljVFRh9TuE86wv6wD3rKTu
	lJ58mhGlvMng==
X-Received: by 2002:a05:600c:64cf:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-4801e33c5ecmr111690835e9.3.1768921076919;
        Tue, 20 Jan 2026 06:57:56 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10bdafdsm12354584b3a.15.2026.01.20.06.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 06:57:56 -0800 (PST)
Date: Tue, 20 Jan 2026 22:57:52 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] ocfs2: fix reflink preserve cleanup issue
Message-ID: <w6hmwb53opubufe77iqvwdcevkggyljujzzjltd3q5s4s4u6k5@ucowivn3qufh>
References: <20251210015725.8409-1-heming.zhao@suse.com>
 <2ddspqqrnjaf4dsw46cx5h7wxnlmaqpbhhiolrfrn2c63v5txg@deaax4xovu64>
 <20260119155353.c52e9ad69538668001833f38@linux-foundation.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119155353.c52e9ad69538668001833f38@linux-foundation.org>

On Mon, Jan 19, 2026 at 03:53:53PM -0800, Andrew Morton wrote:
> On Thu, 18 Dec 2025 22:42:12 +0800 Heming Zhao <heming.zhao@suse.com> wrote:
> 
> > ping...
> > 
> 
> yes please ;)  Some review input would be reassuring, thanks.
> 
> btw, I forgot to ask: what are the worst-case userspace-visible runtime
> effects of this bug?

The worst-case scenario was fixed in commit c06c303832ec ('ocfs2: fix xattr array
entry __counted_by error'). It resolved an out-of-bounds (OOB) issue that could
have caused the kernel to crash.

In patch commit log, there are two issues:
1> the 'last' pointer should be shifted by one unit after cleanup
   an array entry.
2> current code logic doesn't cleanup the first entry when xh_count is 1.

The following points should be noted:

Regarding <1>: after commit c06c303832ec, the last pointer doesn't shift. The
code always clears the last array element.

Regarding <2>: Since the existing code correctly updates new_xh->xh_count, the
xattrs can still be displayed correctly (shown as empty) even if the first entry
is not cleared, as the logic relies on the count.

> 
> IOW, is a -stable backport desirable?

Yes

- Heming
> 
> 
> From: Heming Zhao <heming.zhao@suse.com>
> Subject: ocfs2: fix reflink preserve cleanup issue
> Date: Wed, 10 Dec 2025 09:57:24 +0800
> 
> commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
> doesn't handle all cases and the cleanup job for preserved xattr entries
> still has bug:
> - the 'last' pointer should be shifted by one unit after cleanup
>   an array entry.
> - current code logic doesn't cleanup the first entry when xh_count is 1.
> 
> Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.
> 
> Link: https://lkml.kernel.org/r/20251210015725.8409-2-heming.zhao@suse.com
> Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Joseph Qi <jiangqi903@gmail.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Jun Piao <piaojun@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/xattr.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/fs/ocfs2/xattr.c~ocfs2-fix-reflink-preserve-cleanup-issue
> +++ a/fs/ocfs2/xattr.c
> @@ -6395,6 +6395,10 @@ static int ocfs2_reflink_xattr_header(ha
>  					(void *)last - (void *)xe);
>  				memset(last, 0,
>  				       sizeof(struct ocfs2_xattr_entry));
> +				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
> +			} else {
> +				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
> +				last = NULL;
>  			}
>  
>  			/*
> _
> 
