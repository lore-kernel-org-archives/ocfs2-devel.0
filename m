Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9628330648C
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 09:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778233683; cv=none; b=m8y7v7Q1s9qbqawhVvGS8WG/F2pAVAw9Qj7OqfKnGUxiWJIAr2GG5FD76++Je+JAfdVwLS1VPvh1hS9BYWcd+qf/384tAVmYr5H4bD0LOzwXmTRul8oyCmzXqVbCwuYS1/iAjwzi+0N5INh6CqMYrQdnbA6C9QPS6IDQ5oBO0tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778233683; c=relaxed/simple;
	bh=gV1Dmc/x+sxBDzxpvJIPJDtvR/+6AR9gMh04t7i1vXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJm3Npo9BKEsEBeykU5k9ZedBfRWoqQZrEoWPamxcIel4njZvKR0+Kr/BQqpUt/qAC9tUf1iESe2a/Eci991I3AnpoNJDzyk465lorza9gfYhYE1otCGGXwdcDND6JYwvapAD7pcoSl0osI82tLsOI+rvx9mPndgce8SyNNgnFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=t7VPvWIl; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="t7VPvWIl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778233676; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=g2YFlCcwCas0hV737s2qd0/qcZX+ALSv9B2c95Djw+s=;
	b=t7VPvWIlmi2AZvTrf7+uEsYbNdh894H5yY6x5m8ddeJS/2m0baK8yIEyH47sedcuXKdh+D8lD8yyMAWYoB5BqEGwxhlwzCVNt2Uii3yl80Ipu8mQJYqIZMzjQ+yy5q6iaXOxopgGBML47WFDWgzxwE2sh0UF5v3zFLVg/Nk/1R4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X2X5zmz_1778233674;
Received: from 30.221.129.120(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2X5zmz_1778233674 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 17:47:55 +0800
Message-ID: <75570681-a25a-4cec-9874-b76fec6167e8@linux.alibaba.com>
Date: Fri, 8 May 2026 17:47:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested
 during unmount
To: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>, linux-kernel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
Cc: Joel Becker <jlbec@evilplan.org>, Kurt Hackel <kurt.hackel@oracle.com>,
 Mark Fasheh <mark@fasheh.com>, Heming Zhao <heming.zhao@suse.com>
References: <20260508060107.2666033-1-xujiakai24@mails.ucas.ac.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508060107.2666033-1-xujiakai24@mails.ucas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 2:01 PM, Jiakai Xu wrote:
> A race condition exists between filesystem unmount and inode permission
> operations. When ocfs2_dismount_volume() frees the ocfs2_super (osb)
> structure, concurrent access via OCFS2_SB(inode->i_sb) in
> ocfs2_inode_lock_full_nested() can dereference freed memory, causing a
> page fault in __pv_queued_spin_lock_slowpath via
> ocfs2_is_hard_readonly() -> spin_lock(&osb->osb_lock).
> 
> Fix this with two changes:
> 
> 1. In ocfs2_dismount_volume(): set sb->s_fs_info = NULL before
>    kfree(osb), so OCFS2_SB() returns NULL instead of a dangling pointer
>    during the teardown race window.
> 
> 2. In ocfs2_inode_lock_full_nested(): add a NULL check on osb after
>    OCFS2_SB(), returning -EIO if the superblock info is already gone.
>    This ensures the crash path is handled gracefully when the
>    filesystem is being torn down.
> 

It seems this is not enough, or TOCTOU still exists. Say:

Thread A			Thread B
osb = OCFS2_SB(inode->i_sb)
				ocfs2_dismount_volume()
				-> sb->s_fs_info = NULL
				-> kfree(osb)
use freed osb

BTW, how did you find this issue?

Joseph

> Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
> Fixes: ccd979bdbce9f ("OCFS2: The Second Oracle Cluster Filesystem")
> ---
>  fs/ocfs2/dlmglue.c | 3 +++
>  fs/ocfs2/super.c   | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7283bb2c5a31..cd619958a0a2 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2435,6 +2435,9 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct buffer_head *local_bh = NULL;
>  
> +	if (!osb)
> +		return -EIO;
> +
>  	mlog(0, "inode %llu, take %s META lock\n",
>  	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
>  	     ex ? "EXMODE" : "PRMODE");
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index b875f01c9756..3fd56638e4f0 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1881,10 +1881,10 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	printk(KERN_INFO "ocfs2: Unmounting device (%s) on (node %s)\n",
>  	       osb->dev_str, nodestr);
>  
> +	sb->s_fs_info = NULL;
>  	ocfs2_delete_osb(osb);
>  	kfree(osb);
>  	sb->s_dev = 0;
> -	sb->s_fs_info = NULL;
>  }
>  
>  static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uuid,

