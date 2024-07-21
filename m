Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12332BE4A
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jul 2024 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721574919; cv=none; b=menR0vZok2FIduvdxdG1793/QUAhlKEpV6NSWr2181fYRc4EM5XFVUHGNPH4rdo31ZS1EZ2GcxSwmVbXNdwUI8MIaESy7mW3RAKlyJ6C9ewoKEKJOEVyCV16JzJor+7GksSHbl8gr3BhH7IFrXaXNQJ/jK+ezs4nMh3Gc3R/p4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721574919; c=relaxed/simple;
	bh=Se0C3HRkbTts7Owbbb3oBqW1K+iUBUdtOA582vKA++U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XW5/xe8fZqnXuT/yKzvukUeClJR044eqUdv9lYpMqqLp/Qx/0RlwV/VquzGd1W9V0FFjexmD+eO4oB4Gmq5cfYsCVU/+2Y0jzG9e110H9sq6Yo92NPpCoWT3ekd0JAFmDu5JENDbnSboJCI9SXgIl7Uwpi9DkAibqBBI5QAYIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BW8ZtpWr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BW8ZtpWr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721574913; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WBCW9HFx0RtOXoQT55UTGw6tAitzJTf/AfiWaCG2MEk=;
	b=BW8ZtpWraEOTj7kk2v+5141+KNiUbOyY0zL2dOvugrO4lu6pQwDf6jL6ybh/jLRs0Lx+dl65IxAqUC+QtzvK5JGtRg+LR6ST1bnfot9vK2AKdPhigzF3dCgKRIaQI41Xz2V9al9F9llVERo8Khm3Aii/thkZQIh1SytHgGepM8Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0WAx8kbT_1721574911;
Received: from 192.168.31.113(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WAx8kbT_1721574911)
          by smtp.aliyun-inc.com;
          Sun, 21 Jul 2024 23:15:12 +0800
Message-ID: <8725c1f3-96ee-4a25-9dd1-a7d311bf78b2@linux.alibaba.com>
Date: Sun, 21 Jul 2024 23:15:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: Heming Zhao <heming.zhao@suse.com>, glass.su@suse.com,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20240719114310.14245-1-heming.zhao@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240719114310.14245-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/19/24 7:43 PM, Heming Zhao wrote:
> This bug has existed since the initial OCFS2 code. The code logic
> in ocfs2_sync_local_to_main() is wrong, as it ignores the last
> contiguous free bits, which causes an OCFS2 volume to lose the
> last free clusters of LA window on each umount command.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2 -> v3: follow review comment, revise the commit log.
> v1 -> v2: adjust 'if' condition to make the code logic more concise
> ---
>  fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..8ac42ea81a17 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  		start = bit_off + 1;
>  	}
>  
> +	/* clear the contiguous bits until the end boundary */
> +	if (count) {
> +		blkno = la_start_blk +
> +			ocfs2_clusters_to_blocks(osb->sb,
> +					start - count);
> +
> +		trace_ocfs2_sync_local_to_main_free(
> +				count, start - count,
> +				(unsigned long long)la_start_blk,
> +				(unsigned long long)blkno);
> +
> +		status = ocfs2_release_clusters(handle,
> +				main_bm_inode,
> +				main_bm_bh, blkno,
> +				count);
> +		if (status < 0)
> +			mlog_errno(status);
> +	}
> +
>  bail:
>  	if (status)
>  		mlog_errno(status);
