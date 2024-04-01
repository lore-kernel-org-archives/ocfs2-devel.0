Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6632B623
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Apr 2024 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711935904; cv=none; b=NJMorb3xkEhjeJitYDFl5/jtD7BS9uZDUTcUvSPPeUnPo3AoQxGi7MzMU8VNsef/tlnyd5qyRvG9kqQFB1wpl03Dhr2ih3D47bOORAziY4vG8s4yIv8dEqRB6ne6z2v8oW/TJM7oHCd7FqwdxnNKHKYk6oR3HLGIacWZ+728r+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711935904; c=relaxed/simple;
	bh=UQgRLt7Vmt9/SNBSxUsSptt4OP6D9zdi5OfcTXsDnMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NC4SffRGWVndhkCp1hneSXYopdXDC5eEe34nADw+JKcftSWdlun9xNklgZascnAdyEkvS+41KdaUpGOHappROYdq3lhZmOslUt36BYzxP6TUjoenL7rNaV2tQbQGATmN9ITisAAP75rulU/JQxdYmw019G36UJAtGWuVRy9Cs+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mKRbLro5; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mKRbLro5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711935893; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YbhitQTKK+zOg2u/BVbEQMbVgsfjR4Rv9qkqSGyq0Zw=;
	b=mKRbLro5V1q6M9j/zxSLTzp+769hBo8aUoB5N8P1nADrspHKzkNsj6mok37fgNiGs7DMM0gMuMcJW9wq9qqq379uaHHg8IMb0666nk1jfGRNmPfFZ4HzgaeImN5w1HmINrSa/53Hd6tgwqDsp5VD3Be75KRD/zngNdYkTfx59P8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W3ciNbr_1711935892;
Received: from 30.221.128.209(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3ciNbr_1711935892)
          by smtp.aliyun-inc.com;
          Mon, 01 Apr 2024 09:44:52 +0800
Message-ID: <3d6a2f6b-e345-4e31-9388-4d52c9a39739@linux.alibaba.com>
Date: Mon, 1 Apr 2024 09:44:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ocfs2: return real error code in
 ocfs2_dio_wr_get_block
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev
References: <20240331111744.7224-1-l@damenly.org>
 <20240331111744.7224-2-l@damenly.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240331111744.7224-2-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/24 7:17 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> ocfs2_dio_wr_get_block always returns -EIO in case of errors.
> However, some programs expect right exit codes while doing dio.
> For example, tools like fio treat -ENOSPC as expected code while
> doing stress jobs. And quota tools expect -QUOTA when disk quota

EDQUOT?

> exceededs.

s/exceededs/exceeds

> 
> -EIO is too strong return code in the dio path. I have checked
> return codes from collees of ocfs2_dio_wr_get_block to make sure

s/collees/callers

> the change does not hurt us.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>> ---
>  fs/ocfs2/aops.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index b82185075de7..f0467d3b3c88 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2283,8 +2283,6 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:
> -	if (ret < 0)
> -		ret = -EIO;
>  	return ret;
>  }
>  
