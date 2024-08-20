Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E918EFF4
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 12:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724157890; cv=none; b=OA6anjyBI2wVkwFHPpTIDDXH/0li01SBJfs02puqnHKSfU3Tf4QGvLfGkif5gSE/bmVR90/nVAc3Nm1A1zhgYYX6wV3jVwQC5SRlUVU7X2+d+Fh+7xKxH0jsK20P9DnhlNrBNHVuIty3Ho6Dv38siRSJz+4sZSv1cae3fTxifeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724157890; c=relaxed/simple;
	bh=MCmWaWGj/nB1UwzulXx/ypO+Lvf91G7f9HziNg3QAYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ETCUeqBTCE30KjwEhsk6QfjNfFq68l1XTezZZkKE0aIXx7S4kPguROafRSG8hvXV0jPWPBAg23EOq+YpLjddFNYr/JxnpDD5s4zWp06bp+ng1n9CPf/FK6XQ8xw97hliMJ3QS0LR7Wkwl3VbbNdgSa4ELOWSBwDZybdHGxB15R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=saMy/zCm; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="saMy/zCm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724157879; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p6F69Zfp7ApOoK70J6CqbfRGCkiGhKLxfxHTkQWsHbc=;
	b=saMy/zCm3nvTSS7lduacif/xY/8Eh/UWdxDEwtFHfYLiuHCpehMTn8/rz7igSpIoFVJfwaIoHgZ2N/cztAqjWc6ePD/7Kfe0b/x80w1RT8uA9YV1Pn3EAEZ+4cdVFCki2qy2puIuryJqnT49tdIDVbUXPQNE57RE+iT05yme5+8=
Received: from 30.221.128.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDIj1pp_1724157877)
          by smtp.aliyun-inc.com;
          Tue, 20 Aug 2024 20:44:38 +0800
Message-ID: <205e0d29-2567-4d82-a024-a8e7826d9f18@linux.alibaba.com>
Date: Tue, 20 Aug 2024 20:44:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
To: Edward Adam Davis <eadavis@qq.com>,
 syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <0000000000005894f3062018caf1@google.com>
 <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 8:08 PM, Edward Adam Davis wrote:
> When the i_size of dir is too large, it will cause limit to overflow and
> be less than de_buf, ultimately resulting in last_de not being initialized
> and causing uaf issue.
> 
> Reported-and-tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/ocfs2/dir.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..c308dba6d213 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3343,6 +3343,8 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>  	unsigned long offset = 0;
>  	unsigned int rec_len, new_rec_len, free_space;
>  
> +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
> +		return -EINVAL;

Why OCFS2_MAX_BLOCKSIZE?
It seems that this is caused by a corrupted dir inode, since this is an
inline case, we may try best to make sure it won't exceeds block size?
i.e. dir->i_sb->s_blocksize.

Thanks,
Joseph

>  	/*
>  	 * This calculates how many free bytes we'd have in block zero, should
>  	 * this function force expansion to an extent tree.
