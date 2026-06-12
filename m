Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909438333A
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jun 2026 01:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781227684; cv=none; b=kx60kKwCknNVQq+o/PJYZt+kxzCT2x92GQGbKHKmuErPH+dwunIKZRxyjmhpv1628Z6Q3Ou2YTqRupo8kIv5NxXy/C1Z1FoCO+42Pmhs0DRagdTewVO/Gvtl1jhqzjFRLrpi+TrzBynxfYnG97sVlkQdGFeoqzMuXAE354el2Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781227684; c=relaxed/simple;
	bh=FXrj/w7ZXv0Gok+tAroH0Pb6+LOUFgOiV6HqDg/TiRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/+R4M6BVyM7Dxyzvhvh7rG4VOpaVJIR22HRjZfk8da78vNFbywkwuZH/3bay0kvr2mlQO8BsnLwiwm/Qwty9VszC4InbQAmnB+uDmu4KzuPyVXzcw9Ts7HhuI1YmXvL8Cm8oSmILpaehHdRABRB75Ttb54o2KAOkoKrrhSJqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F/2kgNHm; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F/2kgNHm"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef93a0b0fso40815f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 18:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781227679; x=1781832479; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzaqJwTHaFZzTp92//qArkg/N8YcxfHMHejrUhtyGSY=;
        b=F/2kgNHmYn5ADs6WKQHi21RXzofU4KsUPR1OpI5rjHaxbVwHLpOoz3FGQtTi2cjmku
         YZcPk/4kjRz2QMY42MWNZxABRofmwMLBDLp9DkCXAFctK4dIkAqFXc4mATNaGO7ue8Rj
         Ec2QgbCEIES/0LVUHcQu8R/+C06qBwiI+m2hZZ7oiBRwjIalZ62P9AKYSYUGsYjMb9vm
         SAGzUrRIpbuxFfhekyoG2qXFmyt8D/hKjcI5ty72oPJl3tOCXHkR4pxUJ+/mHQc9lVEa
         frP5L1B2Dl8KrRt/T3ZHicFtFK5E3A256umkTeAafS8MbWr1co6d2m1nsuXEHQnUkd3H
         Swag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781227679; x=1781832479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tzaqJwTHaFZzTp92//qArkg/N8YcxfHMHejrUhtyGSY=;
        b=QAhN1VwSs198tXrHWkCl+ItYs1oY6Jkk/NYmZSVRPz5FhABuE/yCgMWerc6zcKmbj+
         h/Ys36ELMnioBWBS/JupNwSiWdik2w/kFi+jeqrzw/rU3bW6BE+Vrc49jJVaCSMxNAbI
         2wiunPUotaiUXWuoNoqUJueJ9R70sPF9erN2Z0Ie4hzQ2kkz192a1PfLHZd9wDPpCrNp
         lyCPv7Ng9ftsqhZdkOGSNNzgkMjyg0AFoL7ILFB0XwmzVf3FcHnASgHc+/eF6yPxMtUt
         /Kq2Oes9R3bmgRRmkz5Y1Vx0W3wQRKeodndMUcqHrkUFoWZx2a6Q/6+AqQfYSHYPWQlW
         c+Og==
X-Forwarded-Encrypted: i=1; AFNElJ90qZWKc0/d/7qdk0sbxPIaxfb1EUCiNoTPGfHtjjVHumqCNnopN3Za0tNJSQ7QhqolD3EC6fVZKS6rrA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9jz8F4nONT+i6bCaufj1mRWC0z1rYsRzo1U499cvkMhVPiiqF
	qbLUX4pP/y6Bkv+Hx8tCQB13KqB35j5r/4SIAHcwBOWVcd6FjDCIBDndn+/hqO1Wpoc=
X-Gm-Gg: Acq92OF5ZstoFOemD0+GlwZUpHsqQrCNQq8s0jbxLhfWnwd7oCZrovJF65UZ5wwJw8P
	ZAAHk2i+gb3gYagm3rEYXKlR6cqAbtMlIQX+nCx640E/a3J8o+afXgO1ikBCWw4FYuv3aEbxzgI
	vqt/5I+ovqKLV3sD/WLU+R7QTz4XkAsMhq0srnYIKVdbT5rJ8PeMkAvlGcC5G8rIz7aYLxQmsTu
	YR6YjOS0XERjGCqNQZbMf/iQfNzWKBf9T2SonUVUwoGVFkWSaRAhWTfWZaiT7Xk3qBYAbhljAMr
	hnuSvwPWLsBV4b+svC6GYbB9peIA9Um6JECur+65k6aBstpi6ZgFfOb0iMahNzumyAP45fynDrj
	mVSpjsZhyPgLdudIG3Q3bdog85DoyNwmBaj8dS1/QAzCPzAsDzvKn7fd8X5SwdNvyx3J4z2ujWF
	QOVL/fwRpp5W8lrQbdWpcYmA==
X-Received: by 2002:a5d:5e09:0:b0:45e:91ec:d4c4 with SMTP id ffacd0b85a97d-4606dbb1cc8mr456888f8f.7.1781227678960;
        Thu, 11 Jun 2026 18:27:58 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm612658c88.8.2026.06.11.18.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 18:27:58 -0700 (PDT)
Date: Fri, 12 Jun 2026 09:27:55 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Marco Elver <elver@google.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH] ocfs2: fix orphan inode disk leak in ocfs2_dio_end_io()
 on I/O error
Message-ID: <aitf5rampsYpes2t@p15>
References: <20260611150341.3964327-1-elver@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611150341.3964327-1-elver@google.com>

On Thu, Jun 11, 2026 at 05:01:50PM +0200, Marco Elver wrote:
> When an extending direct I/O write or a direct I/O write racing with an
> unlink is initiated, ocfs2_direct_IO() places the user inode into the
> system orphan directory and sets the OCFS2_DIO_ORPHANED_FL flag to
> ensure defined behavior and crash consistency.
> 
> However, if the direct I/O request encounters an error or gets
> asynchronous cancellation (bytes <= 0), the VFS completion hook
> ocfs2_dio_end_io() bypasses ocfs2_dio_end_io_write() entirely and
> executes ocfs2_dio_free_write_ctx().  This completely omits the teardown
> of the orphan entry, leaking the user inode in the orphan directory and
> leaving the OCFS2_DIO_ORPHANED_FL disk flag set.
> 
> Because the OCFS2_DIO_ORPHANED_FL flag remains active, subsequent VFS
> final inode eviction (ocfs2_delete_inode) observes the flag, assumes a
> direct I/O write is actively in progress, and refuses to wipe the inode.
> This results in an irrecoverable disk storage and resource leak that can
> only be reclaimed if the cluster unmounts or crashes.
> 
> Fix this by ensuring that ocfs2_dio_end_io() inspects dw_orphaned even
> when an I/O error occurs, and executes ocfs2_del_inode_from_orphan() to
> liberate the inode before destroying the in-memory write context.
> 
> Fixes: 5040f8df56fb ("ocfs2: free up write context when direct IO failed")
> Assisted-by: Antigravity:Gemini
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  fs/ocfs2/aops.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 4acdbb70882c..ad3f2057e26e 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2419,11 +2419,24 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>  		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
>  				 (long long)bytes);
>  	if (private) {
> -		if (bytes > 0)
> +		if (bytes > 0) {
>  			ret = ocfs2_dio_end_io_write(inode, private, offset,
>  						     bytes);
> -		else
> +		} else {
> +			struct ocfs2_dio_write_ctxt *dwc = private;
> +
> +			if (dwc->dw_orphaned) {
> +				struct buffer_head *di_bh = NULL;
> +
> +				if (ocfs2_inode_lock(inode, &di_bh, 1) == 0) {
> +					ocfs2_del_inode_from_orphan(OCFS2_SB(inode->i_sb),
> +								    inode, di_bh, 0, 0);
> +					ocfs2_inode_unlock(inode, 1);
> +					brelse(di_bh);
> +				}

Calling only ocfs2_del_inode_from_orphan() without ocfs2_truncate_file() will
leave stale blocks beyond the EOF.

I think the existing OCFS2 code already handles error/crash cases for orphaned
inodes, and this "leaking" behavior is by design.
please refer to ocfs2_recover_orphans() and ocfs2_add_inode_to_orphan().

Thanks,
Heming
> +			}
>  			ocfs2_dio_free_write_ctx(inode, private);
> +		}
>  	}
>  
>  	ocfs2_iocb_clear_rw_locked(iocb);
> -- 
> 2.54.0.1099.g489fc7bff1-goog
> 
> 
