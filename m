Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACB83FCB11
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431583; cv=none; b=u6AMWCCVhfpErtLBBGfuP7dpVy7CSJIHfmEAUnJAZmw54geSHzb+jcfYf1R2UoKuMPSmbKqdyf+tLqUZ7ugzWe421AP6XH2edxpUKHUgiXT3psSmJG+w7kXvAhjBRa9X4Bv1KB1/OLTcBcyWyk2Ne56LnTFJ9W277n2YLdoTB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431583; c=relaxed/simple;
	bh=59sYUox1HjPPERh1ZXHMSKMnEQsFaOASzidT5rdQfxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3VdtFDyDNu8icNPu6/N6F2J73i2UHO/dL54BQV01+8rnd1GLgJgVyuKSx0ssUEDGQenT1X+rkoCmQbxaR4JGoLj6beB93Yu34Aw/QIPCZC5R2njp/Duirwb0RgHesClMdNqzO/+xUM2n8i5vInOHRERLuL28wgznhs2xxPX+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vi8YVJ9X; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vi8YVJ9X"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786431572; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FudDH9ix79AAYkLq4lzBSHoUEQe/y9baNnS3pqkX37s=;
	b=vi8YVJ9XLoXQ5WOvf9lZuw0wxhufQiCwa1MwQpZWSTsN0i9X5MDiVinGtQMmHhqypW5As0JmaKagcnbVWqzpEQcqRgIXPpoyCMrE+rmP0bjsx4JJuoPgQ2CJnCFREM3iPwWmEZ5ornRQCePubJc1Boiqy/8jToTiy1xEMVBCJ1s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X8nNji6_1786431570;
Received: from 30.221.129.51(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8nNji6_1786431570 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Aug 2026 14:59:31 +0800
Message-ID: <2cb37959-c50a-44a1-b142-26cf3375c537@linux.alibaba.com>
Date: Tue, 11 Aug 2026 14:59:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: bound-check dir entries in the inline-data
 re-validation scan
To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Junxiao Bi <junxiao.bi@oracle.com>, Changwei Ge <gechangwei@live.cn>,
 Jun Piao <piaojun@huawei.com>, Heming Zhao <heming.zhao@suse.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 zhanxusheng@xiaomi.com
References: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
 <20260811024337.3972976-3-zhanxusheng@xiaomi.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260811024337.3972976-3-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/11/26 10:43 AM, Zhan Xusheng wrote:
> ocfs2_dir_foreach_blk_id() re-scans the inline data area the same way
> ocfs2_dir_foreach_blk_el() re-scans a directory block, and is missing the
> same two bounds:
> 
> 	for (i = 0; i < i_size_read(inode) && i < offset; ) {
> 		de = (struct ocfs2_dir_entry *)(data->id_data + i);
> 		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
> 			break;
> 		i += le16_to_cpu(de->rec_len);
> 	}
> 
> ocfs2_validate_inode_block() keeps i_size inside the inline area:
> 
> 	if (le16_to_cpu(data->id_count) >
> 	    ocfs2_max_inline_data_with_xattr(sb, di))
> 	if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count))
> 
> and that area runs to the end of the inode block, so for a full inline
> directory data->id_data + i_size is the end of di_bh->b_data.  A bogus
> rec_len leaves i in the last OCFS2_DIR_REC_LEN(1) - 1 bytes of it, and
> de->rec_len, at byte offset 8 within the entry, is then read past the
> block.
> 
> The emit loop below hands i_size_read(inode) to ocfs2_check_dir_entry(),
> which refuses both an entry that close to the end and one whose rec_len
> runs past it.  Apply the same two bounds to the re-validation scan, reading
> i_size once into a local as ocfs2_check_dir_entry() takes it as @size.
> 
> Unlike the extent case there is no mask to corrupt here: an unbounded i
> only sets ctx->pos past i_size, which ends the readdir early rather
> than moving it to the wrong place.
> 
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
>  fs/ocfs2/dir.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 39ce60874e17..863c69dec7da 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1812,7 +1812,12 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  		 * dirent right now.  Scan from the start of the block
>  		 * to make sure. */
>  		if (!inode_eq_iversion(inode, *f_version)) {
> -			for (i = 0; i < i_size_read(inode) && i < offset; ) {
> +			loff_t size = i_size_read(inode);
> +
> +			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= size &&
> +			     i < offset;) {
> +				unsigned int rec_len;
> +
>  				de = (struct ocfs2_dir_entry *)
>  					(data->id_data + i);
>  				/* It's too expensive to do a full
> @@ -1821,10 +1826,11 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  				 * least that it is non-zero.  A
>  				 * failure will be detected in the
>  				 * dirent test below. */
> -				if (le16_to_cpu(de->rec_len) <
> -				    OCFS2_DIR_REC_LEN(1))
> +				rec_len = le16_to_cpu(de->rec_len);
> +				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
> +				    i + rec_len > size)
>  					break;
> -				i += le16_to_cpu(de->rec_len);
> +				i += rec_len;
>  			}
>  			ctx->pos = offset = i;
>  			*f_version = inode_query_iversion(inode);

