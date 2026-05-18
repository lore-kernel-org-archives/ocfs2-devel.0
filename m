Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B492231A23
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779068323; cv=none; b=qH3S1wj5DVkAz5ie5IoELneCSEl7iSUr/fEmb5LgwLUK0rX/VmsnNyXDrAT75vPVAMEdiFwVM9m9YvKyI+aWIyHdr9LClzwXwHtcEjwhBOTju1drMkJotumPMTzgI9QMLoG+rcSczZV+Kbjac3qsDAS8NqmiFJ8Cr8bGBbCzoRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779068323; c=relaxed/simple;
	bh=qg4sppiLXyw8H+8vGLaCG/p5asDVGT22b9mDjBpcKjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNVpPs7Z/TmDlDZWrDRmFoXJE96Mz7ZUfjt+ipsKYMdiULZiTsgP07SMMYME+FEAPKVLs7jF9XJdQy0FjDxVnzvhA90l+ZH/svX6rlv8GcJO+HKvlB1XMSdHlmZai1Qd3lWAb2HG4oa2oeJr63L3FreWzXNHd36fSl3tBSbQkvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bFvFCjXt; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bFvFCjXt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779068319; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SWIDsCGcp/zWFBuC85MvM1Rgn/v9xndqii9W0FaALG8=;
	b=bFvFCjXtrLT/3p4nCcsCn6ZXCEzLquMyzvdAIBScQ3ukja0sVPXsAyQbV22Qazd8Ax7AyPF2d5SyZ/Kva59/b0k7x0McOo1wKtVU0j1vlF4NxJyuix4xx6PWBjWlvbL5Lk3nrvJcI1Tf1BK0NurwK4cWyaPXtFD4jkOy7LikoWE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X32hiWi_1779068317;
Received: from 30.221.129.172(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X32hiWi_1779068317 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 09:38:38 +0800
Message-ID: <c507ecb2-0d1f-49ab-b5b0-4d6f3216db8b@linux.alibaba.com>
Date: Mon, 18 May 2026 09:38:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ocfs2: reject regular files with non-zero i_size and
 zero i_clusters
To: Michael Bommarito <michael.bommarito@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
 <20260517111015.3187935-4-michael.bommarito@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260517111015.3187935-4-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/17/26 7:10 PM, Michael Bommarito wrote:
> On a volume mounted WITHOUT OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
> regular file with non-zero i_size, zero i_clusters, and no
> OCFS2_INLINE_DATA_FL flag is structurally malformed: the extent
> map declares no allocated clusters yet the size header claims
> the file has content.  ocfs2_populate_inode() copies i_size into
> the in-core inode and dispatches to ocfs2_aops; subsequent reads
> or truncates then operate on an inconsistent extent state.
> 
> This is the shape an attacker who keeps the rest of the extent
> list intact (to satisfy the inline-data, refcount, chain-list,
> and per-field validators already in this function) would produce
> when forging only the inode header to publish a synthetic file
> size on a victim node.  It is also the shape on-disk corruption
> of the i_clusters field produces.  Reject early in the
> validator.
> 
> The check is restricted to non-sparse volumes
> (ocfs2_sparse_alloc() returns false).  On non-sparse mounts the
> allocator path always grows clusters before i_size:
> ocfs2_extend_file() takes the !sparse branch into
> ocfs2_extend_no_holes(), which calls ocfs2_extend_allocation()
> to journal new clusters first, and only then
> ocfs2_simple_size_update() journals the larger i_size.  The
> truncate path likewise lowers i_size in ocfs2_orphan_for_truncate()
> and then frees clusters in ocfs2_commit_truncate(), which uses
> ocfs2_clusters_for_bytes(new_i_size) as its new_highest_cpos:
> when new_i_size > 0 the floor is at least one cluster, so the
> on-disk dinode never legitimately exposes a non-inline regular
> file with i_size > 0 and i_clusters == 0 on a non-sparse volume.
> 
> On sparse-alloc volumes the same shape is legitimate: an
> ocfs2_extend_file() call goes through ocfs2_zero_extend() +
> ocfs2_simple_size_update(), which grows i_size on its own
> without changing i_clusters; a freshly truncate -s 1M of a
> sparse regular file is therefore on-disk
> (i_size = 1048576, i_clusters = 0).  The check therefore opts
> out via ocfs2_sparse_alloc(OCFS2_SB(sb)).
> 
> System inodes (OCFS2_SYSTEM_FL) carry their own size and
> cluster invariants validated by the allocator, journal, quota,
> and truncate-log subsystems; skip them here.  The inline-data
> fast path is filtered separately by its own dedicated branch
> below: its well-formed case is exactly i_clusters == 0 with
> i_size <= id_count.  Symlinks legitimately keep i_clusters ==
> 0 with non-zero i_size (fast symlinks), so this check is
> restricted to S_IFREG.
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 305e22cc9b1d9..c63d2ced6b338 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1571,6 +1571,47 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * On a non-sparse volume, a regular file with non-zero i_size
> +	 * and zero i_clusters that is not marked as inline data is
> +	 * structurally malformed: the extent map declares no allocated
> +	 * clusters yet the size header claims the file has content.
> +	 * ocfs2_populate_inode() would still publish i_size to VFS and
> +	 * leave the extent state inconsistent for any later read or
> +	 * truncate.  This is the shape an attacker who keeps the rest
> +	 * of the extent list intact (to satisfy the inline-data,
> +	 * refcount, chain-list, and per-field validators above) would
> +	 * produce when forging only the inode header to publish a
> +	 * synthetic file size on a victim node.  It is also the shape
> +	 * on-disk corruption of the i_clusters field produces.
> +	 *
> +	 * The check opts out on sparse-alloc volumes, where the
> +	 * extend path (ocfs2_extend_file -> ocfs2_zero_extend ->
> +	 * ocfs2_simple_size_update) legitimately grows i_size without
> +	 * allocating clusters.  On non-sparse volumes the equivalent
> +	 * path (ocfs2_extend_no_holes) journals clusters first and
> +	 * i_size second, and truncate-down floors i_clusters at
> +	 * ocfs2_clusters_for_bytes(new_i_size) which is >= 1 whenever
> +	 * new_i_size > 0, so the rejected shape never appears on disk.
> +	 *
> +	 * Skip system inodes (OCFS2_SYSTEM_FL) and the inline-data
> +	 * fast path (handled below).  Symlinks legitimately keep
> +	 * i_clusters == 0 with non-zero i_size (fast symlinks), so
> +	 * restrict to S_IFREG.
> +	 */
> +	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)) &&
> +	    S_ISREG(le16_to_cpu(di->i_mode)) &&
> +	    !(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
> +	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
> +	    le64_to_cpu(di->i_size) != 0 &&
> +	    le32_to_cpu(di->i_clusters) == 0) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 (unsigned long long)le64_to_cpu(di->i_size));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  

