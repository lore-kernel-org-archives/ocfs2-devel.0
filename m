Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794360101;
	b=OB3nSaxalERbzlY+1uNuQxZVOBZTiQvc2hHU7QeSCRG53sSvibITrs/Qk8I+WNtgQbmc
	 NvLsC2U/DA4hWd4Yyy1ylMHMmozcFVv/MJL1gLeQ1/BxEAi21/h89GODHGzXcIJRQ+ZfY
	 +SHqEZsL20n7aNMq7xu3wQKKgHfElsPiDckyrBzvq2YQxiffMYge4r08Z7viZtBIG5Dk6
	 2m5Am2gsnAuYcDzqnXFInXDww8QRkeY3JUlmN/3nNpU9B6LrQC6A3a0gr9OiY5qJJjlfU
	 B04biK5A4GTF+hCHsWy+Hqr9rcZQi1/2RDJlJgPKVmgLw+AegA8k7EAKMR8y7pPHXuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794360101;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vn+1VmYhBBdJfereCP6tHTG+RC3081IsvhsQCT8Kt+Y=;
	b=SF/YoUUotWIJrY2Z/u5PpS9xvGXMl4cyPOWuA/jO/sgi4CuDmLRYW4TXzdiV52aSGoAu
	 h+wR5KonK4a1B2c/MCa5buCOHw5ha8sk5mThjwF2o3SSgDLSC7oXYXWbH/myVEUYrErNn
	 VUD2LIMr6EfcgTcjPa22ceBIGdFu0oKUoNF7uBZEsak9mk3g5EECewC+LQeTrwt8bGW+L
	 BGw5HmPfkLmpWxY/YbB2FL9/q2QSzDoN1boMNnDwjwA6LY3TdBSPZaByQzWxWizR6fJGR
	 u76u7WLWu8etSBWpoHBfZpe3tznRk588Hk89uBP/JGD7nzXhvtJcd9KWM6fg1jtYaEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zh9L0xV+;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D840606A31C
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Nov 2026 01:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D840606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Zh9L0xV+
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794360092; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vn+1VmYhBBdJfereCP6tHTG+RC3081IsvhsQCT8Kt+Y=;
	b=Zh9L0xV+SaEL0ugSOe4npDJa77RsiLVYcps7zfS9G8Kah259vDUYCiNmok0Wdoevar07UHbQtzFytIzFZChH/0IFwATF7KqJCGB5oH0ojjUU6v0R+8kXhPWjPrusxN6qcaLYIzG+L3y2zK65yVjuaKm3NPqBJcJQBzqnDZKTKw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XEX7K6x_1794360090;
Received: from 30.221.145.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEX7K6x_1794360090 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 09:21:31 +0800
Message-ID: <462d5470-7d1f-43a0-93a0-6de964169fc2@linux.alibaba.com>
Date: Wed, 11 Nov 2026 09:21:30 +0800
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
Subject: Re: [PATCH] ocfs2: fix lockdep class of newly created directories
To: Shuai Liu <847807867@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 a.p.zijlstra@chello.nl,
 syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <6a791c94.01d0871a.3a0d52.009a.GAE@google.com>
 <tencent_DEBEB3490E975A2C62C2D7DD573A9A254F05@qq.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_DEBEB3490E975A2C62C2D7DD573A9A254F05@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/10/26 9:45 AM, Shuai Liu wrote:
> Directories and regular files use different lockdep classes for
> i_rwsem (i_mutex_dir_key vs i_mutex_key) so that lockdep can verify
> the documented locking order "parent[2] -> child -> normal" without
> spurious class-level cycles: e.g. cross-directory rename takes
> I_MUTEX_CHILD on the source directory followed by an unclassed
> I_MUTEX_NORMAL on the target inode, while other paths take
> I_MUTEX_NORMAL on a file before touching a child-class inode.
> 
> Since commit 14358e6ddaed ("lockdep: annotate dir vs file i_mutex"),
> this split is applied in unlock_new_inode(), which relies on the
> inode being created with I_NEW set.  ocfs2 creates inodes through
> new_inode() (no I_NEW) and instantiates them with a plain
> d_instantiate(), so lockdep_annotate_inode_mutex_key() never runs on
> this path.  Every directory created after mount therefore keeps the
> plain i_mutex_key class for its whole lifetime, breaking the
> dir/file class separation that the VFS locking order relies on.
> 
> With such a directory the class-level chain
> 
>   i_mutex_key/I_MUTEX_NORMAL -> i_mutex_key/I_MUTEX_CHILD
> 
> recorded by the reflink path (ocfs2_vfs_reflink() locks the source
> inode, then __ocfs2_reflink() takes I_MUTEX_CHILD on the orphan
> inode) collides with the chain
> 
>   i_mutex_key/I_MUTEX_CHILD -> i_mutex_key
> 
> recorded by vfs_rename() when renaming a directory onto an existing
> file, and lockdep reports a "possible deadlock in vfs_rename":
> 
>   syz-executor105/5623 is trying to acquire lock:
>   ffff8880767009a0 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: vfs_rename+0x6e3
>   but task is already holding lock:
>   ffff8880764ff9a0 (&sb->s_type->i_mutex_key#18/2){+.+.}-{4:4}, at: vfs_rename+0x64d
> 
>   Chain exists of:
>     &sb->s_type->i_mutex_key#18 --> &oi->ip_alloc_sem --> &sb->s_type->i_mutex_key#18/2
> 
> Fix it by calling lockdep_annotate_inode_mutex_key() in
> ocfs2_get_init_inode() right after the final mode is established,
> before the inode can be found or locked by anyone else.  This is the
> same treatment shmem got (commit b45d71fb89ab8adf, "mm: shmem.c:
> Correctly annotate new inodes for lockdep"), following the hugetlbfs
> pattern of annotating right after new inode creation.  Freshly
> created ocfs2 directories are now properly separated from files in
> lockdep and the rename vs reflink cycle disappears.
> 
> The C reproducer from syzbot (mount ocfs2 image, OCFS2_IOC_REFLINK,
> mkdir two directories, rename a directory onto the reflinked file)
> hits the lockdep warning on every run without the fix and runs
> cleanly with it.
> 
> Reported-by: syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c73ff6790f3d6c635abc
> Fixes: 14358e6ddaed ("lockdep: annotate dir vs file i_mutex")
> Signed-off-by: Shuai Liu <847807867@qq.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/namei.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index d8759605786c4..f3ec348eb709d 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -203,6 +203,13 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
>  		set_nlink(inode, 2);
>  	mode = mode_strip_sgid(&nop_mnt_idmap, dir, mode);
>  	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
> +	/*
> +	 * This inode never goes through unlock_new_inode() (there is no
> +	 * I_NEW state on this path), so the directory vs file lockdep
> +	 * class split for i_rwsem has to be done here, before the inode
> +	 * becomes visible to anybody else.
> +	 */
> +	lockdep_annotate_inode_mutex_key(inode);
>  	status = dquot_initialize(inode);
>  	if (status) {
>  		iput(inode);

