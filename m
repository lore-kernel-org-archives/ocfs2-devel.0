Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6DE33EC
	for <ocfs2-devel@lists.linux.dev>; Sun, 10 May 2026 04:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778385731; cv=none; b=PuJS4r5Yp0+vpokqpWhQzHh6uLk4HvLHxoNixf2sHdTFLnsq4j4fFnsk/Eyc5/NA91RWhn+NDeY0xNpvtgTI6IOREYbFAd2rRB4W+36rUjGcaZYO6zDWShYUCmV7hN3iWulNGMzubhhy8uigBFf9eHllcPZD/EZ9PiSdWUQI01I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778385731; c=relaxed/simple;
	bh=63YYTsJxNg/W/ZczKuH1TO+VZvV4QH4DkpdU8GEJ6jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O056SuRuMklWVcnM+smEpDjZPQH6jiPKcpxi8PuUaE6wqCt9+nkjd0IRfcp//J8qSXrEvL5XfA3k9dtyZQ4NRuljfNFgwR58+GzWug5gMNq4m2exydb7+eFvjCQ2zJhF2/NDLhxRIfpet8aWtTXiD9zf+UAzjPonBLqFl7yMrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aX6k90+N; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aX6k90+N"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778385726; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O6Ag/kDkFf2a4FB/M+Js92ftO6dzIqIcsIqw/8bvU/8=;
	b=aX6k90+NhXOqHxYyLcOmzpOiTn7VzOiZoXecyg87F69p7sj2QHariZXPlsWV0KoVS7vns/sCa82RguEY4nh/U7Q0oe5YozN1tJawOqK/rgqUCP4D9LqxIl7NW05GEsXnyWXE5vOGtuyDUx/9rdntaTcCycuCPX0hh2yE2Je5bLw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2bmefw_1778385724;
Received: from 30.41.171.241(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2bmefw_1778385724 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 10 May 2026 12:02:05 +0800
Message-ID: <e5806b59-7d5a-4f73-aa9a-24a0c4ec2655@linux.alibaba.com>
Date: Sun, 10 May 2026 12:02:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: revalidate the journal dinode before toggling
 dirty
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260509135213.925551-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260509135213.925551-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/9/26 9:52 PM, ZhengYuan Huang wrote:
> [BUG]
> A fuzzed OCFS2 image can corrupt the current slot journal dinode while
> mount is still in progress. The mount path first reports the invalid
> journal block and then crashes in shutdown:
> 
> kernel BUG at fs/ocfs2/journal.c:1034!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
> Call Trace:
>  ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
>  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
>  ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
>  get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
>  get_tree_bdev+0x24/0x40 fs/super.c:1721
>  ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
>  vfs_get_tree+0x9a/0x370 fs/super.c:1758
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3642 [inline]
>  do_new_mount fs/namespace.c:3718 [inline]
>  path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
>  do_mount fs/namespace.c:4041 [inline]
>  __do_sys_mount fs/namespace.c:4229 [inline]
>  __se_sys_mount fs/namespace.c:4206 [inline]
>  __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
>  ...
> 
> 
> [CAUSE]
> ocfs2_journal_toggle_dirty() assumes journal->j_bh still contains the
> same validated dinode that ocfs2_journal_init() locked earlier, and it
> uses BUG_ON() when the buffer no longer looks like a dinode. That
> assumption is too strong. The mount path can force the same current-slot
> journal inode block back in from disk through
> ocfs2_read_journal_inode(..., OCFS2_BH_IGNORE_CACHE) while
> ocfs2_mark_dead_nodes() scans the journal slots. If that reread finds
> corrupted metadata, mount unwinds through ocfs2_journal_shutdown(),
> which reuses journal->j_bh and turns the metadata corruption into a
> kernel BUG.
> 

A bit confused.
Since journal dinode is firstly validated, it means image is checked.
Now mount is in progress, how to corrupt it during runtime?

Thanks,
Joseph

> [FIX]
> Revalidate journal->j_bh with ocfs2_validate_inode_block() before
> updating the dirty flag. If the cached journal dinode has become
> invalid, return the corruption error and keep the failure on OCFS2's
> normal read-only/error path instead of crashing the kernel. This
> revalidation happens in the cold path of mount, so the performance
> impact should be negligible.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/journal.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f9bf3bac085d..c9a972a1304e 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1021,12 +1021,15 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
>  	struct buffer_head *bh = journal->j_bh;
>  	struct ocfs2_dinode *fe;
>  
> -	fe = (struct ocfs2_dinode *)bh->b_data;
> +	/* The journal inode block can be forced back in from disk while the
> +	 * mount path is still running, so validate the cached bh again before
> +	 * updating the journal state on disk.
> +	 */
> +	status = ocfs2_validate_inode_block(osb->sb, bh);
> +	if (status < 0)
> +		return status;
>  
> -	/* The journal bh on the osb always comes from ocfs2_journal_init()
> -	 * and was validated there inside ocfs2_inode_lock_full().  It's a
> -	 * code bug if we mess it up. */
> -	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
> +	fe = (struct ocfs2_dinode *)bh->b_data;
>  
>  	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
>  	if (dirty)

