Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9A74C7B
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jul 2024 01:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721092783; cv=none; b=AMjpCAHslTIPQ7AxQFchWMO0Y+8fm+AKdkBn3doO7Htg8DKUsqsvnJpXOxuqoETX707oq/9eG3aDLhyG+/eKAlRVzId0ADOOIH4c+7e1y2Oljp0f/rJttmjCnl1yYCqnnF/h4zPjX/+MQ98aS7d27KbywM76NwCjr2pr2VSPwI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721092783; c=relaxed/simple;
	bh=DJ09cF3HsJTJHuU7bu45zXCFCvS3d9+y+Q76yGosF98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPIxl3bcZ0Q/hSYQSVep+jDrvbZiy5SyAMZUOlxxCR/yJ53T5ITcOVzeUrg24trjXKj0C6xn05g2XV3CzTatwSV+YcAEAbuj586nHEYmuIPWVxHR4+s4hyv3x81NlQK100xkgYob/rFHLLXjl6U2wuXgfBo1uKMRZMdsPNfbXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cr0h4GhR; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cr0h4GhR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721092773; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xec8Q/X1EdPBny7ED667Auisr/10A9HW03C61vOQHzQ=;
	b=cr0h4GhRkjOKvTBKDtLKs5wQoVKOFiH+rwpvtWGaSjz3s8K8esEI+IFxvxA5ycSy/WPxBSwBIK1MEO4FeqhXm1OvN55vR/UcJJxk7Q0CUrovKsT9qBuBlPhD3MBYZkgXnLRFtOJhntGy8fc7WqIFxv9R7x0vt5LP/zodNIFFGAs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0WAfQXmk_1721092771;
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WAfQXmk_1721092771)
          by smtp.aliyun-inc.com;
          Tue, 16 Jul 2024 09:19:32 +0800
Message-ID: <7ed24ac3-73ad-4cd0-ba27-c4e8098c5830@linux.alibaba.com>
Date: Tue, 16 Jul 2024 09:19:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] quota: remove unneeded return value of
 register_quota_format
To: Kemeng Shi <shikemeng@huaweicloud.com>, jack@suse.com
Cc: mark@fasheh.com, jlbec@evilplan.org, hughd@google.com,
 akpm@linux-foundation.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
 <20240715130534.2112678-3-shikemeng@huaweicloud.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240715130534.2112678-3-shikemeng@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 7/15/24 9:05 PM, Kemeng Shi wrote:
> The register_quota_format always returns 0, simply remove unneeded return
> value.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  fs/ocfs2/super.c      | 6 ++----
>  fs/quota/dquot.c      | 3 +--
>  fs/quota/quota_v1.c   | 3 ++-
>  fs/quota/quota_v2.c   | 9 +++------
>  include/linux/quota.h | 2 +-
>  mm/shmem.c            | 7 +------
>  6 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index afee70125ae3..73caa8914ebe 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1571,15 +1571,13 @@ static int __init ocfs2_init(void)
>  
>  	ocfs2_set_locking_protocol();
>  
> -	status = register_quota_format(&ocfs2_quota_format);
> -	if (status < 0)
> -		goto out3;
> +	register_quota_format(&ocfs2_quota_format);
> +
>  	status = register_filesystem(&ocfs2_fs_type);
>  	if (!status)
>  		return 0;
>  
>  	unregister_quota_format(&ocfs2_quota_format);
> -out3:
>  	debugfs_remove(ocfs2_debugfs_root);
>  	ocfs2_free_mem_caches();
>  out2:
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 23fcf9e9d6c5..a08a71890cd8 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -163,13 +163,12 @@ static struct quota_module_name module_names[] = INIT_QUOTA_MODULE_NAMES;
>  /* SLAB cache for dquot structures */
>  static struct kmem_cache *dquot_cachep;
>  
> -int register_quota_format(struct quota_format_type *fmt)
> +void register_quota_format(struct quota_format_type *fmt)
>  {
>  	spin_lock(&dq_list_lock);
>  	fmt->qf_next = quota_formats;
>  	quota_formats = fmt;
>  	spin_unlock(&dq_list_lock);
> -	return 0;
>  }
>  EXPORT_SYMBOL(register_quota_format);
>  
> diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
> index 3f3e8acc05db..6f7f0b4afba9 100644
> --- a/fs/quota/quota_v1.c
> +++ b/fs/quota/quota_v1.c
> @@ -235,7 +235,8 @@ static struct quota_format_type v1_quota_format = {
>  
>  static int __init init_v1_quota_format(void)
>  {
> -        return register_quota_format(&v1_quota_format);
> +	register_quota_format(&v1_quota_format);
> +	return 0;
>  }
>  
>  static void __exit exit_v1_quota_format(void)
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index c48c233f3bef..1fda93dcbc1b 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -440,12 +440,9 @@ static struct quota_format_type v2r1_quota_format = {
>  
>  static int __init init_v2_quota_format(void)
>  {
> -	int ret;
> -
> -	ret = register_quota_format(&v2r0_quota_format);
> -	if (ret)
> -		return ret;
> -	return register_quota_format(&v2r1_quota_format);
> +	register_quota_format(&v2r0_quota_format);
> +	register_quota_format(&v2r1_quota_format);
> +	return 0;
>  }
>  
>  static void __exit exit_v2_quota_format(void)
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 07071e64abf3..89a0d83ddad0 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -526,7 +526,7 @@ struct quota_info {
>  	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
>  };
>  
> -int register_quota_format(struct quota_format_type *fmt);
> +void register_quota_format(struct quota_format_type *fmt);
>  void unregister_quota_format(struct quota_format_type *fmt);
>  
>  struct quota_module_name {
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a8b181a63402..d27104e1af9b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4660,11 +4660,7 @@ void __init shmem_init(void)
>  	shmem_init_inodecache();
>  
>  #ifdef CONFIG_TMPFS_QUOTA
> -	error = register_quota_format(&shmem_quota_format);
> -	if (error < 0) {
> -		pr_err("Could not register quota format\n");
> -		goto out3;
> -	}
> +	register_quota_format(&shmem_quota_format);
>  #endif
>  
>  	error = register_filesystem(&shmem_fs_type);
> @@ -4693,7 +4689,6 @@ void __init shmem_init(void)
>  out2:
>  #ifdef CONFIG_TMPFS_QUOTA
>  	unregister_quota_format(&shmem_quota_format);
> -out3:
>  #endif
>  	shmem_destroy_inodecache();
>  	shm_mnt = ERR_PTR(error);
