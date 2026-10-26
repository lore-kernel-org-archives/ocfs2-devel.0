Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016134;
	b=U+DKK9wF3zc3FqFKhd8dDq1gMb4DCkXD3dTSqwWMDlb3SPTyOHmL5MBDSkvM+0iko6f4
	 E1VmQ+noteOUzwvGF9nc94AkTS+KOb4IWJGBicrr/6JKDJl+UW+rWeJLqkVzmGQF3rqvM
	 hwMK2786AdXnNdCab1x2Gf5Fx47wVL2AuVtybrT+mj+MpSGy0OpYRcQ5Ct7zZJuEKSauA
	 z74tLqGl0oC5jTYl7H8jW2llZiAoVW/Cwz6Xv6SDJRjYm0p0FrudzLEvZSE1ih49Y8TZi
	 ABicr1XmdPJj++Zumr7zWzBTpVO1g9Le3AMybtBe8nGnEgv7D4O//wIL4TRCfN/rXXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016134;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Ra7qPqEIPzONkorSTqTvW8u0kxw/OAVjgPoyaHh2L4Y=;
	b=m0XpN+UzzdeUIYspO5ub06vP7YqFMRgbS4PLMAUDOFFgX2g6W1aMLhHCWfOq9UPMyiSB
	 YiVDQwGvYypsoBANaH1eYhZYb1kIE/nn/54rrrA4w5fsaH5LVErguEw4RQRexIygu0aAs
	 Zw2M689T2pJv22iK6NZFu/sLgfyTEjVdixk/h8oJ6f8wxcqFGFpQafciskL9u/eRbSeDD
	 rp/fJqakyewEnK5AkAaUmrvIm/jLGbp+GNPs3IdO8EOlRdhWvp2Ex2UnBy32wpwJCASFv
	 dJdLh7G9wnpCsEvPEzFi2qYyzGeTnCyCfnO6zyIvv+PTkxE2WuktcTZ3LC76Q614zhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DOkq4rHs;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA31606A31F
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 12:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA31606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DOkq4rHs
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793016130; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ra7qPqEIPzONkorSTqTvW8u0kxw/OAVjgPoyaHh2L4Y=;
	b=DOkq4rHs0GVNAPLPeLBKpFxa2ZT3hpqJopCExQKUxM6k7yD8K46YHY4l1W0iIz8k/ejCaHLq6EZEn3eYDIhx8u6xIAp76AwYm/A0yemPR3+dNR6rB840WkIKB5AdJY/YUvzqsoHy54pss+X+m6QU6o20emCZ7aV79TPJtLnFhrA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDY3IkN_1793016128;
Received: from 30.221.130.82(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDY3IkN_1793016128 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 20:02:09 +0800
Message-ID: <90b2a787-3b00-4c69-9d59-e0184674bd7e@linux.alibaba.com>
Date: Mon, 26 Oct 2026 20:02:08 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate move extents against a stable EOF
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-move-extents-isize-rrw-v6-395bdee84ea81149068e@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-move-extents-isize-rrw-v6-395bdee84ea81149068e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/26/26 7:04 PM, Cen Zhang wrote:
> The move-extents range must be bounded by the inode size used for extent
> movement. ocfs2_ioctl_move_extents() checks and clamps the request before
> taking the local inode and cluster locks in ocfs2_move_extents(). It also
> uses separate i_size_read() calls for the range check and subtraction.
> 
> A concurrent truncate can invalidate the first check and make the later
> unsigned subtraction underflow:
> 
>   Move-extents ioctl                  Truncate
>   ------------------                  --------
>   check me_start <= i_size
>                                       take inode and cluster locks
>                                       shrink EOF below me_start
>                                       release locks
>   compare me_start + me_len with EOF
>   set me_len = EOF - me_start
>     [unsigned underflow]
>   acquire inode and cluster locks
>   select extents using the bad range
> 
> A truncate after clamping can also leave the range extending beyond EOF.
> Conversely, the cached size may be smaller than the size refreshed when
> the cluster inode lock is acquired. Early validation can then reject a
> valid start or permanently shorten the requested length and threshold.
> The me_start + me_len comparison can also wrap for a large input length.
> 
> Validate and adjust the original request once, after inode_lock(), the
> exclusive rw lock and ocfs2_inode_lock() have stabilized and refreshed
> the size. Read EOF once, reject a start beyond it, and bound the length
> by EOF minus start. Normalize the threshold using the same EOF snapshot.
> This keeps zero as the default-threshold sentinel until validation uses
> the size that will govern extent movement.
> 
> Move goal validation after range adjustment as well. Its allocation-group
> capacity check uses me_len and must see the EOF-clamped length. Both
> validation failures use the existing inode-lock unwind path before any
> extent movement or transaction starts.
> 
> Range errors now reach the ioctl's normal copyout path, as goal errors
> already did. Unlike the old early rejection, a failed copyout can
> therefore override -EINVAL with -EFAULT.
> 
> Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
