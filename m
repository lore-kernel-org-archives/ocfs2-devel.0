Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47877185E4A
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Jan 2026 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769398477; cv=none; b=gTGPjrKmlVjGDgiFW8JqdPXZigWnGUppY0mhQqg4OQ69Ywj67py2Cgeb8AcTUtPvGFgEQiaCwXfv8RKT39PbQwAwQUkkRJ7SZ0++senXlF68tTT8346+u+yrOFpzIuYJmwTzEfbVv/y+Klqo8ChxPpJrBC1+53jG627LBgcOSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769398477; c=relaxed/simple;
	bh=PEnc3aKqN0qbwiATEaBTLTySgkCimuk394JQEBQYozw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3Hz5FlqltHZHfErL1tMJoEWS7Sq2fZmKbtYbyuYYzU0VGg71c7ZdIo7orbsejIzaEuzNj1yHf7BikPbTh/XD6/9++xI38Df5zEy1KaqY7oLHPsFFtUKM682xTe3iFhy5KOPxkY03C0JHCubnGMJkpJkEnlexR4bFaCB9DzFVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pj2O5VLW; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pj2O5VLW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769398466; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x/gewgo/vZCLPNFFqWCeFiAOC6vI0DF40EGGJQeVdCU=;
	b=pj2O5VLWRu8FdJUdjYrya+4HK6IAxhSCZxInJ8hgw19PK6WKfXJ3wprLmm32Pb360Oxu+q5b9PbrF+v/CKue3WBfBmpJGg5XYm6BeRVs7qiU5HdbWYtpl/v+y3pe7nyU7ofXbZRAvJspenkEnWviGrAqeN3k6gW3yBMCHVpSiLo=
Received: from 30.221.130.48(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WxnKsSh_1769398465 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Jan 2026 11:34:26 +0800
Message-ID: <95b86635-8ab4-4b40-9eec-2610b65150b2@linux.alibaba.com>
Date: Mon, 26 Jan 2026 11:34:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate i_blkno and BITMAP_FL consistency in
 ocfs2_validate_inode_block
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260124050124.27926-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260124050124.27926-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/24/26 1:01 PM, Deepanshu Kartikey wrote:
> ocfs2_is_cluster_bitmap() checks whether an inode is the global bitmap
> by comparing ip_blkno with osb->bitmap_blkno. A corrupted filesystem
> can have an inode with i_blkno and OCFS2_BITMAP_FL flag inconsistent:
> - i_blkno matches bitmap_blkno but BITMAP_FL is not set, or
> - BITMAP_FL is set but i_blkno does not match bitmap_blkno
> 
> In either case, ocfs2_is_cluster_bitmap() returns incorrect results,
> triggering BUG_ON in ocfs2_block_group_search() or
> ocfs2_cluster_group_search() causing a kernel panic.
> 
> Call trace:
>   ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
>   ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
>   ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
>   ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
>   ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
>   ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
>   ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852
> 
> Add validation in ocfs2_validate_inode_block() to check that i_blkno
> and OCFS2_BITMAP_FL are consistent:
> - If i_blkno matches bitmap_blkno, BITMAP_FL must be set
> - If BITMAP_FL is set, i_blkno must match bitmap_blkno
> 
> This catches corrupted inodes early when reading from disk.
> 
> Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
> Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20260104014028.305029-1-kartikey406@gmail.com/T/ [v1]
> Link: https://lore.kernel.org/all/20260110054443.604944-1-kartikey406@gmail.com/T/ [v2]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v3:
>   - Move validation to ocfs2_validate_inode_block() to catch corruption
>     early when inode is read from disk (Joseph Qi)
>   - Add check for both directions of inconsistency
> 
> v2:
>   - Fix commit message - ocfs2_is_cluster_bitmap() checks ip_blkno
>     against bitmap_blkno, not a flag (Joseph Qi)
> ---
>  fs/ocfs2/inode.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index b5fcc2725a29..2d80934d14b4 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1529,6 +1529,27 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	/*
> +	 * Validate bitmap flag consistency with bitmap_blkno.
> +	 * A corrupted inode with mismatched i_blkno and BITMAP_FL would
> +	 * cause ocfs2_is_cluster_bitmap() to return incorrect results,
> +	 * triggering BUG_ON in ocfs2_block_group_search() or
> +	 * ocfs2_cluster_group_search().
> +	 */
> +	if (le64_to_cpu(di->i_blkno) == OCFS2_SB(sb)->bitmap_blkno &&
> +	    !(di->i_flags & cpu_to_le32(OCFS2_BITMAP_FL))) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: i_blkno matches bitmap but BITMAP flag not set\n",
> +				 (unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	} else if (di->i_flags & cpu_to_le32(OCFS2_BITMAP_FL) &&
> +		   le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno) {

Ummm... This is not right.
OCFS2_BITMAP_FL is set not only for global bitmap, but also for
localalloc, extent alloc, inode alloc, etc.
BTW, OCFS2_BITMAP_FL should be checked along with OCFS2_CHAIN_FL.

Thanks,
Joseph

> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: BITMAP flag set but i_blkno does not match bitmap\n",
> +				 (unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	}
> +
>  	rc = 0;
>  
>  bail:

