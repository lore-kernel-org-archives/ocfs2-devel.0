Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C290D2D46CE
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 05:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761544446; cv=none; b=kty80rVnTpF0uNKdgV+pXs7S8rT6dNDcZ7elW5zuDcWS5JSrP7sOcbn1p/ddgf0UTTUgyAzKK46pj+CHRiJnL3AhmFZOQvX1bZQaDD1gYxYKFcckwM79Dld4pPrY5H/CRLNAhAuW/rVZ4Dnf/4cNvpvVjIZKSuhHg94JEEZ3oSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761544446; c=relaxed/simple;
	bh=u+EU8KKrH5ID+5HbxOkW9Wqcr8VXA7wNxx+OfG6IZfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cStlTojizJ8Liia3mxgWeF/cVG0yrEGkzXLYQHWMcT1nulFjhhzhTdf0Gbbz+mDFvhj1iHKsOwb/41PLXizmZVWzcO69/j9KAQx6Ze2ZDgevzc5T+YmmCnw85jwdF063rcXllxCDv0WW/hlURB/xdbuOzJVpoLqKhWy7wABa4pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M8zI7EuJ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M8zI7EuJ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-427054641f0so645857f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Oct 2025 22:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761544442; x=1762149242; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/njuYphPXe8hfmDWuFlJW6IGw1olfhhXsWRDHoUnG8=;
        b=M8zI7EuJSCtIP1MJKOywHK/dLOww4eRBYYmeN34z8EHG9Fkaz2RTHTv4YQ6uXVuEU3
         KAshF0iUGKd914vcbVLULlHV0c/imkGcbNb4qFxcYsFfkVCfHE68DQ08jWxhtH7PZ20h
         dIcrlRBjKvuH/42ZhUHg7girzXe//9fGOo7TxAebgtsdSRHWRZaC/Krd4tFRs6gbFaS0
         IPRre+2jJrRDrrEuZJTxxg9jJkBSIjWqVIov6Winm0D0XfAuJzOJtlDymXSanO6jEcDZ
         Nh1qtOE5H8pmki97N7VGznUAOap2hMrrTon9hK5IFmMT8Z9Xx7A9u/w000cvVa3OWozC
         QAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761544442; x=1762149242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/njuYphPXe8hfmDWuFlJW6IGw1olfhhXsWRDHoUnG8=;
        b=VzufADE+qeyvP3QjuTo3zmSjnSS7ZdZgo/Ye+t4aOLkEAWNqspt011CVQCT631FGfo
         XQUrksZWFqHzYrrBwDdDIKaYyFMYM9ZjkRhpoDGku1fXlvhAlquW+kJckxqwL/WoCARg
         g/zUIoufVI2aseeOa2k3UxjpZqQpSfE5hWW/u6FC/eg8/2wysGj+6CPuGKvbKs5zp//r
         5XSK3Y/EcO4sc7BcLvGLhwzpmNhJHdI9aHNMQBL2O4cmH7qJC3/FGCJnZHXl/htglm1s
         YArO8cVQngiKKNwY0zYITD05JQuXxHHzAoo2PFRqXp1x0f+YSQjJVK3QhNC9sK3Iqhux
         ijUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwBn8xQ3kWniIm4VLdTKi/IIAYSSEFpnqX6SohL/clt7hICub6XN5rLl8+rtzHsBeKF118QEeuler79g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIOlvc9eZBYfCMsXsx0DzCHcKLtrp/NwF2cbIATdKeefSfOjpe
	6S44/ZhIwN2NmmsO2ML2KgIJ+wYEHlsCT3llnvplV0aQEhku5WxL3ipOxDFJgJwSXlKIzkkfQZ+
	FZghr
X-Gm-Gg: ASbGncu1gdweu5vK3YxFRglnZJ07jEgX7F4Y8DoSowgNpfdfHbqUtNeRYOdCKMnMy/0
	Nmde91JueNWQZOZUiiritvGrlaM5eU3bXg0JyKo1wyugbXcbDSFRAbLNoGK6bDJyYc+G3nKu6Gl
	d+tqpo6//xmW6QD1JlfS267GyqtMenxUoh3ARgF6HTxnyG8HUinZc+yO25MFchpfvpSTkrfsF/s
	5IJ/oK+MJOSsOHE07I9Rm+/hEFlBaBGtopFKBiTJXbt9+vbmDZ16Wv1xpu15SfRHtZxC61vA7uK
	taV72aSkxLcE51INqZ5FUEex31RoRs6jnVkmLkwd4YNTVC33L/V5hbq+6jTEHjcBPtiUWGo5QZS
	9AROPdWz1yLQOA0TyEHL7G+GnVgjwgJa4SIXkCjjMHngzeQFE6TG0kVBjjrlRGLj9DX5e7dvX7D
	wmWszB51C9JA==
X-Google-Smtp-Source: AGHT+IG8MPLs1qrZR256g1yVGjEve1aePQI2yiy3sIO7Ehk1lRgqgFIz7r7MQW1cSu+i/lCdhODwrA==
X-Received: by 2002:a05:6000:200f:b0:426:fff3:5d1a with SMTP id ffacd0b85a97d-4284e557389mr8886837f8f.6.1761544442058;
        Sun, 26 Oct 2025 22:54:02 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414012899sm6842506b3a.0.2025.10.26.22.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 22:54:01 -0700 (PDT)
Date: Mon, 27 Oct 2025 13:53:59 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: use correct endian in ocfs2_dinode_has_extents
Message-ID: <yftcjac4lb3j6pkszvd5mvb2myqbfs3k72ey6nj4wgyv3lc2z2@6fny5k356udd>
References: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>

On Sat, Oct 25, 2025 at 08:32:17PM +0800, Joseph Qi wrote:
> Fields in ocfs2_dinode is little endian, covert to host endian when
> checking those contents.
> 
> Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..0a0a96054bfe 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -201,13 +201,15 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
>  {
>  	/* inodes flagged with other stuff in id2 */
> -	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
> -			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
> +	if (le32_to_cpu(di->i_flags) &
> +	    (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL | OCFS2_CHAIN_FL |
> +	     OCFS2_DEALLOC_FL))
>  		return 0;
>  	/* i_flags doesn't indicate when id2 is a fast symlink */
> -	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
> +	if (S_ISLNK(le16_to_cpu(di->i_mode)) && le64_to_cpu(di->i_size) &&
> +	    !le32_to_cpu(di->i_clusters))
>  		return 0;
> -	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
> +	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
>  		return 0;
>  
>  	return 1;
> -- 
> 2.39.3
> 
