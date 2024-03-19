Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D4F2F22
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Mar 2024 01:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710812590; cv=none; b=u5eS9JkVTiyNGIZZYm5e8SjMYvdpDBoDfbA8PEWBAR0G81YWq6xsDTUWB82hPAmjXfhzu1pJEm7w2LL+YuJDQa3iTmeTy0OekJBMy5P/Zip2xB+fRkbAGmLKmA8wPNYZUfHX5MI3Q7KflThtrpYaV1p/EhOPsnAeOIokcWQCACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710812590; c=relaxed/simple;
	bh=TvNTc8FzPq+JeREItM2EthjVSE6XjO7hLM2aojWLJHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=szVNomHfrNW70z/nVQc/MWHSrmDLcZQA6W3pvyeOLP7rGh+ayiikXQLpR7Q0k/ACdZBMBkTjL+8aPEtpjKlhlGu8+MjUUm1Uun+bOvLaDJuULTPySgNQ3iH57N4bCwRP5SWoWeg/keoe5Y1kwP7oOs6tDOgtn75sWCFL724rhQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hwmm47rb; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hwmm47rb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710812585; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yfU+eBBFJl4Z6MSwo9UFHmUezic3wTNiRFqLlOS+Rmw=;
	b=hwmm47rbUY9sx5RROTxYKy1vYUUDtIJaK2/4Tk3QYg9Ui3G+kJGSsQXn7jfnXzMIYC64Zvx2HEENgK2CGuJ69WuO7uQycOyi/99C3m6Mg+vPGSJytqmTJEuRR+IkEeIQrwV6HsuMvei8Pvinuqwp/DUTznXAGu9Lmhh5uL/w4sc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W2qr6G2_1710812584;
Received: from 30.221.129.228(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2qr6G2_1710812584)
          by smtp.aliyun-inc.com;
          Tue, 19 Mar 2024 09:43:04 +0800
Message-ID: <e1d44e5a-aae4-4331-a276-2f71b64f2198@linux.alibaba.com>
Date: Tue, 19 Mar 2024 09:43:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: update inode ctime in ocfs2_fileattr_set
Content-Language: en-US
To: Su Yue <glass.su@suse.com>, akpm <akpm@linux-foundation.org>
References: <20240318115609.3194-1-l@damenly.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
In-Reply-To: <20240318115609.3194-1-l@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/18/24 7:56 PM, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> inode ctime should be updated if ocfs2_fileattr_set is called.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/ioctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index b1550ba73f96..71beef7f8a60 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -125,6 +125,7 @@ int ocfs2_fileattr_set(struct mnt_idmap *idmap,
>  
>  	ocfs2_inode->ip_attr = flags;
>  	ocfs2_set_inode_flags(inode);
> +	inode_set_ctime_current(inode);
>  
>  	status = ocfs2_mark_inode_dirty(handle, inode, bh);
>  	if (status < 0)
