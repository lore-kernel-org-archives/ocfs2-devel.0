Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFE6331A7A
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 08:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767861811; cv=none; b=QC3KmENiHgbb85ZMaG7YoK2vOciRStVI/2qqWyI1CXL4JDuZgnyMkOGZ6NL++YUe2rk5K3+tTxUBQRUs3w/x09w3hZjSONAG8o3CffOxAs7wU3KjhCg9Ccas8/vWYJ6l3vQQ14Bzlsj32+GsafJ2KTV7XrIfl/MYd/CC6R555r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767861811; c=relaxed/simple;
	bh=ivfsNBAVGxXUSJhbdNUSq3B3PhSU90PDYOOAAy5Aew8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sEF2oNd+pu0r1TUpKKzvPQyZ2z8QZpIN0tYyN/N/8uYU9WzAGzLqT5jlmaSsXLQ4L1TyX3EbSS/PcazSa/UAZHnC2+kwWknuYETdsmD1nYdlivISmgFYQyJAOcQisbKoh8ADkkcs5mrxrbXJU6uK+iJpJCn/DlVEzeDMo10dnW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Not9s/SE; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Not9s/SE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767861796; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fTLau4n3Kovtfis5XBeTpHkNmM2prq1BKHeb/rJL2OE=;
	b=Not9s/SEzIGeKlpTE93+YimVQ4X5ggSFVMNgJPqH6IBB1Ha57GhU1FhB0g9SQeEXz3Pq3OQkNA5FAKFydV4YaOTx+XiqpHKCAa42B8r+F02kWEzq77+Gw/MbYEurtpvuZZPpXBh7xWhQEDMBmA4M/qvxSNmPy+oCjm68H4WqKVM=
Received: from 30.221.145.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WwbyboV_1767861795 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Jan 2026 16:43:16 +0800
Message-ID: <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com>
Date: Thu, 8 Jan 2026 16:43:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_acquire_dquot
To: Szymon Wilczek <swilczek.lx@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com,
 syzbot+51244a05705883616c95@syzkaller.appspotmail.com
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251227174251.121668-1-swilczek.lx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/28 01:42, Szymon Wilczek wrote:
> Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() to
> fix a circular locking dependency reported by syzbot.
> 
> The issue occurs because ocfs2_extend_no_holes() internally calls
> ocfs2_extend_allocation() which starts a transaction (acquiring
> sb_start_intwrite). When called while holding the global quota file
> lock, this conflicts with mount-time operations that acquire

It seems the following locking sequence is fine:
ocfs2_lock_global_qf -> start_trans

So could you please elaborate more?

> sb_internal first, creating the following circular dependency:
> 
>   sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key
> 
> By moving the quota file extension before acquiring the global quota
> file lock, we ensure that any internal transactions complete before
> quota locks are held, breaking the circular dependency.
> 
> Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
> Tested-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
> Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
> ---
>  fs/ocfs2/quota_global.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index e85b1ccf81be..136aaaae27f3 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -821,6 +821,19 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>  	trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
>  				  type);
>  	mutex_lock(&dquot->dq_lock);
> +	/*
> +	 * Extend global quota file before acquiring global qf lock to avoid
> +	 * lock inversion with sb_internal (via ocfs2_start_trans).
> +	 */
> +	if (need_alloc) {
> +		WARN_ON(journal_current_handle());
> +		status = ocfs2_extend_no_holes(gqinode, NULL,
> +			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
> +			i_size_read(gqinode));
> +		if (status < 0)
> +			goto out;
> +	}
> +
>  	/*
>  	 * We need an exclusive lock, because we're going to update use count
>  	 * and instantiate possibly new dquot structure
> @@ -843,19 +856,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>  	OCFS2_DQUOT(dquot)->dq_use_count++;
>  	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
>  	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
> -	if (!dquot->dq_off) {	/* No real quota entry? */
> +	if (!dquot->dq_off)	/* No real quota entry? */
>  		ex = 1;
> -		/*
> -		 * Add blocks to quota file before we start a transaction since
> -		 * locking allocators ranks above a transaction start
> -		 */
> -		WARN_ON(journal_current_handle());
> -		status = ocfs2_extend_no_holes(gqinode, NULL,
> -			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
> -			i_size_read(gqinode));
> -		if (status < 0)
> -			goto out_dq;
> -	}
>  
>  	handle = ocfs2_start_trans(osb,
>  				   ocfs2_calc_global_qinit_credits(sb, type));

BTW, even if your analysis is right, here also calls ocfs2_start_trans().

Thanks,
Joseph

