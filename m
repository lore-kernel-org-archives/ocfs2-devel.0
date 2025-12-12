Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0F016F288
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765518515; cv=none; b=RcYCYCLHeN37w28MxAFOmI46A2mr+5XPVSOjwQb+AsNnaCtSu2q1+JMqhP/LHMXUIAiq+jOyesV3AffVFr8cQ3+HyPEFHlGgFHf16GBDYspeG16aefisSXSpHscokboy5uHFmb1Yesa2ViLs0li/yI3IqjAvKoU1zCUiBHrdYl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765518515; c=relaxed/simple;
	bh=XuxyYTJ+8/dYlZyCXciSVva83kz7+Vq0KD9gtLbkp60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUg9cGGCS02q/X4KlVaenkdkH9YEwzWYnTvbTBosHwt2m809MLqYzPXSoCOEYVfMEAEarG8vXQMOgXEii+OEY3DNuV0xIh2mRdBMPd1GqAa0JKLB7odCg9p1zDU9Xqoo26n44eNVUMlFttkWK/wPB7qkFT4oNvONEvl721NZK0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tJyM7NiC; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tJyM7NiC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765518502; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9NLW99O7pMh4FQr4SOmLZT9MScCqeTPSZCkmGHQOjXg=;
	b=tJyM7NiCh9TUYMCEAMJlmywTB1yhVOnHcSVK/NUth9QqAM7t9oMoexXurrgAxNOC4UWm5P8aZlYeFHrxNIz2RPhgiCa2JHMG/5xCoUIb45ap107qIltqiJsccjrTHhzq8AMuW8Xkf0kDrg6t+S42afT389fm0SJm6m2e79kbh4M=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wud1jKs_1765518501 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 13:48:21 +0800
Message-ID: <5c47b8a5-f9fa-45b1-9966-442a45a4e3b6@linux.alibaba.com>
Date: Fri, 12 Dec 2025 13:48:19 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate i_refcount_loc when refcount flag is
 set
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
References: <20251212045646.9988-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251212045646.9988-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 12:56, Deepanshu Kartikey wrote:
> Add validation in ocfs2_validate_inode_block() to check that if an
> inode has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid
> i_refcount_loc. A corrupted filesystem image can have this inconsistent
> state, which later triggers a BUG_ON in ocfs2_remove_refcount_tree()
> when the inode is being wiped during unlink.
> 
> Catch this corruption early during inode validation to fail gracefully
> instead of crashing the kernel.
> 
> Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
> Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v2: Shortened error message to fix line length (Heming Zhao)
> ---
>  fs/ocfs2/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 78f81950c9ee..06f1f9e21423 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) &&

I'd like to covert it to host endian to keep consistent with other checks.

Thanks,
Joseph

> +	    !di->i_refcount_loc) {
> +		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
> +				(unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	}
> +
>  	rc = 0;
>  
>  bail:

