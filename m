Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BAE446A2
	for <ocfs2-devel@lists.linux.dev>; Fri, 22 Mar 2024 12:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711111292; cv=none; b=JFdhTZOPOY++nqwFUJMy6/xhCR/dRYn8leOoDS7qIcA1GfdUgc6ID3qI2fB0GSo11vRq0ANP6Vn7UnzDIBd2xhv0uffmVap5+AhIVWFaG6MVIrjhMkUUwFi3rvgYm4WaBhXd4FQWw4lHDAS/UbxHtE/5bivrILcfrgSnG4khOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711111292; c=relaxed/simple;
	bh=3Je8w2bAEmEHX1T7e/jY+IL0n4dVZyCdK5mweC9BXJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIoitIblDEZw9OfRgW6zr2IFsOkA5LWQ+0M8VuUA6fyG4vebHX4cnkxk7Z9FEklxTYweOY0jqtX9iarW7brcv0jbb9pffXQ9NAqpXAudJpLGqDSJ7Ud/CnKPrIylAYWIqql+Tn9HdjsWKp+fTrh7hrAkd431e7zb8LXAZ8p6caQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cVgkw9qm; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cVgkw9qm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711111286; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xAE0vYbfun0EnTckxuzzM5D85GyEmtWY8TOlqPzbd/Y=;
	b=cVgkw9qm8t8V7qtcGpyGCFuMt6/LWLqY/5Pp8hU1jaRw7JmXCJyfvgU8UdVPu7ebbqq3+w8lA4vfUQSSNdbUOtPwNRZ+zRoDyzjHmz0VISPq1rWvNKHtHWUemfbtEiq4nR9Sy4857EODaGrlXxsMwx0DuS/x8OWOvA3bOLlQRfs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W327Cer_1711111284;
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W327Cer_1711111284)
          by smtp.aliyun-inc.com;
          Fri, 22 Mar 2024 20:41:25 +0800
Message-ID: <23f6cc23-9f9b-405b-8c8e-5cda14e79587@linux.alibaba.com>
Date: Fri, 22 Mar 2024 20:41:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] fs: Add kernel-doc comments to
 ocfs2_prepare_orphan_dir()
Content-Language: en-US
To: Yang Li <yang.lee@linux.alibaba.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240322063718.88183-1-yang.lee@linux.alibaba.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240322063718.88183-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/22/24 2:37 PM, Yang Li wrote:
> This commit adds kernel-doc style comments with complete parameter
> descriptions for the function ocfs2_prepare_orphan_dir.
> 
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 9221a33f917b..8a61c5f94533 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2187,8 +2187,10 @@ static int __ocfs2_prepare_orphan_dir(struct inode *orphan_dir_inode,
>   * @osb: ocfs2 file system
>   * @ret_orphan_dir: Orphan dir inode - returned locked!
>   * @blkno: Actual block number of the inode to be inserted into orphan dir.
> + * @name: Buffer to store the name of the orphan.
>   * @lookup: dir lookup result, to be passed back into functions like
>   *          ocfs2_orphan_add
> + * @dio: Flag indicating if direct IO is being used or not.
>   *
>   * Returns zero on success and the ret_orphan_dir, name and lookup
>   * fields will be populated.
