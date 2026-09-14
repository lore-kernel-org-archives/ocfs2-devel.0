Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1219E346ACE
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 05:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365197; cv=none; b=GF0gkQoUryINt93D0H7dUM2Y717rrk1u9tAWodvvIdFPxaqSSWIdioQVLzJJa4pAg7FDv5BxPfH1HPi4l+gUpNJ7uEfiytmL1HqoRhoGdITl0s8UR+JELorqW2U180II7CLWT2iC08UDdaJBnsPVqMkUUbyptgOkXf+qRiV9Vy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365197; c=relaxed/simple;
	bh=5xKfAPsDRZgRWSGT3oeGlbWjQJ8pKeZkLHnc8er54f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXRG20PT/EbjVX34HaBrqySUyjCY6W9E1BclBdDEDbLWrjENm6+afvTC1SZCcs8wgchjXJtaw0ulUYzM7vpsnncWgkP7k6ZXuaRLyDDCh+1DIVa77AWz5ZdcP5h4OIFhwkv2p28TYWdMp/rBisXY42+MtKbtOoJLaRTKV3K9Ers=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ib1DR3Uz; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ib1DR3Uz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789365185; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DGCUqYpSgp6dwqHfummvsIu0f3GHTB/sFbpAB8I2TaM=;
	b=ib1DR3UzYQl/ILtdjF9CNL/jaemBrSA6YKB+kStq0kmLanZ7uXZt0rNiEdjfINyQka9gzUA7eODMjssQgfPwlbh6AXx6fD9M3pZbrHFk7IpOa2qA5HtoCbT8f3DyLiCYjjvlAkbvdCc0GzPGnbqDPL0ZuHP/bTO4rYyivPizYTw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XAqpvuP_1789365183;
Received: from 30.221.129.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAqpvuP_1789365183 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 13:53:03 +0800
Message-ID: <c11b5a78-a1d7-4618-beab-dda967863f50@linux.alibaba.com>
Date: Mon, 14 Sep 2026 13:53:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: don't let the root inode outlive a failed mount
To: Farhad Alemi <farhad.alemi@berkeley.edu>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: falemi@asu.edu, ocfs2-devel@lists.linux.dev,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <CA+0ovChT6BRXp0kntaJ_Eiw-2-z=fpofsvyALiwdORe3zG_YWA@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CA+0ovChT6BRXp0kntaJ_Eiw-2-z=fpofsvyALiwdORe3zG_YWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/11/26 5:47 AM, Farhad Alemi wrote:
> ocfs2_init_global_system_inodes() installs osb->root_inode before the
> second ocfs2_iget() runs, and when that iget fails ocfs2_initialize_super()
> jumps to out_dlm_out, which sits below out_system_inodes, so
> ocfs2_release_system_inodes() never runs and the kfree(osb) that follows
> makes the stranded root inode reference unreachable.  ocfs2_fill_super()
> strands the same inode a second way: nothing drops the reference igrab()
> takes on osb->root_inode when an out_dismount path ahead of d_make_root()
> is taken, so the ocfs2_release_system_inodes() call inside
> ocfs2_dismount_volume() cannot free it and the root inode stays hashed on a
> superblock whose ocfs2_super has already been freed.  The reported KASAN
> slab-use-after-free write hits an ocfs2_inode_cache object that
> ocfs2_release_system_inodes() freed during teardown, so an ocfs2 inode
> reference that survives that call is a lifetime error on those same objects
> and not a bare leak.  Release the system inodes at that failing
> ocfs2_iget() and drop the igrab() reference on out_dismount, clearing inode
> right after d_make_root(), which consumes it on success and on failure
> alike, so it cannot be dropped twice.
> 
> Closes: https://lore.kernel.org/all/CA+0ovCjAKQMn7iF8BJR-3+G9_HBRnRFtJxjr-9P9GuKSxFj+3Q@mail.gmail.com/
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> ---
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c

Seems it is a corrupt patch?

> @@ -450,6 +450,7 @@ static int ocfs2_init_global_system_inodes(struct
> ocfs2_super *osb)
>  	if (IS_ERR(new)) {
>  		status = PTR_ERR(new);
>  		mlog_errno(status);
> +		ocfs2_release_system_inodes(osb);
>  		goto bail;
>  	}
>  	osb->sys_root_inode = new;
> @@ -1110,6 +1111,8 @@ static int ocfs2_fill_super(struct super_block
> *sb, struct fs_context *fc)
>  	}
> 
>  	root = d_make_root(inode);
> +	/* d_make_root() consumed our reference, on success and on failure. */
> +	inode = NULL;
>  	if (!root) {
>  		status = -ENOMEM;
>  		goto out_dismount;
> @@ -1163,6 +1166,7 @@ out_dismount:
>  	atomic_set(&osb->vol_state, VOLUME_DISABLED);
>  	wake_up(&osb->osb_mount_event);
>  	ocfs2_free_replay_slots(osb);

Please rebase on top of the latest linux-next.
The above 'ocfs2_free_replay_slots(osb)' is removed.

Thanks,
Joseph

> +	iput(inode);
>  	ocfs2_dismount_volume(sb, 1);
>  	goto out;

