Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5C026AFA
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jan 2025 11:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737459222; cv=none; b=WdfS7j0HqdMLMV8CiKU30c5UYOTO4gpXWzMNrSqVrRYvJUqQTLpmlc49WPiQYHvbc8YueOj7MU8wmp2moffWKQ8gTyc6WDrsv+UbOm8j7vZlIl2tJuVokGf/DgJSNaozrTI409K5oV2sQGEfn/Po1mCZKGLFj9eQOmFmI6sYZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737459222; c=relaxed/simple;
	bh=6G62iQYzPR6r+K/s3gNwFseE/AEifYFbjoE55TuHgrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6SdCAN3ky3cBeGoGDzLFS7cFs4eLiccMEkVUqff3k7c4fcDrp43ki4eI8wVW9Rljgg8zQPn2J0lq/SJflwmr+wj58vOIowyVydqZIDBIBTpiEJRhyBgOQX5rmb3QqR7XjD8XQXJIgwuUw5k342qtNsgrSEkTxkJwxgEd1uUZHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PFlv/Zlb; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PFlv/Zlb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1737459211; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UIocT754iwmFWXnCYQZUTgWJeXNxCva3MnB4mlAl26c=;
	b=PFlv/ZlbRdMppQI5gFTTT8zISLUh+PUSuPb+VUeRTMJ0XKqLbKtHQceAkVPlnCcmla62iWP2QLqeS6ocvnTLu3rS7dIwv40shXjCEn3D49GOR5A+HlfZQhKkcXvEkrhGR3mf1X/TNgFToQSjBmnKU4kQ1n1rIWnCQ0SXxz4+nsw=
Received: from 30.221.130.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WO5FJbV_1737459209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jan 2025 19:33:30 +0800
Message-ID: <020e497f-54d2-44d5-aee5-625cb430de6b@linux.alibaba.com>
Date: Tue, 21 Jan 2025 19:33:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix incorrect CPU endianness conversion causing
 mount failure
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250121112204.12834-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250121112204.12834-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/21 19:22, Heming Zhao wrote:
> Commit 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
> introduced a regression bug. The blksz_bits value is already converted
> to CPU endian in the previous code; therefore, the code shouldn't use
> le32_to_cpu() anymore.
> 
> Fixes: 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Thanks for pointing out this issue.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c79b4291777f..1e87554f6f41 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2340,7 +2340,7 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
>  			mlog(ML_ERROR, "found superblock with incorrect block "
>  			     "size bits: found %u, should be 9, 10, 11, or 12\n",
>  			     blksz_bits);
> -		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
> +		} else if ((1 << blksz_bits) != blksz) {
>  			mlog(ML_ERROR, "found superblock with incorrect block "
>  			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
>  		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=

