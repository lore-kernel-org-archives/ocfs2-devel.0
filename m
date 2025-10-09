Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B490F9C1
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759973696; cv=none; b=FTXQen/ZE6mwsnFcwYwkOGW+u6gMWpmFCnA/2n/SNRTRLOmJ+W210MCaw2VxKt/g2cDhcTTcVZPhD6M4e4zZCJ1pBmUv1FMJtkvVnRZZQeFNFOqgE5BXT1ktxcctbB15GB8AvoG0E4PLzZwu1xLHrtKgee5PkSgCEL1yYE9ayFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759973696; c=relaxed/simple;
	bh=uvrjhLvAYfZOfvdcnoX6f2sEkNTlZoS2jBSE2bogMfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5SQW7B63/ilSeSg0bskV5/0cMP5YccYMvXYL4vMg3iH2gj3HWWQCOwxGr/Ew4jKe+WSfNQ6f3IJOrgkcdUvk2YaVm+ZwdBC9Tdhy2a4V1iKAz3uJKJiLrxwf7RIAFFNpKGcbiWlrAnHq5VJ1BBrsjANusOd0me5EXqdNEUZ7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DzgT6n3e; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DzgT6n3e"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759973690; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=I3slU/IaP0WiQpxT/JegwFgxdB3cll3URPm28WT3mIc=;
	b=DzgT6n3eDoj2PHNgLwohYCSu1nObo61DvWva5AN4GloIPaVtakfkoUva5nviNzKY60gVC14BvMHXO+yOzF1q2VB8DAsMKuuOHqk8BQKoFM5mYEeu4O6o6paeMaURs88jSY6ZXGTlI2vDDRxxk0R11c4webRjvfikTUGWS5RqxsY=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpgW.lk_1759973372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 09:29:33 +0800
Message-ID: <5df01bdb-caae-47e7-90f2-d14e3982f4d7@linux.alibaba.com>
Date: Thu, 9 Oct 2025 09:29:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix use-after-free in ocfs2_dx_dir_lookup_rec
To: ssrane_b23@ee.vjti.ac.in, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <20251005151403.9012-1-ssranevjti@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251005151403.9012-1-ssranevjti@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
This seems to be fixed by the following commit:
44acc46d182f ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()

Thanks,
Joseph

On 2025/10/5 23:14, ssrane_b23@ee.vjti.ac.in wrote:
> From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
> 
> A syzbot report triggered a KASAN use-after-free read when creating a
> file on a corrupted OCFS2 filesystem image.
> 
> The crash occurs in an error-handling path within the
> ocfs2_dx_dir_lookup_rec function. When the function fails to find a
> matching extent record (`found` is false), it attempts to log details
> about the corruption by reading from the `rec` variable.
> 
> According to the KASAN report, the memory pointed to by `rec` can be
> invalid at this point, leading to a kernel crash.
> 
> Fix this by modifying the error message to use only variables that are
> known to be safe, such as the inode number and the extent block's
> buffer head block number. This preserves the valuable error log for
> debugging corrupted filesystems while preventing the memory safety
> violation.
> 
> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
> Tested-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
> Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
> ---
>  fs/ocfs2/dir.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..8c4dd61efa8d 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -820,8 +820,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  		ret = ocfs2_error(inode->i_sb,
>  				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
>  				  inode->i_ino,
> -				  le32_to_cpu(rec->e_cpos),
> -				  ocfs2_rec_clusters(el, rec));
> +				  eb_bh ? (unsigned long long)eb_bh->b_blocknr : 0);
>  		goto out;
>  	}
>  

