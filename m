Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B6A10E5
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Apr 2024 02:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711936957; cv=none; b=nhyDUV/+7eUqpFGzqepF3g1smTYN48ZNROoNpg6ZoX4rTseEaQQYw5jWSWqWCV2SjcfFgIh0u62XhyPeYnocyaLpEKzV66ycHqNBD7T4ZuonefnCa2X0OEetl8UBhoCdNOFQJlqxXCmwyzzysmRZetbDrtvgT2cWPM9oiYGc6+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711936957; c=relaxed/simple;
	bh=D11JDRVNc9HNF9p4HvetAa4/1XREDtMeY5ZEd3OAHWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cF9sSlHQAKG2mHJRYE/VOlCRaDE3Lt0dBVrJhCPcfxsN2gVeKgR87YqAHCu5KHl1HvZRbROY4LIEizHyDUZ2B5gfEPDH8jDGzF7x0+45eF4k1apoJ6LRKhax7c4w18o9BsMvmU3Se5bZ4dUt4p78Jz+4HtXuJ9vKvxiRLa7Ant0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jCLvT+CS; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jCLvT+CS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711936952; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RRlIDCtJMCOOCGDDe9SB5YSU6CBOK+X9O0XHZnS0MaI=;
	b=jCLvT+CSH/SXZZQtMgN0/k9Fj5HhuzkqIXfIvZ7KcC4uGDM7e3mb3JXdvDZfxOHYRxBDmmxjrmZHteJysSXTw10aGTYJ8kOAvE0ocH9KcOvH31kItq/OyYfb+Db3LFDyYAr8SOHp1ZzR7VZcIxTYoIfUDEmtptFwMn1KXLxiieg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3d8LOo_1711936951;
Received: from 30.221.128.209(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3d8LOo_1711936951)
          by smtp.aliyun-inc.com;
          Mon, 01 Apr 2024 10:02:31 +0800
Message-ID: <aefacf75-b77d-4217-8c59-813263127016@linux.alibaba.com>
Date: Mon, 1 Apr 2024 10:02:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] ocfs2: use coarse time for new created files
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
References: <20240331111744.7224-1-l@damenly.org>
 <20240331111744.7224-5-l@damenly.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240331111744.7224-5-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/24 7:17 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> The default atime related mount option is '-o realtime'
> which means file atime should be updated if atime <= ctime
> or atime <= mtime. atime should be updated in the
> following scenario, but it is not:
> ==========================================================
> $ rm /mnt/testfile;
> $ echo test > /mnt/testfile
> $ stat -c "%X %Y %Z" /mnt/testfile
> 1711881646 1711881646 1711881646
> $ sleep 5
> $ cat /mnt/testfile > /dev/null
> $ stat -c "%X %Y %Z" /mnt/testfile
> 1711881646 1711881646 1711881646
> ==========================================================
> 
> And the reason the atime in the test is not updated is that
> ocfs2 calls ktime_get_real_ts64() in __ocfs2_mknod_locked during
> file creation. Then inode_set_ctime_current() is called in
> inode_set_ctime_current() calls ktime_get_coarse_real_ts64() to
> get current time.
> ktime_get_real_ts64() is accurater than ktime_get_coarse_real_ts64().
> In my test box, I saw ctime set by ktime_get_coarse_real_ts64() is
> less than ktime_get_real_ts64() even ctime is set later.
> The ctime of the new inode is smaller than atime.
> 
> The call trace is like:
> 
> ocfs2_create
>   ocfs2_mknod
>     __ocfs2_mknod_locked
>     ....
> 
>       ktime_get_real_ts64 <------- set atime,ctime,mtime, more accurate
>       ocfs2_populate_inode
>     ...
>     ocfs2_init_acl
>       ocfs2_acl_set_mode
>         inode_set_ctime_current
>           current_time
>             ktime_get_coarse_real_ts64 <-------less accurate
> 
> ocfs2_file_read_iter
>   ocfs2_inode_lock_atime
>     ocfs2_should_update_atime
>       atime <= ctime ? <-------- false, ctime < atime due to accuracy
> 
> So here call ktime_get_coarse_real_ts64 to set inode time coarser while
> creating new files. It may lower the accuracy of file times. But it's not
> a big deal since we already use coarse time in other places like
> ocfs2_update_inode_atime and inode_set_ctime_current.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks reasonable.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 55c9d90caaaf..4d1ea8703fcd 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -566,7 +566,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>  	fe->i_last_eb_blk = 0;
>  	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
>  	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
> -	ktime_get_real_ts64(&ts);
> +	ktime_get_coarse_real_ts64(&ts);
>  	fe->i_atime = fe->i_ctime = fe->i_mtime =
>  		cpu_to_le64(ts.tv_sec);
>  	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
