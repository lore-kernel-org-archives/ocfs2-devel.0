Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580926;
	b=JLfjbvQ65KKQFtd8kDegOz7bPDtL1h4vf9DuQMqT72XU26aLe6q0FzcN/DnRDPvJjhpb
	 vpnHq3ZC0uzyrZiswb1heIX+oJogfU5/DkyuRh6YKgPOQ05TrqWEG3l0i+zMhRkam916A
	 J/FzICAkG6GPbGYxsFRWK/eoHUUMZQZ7bX7JJIuSvN7Bq6vscctFTelX+rO4cYXaz0pVQ
	 kbKDmt5/PNhAAtVdswIKsi2d39CrdfWhXtpg10NaTrizvatKbK7umK95GrHfkI8RHJoyg
	 O8N2J9loALDJgzf4//S7t81gHAel7n29y/7EXXOHi84ui/kBcg7yyeUxKBIa3e0c/hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580926;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/XcNu/0ak4HgxgCQYtJR0Uk5O3TPxB93l8oUZ2RHpqE=;
	b=Yo4bSRv+RR70bHGf+orJ63HdZKpJ/Zn80cWZFZkHewkjix6NP2JFn54Oo6AmD99PLNGg
	 N3kUjYTbF+iCXYbHKSeZvkvjjubuDAcpwEYg9kiHq8NXB0V7uMCj4dqZLe5aUkU5nzDBE
	 oODQUoVdItj4VNbKt/5Ch2rpkOaQCIAl2kyt7yyGQzEw0T0uZ6FFp2BNfo5DsShoIHmp1
	 COUNlGEBIysvVC4xFapJ9f9SQ+yAfCFY9xcTahpoHHJp6Xr60PgjR6I7SqtaAYQrJ16of
	 I8hJsSMoi1XNQcY+xQGcTl657Et/wUiUDqHsvIqpq4qdP987ANHU24yXwfClm2IHOqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qpuH+fZ0;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9526606A319
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Oct 2026 11:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9526606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qpuH+fZ0
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792580917; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/XcNu/0ak4HgxgCQYtJR0Uk5O3TPxB93l8oUZ2RHpqE=;
	b=qpuH+fZ0z2bHilPpYmuPb+TQ6WZ0n02cDGf9TiFYCizXrdWHD3koYc7wZIa12L0570U19dOymTBaG74iM3HEe8bEGQT4TqmyP9Vqfz+pBYObnsRM7NPhLfY8SHxg+X9PMoqTRwbF+SExzWev5hYMdrBPy1xqqPPpc+NUAQAHk+k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XDGEmZt_1792580916;
Received: from 30.221.149.139(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDGEmZt_1792580916 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 19:08:36 +0800
Message-ID: <8b77086a-3859-4078-8e47-cc900d17f021@linux.alibaba.com>
Date: Wed, 21 Oct 2026 19:08:36 +0800
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
Subject: Re: [PATCH v2] ocfs2: validate the block count of a local quota file
To: Jiaming Zhang <r772577952@gmail.com>
Cc: jlbec@evilplan.org, mark@fasheh.com, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261020024651.3217554-1-r772577952@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261020024651.3217554-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

This conflicts with the following commit in linux-next:
b10ef5d2c208 ("ocfs2: validate chunk and block counts of the local quota file")

Thanks,
Joseph

On 10/20/26 10:46 AM, Jiaming Zhang wrote:
> Every ocfs2 node keeps a local quota file made of chunks.  A chunk is a
> header block, whose bitmap marks the entries in use, followed by up to
> ol_chunk_blocks() blocks of entries, and only the last chunk may be
> partly filled.  The file header records the number of chunks in
> dqi_chunks and the number of blocks in dqi_blocks.  When no chunk has a
> free entry, ocfs2_extend_local_quota_file() works out from dqi_blocks
> how many entry blocks the last chunk already has, and puts the new entry
> right after them:
> 
> 	chunk_blocks = oinfo->dqi_blocks -
> 			ol_quota_chunk_block(sb, chunk->qc_num) - 1;
> 	...
> 	*offset = chunk_blocks * epb;
> 
> olq_alloc_dquot() then sets that bit in the chunk's bitmap, which fits
> in a single block.  This is only safe while chunk_blocks is at most
> ol_chunk_blocks().
> 
> ocfs2_local_read_info() reads dqi_chunks and dqi_blocks from disk at
> mount time and never checks that they agree.  With one chunk and a
> dqi_blocks of a few thousand, the last chunk appears to hold thousands
> of entry blocks, and the bit lands kilobytes past the end of the bitmap.
> A dqi_blocks below the last chunk's header block makes chunk_blocks, an
> unsigned int, wrap around to the same effect.  dqi_blocks is not checked
> against the file size either, and a dqi_blocks past the end of the file
> can make the kernel write the new block of the file to block 0 of the
> device.
> 
> The stray bit write corrupts unrelated kernel memory.  KASAN calls it a
> use-after-free only because the page it hits happens to be free; nothing
> in ocfs2 was freed.  The second case overwrites block 0 of the device.
> Triggering either issue requires mounting a crafted image with quotas
> enabled, which needs CAP_SYS_ADMIN, and creating a file.  The first
> issue was found by fuzzing and has not been seen in production; the
> reproducer can be found in the linked report.
> 
> Check in ocfs2_local_read_info() that the last chunk has its header
> block and at most ol_chunk_blocks() entry blocks, and that a file
> without chunks holds only its info block, since the first new chunk is
> placed at block dqi_blocks.  Also check that dqi_blocks does not exceed
> the file size.  Refuse the file with ocfs2_error() otherwise, as
> ocfs2_read_quota_block() does for a corrupted quota file.  The header
> block of the last chunk is computed in 64 bits because a crafted
> dqi_chunks can wrap ol_quota_chunk_block().
> 
> Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
> Closes: https://lore.kernel.org/lkml/CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
> Changes in v2:
> - Reject a dqi_blocks larger than the file size.  Suggested by the
>   Sashiko review of v1.
> - Print i_size in the error message.
> - v1: https://lore.kernel.org/lkml/20261019154732.3149351-1-r772577952@gmail.com/
> 
>  fs/ocfs2/quota_local.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..f3eb366f8fae 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -678,6 +678,39 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  	return status;
>  }
>  
> +/* Check dqi_blocks against dqi_chunks and the size of the local quota file */
> +static int ocfs2_local_check_info(struct super_block *sb, struct inode *lqinode,
> +				  struct ocfs2_mem_dqinfo *oinfo)
> +{
> +	u64 hdr_blk;
> +
> +	/*
> +	 * i_size is grown before dqi_blocks, so the file may have more blocks
> +	 * than dqi_blocks, but should not have fewer.
> +	 */
> +	if (oinfo->dqi_blocks > (i_size_read(lqinode) >> sb->s_blocksize_bits))
> +		goto corrupted;
> +
> +	if (!oinfo->dqi_chunks) {
> +		if (oinfo->dqi_blocks == ol_quota_chunk_block(sb, 0))
> +			return 0;
> +	} else {
> +		/* Same as ol_quota_chunk_block(), but in 64 bits */
> +		hdr_blk = 1 + (u64)(ol_chunk_blocks(sb) + 1) *
> +			      (oinfo->dqi_chunks - 1);
> +		if (oinfo->dqi_blocks > hdr_blk &&
> +		    oinfo->dqi_blocks - hdr_blk - 1 <= ol_chunk_blocks(sb))
> +			return 0;
> +	}
> +
> +corrupted:
> +	return ocfs2_error(sb,
> +			   "corrupted local quota file %llu (chunks=%u blocks=%u size=%lld)\n",
> +			   (u64)OCFS2_I(lqinode)->ip_blkno,
> +			   oinfo->dqi_chunks, oinfo->dqi_blocks,
> +			   i_size_read(lqinode));
> +}
> +
>  /* Read information header from quota file */
>  static int ocfs2_local_read_info(struct super_block *sb, int type)
>  {
> @@ -733,6 +766,10 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
>  	oinfo->dqi_libh = bh;
>  
> +	status = ocfs2_local_check_info(sb, lqinode, oinfo);
> +	if (status)
> +		goto out_err;
> +
>  	/* We crashed when using local quota file? */
>  	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
>  		rec = OCFS2_SB(sb)->quota_rec;

