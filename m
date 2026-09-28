Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5646235E1D1
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 01:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790559205; cv=none; b=IAuDlBJLqq4os8q49hyneetLTcp6Ikd+/lQrm6rFUR/EBwNLoKf9tUvKInQ2dxr7FkTWqJqqh79XgaVzlMqe9CM4uoixgKVCU9MBGvFeCzmb31ULXvHexzP6lUVM2CYkiIgqV+nVKhCJGwr+FLRkHPQManq/F+6vwa9bbjfGW08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790559205; c=relaxed/simple;
	bh=SVQkkOjcFpzF23UJI4UvDp/q4m82LfGsuJgV4Dy3sK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=CGUVQ2a61XeVW/wxgdR39JKBEnD0yHpSM0ik1qvtWU2+b8deq5KCMBdTDu525E/OJUmdQULKCbOVEoFzhjTuV2wf/2BrnsqXfCXydIEUeHWp+oNRnsrx8hg690oPLtNJfSPVGnZwCFFcAGZx1oCgv+ogy1PuvOLahvrYzXLjmNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VgGLTs5X; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VgGLTs5X"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790559194; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RJAAXUqUBPmvFVa1V8NjamlXm++I27vg4KTloTXHO2Y=;
	b=VgGLTs5XCijwpZr0pmsYmU127USUujTL+IpycIvaoGpqt2bDqWtNw53XrtQ76Vx53Ttbd836D5QcpLDeQpr3rCsGx/7cpaqb4PpUTNT45U2wHJ1lF2fU+BrfN4KrL/ALohKly1zOLj64MoU4lPnqQ4X2ayhgiKYtsqA5s+WBhvk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBgz1Bs_1790559192;
Received: from 30.221.128.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBgz1Bs_1790559192 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 09:33:13 +0800
Message-ID: <744a70bd-5455-421f-a37d-1c0a63f54b60@linux.alibaba.com>
Date: Mon, 28 Sep 2026 09:33:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate extent list in filecheck repair
To: Jiale Yao <yaojiale02@163.com>
References: <20260926131848.3379842-1-yaojiale02@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Gang He <ghe@suse.com>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260926131848.3379842-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/26/26 9:18 PM, Jiale Yao wrote:
> ocfs2_filecheck_validate_inode_block() does not validate the embedded
> extent list, while ocfs2_filecheck_repair_inode_block() only clamps
> l_next_free_rec to l_count.  The normal inode read path requires l_count
> to be non-zero, limits it to the number of extent records that fit in the
> inode, and requires l_next_free_rec not to exceed l_count.
> 
> Without the same checks, filecheck can report SUCCESS while leaving an
> invalid extent list on disk.  A later read through the normal inode
> validation path rejects the inode and makes the filesystem read-only.
> 
> Add a shared helper for the filecheck paths to check these invariants.
> The filecheck validator now rejects all three cases.  The repair path
> still clamps l_next_free_rec, but refuses to repair zero or oversized
> l_count values.
> 
> Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")

I'd like make this as a new ability rather than a bug fix.

> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  fs/ocfs2/inode.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 180107a11046..57168ed02915 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -249,6 +249,41 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
>  	return 1;
>  }
>  
> +enum ocfs2_extent_list_status {
> +	OCFS2_EXTENT_LIST_OK,
> +	OCFS2_EXTENT_LIST_ZERO_COUNT,
> +	OCFS2_EXTENT_LIST_OVERSIZED,
> +	OCFS2_EXTENT_LIST_BAD_NEXT_FREE,
> +};
> +
> +static enum ocfs2_extent_list_status
> +ocfs2_check_extent_list(struct super_block *sb, struct ocfs2_dinode *di)
> +{
> +	struct ocfs2_extent_list *el = &di->id2.i_list;
> +	u16 count;
> +	u16 next_free;
> +
> +	if (!ocfs2_dinode_has_extents(di))
> +		return OCFS2_EXTENT_LIST_OK;
> +
> +	count = le16_to_cpu(el->l_count);
> +	next_free = le16_to_cpu(el->l_next_free_rec);
> +	if (count == 0)
> +		return OCFS2_EXTENT_LIST_ZERO_COUNT;
> +	/*
> +	 * The exact capacity depends on i_xattr_inline_size, another
> +	 * unvalidated on-disk field. Inline xattrs only shrink the
> +	 * list, so the no-xattr maximum is a safe upper bound that a
> +	 * valid l_count never exceeds.
> +	 */
> +	if (count > ocfs2_extent_recs_per_inode(sb))
> +		return OCFS2_EXTENT_LIST_OVERSIZED;
> +	if (next_free > count)
> +		return OCFS2_EXTENT_LIST_BAD_NEXT_FREE;
> +
> +	return OCFS2_EXTENT_LIST_OK;
> +}

This seems a duplicated check in ocfs2_validate_inode_block().
So I sugguest just extract the helper from it instead of duplicating
a new one.

BTW, seems we don't have to introduce enum ocfs2_extent_list_status,
to make the checks simple.

Thanks,
Joseph

> +
>  /*
>   * here's how inodes get read from disk:
>   * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
> @@ -1835,6 +1870,33 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	switch (ocfs2_check_extent_list(sb, di)) {
> +	case OCFS2_EXTENT_LIST_OK:
> +		break;
> +	case OCFS2_EXTENT_LIST_ZERO_COUNT:
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: extent list l_count is zero\n",
> +		     (unsigned long long)bh->b_blocknr);
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	case OCFS2_EXTENT_LIST_OVERSIZED:
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: extent list l_count %u exceeds max %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_count),
> +		     ocfs2_extent_recs_per_inode(sb));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	case OCFS2_EXTENT_LIST_BAD_NEXT_FREE:
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: extent list l_next_free_rec %u exceeds l_count %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_next_free_rec),
> +		     le16_to_cpu(di->id2.i_list.l_count));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
>  	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
>  		if (S_ISDIR(le16_to_cpu(di->i_mode)))
>  			mlog(ML_ERROR,
> @@ -1893,6 +1955,15 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
>  	}
>  
> +	switch (ocfs2_check_extent_list(sb, di)) {
> +	case OCFS2_EXTENT_LIST_OK:
> +	case OCFS2_EXTENT_LIST_BAD_NEXT_FREE:
> +		break;
> +	case OCFS2_EXTENT_LIST_ZERO_COUNT:
> +	case OCFS2_EXTENT_LIST_OVERSIZED:
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +	}
> +
>  	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
>  		di->i_blkno = cpu_to_le64(bh->b_blocknr);
>  		changed = 1;

