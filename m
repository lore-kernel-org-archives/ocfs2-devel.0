Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9058E4052D7
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788430557; cv=none; b=rJNo9a16rHcNnJFTUFo4/R59iHYwEYALH0te8VXKsYqBJSG9MpaxPTX+hN6VCBySf6CFl91EasxkuCRbqsTGO1mqFgWoGakQKuzX1gXZhs+F2vhi8JrNBWVJUv14UlmZ1fffArSVbHhbsqv1tYBkkF9LPYfqkGta62vVeIaZmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788430557; c=relaxed/simple;
	bh=+bejIuWBQPs5IrJ0YHxkejyGC/P6RmGiMGEsbYd99ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avGmvsGOc9M8zN98Lra6UqEezBw6sKXVhvEVsbxyOfplyGaRc7gLC/NR5PyO/ayL1hOq9Ls8H3bniGibtLqgDbzttm9Lvjd3WLvcx+OdqqcnTpjd/mCmx0yn9oqlVGHmduz0qjAkF7UsGpHHFDgpAskoub5/v5NRJH4TSMFM8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sPJYGYnG; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sPJYGYnG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788430540; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OyJ6y9tOxjQFUNrQBycZ3KwqBU7c38czB5+Luukp45Q=;
	b=sPJYGYnG2txk19WRr+QhFf9NRCGG1p1D3k/+nnBE6DnVZmhe2bT3CSBy1My8mA992KkTpxpMeQlY75oxB4i1L7c16mxirzxZFqnKkrI/cz2IM2eZA7BScMc88TsFSALewyxEgTxLsoA8r5krN2gCyMgBU/h1uNMzq47NFEjeWQs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAFjWt3_1788430538;
Received: from 30.134.112.244(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAFjWt3_1788430538 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:15:39 +0800
Message-ID: <0dfb2aff-47a7-42bc-8698-da7d9f89663c@linux.alibaba.com>
Date: Thu, 3 Sep 2026 18:15:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: Refuse to enable ocfs2 format for another
 filesystem
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, ocfs2-devel@lists.linux.dev,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260903090053.13120-1-jack@suse.cz>
 <20260903090508.1360863-3-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260903090508.1360863-3-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/3/26 5:05 PM, Jan Kara wrote:
> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using ocfs2 quota format. With suitable
> passed arguments this can get upto ocfs2_local_check_quota_file() where
> the passed superblock is from the ext4 filesystem and that can cause all
> sorts of interesting things, most likely crashes. As ocfs2 quotas are
> specific to ocfs2 filesystem, verify we are indeed enabling quotas
> there.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_local.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..a2b276bcd0a8 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  	struct ocfs2_disk_dqheader *dqhead;
>  	int status, ret = 0;
>  
> +	/* OCFS2 quota format is supported only for OCFS2 filesystems */
> +	if (sb->s_magic != OCFS2_SUPER_MAGIC)
> +		goto out_err;
> +
>  	/* First check whether we understand local quota file */
>  	status = ocfs2_read_quota_block(linode, 0, &bh);
>  	if (status) {

