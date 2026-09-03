Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1F27AC45
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399418; cv=none; b=PEVBsWSdNvmdiN+Gqe936jWFvRctXtisTOBFwumhBKZn9PQFp7Ytaumo8vT2jnwGogeMCZ2eoLr5U7s7MHsmxZcxWp08qsljMJa35ePM422MI58yj/WyhyCiossx5K81bzFxEFSKVv7yNGY1rCJvvb6guR1dCSsZPj2+U6WTqzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399418; c=relaxed/simple;
	bh=A9wPB/8EmOQCGuIA98MTaeW5eFFBrCkau+sQczMZbwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5vsq+hQRwetTzRsNsiBRVsRh3RE4cbXK7QCHsyACt+16dszRy6CSEjwDdiKr2a/QnN+6yluDV30jDXbht6gk0QfjjnzE6Zn6jIAmF/qTUCXC3Y83TUq78f3xQGHn/GRqHI8+MuxIORmRO8T7yWSFadPvJXlCrYlhgcoifphfVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Xi+G5uut; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Xi+G5uut"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788399413; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e541pMb9oMqhXLTyZBftOnSifT1JVi2i2ff57bVED4c=;
	b=Xi+G5uut+AJDQNkvLZyBkcSMfM28p9ORQ3yaTodx/LvGGOk89zMyBsyAYdVRLhqp/9KdQJxhQ6XQ9Ncv9afZDLXoLnYwbyD94Mu0kDffOZcXwL2JyICaQMeNcFLOLaHCFFslIEvw5uS9iFmoxckZMi9bvwyuV1viv7+FDbX2gw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAEOibv_1788399411;
Received: from 30.221.131.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAEOibv_1788399411 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 09:36:52 +0800
Message-ID: <8d78e72c-a7f5-4b08-a249-34e924bda588@linux.alibaba.com>
Date: Thu, 3 Sep 2026 09:36:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another
 filesystem
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, ocfs2-devel@lists.linux.dev,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260902132458.23590-1-jack@suse.cz>
 <20260902133702.1313635-3-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260902133702.1313635-3-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/26 9:36 PM, Jan Kara wrote:
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
> index f55810c59b1b..97dee8ee6096 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
>  	struct ocfs2_disk_dqheader *dqhead;
>  	int status, ret = 0;
>  
> +	/* OCFS2 quota format is supported only for OCFS2 filesystems */
> +	if (strcmp(sb->s_type->name, "ocfs2"))
> +		goto out_err;
> +
>  	/* First check whether we understand local quota file */
>  	status = ocfs2_read_quota_block(linode, 0, &bh);
>  	if (status) {

