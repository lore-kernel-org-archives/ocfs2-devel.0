Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA012F29
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 02:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976443; cv=none; b=IZYEVDVup9N9UcHSwQpl2IxFx8OaTGIcD3qy+HBB61DPHIgeWFCvpF4uDuoCvd3boRMLsCVlN6mUXY3F8vIIrMK/O89OPIkTNO61AsVFdAi9aV+wooFjFozoo6nKUE/7wCxdSTfrPSDy3VcLh/yrkatTUiVUoee1IBH+JHIf8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976443; c=relaxed/simple;
	bh=QddCrSlSfud9xwLlIAadjQr8jXfFFifcl3SWKGQJtPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dj+1668wPR73c6m72rwg9j5Iz+tOE1nqpui0eDFypNxb4G3Jegz6Jdfk67F/qlwGS5gToRthJsqsLrQCr9ohit0CaTDpbAVyTTs4OJ2R2YyD2zxiTJbuQ+F8CawW+REFVww9bHzvRGMwfyPjGrGPqdKpWy6/iDmH0bgdyxxJpZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ebjRNBCO; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ebjRNBCO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759976438; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5wDXPM+yx4pnWrOtwBYW4f1Ae8DOagBUoOEYJ7esGQk=;
	b=ebjRNBCOxouzoCK+BRXOKusC/0x2G13ViwWXCkliETQZhixG1P0iKE9QsWpQs0vhRK6oJs1UbLbb3NJ60JMVV0/8/ofLYD1RP9w5V7HDF/ouwh6UeF15sJGdnFDov1vrwjuvaNhsXCYBTPa0dQy8gXFCYAy7XlWX99KUxc4SetU=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wpght00_1759976121 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 10:15:21 +0800
Message-ID: <8df4d266-6e41-43fb-9412-5a2ccbcf0d96@linux.alibaba.com>
Date: Thu, 9 Oct 2025 10:15:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extra flags check in
 ocfs2_ioctl_move_extents()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
References: <20251008112031.2369598-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251008112031.2369598-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/8 19:20, Dmitry Antipov wrote:
> In 'ocfs2_ioctl_move_extents()', add extra check whether only actually
> supported flags are passed via 'ioctl(..., OCFS2_IOC_MOVE_EXT, ...)',
> and reject anything beyond OCFS2_MOVE_EXT_FL_AUTO_DEFRAG and
> OCFS2_MOVE_EXT_FL_PART_DEFRAG with -EINVAL. In particular,
> OCFS2_MOVE_EXT_FL_COMPLETE may be set by the kernel only and
> should never be passed from userspace.
> 
> Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/move_extents.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..e038c009cdef 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -1031,6 +1031,12 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  	if (range.me_threshold > i_size_read(inode))
>  		range.me_threshold = i_size_read(inode);
>  
> +	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
> +			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
> +		status = -EINVAL;
> +		goto out_free;
> +	}
> +

The check here looks fine.
Could you please elaborate more how it fixes the reported bug?

Thanks,
Joseph 

>  	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
>  		context->auto_defrag = 1;
>  

