Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021FB1A239A
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784596131; cv=none; b=mcQWA9kZzdZ+6opS6viv1rJYpV12sCwjpvibd691FxXU3KWJYIWDJziB7PQ9MChWhaGvz8wiOkHJyXNfP1Cy1v6ojoChKH/XZtimpQcLmUhljtbfvXIV+rmvrSPgc+X4BXifmN/54XOSiUXdtASHWuwcyvJFDo5YA+HRllnHRGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784596131; c=relaxed/simple;
	bh=yQW9BpTRoM4erxzk5/SAkxgWc34OWidz8X7nFQLpeME=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=GGjm3vhq944XhnzXJeTlViRrquj7oYlXTboICymmZBm+rpgkcTOFD9mitHgMsB3QOav8hex/gkSBdAItfbFAvTAT2Zp7ipXEFE+QAb7KWLhVLps2bhU9wu4DVDtcLgxCumfXfSPzepfF9cHVRZ9uBSpisrQJ8cMtZRTXrXI+Qtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Wz4QZpTH; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Wz4QZpTH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784596120; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=89vvMoM5LmIGrWrLgI2HXEvxQqgOCPIiuWNnuqEnJUU=;
	b=Wz4QZpTHbDNxLPfp62uFdHd4ujpmUR+zkrSyKRd84FUMBWCh61OaNd8Bka5kmpiS1Z2tCO24+5RbZxbccjIqKbSTGnO/73CsD1EvT+psIbKBmnhosfull2pFrEA33qTk37gH+k/1UNd4n6HkFx7UUtvxOIgePxKQhM3eyHzd95I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7XoKKw_1784596118;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7XoKKw_1784596118 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 09:08:38 +0800
Message-ID: <a693bbc7-52fb-4efc-a4de-fa597cff24c8@linux.alibaba.com>
Date: Tue, 21 Jul 2026 09:08:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: free unused clusters on defrag move errors
To: Guangshuo Li <lgs201920130244@gmail.com>, akpm <akpm@linux-foundation.org>
References: <20260720141944.485212-1-lgs201920130244@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260720141944.485212-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/20/26 10:19 PM, Guangshuo Li wrote:
> ocfs2_defrag_extent() claims new clusters before calling
> __ocfs2_move_extent(). If the move fails before ocfs2_split_extent()
> succeeds, the claimed clusters are not referenced by the inode and must
> be released.
> 
> The current error path only logs the error and continues to
> ocfs2_cow_sync_writeback(), which can overwrite the original error with
> zero and leave the claimed clusters allocated.
> 
> Not every __ocfs2_move_extent() error can free the new clusters. Once
> ocfs2_split_extent() succeeds, the extent tree references them even if
> ocfs2_decrease_refcount() or ocfs2_truncate_log_append() subsequently
> fails. Freeing the clusters in that case would leave the extent tree
> pointing to clusters marked free.
> 
> context->new_phys_cpos is updated immediately after a successful extent
> split. Compare it with the newly claimed physical cluster on error. If
> they differ, the split for the current move did not complete and the
> claimed clusters can be freed. If they match, leave the clusters
> allocated because the extent tree already references them.
> 
> Return move errors through the transaction cleanup path so that the
> original error is preserved instead of being overwritten by writeback.
> 
> Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v3:
>   - Fix the duplicate split_started declaration.
>   - Reuse context->new_phys_cpos to determine whether the extent split
>     succeeded, as suggested by Joseph Qi.
>   - Avoid changing the __ocfs2_move_extent() prototype.
> 
> v2:
>   - Do not free the new clusters after the extent-tree update has
>     started, as pointed out by Joseph Qi.
>   - Track whether the new clusters remain unused on error.
>   - Preserve __ocfs2_move_extent() errors instead of allowing the
>     subsequent writeback call to overwrite them.
> 
>  fs/ocfs2/move_extents.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index ad1678ee7cc4..7820df90a262 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -310,8 +310,12 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>  
>  	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
>  				  new_phys_cpos, ext_flags);
> -	if (ret)
> +	if (ret) {
>  		mlog_errno(ret);
> +		if (context->new_phys_cpos != new_phys_cpos)
> +			need_free = 1;
> +		goto out_commit;
> +	}
>  
>  	if (partial && (new_len != *len))
>  		*len = new_len;

