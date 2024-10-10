Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEA21C4600
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Oct 2024 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728562926; cv=none; b=HGRLMutpkv2fV+8OBoTVGrEnuxt/JpkEU9qJcesqIHFH6qksMHn2Qlavh/GiXsMnD4YtgpTkSFmwIaLRj2lpQdjxS5GGTEvlO136i4b7EUomh0vXweHXAYibTfPJFV44LrercQaJSU2PKb8gg2kcq8LgfR1YglsOtMY3K4RfL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728562926; c=relaxed/simple;
	bh=aSsLD/2YVlQ4ipaA0/wB4H7bnwyHOJzmXA71hqS/C0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4UkgrWMzSc7sqjQKdOuEXSyQmjFVPuH7RWaIDeGrhJ9PJiX3aeEOAvGxvEhzF8NFuwH/qoc6inqJzP8OYlQ2V8QHqieg8PMOUfRJG4nte+w3KPtTMYiSQx9bxvNaKJqGhC23SJeO3VA34ocGUNWlSZchkSBqqDX3H4TC2rdHxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lz4t8QL1; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lz4t8QL1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728562922; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H7AUSm5pX1sMuXp2biuJaMWKGAYiM60rDEEuvukFCl8=;
	b=lz4t8QL1ct3qWSEy3EGJ7UIqyN7MjQ/slqEKH6gYeSBBWKGq3vnk7PJ2mKtY8jaFLd310iXpQbc2RHeO8FHZONh4PkN6J56CQp3WGgcQutr2WaKU8w0vNhScPZEkyiB9jH05NlncAP9HhoAGENXtVK7pO3gl1Oiz2FvAB9Jy9Sg=
Received: from 30.221.129.173(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WGmMX0f_1728562920 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Oct 2024 20:22:00 +0800
Message-ID: <4195446e-2d2b-442c-a1ad-b1498d243a70@linux.alibaba.com>
Date: Thu, 10 Oct 2024 20:21:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
To: Edward Adam Davis <eadavis@qq.com>,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <67062030.050a0220.3f80e.0024.GAE@google.com>
 <tencent_B22CA96C8896C0E9FEEFD2CCAC795A6E500A@qq.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_B22CA96C8896C0E9FEEFD2CCAC795A6E500A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/24 11:05 PM, Edward Adam Davis wrote:
> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
> There are two reasons for this: first, the parameter value passed is greater
> than UINT_MAX, second, the start and end parameters of ocfs2_truncate_inline
> are "unsigned int".
> 
> So, we need to add a sanity check for offset and len in ocfs2_fallocate, if
> they are greater than UINT_MAX return -EFBIG.

fallocate should accept loff_t (aka long long) offset and len.
I guess the reported bug is caused by a crafted image, which set
overflow offset and len in case of inline data (with flag
OCFS2_INLINE_DATA_FL set).
So IMO, the right place to add a sanity check is right before
ocfs2_truncate_inline() in ocfs2_remove_inode_range().

Thanks,
Joseph

> 
> Reported-and-tested-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/ocfs2/file.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ad131a2fc58e..ed26ec8ac6b6 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2117,6 +2117,9 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
>  			return ret;
>  	}
>  
> +	if (offset > UINT_MAX || offset + len > UINT_MAX)
> +		return -EFBIG;
> +
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		cmd = OCFS2_IOC_UNRESVSP64;
>  

