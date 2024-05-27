Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2C63D
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 May 2024 02:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716777195; cv=none; b=XuH+rxFhL54FSExhtX3Tl04JuYM9/LubE2RYVvcCVKiWeppG5dSZsMJGgOydz+qnQkM+qL6NiP0F42IJta1GDCz+OLrmZln0lf44ZEb3FQN6toCFxlvAvQkoT9Y598qOZW9KMkWxYGJ6+ZWxTRpLsE+7zd8JWSGNfmwQZUqkBVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716777195; c=relaxed/simple;
	bh=wZH1DvPetZYfXxeV5CD1cBhK0z4ymdmb9HxMSr8feM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OiZaxTQZSu5qHYCg6E0zm7t6OIcjwZWySxkAMbNDJfkd7XqxB7as/wxU7QZSGK2uSG67noWKNaa8MAJ4+AgmlnLAEJL1Bsvd+VqgVYEdbfpiM3vVw52IEB4Gr2mrvPefZ9YP0oNSjbsWlGQZ67rDItsuaBCoJB5+/7SqhADUoa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xlmUq9nL; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xlmUq9nL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716777184; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+XXzhyIEHU938zz/Rj1obzB9ZpTYUZUMj9NcuIVQ83k=;
	b=xlmUq9nLVQqiQed9qK+K9FImFeRazBn5TX03KtsYHGiD5iWvlarnPzO0MxmWelPXaBufb9dlYrv1oTrDCQkQgAn2vub2YHAT2jgtaL9fR+JuY/inqrt4Av25abZpdfe6KN/XFCEbL4JteRifYV9BolhK+j0y4lYdOrtXuJBFUqM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W7Ctmc1_1716777182;
Received: from 30.221.129.180(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7Ctmc1_1716777182)
          by smtp.aliyun-inc.com;
          Mon, 27 May 2024 10:33:03 +0800
Message-ID: <059f5953-4f6d-4580-9bc5-685a03364987@linux.alibaba.com>
Date: Mon, 27 May 2024 10:33:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: lei lu <llfamsec@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240526110631.10618-1-llfamsec@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240526110631.10618-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/24 7:06 PM, lei lu wrote:
> Add a check to make sure all members of the ocfs2_dir_entry
> don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/ocfs2/dir.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..385576d86983 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -358,6 +358,17 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>  
>  		de = (struct ocfs2_dir_entry *) de_buf;
>  
> +		if (unlikely(de_buf + OCFS2_DIR_MEMBER_LEN > dlimit)) {
> +			ret = -1;
> +			goto bail;
> +		}

It seems that this check can be moved to:
while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
	...
}

> +		de_len = le16_to_cpu(de->rec_len);
> +		if (unlikely(de_buf + de_len > dlimit) ||

dlimit = de_buf + bytes;
So here you mean check de_len < bytes?

Or should we check more precisely, like in ocfs2_check_dir_entry():
(de - bh->b_data) + de_len > bytes - OCFS2_DIR_REC_LEN(de->name_len)

> +		    unlikely(de_len < OCFS2_DIR_REC_LEN(de->name_len))) {

This is already done in ocfs2_check_dir_entry().

> +			ret = -1;
> +			goto bail;
> +		}
> +
>  		if (de_buf + namelen <= dlimit &&
>  		    ocfs2_match(namelen, name, de)) {
>  			/* found a match - just to be sure, do a full check */
> @@ -371,7 +382,6 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>  		}
>  
>  		/* prevent looping on a bad block */
> -		de_len = le16_to_cpu(de->rec_len);
>  		if (de_len <= 0) {
>  			ret = -1;
>  			goto bail;
