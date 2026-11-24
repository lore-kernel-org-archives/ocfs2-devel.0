Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518285;
	b=t8x6cCuBa9Z9vRhGEZ0GqJx/wjhgTNHyAUqxjGCL8O1kSUaNtVBhmkfgSCqMj7c9Fhvc
	 lq9y1CRDsbpyx/kRbdkTGqBH38ja+npJivGj4qKxZC+nWVTCvHMu5L4u9/YrcoRRBrBlY
	 yCrOazX+Hb9LvdE6g+aHJsG6mA1hGZx4teqZYZFZ8zGa+2udf4n0SR90wEse72zPQ2rbV
	 BjobnCBk5LMKMwZ9RqYa0Q2gJO9VzFKWvnPxk1I/GOJZ2oOHCSVVixM7YrN+wgZlakx97
	 NrZgyOtK1CIq6EoYTUEWKOYwVy87O/QZFUghCDao9+2IA+399ftHSzMkDAdHROIcvmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518285;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=BymQS6GK987uNfZbDCjncL57Qqv9/djtgx0zK7uytsg=;
	b=29PF44fJvcMUDKDePb6gbPgxUY8LA8j0ohFj8L/N1+AF8YGnrT1srWWHIxnfNrbJAj0m
	 Gfp8av0fp4Q163hAYfArMNDA/W5vmD8Z3BpW2YARZFLKMORJ47WfRSS0SCWA2T28nbanz
	 Ww7Hx+wAgFG+5o1lsvuW2Cp87+R+qQqZQRKU5Oo7KrbKNF/XrfriSKjz0sVLjEtJExuvq
	 JOuU437V6oYPFohlghxm12F7d1mQ33Pqpc92IVu0PhF6RMmdwpAzxVL9uK/oyZlxGHayQ
	 Eke3AgPHeOknAJAnuwwYnzbnzjt9W4oqZLKVSvzBJxMNRtRlsuCEDw4lShh5Q1sB4Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="h+S/qozl";
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F393606A31E
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 11:04:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F393606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=h+S/qozl
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795518279; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BymQS6GK987uNfZbDCjncL57Qqv9/djtgx0zK7uytsg=;
	b=h+S/qozlqfgAVbRVx/bVx7+RMQtbh7Odl1UXNGa4zCP5gPWUbUCKbFJ23Qy3ZVYiyjzhdSrabKoUMmRfbNe7cNTGfD+hc9ijgS4Mo885Zu0lJy+XRVeLaJYPacaSdgJHCOw33QElQELb3yRb8c89GvUrFaEScJiiILVfhndG13I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XFOMQtm_1795518278;
Received: from 30.221.129.142(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFOMQtm_1795518278 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 19:04:38 +0800
Message-ID: <98371fed-7bd3-4dd4-8142-bb59edec135a@linux.alibaba.com>
Date: Tue, 24 Nov 2026 19:04:37 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v10 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
 hch@lst.de
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261124045501.10281-1-heming.zhao@suse.com>
 <20261124045501.10281-4-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261124045501.10281-4-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/24/26 12:54 PM, Heming Zhao wrote:
> Converts OCFS2's DIO write path from the legacy buffer_head
> infrastructure to the modern iomap framework.
> 
> The buffer_head based ocfs2_dio_wr_get_block() is replaced by
> ocfs2_dio_wr_map_blocks(). Instead of one cluster per call, it now
> hands iomap a mapping of as many clusters as can be described by a
> single struct iomap: up to 16MB, stopped at the first cluster that is
> not of the same kind as the first one (hole, unwritten, written).
> 
> Implement ocfs2_dio_end_io() and ocfs2_dio_end_io_write() to handle IO
> completion. They convert UNWRITTEN extents, updates inode size (EOF).
> 
> In the buffer_head path, ocfs2_dio_wr_get_block() stores dwc in
> bh->b_private, enabling it to detect the first call for an IO chunk and
> invoke ocfs2_add_inode_to_orphan() to protect the extent allocation.
> However, iomap doesn't provide a similar private field. Therefore, moves
> ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks(the buffer_head
> counterpart to ocfs2_dio_wr_get_block()) to ocfs2_file_write_iter().
> 
> It is also impossible t pass The dwc to iomap_dio_ops.end_io, the iomap
> ->end_io callback cannot effectively distinguish between I/Os initiated
> by different threads concurrently. For example, when multiple DIO write
> threads operate on the same inode concurrently, the end_io callback
> without the dwc context may incorrectly delete an orphan inode created
> by another thread, leading to a crash. The fix is to move the orphan
> inode deletion from end_io into ocfs2_file_write_iter(). In
> ocfs2_file_write_iter(), inode_lock() serializes the write threads,
> and IOMAP_DIO_FORCE_WAIT ensures that the function only returns after
> the bio completes. This guarantees that i_size has already been
> updated when ocfs2_dio_del_orphan() is called.
> 
> iomap calls ->iomap_begin() once per mapping but ->end_io() once per io,
> and the latter only gets the kiocb, so the kiocb is used as the identity
> of the io: ocfs2_file_write_iter() passes it in iomap_iter.private,
> ocfs2_iomap_next() forwards it to ocfs2_dio_wr_map_blocks(), and each
> unwritten record stores it in ue_owner with the cluster range it covers.
> 
> Doesn't like ocfs2_dio_wr_get_block(), move the zero operations from
> ocfs2_dio_wr_map_blocks() to ocfs2_file_write_iter(). If do the zeroing
> in ocfs2_dio_wr_map_blocks() would zero blocks that earlier mappings of
> this same dio have already written, as i_size is only updated at dio
> completion. this will makes xfstests generic/538 failure.
> 
> Assisted-by: LLM
> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/Kconfig      |    1 -
>  fs/ocfs2/aops.c       | 1600 +++++++++++++++++++++++++++++++----------
>  fs/ocfs2/aops.h       |   36 +-
>  fs/ocfs2/extent_map.c |   34 +-
>  fs/ocfs2/extent_map.h |    3 +
>  fs/ocfs2/file.c       |  282 +++++++-
>  fs/ocfs2/inode.h      |    9 +
>  fs/ocfs2/mmap.c       |    2 +-
>  fs/ocfs2/super.c      |    3 +
>  9 files changed, 1509 insertions(+), 461 deletions(-)
> 
...
> +/*
> + * Prepare the area between i_size and a direct write that starts or ends
> + * beyond it. Must be called once per dio, before any io is issued, with
> + * i_rwsem and the rw lock held.
> + */
> +int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count)
>  {
> -	struct ocfs2_dio_write_ctxt *dwc = NULL;
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	struct buffer_head *di_bh = NULL;
> +	int ret;
>  
> -	if (bh->b_private)
> -		return bh->b_private;
> +	if (pos + count <= i_size_read(inode))
> +		return 0;
>  

On a sparse volume ocfs2_zero_tail() only acts when pos > i_size, so an
extending write starting at or before i_size locks around a no-op and
then immediately re-locks in ocfs2_dio_wr_map_blocks().
We can return early in this case.

	loff_t isize = i_size_read(inode);
	...

	if (pos + count <= isize)
		return 0;

	/*
	 * ocfs2_zero_tail() only zeroes a gap past i_size, so on a sparse
	 * volume there is nothing to do here and no need to take the cluster
	 * lock.  The non-sparse path below always has allocation work left.
	 */
	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && pos <= isize)
                return 0;
	...

Thanks,
Joseph

> -	dwc = kmalloc_obj(struct ocfs2_dio_write_ctxt, GFP_NOFS);
> -	if (dwc == NULL)
> -		return NULL;
> -	INIT_LIST_HEAD(&dwc->dw_zero_list);
> -	dwc->dw_zero_count = 0;
> -	dwc->dw_orphaned = 0;
> -	dwc->dw_writer_pid = task_pid_nr(current);
> -	bh->b_private = dwc;
> -	*alloc = 1;
> +	ret = ocfs2_inode_lock(inode, &di_bh, 1);
> +	if (ret) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
>  
> -	return dwc;
> +	down_write(&oi->ip_alloc_sem);
> +	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
> +		ret = ocfs2_zero_tail(inode, di_bh, pos);
> +	else
> +		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, count,
> +						   NULL);
> +	if (ret < 0)
> +		mlog_errno(ret);
> +	up_write(&oi->ip_alloc_sem);
> +
> +	ocfs2_inode_unlock(inode, 1);
> +	brelse(di_bh);
> +	return ret;
>  }
>  
...

