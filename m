Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E852155C97
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723866; cv=none; b=NMW/LYAKFLZmlnBm/fsU8tnZ8KH8s8w2hzKUIrU7rzYXW3bE2c0cujSmJAx4nXVkiGKoWpoBAsCrPBLxRnVfVpQu4Xg9p6zJp1m5qF6OivNy6tBY8GP30pTkAF6fjntUOE2fC72z1b03bPJKReOAhlCM7otTF2/VDpI3CHKJtyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723866; c=relaxed/simple;
	bh=F5uSWUvnACQXUIpvYdZl8rUAm1cPYBlzjzqgIVKhfR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ge5DUbeI4OgdDvP8WngfFc3tATTe6e32cRS6jlaPmkUu2M72owzK3biDf4oytNVy5Z/jRm3hEkfNCpjANJXJZBhm6q8GZDZi8+R8IepQtnmetf4z/ILhu51ZXhPGnU6dyOYV4DxqLXaGiZCB5HIQQWBspq54EPZ4KHnlhucJY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s6h2QGRo; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s6h2QGRo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764723855; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6ES2tsQbOs6cUaAl9oROxPHl0Mr/J/TwFpPvl9Hl+/8=;
	b=s6h2QGRouVfohxm5EPWu/p8lZ6lGH4vUa7JjuF4e+Qhe8goGkpUiCRi99jJQk01zbkQ79QMzWLzqvlaS9R+Ubc5ICBrD3PpUAjkWZrnvjiqLtMTJpDt/KZ7VZaEwne5i38DBGBaOqmmKibyR73M/anV0lnIGqV9WK7mSklQtVDw=
Received: from 30.221.128.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtyn.3V_1764723853 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 09:04:14 +0800
Message-ID: <ad0b67fb-9af6-4179-a4e5-032d749f50d6@linux.alibaba.com>
Date: Wed, 3 Dec 2025 09:04:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] ocfs2: Invalidate inode if i_mode is zero after block
 read
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251202224507.53452-2-eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251202224507.53452-2-eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/3 06:45, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
> v2:
>  - Only checking either i_links_count == 0 or i_mode == 0
>  - Not performing le16_to_cpu() anymore
>  - Tested with ocfs2-test
> ---
> v3:
>  - Add checking both high and low bits of i_links_count
> ---
> v4:
>  - Reading i_links_count hi and low bits without helper function
>   to save few cpu cycles
> ---
> v5:
>  - Clear i_links_count check
>  - Log the actual i_nlink/i_mode
> ---
> v6:
>  - Use `ocfs2_read_links_count` to get nlink
>  - Convert di->imode to cpu endian
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..f83b8e4f4d8b 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1456,6 +1456,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink = %u or mode = %u) detected!\n",
> +		        (unsigned long long)bh->b_blocknr,
> +			ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */

