Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EEF2D321D
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 06:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763533272; cv=none; b=twt2vht65KxJ8SK3iZYti5+4mol9vK3SUI8GVCcnqxx8ocqiktq6BAeMazWOJNZNkJahlwCUYow7lu8e7p74b26fHaSPSnvC47IjqUZucMHecjL6DXnu+ZZParjDxs4z8YyM+OYdFzPaPR/lqwJzzGzxyz4T+9snAfcqmdHYShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763533272; c=relaxed/simple;
	bh=Y2L8S9THdY6DRmj+REtQbD6fZ3Romq0rR7veNrB+EKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HsUc6BTt3Zzr66u+T/3Id4JSqPftHrOeF7Y4/9LBQGAdKC2aiOLUyPlb1gLphLeRmOP2L782YwKz4WiDZ7UtzuRVVp3jZ2T5Bm85fcwy/uAbrD+0R7Hq7DUxNWaLx52m+xXXq9jiFl4zcqbVu5zwXM4l62yUiIUvPn7SFLyK7NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WJkXYMkn; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WJkXYMkn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763533265; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ke3SUSVyC6dcJ3Xo1lf/T2Rm9mPW+0S8h1NsTCuTock=;
	b=WJkXYMkn+2x9wpW19CkzXJt687s76RB47drZ2PeuTnpIJi7K9vbWQmAXWiHT1WMPpMUwYBSFH1yGuLQ9qy2pqrQovbD2VgZGl5XuKkBL8Cr2ndwZWoLsZrbWtVtqqHBOdfNTx35Si4og8OLC4z5pFHDPr9uxpIdTgXz8Et069Qw=
Received: from 30.48.68.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WsnUDLd_1763533264 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Nov 2025 14:21:04 +0800
Message-ID: <58e5f4bb-0288-4d65-b38c-34dfe569098e@linux.alibaba.com>
Date: Wed, 19 Nov 2025 14:21:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Mark inode bad upon validation failure during read
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com,
 Heming Zhao <heming.zhao@suse.com>,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251118001833.423470-2-eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251118001833.423470-2-eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/18 08:18, Ahmet Eray Karadag wrote:
> A VFS cache inconsistency, potentially triggered by sequences like
> buffered writes followed by open(O_DIRECT), can result in an invalid
> on-disk inode block (e.g., bad signature). OCFS2 detects this corruption
> when reading the inode block via ocfs2_validate_inode_block(), logs
> "Invalid dinode", and often switches the filesystem to read-only mode.
> 
> The VFS open(O_DIRECT) operation appears to incorrectly clear the inode's
> I_DIRTY flag without ensuring the dirty metadata (reflecting the earlier
> buffered write, e.g., an updated i_size) is flushed to disk. This leaves
> the in-memory VFS inode object "in limbo" with an updated size (e.g., 38639
> from the write) but marked clean, while its on-disk counterpart remains
> stale (e.g., size 0) or invalid.
> 
> Currently, the function reading the inode block (ocfs2_read_inode_block_full())
> fails to call make_bad_inode() upon detecting the validation error.
> Because the in-memory inode is not marked bad, subsequent operations
> (like ftruncate) proceed erroneously. They eventually reach code
> (e.g., ocfs2_truncate_file()) that compares the inconsistent
> in-memory size (38639) against the invalid/stale on-disk size (0), leading
> to kernel crashes via BUG_ON.
> 
> Fix this by calling make_bad_inode(inode) within the error handling path of
> ocfs2_read_inode_block_full() immediately after a block read or validation
> error occurs. This ensures VFS is properly notified about the
> corrupt inode at the point of detection. Marking the inode bad  allows VFS
> to correctly fail subsequent operations targeting this inode early,
> preventing kernel panics caused by operating on known inconsistent inode states.
> 
> Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous-link: https://lore.kernel.org/all/20251029225748.11361-2-eraykrdg1@gmail.com/T/

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..415ad29ec758 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
>  	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
>  			       1, &tmp, flags, ocfs2_validate_inode_block);
>  
> +	if (rc < 0)
> +		make_bad_inode(inode);
>  	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
>  	if (!rc && !*bh)
>  		*bh = tmp;

