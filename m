Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543D93515F2
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126878; cv=none; b=KtpGHgCmXuTgApkJAshDv6e7vmFVGQK+vdxyLVhgei4UbyaiEd3zvFUtaBzN/rKbphdNDjLteJ6c98uF7pkir4OHG5u+8LD6iUhkD4K9D1uyf/krKSnrtFqZQPAqU2VYz7zlRZmT9dE1n/O+MHJH17r707g1viSOqron5tRGyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126878; c=relaxed/simple;
	bh=mW3Vkfkxjp+H+5FmxGrHaec7y+NgR5m7QC1Xm8DDNl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YuWZv/3EivE0FeqYkeqgKCnUpgEaSnvc6tGljq2NrKfrVu8EKeXlACBrVaeOHRgCinsigW9E49ncFCoddKvX3X+giXC//RiyHwCEZksPAQDQz8FeGIcSNYu8r7hpXRaRpGKaTEObZ8ZbHSebr+G7sBR6C6oJqXSA+iWt/TH0+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MenRviod; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MenRviod"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790126872; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cD1YZ/WyUkw2qCPI2vFSMU0Kjpp4BrTGZOfKp+4KDFA=;
	b=MenRviodAWpyhOyywxWe8gbb1EHKmmTfKjmXOyTxfs6GqaYywmHvMmrEOsVgYw0pYzdjtYO0Q+jgm6Cs40RFWIAyNKGN31sGrlPFhfRonOaT/dmuMCR53egmpjHmRhtBt2AD2HIM3LJceiYwSdu4A4WA++t/nOKq++iswDlcnU0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBVIAlL_1790126871;
Received: from 30.170.56.46(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBVIAlL_1790126871 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 09:27:52 +0800
Message-ID: <c83f90ca-6712-4c84-8417-451cef65567e@linux.alibaba.com>
Date: Wed, 23 Sep 2026 09:27:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix array out of bound access in
 __ocfs2_find_path()
To: Giorgi Kobakhia <gkobakhi@asu.edu>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Xiang Mei <xmei5@asu.edu>, stable@vger.kernel.org
References: <20260922202159.2421642-1-gkobakhi@asu.edu>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260922202159.2421642-1-gkobakhi@asu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/26 4:21 AM, Giorgi Kobakhia wrote:
> __ocfs2_find_path() walks down the extent tree and records path by calling
> find_path_ins(), which appends entry to path->p_node[]. It only has 5
> spots.
> 
> A corrupted ocfs2 image whose extent block is pointing to itself causes
> __ocfs2_find_path() descent endlessly, writing past the end of
> path->p_node[] array.
> 
>  UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:677:14
>  index 5 is out of range for type 'ocfs2_path_item [5]'
>  Call Trace:
>   <TASK>
>   find_path_ins (fs/ocfs2/alloc.c:677 fs/ocfs2/alloc.c:1914)
>   __ocfs2_find_path.constprop.0 (fs/ocfs2/alloc.c:1882)
>   ocfs2_commit_truncate (fs/ocfs2/alloc.c:1924 fs/ocfs2/alloc.c:7286)
>   ocfs2_truncate_file (fs/ocfs2/file.c:515)
>   ocfs2_setattr (fs/ocfs2/file.c:1224)
>   notify_change (fs/attr.c:556)
>   do_truncate (fs/open.c:68)
>   do_ftruncate (fs/open.c:194 (discriminator 1))
>   ksys_ftruncate (fs/open.c:206)
>   __x64_sys_ftruncate (fs/open.c:211 fs/open.c:209 fs/open.c:209)
> 
> Commit a406aff8c051 ("ocfs2: validate l_tree_depth to avoid
> out-of-bounds access") already restricts el->l_tree_depth to be less than
> OCFS2_MAX_PATH_DEPTH, which is equal to 5. However, does not handle the
> infinite descent case.
> 
> Check if the el->l_tree_depth decreases on each descent. Maximum
> descents are restricted to 4 and the path->p_node[] array does not
> overflow.
> 
> Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Tested-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index be09e766ac1f..c85a472965d5 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1817,6 +1817,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  	int i, ret = 0;
>  	u32 range;
>  	u64 blkno;
> +	u32 prev_depth = OCFS2_MAX_PATH_DEPTH;
>  	struct buffer_head *bh = NULL;
>  	struct ocfs2_extent_block *eb;
>  	struct ocfs2_extent_list *el;
> @@ -1824,14 +1825,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  
>  	el = root_el;
>  	while (el->l_tree_depth) {
> -		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
> +		if (unlikely(le16_to_cpu(el->l_tree_depth) >= prev_depth)) {
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
> -				    "Owner %llu has invalid tree depth %u in extent list\n",
> +				    "Owner %llu has invalid tree depth %u in extent list (max %u)\n",
>  				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
> -				    le16_to_cpu(el->l_tree_depth));
> +				    le16_to_cpu(el->l_tree_depth), prev_depth - 1);
>  			ret = -EROFS;
>  			goto out;
>  		}
> +		prev_depth = le16_to_cpu(el->l_tree_depth);
> +
>  		if (!el->l_next_free_rec || !el->l_count) {
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
>  				    "Owner %llu has empty extent list at depth %u\n"

