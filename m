Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E8529DB8F
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 07:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060716; cv=none; b=p0dlJWzoFT6NUJvfl/k4tt2DMDLBmSVrVz7Da5cU/39viPq2gVv/NB7bX1a0Oir2XsP/RDE42t2jIQJn/HCbiIIx6Dtjz37smqktGbArrQGYX0FYgJAbMhWBCFbJDVayaGABDjl5dnsB2krmjwT9QjoedEt5IB7CJWrVTCiStHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060716; c=relaxed/simple;
	bh=x4qndyo2plDeAQ9kTJLziF/T7ypzXc5cD125h3qIsHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D9D2MtKF5StTT6vXAL1HgOhMJtdEkhdowx9Nl2TrAsVLrjaRh27T0qdGd65b4nU+r/twn73vOzM0WSv0t8w2ATBexlsdCJwSrU8YY62zKlN8t96ytca9RJT/H2CV6DofYkBUEZMrsA0BZwmJoksh259XLzXP601V8BicU78KFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ianmlMfF; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ianmlMfF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790060709; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HFmC+IRfrPtNWZDseUNbSSlWv7G2H1MGtwlSyqiIsrM=;
	b=ianmlMfFlWdopvwjzyiwWMBuiPXb3qap2Gy2btKdpaYF3c4kl7rrWkqbMNcadR2wu/kwGkrMbuqogM6/xR3tpKrYn6atxUjsTaNitp1Gyd7H8gtV19R//dC83QriYdnP7D9Gu/3B+HGIDKtuqWthPAfyBAEr9yBs6r73m4lxfdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XBSvLXu_1790060707;
Received: from 30.221.129.227(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBSvLXu_1790060707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 15:05:08 +0800
Message-ID: <168b4677-c25e-4ca5-bba7-4296915890bb@linux.alibaba.com>
Date: Tue, 22 Sep 2026 15:05:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate chunk and block counts of the local quota
 file
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
References: <20260920140710.43938-1-ngocthang2710.1999@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260920140710.43938-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/20/26 10:07 PM, Nguyen Ngoc Thang wrote:
> ocfs2_local_read_info() trusts dqi_chunks and dqi_blocks from the local
> quota file header.  If dqi_blocks is too small,
> ocfs2_extend_local_quota_file() computes a bogus chunk length, extends the
> file, and maps logical block dqi_blocks, which is already in the inode's
> metadata cache (the header or a chunk header read at mount).  sb_getblk()
> returns that cached buffer and ocfs2_set_new_buffer_uptodate() hits
> BUG_ON(ocfs2_buffer_cached()):
> 
>   kernel BUG at fs/ocfs2/uptodate.c:509!
>   ocfs2_extend_local_quota_file+0x45c/0x1100
>   ocfs2_create_local_dquot+0x8ac/0xb50
>   ocfs2_acquire_dquot+0x614/0xae0
>   ocfs2_get_init_inode+0xe9/0x1b0
>   ocfs2_mkdir+0x174/0x430
> 
> ocfs2_local_quota_add_chunk() has the same exposure.
> 
> Reject a header whose counts don't fit the chunk layout or exceed i_size.
> 
> Reproduced with a crafted image (dqi_blocks = 1, chunk 0 dqc_free = 0);
> syzbot has no reproducer for this report.
> 
> Reported-by: syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=03aaa576f1daa1c1f2f0
> Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/quota_local.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..1c9afe38e40e 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -245,6 +245,25 @@ static void ocfs2_release_local_quota_bitmaps(struct list_head *head)
>  	}
>  }
>  
> +/* Check that the on-disk chunk and block counts match the file layout */
> +static int ocfs2_check_local_quota_info(struct inode *inode,
> +					unsigned int chunks,
> +					unsigned int blocks)
> +{
> +	u64 chunk_len = ol_chunk_blocks(inode->i_sb) + 1;
> +	u64 min_blocks = chunks ? 1 + chunk_len * (chunks - 1) + 1 : 1;
> +	u64 max_blocks = 1 + chunk_len * chunks;
> +
> +	if (blocks >= min_blocks && blocks <= max_blocks &&
> +	    blocks <= i_size_read(inode) >> inode->i_sb->s_blocksize_bits)
> +		return 0;
> +
> +	return ocfs2_error(inode->i_sb,
> +			   "Quota file %llu has bad info: %u chunks, %u blocks\n",
> +			   (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +			   chunks, blocks);
> +}
> +
>  /* Load quota bitmaps into memory */
>  static int ocfs2_load_local_quota_bitmaps(struct inode *inode,
>  			struct ocfs2_local_disk_dqinfo *ldinfo,
> @@ -733,6 +752,11 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
>  	oinfo->dqi_libh = bh;
>  
> +	status = ocfs2_check_local_quota_info(lqinode, oinfo->dqi_chunks,
> +					      oinfo->dqi_blocks);
> +	if (status < 0)
> +		goto out_err;
> +
>  	/* We crashed when using local quota file? */
>  	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
>  		rec = OCFS2_SB(sb)->quota_rec;

