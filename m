Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9183B52FB
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 07:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868529; cv=none; b=ehMjEsTiXohZVCC7wC07WTG0NP3EVlisbK1y9BjXzP6A3T2LodotNK52vntqaFqtN+z9phe3nUzY4KVOGFCQXYyekg+QCkpoFLptgM/7XFxLKxZ1kcw6ZsNqa++ll4GSyCjL6qTVtfs+jRgc8xV9vZvyVn7ZTpXKOvGqJddCBj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868529; c=relaxed/simple;
	bh=kNKnRUj/qmc+iS0euH+So18tOdbUbYE8PJbrFOxptes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=obRlwaex8jwa12jcxJKhOHuchoOgdpXtA/024wjHfGC7JPLlXPGHSOnmcdutJGYj0ifBZhueG0bYj0fCbUsHKvTnhnaPvAgC0fs0jDvcawmjM2tqy+I5w0qjF+33Tsvg692BBpcohmuN/L8M5JmXAb5BBn5uxKi31SVNt9Uddt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rLWMfWnX; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rLWMfWnX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779868525; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kxK9ak3kS1f+m6OltbJntLRNfyX+Ys2dJ/fXYTcJn9c=;
	b=rLWMfWnX74h0FgJBxIhjTODKufRuGnFpyfTB37HEza9+H8PqPI07EXLDA/U4ywCdvOG0h9rRz4w+sE1fO9+EprZuV2TLtFOIbI7BbX9eXiHAPg327EbHXzYuc2VzB/eMNjdr8W6V6aJ6AxR8bdX4s5r5RuABRObBlc35QT0rUOw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3irpX9_1779868524;
Received: from 30.221.145.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3irpX9_1779868524 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 15:55:24 +0800
Message-ID: <3863dc00-0b8d-43cf-8e68-cbc9c9bc8665@linux.alibaba.com>
Date: Wed, 27 May 2026 15:55:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/34] ocfs2: Convert ocfs2_read_blocks to bh_submit()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-21-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525171931.4144395-21-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 1:19 AM, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: ocfs2-devel@lists.linux.dev

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 44a4fa3dfbc0..4d3f03f99a8a 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -321,11 +321,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  				continue;
>  			}
>  
> -			get_bh(bh); /* for end_buffer_read_sync() */
> +			get_bh(bh); /* for bh_end_read() */
>  			if (validate)
>  				set_buffer_needs_validate(bh);
> -			bh->b_end_io = end_buffer_read_sync;
> -			submit_bh(REQ_OP_READ, bh);
> +			bh_submit(bh, REQ_OP_READ, bh_end_read);
>  			continue;
>  		}
>  	}

