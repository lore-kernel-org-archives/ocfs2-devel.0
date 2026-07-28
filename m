Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCC23B7B76
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 06:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785218878; cv=none; b=VTq3t73o+tKyh661pzbyOrWqvrFqLtvPTlchK5a/cGWLyFSP85UqRbEAZDikW6wMJz56jrqv0QcGjCeJlbHjfEYkf7MG2KcMs+ig9tP2GDz2J6C6Yns7GHjnnTNOFZ1vTFeko7pyFXTkGqzYJ4s0rQJNWZsrX0/xdQlrDZ5c5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785218878; c=relaxed/simple;
	bh=fgfM30wJW9cbXDSv58gHnTOvziLZIx+UTv0xICxv6tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTCYxLASrYRrV6gMcUk6f0jgz2BU8RCigoSQSE2hPM5ra4DpnOrK7+NcsReFqVx2ULF4zj3DIVqnpA7J/cS53nxoVErm6+Afinq33xIWtePLnmpQPOrVS3hnq+hrhfG334zV5s5Ma7/4m3zcmFcsLRXwCxVF6YyfzNFw4+kZd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fFMI/ZrP; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fFMI/ZrP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785218865; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YFSF9rs7qg+SuvhfUxMah6xD6FM7PSs3zgpHI0Mu0z8=;
	b=fFMI/ZrPsZxkU9NfT8bxrH07Q5qz8JmblZ+31/T/WICx5ApSWWG7Xl+EC9BAGW4XNQFawTSUnVZTbRuKI7FsZsY/YwhqEgB2Y2KMGArgzqZb1ykzZz0Rjlc2pYiPPs2AVgb5/mhM52iS4GqoYuET/Z/JlGNf+oRtYta3qkQNL94=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7zn7DQ_1785218864;
Received: from 30.221.129.76(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7zn7DQ_1785218864 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 14:07:44 +0800
Message-ID: <b4942947-86cd-45d1-8f31-c8f55e0ae71d@linux.alibaba.com>
Date: Tue, 28 Jul 2026 14:07:42 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/4] ocfs2: switch dio write path from buffer_head
 to iomap
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-4-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260727061802.18485-4-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/27/26 2:17 PM, Heming Zhao wrote:
> This patch converts OCFS2's DIO write path from the legacy
> buffer_head infrastructure to the modern iomap framework.
> 
> Key modifications and designs are as follows:
> 
> 1. Dynamic Context Allocation:
>    Refactor 'struct ocfs2_write_ctxt' to use a flexible array 'w_desc[]'
>    instead of a fixed-size array. Dynamically allocate the context based on
>    the write length ('w_clen') in 'ocfs2_alloc_write_ctxt()'. This prevents
>    static limits overflow and optimizes kernel heap memory utilization.
> 
> 2. Robust Mapping and Limits:
>    Introduce 'ocfs2_dio_wr_map_blocks()' to allocate and map direct write
>    blocks. Implement a 1 MiB cap ('OCFS2_DIO_WR_MAX_MAX_BYTES') per mapping
>    call to restrict allocation granularity, preventing JBD2 transaction
>    credit exhaustion during huge asynchronous sequential writes.
> 
> 3. Reliable Completion Work and Fallback:
>    - Implement 'ocfs2_iomap_dio_end_io_write()' to handle metadata completion.
>      It converts UNWRITTEN extents, updates inode size (EOF), and deletes the
>      inode from the orphan directory if it was appended.
>    - Implement 'ocfs2_dio_write_end_io()' to finalize the dio lifecycle and
>      release cluster locks safely.
>    - Intercept '-ENOTBLK' errors from 'iomap_dio_rw()' caused by page cache
>      invalidation failures (due to mmap/buffered collisions). Gracefully clear
>      the error, strip the IOCB_DIRECT flag, and fall back to buffered write
> 
> 4. Moved ocfs2_add_inode_to_orphan():
>    - moved ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks() to
>      ocfs2_file_write_iter().
> 
> 5. Uncertain logic in code
>    For the following code block in ocfs2_dio_wr_map_blocks():
>    ```
>      if (extend) {
>              if (ocfs2_sparse_alloc(osb))
>                      ret = ocfs2_zero_tail(inode, di_bh, pos);
>              else
>                      ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
>                                                          map_len, NULL);
>              if (ret < 0) {
>                      mlog_errno(ret);
>                      goto unlock;
>              }
>      }
>    ```
>    I am not completely certain whether it is called only once per
>    ocfs2_file_write_iter(), but I believe calling it multiple times will
>    not introduce any side effects. Furthermore, testing across various
>    scenarios showed no instances of multiple calls.
> 
> Assisted-by: Gemini:gemini-3.5-flash
> Assisted-by: Claude:claude-sonnet-4-5
> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c           | 394 ++++++++++++++++++++++++++++++++++++--
>  fs/ocfs2/buffer_head_io.c |   7 +-
>  fs/ocfs2/file.c           |  91 +++++++--
>  fs/ocfs2/ocfs2.h          |   2 +
>  4 files changed, 459 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 12f5f2e3530a..9a079436c9c0 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c

...

> +
> +	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
> +	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, map_len, map_len, wc);
> +	BUG_ON(ret != map_len);

Under memory pressure, folio allocation may fail. In this case,
ocfs2_write_end_nolock() can return a short count.
So we must handle this case gracefully.

> +	ret = 0;
> +
> +unlock:
> +	up_write(&oi->ip_alloc_sem);
> +	ocfs2_inode_unlock(inode, 1);
> +	brelse(di_bh);
> +
> +out:
> +	return ret;
> +}
> +
>  static int ocfs2_dio_end_io_write(struct inode *inode,
>  				  struct ocfs2_dio_write_ctxt *dwc,
>  				  loff_t offset,

...

> +static int ocfs2_iomap_dio_end_io_write(struct inode *inode,
> +				  loff_t offset,
> +				  ssize_t bytes)
> +{
> +	struct ocfs2_cached_dealloc_ctxt dealloc;
> +	struct ocfs2_extent_tree et;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	struct buffer_head *di_bh = NULL;
> +	struct ocfs2_dinode *di;
> +	struct ocfs2_alloc_context *data_ac = NULL;
> +	struct ocfs2_alloc_context *meta_ac = NULL;
> +	handle_t *handle = NULL;
> +	loff_t end = offset + bytes;
> +	int ret = 0, credits = 0;
> +	struct ocfs2_map_block map;
> +	unsigned int blkbits = inode->i_blkbits;
> +	unsigned int max_blocks;
> +	unsigned int ue_cpos = 0, ue_phys = 0, ue_len = 0;
> +	unsigned int curr_lblk, end_lblk;
> +
> +	map.lblk = offset >> blkbits;
> +	max_blocks = (bytes + offset) >> osb->s_clustersize_bits;

Seems unused.

...

> +	curr_lblk = offset >> blkbits;
> +	/*
> +	 * Round the end up so the final partial block (sub-block direct I/O)
> +	 * is included; otherwise the last, partially-written cluster is left
> +	 * unwritten and reads back as zero.
> +	 */
> +	end_lblk = (offset + bytes + (1 << blkbits) - 1) >> blkbits;
> +	while (ret >= 0 && curr_lblk < end_lblk) {
> +		memset(&map, 0, sizeof(map));
> +		map.lblk += curr_lblk;

Since map is memset just now, so here we can use "map.lblk = curr_lblk"
directly.

> +		map.len = end_lblk - curr_lblk;
> +
> +		ret = ocfs2_assure_trans_credits(handle, credits);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		}
> +

...

> +
> +static int ocfs2_dio_write_end_io(struct kiocb *iocb, ssize_t size,
> +			int error, unsigned int flags, int level)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	loff_t offset = iocb->ki_pos;
> +	int ret = 0;
> +
> +	if (error)
> +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
> +				 (long long)size, error);
> +
> +	if (size && ((flags & IOMAP_DIO_UNWRITTEN) ||
> +		    (offset + size > i_size_read(inode)))) {

Is it safe to do i_size_read() in case async dio completion?

...

