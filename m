Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29D237CD39
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431561; cv=none; b=cOtK/2s0cYu8npeLiYZXX++HbF13xM9wj3GwWRSmCk1bbecP8tKKVeOsEV61lI0cRMChr144QtI9HREVxAcq3/2Rw6DO98mNNMevDFYncAE0ZxJQNGo5f2o/HMzKrVqpPrGvflm1IPvUtw7SJ4Obp361kyDV55FSWiGVIHA95ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431561; c=relaxed/simple;
	bh=ryoxL8cMaL6VlsCcopVnBKtGT9vHf5H5Y8cjbZxMGGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PEU+SYyMaDA//aFV4MoHbOPgY5qTTCOwFwFjU4tZpzepyl/NnJaunHboKCXqcHmLnPPH6OXAUDZdDBgLq61qoESkBqlV/REUooJM29YSjIg6yWtdXfnhAjNgJ+4uCWvX2qCa1JHMqO1HzV/GODTkkMeGHe6/ANE4E84fOJ/e6dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dtW29R/m; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dtW29R/m"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786431557; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GBNKcEC4bSdi0Sw1Sp1EQMAbQamHDnyWcuCeF8zfbwA=;
	b=dtW29R/mnddpf1cYFBEXpJxPqqFoqnKMxAHuNPgEOG/A4sorryV+lgicyjWUgqE4TPteHLXdDKeYTlb7bNgj21YhdNoKdd+kTRlPXlU9UVSAidxVq2Aqyyk07LK9hnS7HNyYLh/uB0r9S9is9bblw/XaWuYYovIUejgsFg1npWI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X8nOTHz_1786431555;
Received: from 30.221.129.51(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8nOTHz_1786431555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Aug 2026 14:59:16 +0800
Message-ID: <cdfcc004-b4fe-485b-8e22-8f8ca8c1ce68@linux.alibaba.com>
Date: Tue, 11 Aug 2026 14:59:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: bound-check dir entries in the readdir
 re-validation scan
To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Junxiao Bi <junxiao.bi@oracle.com>, Changwei Ge <gechangwei@live.cn>,
 Jun Piao <piaojun@huawei.com>, Heming Zhao <heming.zhao@suse.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 zhanxusheng@xiaomi.com
References: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
 <20260811024337.3972976-2-zhanxusheng@xiaomi.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260811024337.3972976-2-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/11/26 10:43 AM, Zhan Xusheng wrote:
> When the inode version changed since the last readdir(),
> ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
> relocate the current position:
> 
> 	for (i = 0; i < sb->s_blocksize && i < offset; ) {
> 		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
> 		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
> 			break;
> 		i += le16_to_cpu(de->rec_len);
> 	}
> 
> i walks the block on rec_len values taken from the block itself and the
> only thing tested is that rec_len is not too small, so a single bogus
> rec_len
> leaves i anywhere in the block, including its last OCFS2_DIR_REC_LEN(1) - 1
> bytes.  @offset comes from ctx->pos, which userspace moves with lseek() on
> the directory fd, and decides how far the walk gets.
> 
> Two bounds are missing, both of which ocfs2_check_dir_entry() applies for
> the emit loop below.
> 
> de->rec_len sits at byte offset 8 within the entry, so dereferencing de in
> that tail reads past the s_blocksize buffer.  ocfs2_check_dir_entry()
> declines to look at an entry that close to the end:
> 
> 	size - buf_offset < OCFS2_DIR_REC_LEN(1)
> 
> Nothing bounds i += rec_len either, so i can end up past the block.  The
> emit loop that follows is guarded by offset < sb->s_blocksize and does not
> run, but
> 
> 	offset = i;
> 	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;
> 
> runs first and ORs a value with bits above the block mask into ctx->pos,
> corrupting the block number readdir() resumes from.
> ocfs2_check_dir_entry() rejects that as "directory entry overrun":
> 
> 	next_offset = buf_offset + rlen;
> 	... next_offset > size
> 
> Apply both bounds.  For a consistent directory this changes nothing:
> entries are at least OCFS2_DIR_REC_LEN(1) bytes and do not cross the end of
> the block, so no valid entry is skipped.
> 
> Found by the sashiko review tool; fix approach suggested by Joseph Qi.
> 
> Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dir.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index c30a86856d5b..39ce60874e17 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1903,7 +1903,10 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  		 * dirent right now.  Scan from the start of the block
>  		 * to make sure. */
>  		if (!inode_eq_iversion(inode, *f_version)) {
> -			for (i = 0; i < sb->s_blocksize && i < offset; ) {
> +			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
> +			     i < offset;) {
> +				unsigned int rec_len;
> +
>  				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
>  				/* It's too expensive to do a full
>  				 * dirent test each time round this
> @@ -1911,10 +1914,11 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  				 * least that it is non-zero.  A
>  				 * failure will be detected in the
>  				 * dirent test below. */
> -				if (le16_to_cpu(de->rec_len) <
> -				    OCFS2_DIR_REC_LEN(1))
> +				rec_len = le16_to_cpu(de->rec_len);
> +				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
> +				    i + rec_len > sb->s_blocksize)
>  					break;
> -				i += le16_to_cpu(de->rec_len);
> +				i += rec_len;
>  			}
>  			offset = i;
>  			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))

