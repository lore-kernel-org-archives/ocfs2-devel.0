Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD31885BE
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 06:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739513916; cv=none; b=fX9zG4UC9oNZ22iXB8ZFljsD7HBVYcNxU9QSklRJ4T6OsBy8pa2QxsJUkBVZz9rlyFd27Hh0NswE51xUSZUaZV7lVrVznQ5LwYIJ1blSZfZ1yt2AoAy3TyL/4eoGmDAGLHtAlcSk9Zel6ru+S5UsUE15vVMksFwnT3bo33LB5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739513916; c=relaxed/simple;
	bh=0HETSp4pmmvjNN1DgIVpNcce5dCbtglud0p0QHKoMzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mu+oib5PwdBnmfT5kfFp0p6EvBOy9GKm6gmovLkm/ASC+3FkXHR8ilwlGePIsJxWLCxOSvGB7CZ0iEfCzA0YjAiT4qcn4+9PsteaTzdsyIvWPXBzwF4ER4Utrx0j/SML215BkdoGOMoRZGaOsY+EXrLGoougB37bVheoS5pS9/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LT49jobL; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LT49jobL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1739513905; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PuYGKsFncvAhPtWK3+j5Q+//S+1/fBy7fbKsaBB8yNo=;
	b=LT49jobLfgPehBqsDdTSDN71HpsmFkAJ/a2I0M3EOJblqFfzsQ69gjipMoMqxIox+7m6b+7uwbKQwqWZQjFYIbmkcUCO0fdJb7ySzPg93R/2LYTPdoyC1uypMtFJTpydMP8gMJFiCKd3tjHOpwiZ0muzkAjx7JVH8iQgOid1ohI=
Received: from 30.221.128.236(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WPPo2Gj_1739513903 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Feb 2025 14:18:24 +0800
Message-ID: <2d12eb70-5fbe-415b-9970-78af2ab7945c@linux.alibaba.com>
Date: Fri, 14 Feb 2025 14:18:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate l_tree_depth to avoid out-of-bounds
 access
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: lvc-project@linuxtesting.org,
 syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Kurt Hackel <kurt.hackel@oracle.com>, Joel Becker <jlbec@evilplan.org>,
 Mark Fasheh <mark@fasheh.com>
References: <20250213191642.720812-1-kovalev@altlinux.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250213191642.720812-1-kovalev@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/2/14 03:16, Vasiliy Kovalev wrote:
> The l_tree_depth field in struct ocfs2_extent_list is defined
> as __le16, but according to the comments in the structure
> definition, the high 8 bits must not be used, meaning its
> maximum valid value is 255.
> 
> Add a check to prevent out-of-bounds access if l_tree_depth
> has an invalid value, which may occur when reading from a
> corrupted mounted disk [1].
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> ---
>  fs/ocfs2/extent_map.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 930150ed5db15..0d9c25fdec029 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -415,6 +415,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  	tree_height = le16_to_cpu(el->l_tree_depth);
>  
>  	if (tree_height > 0) {
> +		if (unlikely(tree_height > 255)) {

In fact we won't allow larger tree depth.
IIRC, it is OCFS2_MAX_PATH_DEPTH, refer ocfs2_new_path().
BTW, I'd like add this check in __ocfs2_find_path() instead.

> +			ocfs2_error(inode->i_sb,
> +				    "Inode %lu has too large l_tree_depth=%u in leaf block %llu\n",

It's not leaf, but root.

Thanks,
Joseph

> +				    inode->i_ino, tree_height,
> +				    (unsigned long long)di_bh->b_blocknr);
> +			ret = -EROFS;
> +			goto out;
> +		}
> +
>  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
>  				      &eb_bh);
>  		if (ret) {

