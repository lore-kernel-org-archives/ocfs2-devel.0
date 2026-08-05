Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6077B3E5EDB
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785919768; cv=none; b=hDMsOw35c3DCFeahA5ElHsZ01zWjOEEh+wQWCJN9AH8m1nJPNt6r5sCVc8yfbLg2cXJKlpJtDBMG487BadFO4aTtJL/UFi6jmPdo+9fSro8EIBWLayzopNcAzzQRy3IDM6SfS7jEcwsJZ7HKlJjPJFEpPHOqKrrk2540KFP/txw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785919768; c=relaxed/simple;
	bh=T4YE/eGnsv3t/rKH3kRrdoat5725qTujmUDheDsuNX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m05VSPZMTUFszH5YGIFKy5YN+LLw3/ZFs7xcKl+54Q8h39g4MeNUWsmFbuXE0VTq61WmZtwu+LCL90f63iJ9s8/Jw6TKqRCltUTXyHZDvezG6NlJjQP2iM9wIjMHygp27cu6SQQ4Rzc8o2gfE0FKhPHY1KQlE7SkCjdoKpA1c4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dX5Oqrqb; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dX5Oqrqb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490791a3e92so746315e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 01:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785919766; x=1786524566; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EfjKHFvdiIekXPyIJtfsuWIiX/n/M+UVlVb3uUnbRMI=;
        b=dX5Oqrqbo2+D/qWKWuD+ooGr5snbnshss+FtTjmRQlN7XDKDCA5oU+1WGW+i82YUJg
         YEKmVJGaDh23NJsQusXbCPyvVI7+apLrWTwyxnZMtIK3vPSLUJwOjsxUdYYqV2wsaADz
         Vyy+sjGObjvejJS/P2DgzkCYqgkYH6YYCdkN6cebYG+u+pq/Y46PsViQ+wMkqdYwwIVA
         tBXzpxA+QTjJALN5BWiwQYO59bxfcbyQcaXB0bAhZFENyv9RPEqspGt9BOWsgPJPSjpG
         al7D9mRYt9vUlaSOIODLWVsVaAVRceODm+pZeu6p+fBHeXNiQUMIjkjrhnDFCHXyp7To
         dQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785919766; x=1786524566;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EfjKHFvdiIekXPyIJtfsuWIiX/n/M+UVlVb3uUnbRMI=;
        b=FQ3bJHrNt+u2dc5rGPOEk0dGOj/ihOa5y+Wo3VRrkYexMFD5XVfAxC8L4epC7Eu4Ki
         OIIVuQy4nLj1wi7VuA7Lkf/rjOnvv5RMKVYrmmXiB0YzOEcEV1cr3BvO+d2QQmHpiw23
         jcV7mD06fagbz78x2rVeaANZ5k9AMCZi13ZfWFeWV1Bh26u1NPh1xfK3ZdMRgyJnkymL
         3ycduzNymJohm0EWLMEUR5ZqSRIYWoU7UAFsMft5bHR8bCAWMCtQbbSgVxXK4kyWGNhg
         A06IjU8vVVmVDthRTu2InX0TQtXzklaX2ozkCQiKAn6VVrhkzzsGOziRbyaB1EdItHkf
         50yQ==
X-Gm-Message-State: AOJu0YzNW4SeHsQx7tjZ5RE3isWfY3lK4MNbQrWvQ5GQjwMwpbhodi1/
	ihUe/4Ko8YWHYEG5p/6LJAcD8JvpJxR69fs0iUpVr6SqEETrVVHCZM/lZyiXd2OnqQo=
X-Gm-Gg: AR+sD11W5p5nJt4tSijWg1v4S8d0IoHqDLvRbnkb6goFc+wBS3dbcf5hoDsjj8X+QoT
	IQdB8mEbRf/58A5Glh3KD48c6qhvH8nCMhaVon7HcxNLojTz0A0KKk8oJtUHGROfK2GZ/aD/8fw
	RkGxxS4JQm58VOKvSiUD3FOMRkh/E2iN7SEKL9aYJef0lp8BjjtgQhTj0GPeQJ3kMZ8tmqIavHN
	KnMPlhtHEcyo4tZKyl3Ft37BkZ+hTH2q9WM4MiIg8fkkQYRc4LDdtEVmMFNyBE99CjoQSVEI19a
	rMkoikt3HDEoNMjIYDjeEgvLu0HG5T5Qk+Qtsr12jr0nyOduMM9qr/NL64b6remgQ/wnMIrmdH+
	3SNTk5l/J58iCZRz1niYpfhQ4KqcKnFNzL4FfdGX8OA6ECVS2Za1XpYwhJLvaBY7UbzNZ/iQr6F
	XiEtnkLiCX3pjPdd6ZydAsPnDNeFwII2EPJ2RtlTfgdSTEBQ8jTu50HYpUn4g=
X-Received: by 2002:a05:600c:1550:b0:493:ad11:6d5c with SMTP id 5b1f17b1804b1-4994e7cf0dcmr26391075e9.4.1785919765638;
        Wed, 05 Aug 2026 01:49:25 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903f5fd0fesm1209890a91.2.2026.08.05.01.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 01:49:24 -0700 (PDT)
Date: Wed, 5 Aug 2026 16:49:19 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, glass.su@suse.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix cached cluster count after suballocator
 reclaim
Message-ID: <anL1pYKZK8UqYwsI@p15>
References: <20260805070837.3390148-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805070837.3390148-1-matthias.goergens@gmail.com>

The code looks good to me. However, the commit log needs some revision.

On Wed, Aug 05, 2026 at 03:08:37PM +0800, Matthias Goergens wrote:
> When reclaiming a suballocator block group, first reduce the on-disk
> cluster count by cl_cpg.  The current code then subtracts that new count
> from the old cached count.

The current code then sbtracts that new count (fe->i_clusters) from the old
cached count (OCFS2_I(alloc_inode)->ip_clusters).
> 
> For an allocator with N groups, that leaves the cache at

For an allocator with N block groups, that leaves the cache at
> 
>     N * cl_cpg - (N - 1) * cl_cpg = cl_cpg

     N * cl_cpg - (N * cl_cpg - cl_cpg) = cl_cpg

     i.e.:
      ->ip_clusters -= (fe->i_clusters - cl->cl_cgp)
      => ->ip_clusters equal to cl_cpg
> 
> regardless of N.  This happens to be correct when reclaiming from two
> groups, but undercounts the clusters from three groups onwards.  The

s/groups/block groups/

> incorrect cache value is also used immediately to update i_blocks.
> 
> Assign the updated on-disk count to the cache, matching the allocation and
> inode refresh paths.
> 
> In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
> create/delete workload, the first buggy reclaim left the on-disk and cached

create/delete workload, the first buggy reclaim left the on-disk (fe->i_cluster)
and cached (->ip_clusters)

Thanks,
Heming

> counts at 2048 and 512 clusters respectively; later reclaims underflowed
> the cache.  With this change, the cache matched the on-disk count across
> all four reclaims: 2048, 1536, 1024, and 512 clusters.
> 
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index a4a2b87a45fe3..20c3aec6b9873 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
>  
>  	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
> -	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
> +	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>  	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
>  					     le32_to_cpu(fe->i_clusters)));
>  	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
> -- 
> 2.55.0
> 
