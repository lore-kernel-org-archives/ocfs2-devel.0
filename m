Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F8E31ED66
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768834163; cv=none; b=kEUmZCpJvv+Uuo/miV5yy8S8RAwHXb44bd205FhDoOQfAugbb/mo74QfYj2zqV/IV02xRW+POnhSBq5EsXzTXs6aNYIvcMIZxfJGtoAbclK/mqNXHU1zcwuPAnnBL9IpP8mdwKn7+xCPumsbMOrRjIJE5TZ/Ano4+uo8De4Oimg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768834163; c=relaxed/simple;
	bh=0u6sBpCxZnotqDcNs/tM/BY8PcTHp3EA8t7dw7tbf/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tB1d6famvG2xtTcWD2uuZK/zwqGC99l5VheFuEQlHe4wNoWaw2iDPrLVX4OvZSigy+Zk1uxiwEPS+B5g3CNnSLMF/pZ5OrqEvnC78e3F7ZyeJY3687ryoJHy3ZdCE42MUGncosCh5yprGVEsFG93S5+aJZ8Kj3mB3j02VIMJVBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bvJ7bGHJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bvJ7bGHJ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801c632109so1763595e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 06:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768834160; x=1769438960; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JCcha9GOzlb5VHrdIzazKOTH6/pKsbFmBEXD01Wri8Y=;
        b=bvJ7bGHJ2ClxxLFLC5PQzBf/sgYq8V66p4zjvV/nzquSM8V7Jefz71K34hUYulkObL
         Y9lEwn9se9woVeIt/tj3q7zGJMyIZ4OYuRAwwdo87prqOliBCGl0GQHfRIssP72oZmsW
         n8ByW2eSsBr9cWW159FnmeMi4EIGBiPMyND9bi5zal+vsRhvgOJwj2EC4A7XJ1/I74FT
         bMfexB8m8jXyDffMLo9rq98x3NN1gNV1rfoTIm8W0QUuBD8lvDKfeJIzFnQ1e3BA0Fdl
         nnPOrPwBPnd7CXAaK/NFxvspOnXa2hohHM07ETdi/K2m83VNdQid2Xbt/etWmfAL20nt
         BCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768834160; x=1769438960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCcha9GOzlb5VHrdIzazKOTH6/pKsbFmBEXD01Wri8Y=;
        b=BRFfRLjkrEAKErxUchvj8gshcJusdE56ecRR+7FYFbbE6WsJnOWmPT3MPu3WjdCB3p
         v0zJC2dU/EJaCHgTdA31KK5yLibhyEST3c8Tk/tKm8d6y844lfzuKYS+xb3sb+XboEDW
         7QfCrzEdEqIhMaQebi77cFjhKEUQNeZYyEIBphSF11xoSI/CgP5XaGAVhCeIg/hFXOpa
         G2wmEYUxQh4oKCJ/Rq3fHWiy80L3PDV85EFkkkmeVY/uGRUx4J8fX7XTzAyUYHxf16Pu
         +oka/I4CD3+Kb/7h9hhmAnjfcV/44sAMsZuX/Vujti4cbkMcjyoasbLNYYMp8ZuCy4T9
         MQog==
X-Forwarded-Encrypted: i=1; AJvYcCX72YxyYMfFgh+xUFYj3bALMdrk92oYyxGfnC1quqzfSQGuldbQ5Jgr7zj4U4VGhcRWDdK2V2LY498ikg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwTOEGKGlhhv19PMT6/bpluRuwyL7csE9iQlppbL6jJDs11qdp
	s2kziAOxxmpKzVdIwPbbdpQ/LljPNGN4y1ul3N6rkt/Qg3Mw+Zsm3KVn1+aFDHAyYzw=
X-Gm-Gg: AY/fxX48hO7Chpnbnzx+Bw/qW7LwAuMgjswZDLAxrQzpz7rezSR5SdpKBBpGusEBKvl
	dgEiLXEFzI7C64H5u9+97laPoHxyPbEtzDdPoHmKMPzKjop4VZlzkB19FenDv6sHbmtjF5n4ij9
	r6XCTNPxTi1rXOPxUyJxnc2DRvjWq3v2aly34z/Af+L+Txg7Eauae8l73hid8f9yul07syomoxf
	rwdEmPRAJCDBJNeLnagqhmr6PZlMkSTBzrntXpQW59bNHGAQRa66JR0etu3b0XA+Ik1HTxYsK6a
	pIdm7IV0bVgh5vEbZ3QdR91Wm02ZC/jhBop76/mDZ0uZB2JGjqWhhrLDfMvtSZteNAyu0cPvrkG
	8f//TZwwaTCIdcgGq4UJbX+TRrZqm1RVOYqw7GUDAIoM96+DtumC3WayAuLUwF89FTO4cMI3cNE
	fyJqVE8/A1fA==
X-Received: by 2002:a05:600c:6212:b0:47e:e20e:bbb6 with SMTP id 5b1f17b1804b1-4801e31e0f6mr78140845e9.1.1768834159826;
        Mon, 19 Jan 2026 06:49:19 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12b2bb2sm9550969b3a.59.2026.01.19.06.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:49:19 -0800 (PST)
Date: Mon, 19 Jan 2026 22:49:16 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix NULL pointer dereference in
 ocfs2_xattr_get_rec
Message-ID: <ywzkg5c3z5bwugddfhsqcybzj3mw2yys3al53pjfede4rjp7qk@gzfcpu4etohi>
References: <20260117173556.36601-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117173556.36601-1-jiashengjiangcool@gmail.com>

On Sat, Jan 17, 2026 at 05:35:56PM +0000, Jiasheng Jiang wrote:
> In ocfs2_xattr_get_rec, the variable 'rec' is initialized to NULL.
> If the extent list 'el' is empty (l_next_free_rec == 0), the loop
> iterating over the records is skipped, leaving 'rec' as NULL.
> 
> Since 'e_blkno' is initialized to 0, the function enters the error
> handling block 'if (!e_blkno)'. Inside this block, the function calls
> ocfs2_error() and attempts to dereference 'rec' via
> 'le32_to_cpu(rec->e_cpos)' and 'ocfs2_rec_clusters(el, rec)'. This
> results in a NULL pointer dereference and a kernel panic.

Do you have reproduction steps to support your analysis?

- Heming
> 
> Fix this by ensuring 'rec' is not NULL before accessing its members
> within the error handling path, or by checking for an empty list
> explicitly.
> 
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 1b21fbc16d73..b018c84dbc05 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3757,10 +3757,16 @@ static int ocfs2_xattr_get_rec(struct inode *inode,
>  	}
>  
>  	if (!e_blkno) {
> -		ret = ocfs2_error(inode->i_sb, "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
> -				  inode->i_ino,
> -				  le32_to_cpu(rec->e_cpos),
> -				  ocfs2_rec_clusters(el, rec));
> +		if (rec)
> +			ret = ocfs2_error(inode->i_sb,
> +					  "Inode %lu has bad extent record (%u, %u, 0) in xattr\n",
> +					  inode->i_ino,
> +					  le32_to_cpu(rec->e_cpos),
> +					  ocfs2_rec_clusters(el, rec));
> +		else
> +			ret = ocfs2_error(inode->i_sb,
> +					  "Inode %lu has bad extent record (NULL) in xattr\n",
> +					  inode->i_ino);
>  		goto out;
>  	}
>  
> -- 
> 2.25.1
> 
> 
