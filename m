Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AE3B66F
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 06:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710224623; cv=none; b=FDG6KZx8RcWBYxgyp0QpO48+z+1qGc4b2H4Wg/yFscJhgT/lzC0mzyWkVP/d/UasCvFaei86cY30C3X2MISjKufRTiK6GGfIOCCMEpwDdaEhNnNrN4ZNogOr7imXN5afhRxvDP7WNJZiVgMFt3kdHPuKPO4DEaCpQE7EaIb1rBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710224623; c=relaxed/simple;
	bh=+5LHTQqB9WsCFFeOHN3EDpMG0s2MZm/RQW81qTZxqjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nimEvnUiOFbWQlZuxkxjHUgHs++wHa7RuyYUDN3f2Q4tVeH9L/OVwS3KWEe/iPpOzqJ70vRtmHgOr+yhyNWhFsAOmjXPQpkmVoK1L+1i8wqgtzIXr7pgcjm80xOnQyAe2x4WsL/ks99lhzhe9zbov9rj4MPWw4LxmQK+LqQhtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XNMpbv9w; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XNMpbv9w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710224617; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BXl2OBlcbT2ToUa++EpOEZsb+eFfhCw2oKx/Wm4RVew=;
	b=XNMpbv9wz69rONw2MWt4cUrZNPKyR0F1Or40MOYixRWJk0rzZz93yMNQ9WjepWLVGeur0DYGB75kFECLRgzgJWsLddKBkhVU9iboe0CpjXLO333SwV80iMtWxVhKzPgdyTCTYwp9/iGfjyj4vOOS2pIW/uhw1qC8H+Q/Qjdz/MQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W2Km2pb_1710224615;
Received: from 30.221.131.212(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2Km2pb_1710224615)
          by smtp.aliyun-inc.com;
          Tue, 12 Mar 2024 14:23:36 +0800
Message-ID: <4e04ff5f-45d6-4d61-b630-0c7116a972d5@linux.alibaba.com>
Date: Tue, 12 Mar 2024 14:23:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: enable ocfs2_listxattr for special files
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
References: <20240312042908.8889-1-l@damenly.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240312042908.8889-1-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/12/24 12:29 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> For special files in S_IFBLK/S_IFCHR/S_IFIFO type, we already
> have ocfs2_setattr and ocfs2_getattr enabled.
> It's confusing for user space if it can use setattr/getattr to
> control one attribute appointed but can not list attributes
> using listxattr for above type files:
> 
> $ mknod /mnt/b b 0 0
> $ setfattr -h -n trusted.name -v 0xbabe /mnt/b
> $ getfattr -n trusted.name  /mnt/b
> getfattr: Removing leading '/' from absolute path names
> trusted.name=0sur4=
> 
> $ getfattr -m trusted  /mnt/b
> $
> 
> Fix it by enabling ocfs2_listxattr for ocfs2_special_file_iops.
> After the commit, fstests/generic/062 will pass.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Acked-by: Joseph Qi \<joseph.qi@linux.alibaba.com\>

> ---
>  fs/ocfs2/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 8b6d15010703..0da8e7bd3261 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2763,6 +2763,7 @@ const struct inode_operations ocfs2_file_iops = {
>  const struct inode_operations ocfs2_special_file_iops = {
>  	.setattr	= ocfs2_setattr,
>  	.getattr	= ocfs2_getattr,
> +	.listxattr	= ocfs2_listxattr,
>  	.permission	= ocfs2_permission,
>  	.get_inode_acl	= ocfs2_iop_get_acl,
>  	.set_acl	= ocfs2_iop_set_acl,
