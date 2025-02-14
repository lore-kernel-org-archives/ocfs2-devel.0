Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25A24A049
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526968; cv=none; b=HMZZDZu02dG3BTxYZ2OC1S4YSFls+r72Kv/ny7YJXi4y8m/dVfCnmi60ZGFWwu+vf4CAzIanppX7Ecff5AfEIMa9b4pPb9oNd7BwFQlOEBzZreJWted2s/HWWKmZ/hBKcYKg7vYdhdbMOhIYSX2DYJFY6cGzJ0C3M+tY6o/3VCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526968; c=relaxed/simple;
	bh=+OJpQFCSwnAr0QKsPFczUVV45E7Dcuz3Varw1DyGdvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P46Y7gv4dZPzQ0swYIOl3KLvCTND5FIWoa6m1KPyhWj+BMFDpGCTxKLe4CzpDNcgJ6HPSwJjQCeH6Df8qAc2jVy4EnLwGKw9h3CyKBRexcWJeolAtQAh24LVNY4JtoVnENi9GrV2sRZ1GuCfhPu07Vn/fAc4jycRw8DX7ah3iaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MPqPbnfe; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MPqPbnfe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739526956; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sgtvYQK6mN5g++B1Dhn58lzoSeVR6IVgGu3OC+TT2Ds=;
	b=MPqPbnfeav17TRq4q+gkcdyLTyDpwSSAusqEqCxXpyKEVD+dGOqQfN8jkFOSnj6FfqeyHunzISFX429w+6Nz10eROXxC+BhH5uQoS9IS90oBbz2RrnTL3DCXeSbja+7dxjW5AFa169RtYawSGNNq4LE7J4ASTIYrnsu58Azm2mo=
Received: from 30.221.128.236(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WPQVN0m_1739526954 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Feb 2025 17:55:55 +0800
Message-ID: <f3ac22d4-10ea-4800-993f-f59952847edf@linux.alibaba.com>
Date: Fri, 14 Feb 2025 17:55:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate l_tree_depth to avoid out-of-bounds
 access
To: Vasiliy Kovalev <kovalev@altlinux.org>, akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, kurt.hackel@oracle.com, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
References: <bb8e95f6-ee91-47b9-82a0-86d576f67e39@linux.alibaba.com>
 <20250214084908.736528-1-kovalev@altlinux.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250214084908.736528-1-kovalev@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/2/14 16:49, Vasiliy Kovalev wrote:
> The l_tree_depth field is 16-bit (__le16), but the actual
> maximum depth is limited to OCFS2_MAX_PATH_DEPTH.
> 
> Add a check to prevent out-of-bounds access if l_tree_depth
> has an invalid value, which may occur when reading from a
> corrupted mounted disk [1].
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v3: Change the condition "> OCFS2_MAX_PATH_DEPTH" to ">= OCFS2_MAX_PATH_DEPTH"
> v2: Restricted depth to OCFS2_MAX_PATH_DEPTH and moved the check
>     to __ocfs2_find_path().
> ---
>  fs/ocfs2/alloc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 4414743b638e8..cec8fc5cb8e87 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1803,6 +1803,14 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  
>  	el = root_el;
>  	while (el->l_tree_depth) {
> +		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
> +			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
> +				    "Owner %llu has invalid tree depth %u in extent list\n",
> +				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
> +				    le16_to_cpu(el->l_tree_depth));
> +			ret = -EROFS;
> +			goto out;
> +		}
>  		if (le16_to_cpu(el->l_next_free_rec) == 0) {
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
>  				    "Owner %llu has empty extent list at depth %u\n",

