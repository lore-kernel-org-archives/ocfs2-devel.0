Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ECB79F5
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022674; cv=none; b=allMTfAPL48px7HwzjRfWX+q7V7oDjC0TbmXEZB9OXM6wjG4UyuLxCSwKOsrN/1o1vLlxhMN6C2ZndUT5OVP52DmT0X7sTzoFHJkkRfQVzSY/fBRHbot45/uZ1xgvpaN1xZZYGNzzCwOVlX8QS9Iromm736JF2ihpTcmihi/PhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022674; c=relaxed/simple;
	bh=UEmFTEKZdYKugKn0hTOij+HkWRJmS/Y56HXPJuPyhtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uvdaywVuxbcJvXbDsuWPHl1GcROPwu24TvLzwahMSnpncPikdodYc0KOx5Zs4SarhSLdt+s8P19ur2ZXIhe1qCdpvfigOsG0jco0WsYWPoXI8synK7xYbujneR474MIIpdMJxATdhhYwOHWoKTNlVI5QTANfIH5X0EMg06ALBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vgA6KsjE; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vgA6KsjE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1712022670; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aDuzgLKUPR3PQeJLJPYTb5ueF9H2Ov6m1kERYwkXKiE=;
	b=vgA6KsjEIWcdeUr+pcyau2ZRzlfvp4O2+lgqnX2zM6BAdxeJHtpe6HY0y3FnmthS4lqIh/1Z6iC/6i6aE7zkUsmQdWM91Rck/clUl/nxx6Xr9oPN4ykpgOnhuaxkIXWyUKDVRHLJOYNpsZ3FwbGevLFMkJv1YuKEo+OLspwonfM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3mOrwF_1712022668;
Received: from 30.221.129.162(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3mOrwF_1712022668)
          by smtp.aliyun-inc.com;
          Tue, 02 Apr 2024 09:51:09 +0800
Message-ID: <9a2b1886-1f5c-4fde-8020-0ef21cd37f5f@linux.alibaba.com>
Date: Tue, 2 Apr 2024 09:51:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ocfs2: return real error code in
 ocfs2_dio_wr_get_block
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev
Cc: akpm@linux-foundation.org
References: <20240402014651.13723-1-glass.su@suse.com>
 <20240402014651.13723-2-glass.su@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240402014651.13723-2-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/2/24 9:46 AM, Su Yue wrote:
> ocfs2_dio_wr_get_block always returns -EIO in case of errors.
> However, some programs expect right exit codes while doing dio.
> For example, tools like fio treat -ENOSPC as expected code while
> doing stress jobs. And quota tools expect -EDQUOT when disk quota
> exceeds.
> 
> -EIO is too strong return code in the dio path.
> The caller of ocfs2_dio_wr_get_block is __blockdev_direct_IO which is
> widely used and it handles error codes well. I have checked functions
> called by ocfs2_dio_wr_get_block and their return codes look good and
> clear. So I think it's safe to let ocfs2_dio_wr_get_block return real
> error code.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
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
