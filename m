Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318518C02E;
	Mon, 22 Jun 2026 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782089942; cv=none; b=Q986Ypkz58HTVRZ9U53kkCRqwsNzm1aBv7LOZ2fViHV8Ta/Oe+ripuQTzoierinNeyQEz7BSm0eLW1GAoP1Gor2CwrpJp0g+hnelhEtCPjFWljTpuJrHfSf0FVZVW1mdxrAiVcBb30nGcBoXnWC6rrNby346rUGoOjagZJOeKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782089942; c=relaxed/simple;
	bh=jPdBCba2a1RxBylDYBgt3vuNgPjL9eEtN5N7O7a/DUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XifxhSn3r1bShDN+ZqcMOv1z9MP+4nggwRn/DB98z81itPhQFYvrv5mH7yfqTywwvggmPXgVr0aPK7cPxF9TZPAnkKP5FAGnSRjxiD9xkt4p1qyDRrrz9qBcOKt3+SeLdHFEa5vhdXWDQsKGjnlz9PuhUY6HZX6odZmiYbHMYQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BThlBYgm; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BThlBYgm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782089937; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xVeY4GpnfbmDONSK7yvW3uoN9D+nRaZSlO60d+kUxRI=;
	b=BThlBYgmlfdXJrMpsshU79pgcFBfmc3puKQOG2oxKthb4ShdUU0SrNy/E5LWrGsOwXB5pW33qKBwknVjJ61I292VZ4QdXf9Xnjo7gn9aijJUG8tD8tBTs1XMbM69lO1Mkhv80oz3NtWl5jqxP2GgMwsJ6qgbGrj/PtmSEX3zU3I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X5GLJ7m_1782089935;
Received: from 30.221.145.9(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5GLJ7m_1782089935 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 08:58:56 +0800
Message-ID: <df25ea2d-1485-4ef5-9aae-9e88c41b14be@linux.alibaba.com>
Date: Mon, 22 Jun 2026 08:58:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: use inode_lock_nested() for orphan dir locking
To: Deepanshu Kartikey <kartikey406@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev,
 syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 Matthew Wilcox <willy@infradead.org>
References: <20260620231223.46588-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260620231223.46588-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/21/26 7:12 AM, Deepanshu Kartikey wrote:
> PREEMPT_RT's rtmutex PI chain walker warns about a lock dependency
> cycle when inode_lock(orphan_dir_inode) is called while holding
> inode_lock(file_inode):
> 
>   ocfs2_file_write_iter()
>     inode_lock(file_inode)               [class 0]
>       ocfs2_dio_end_io_write()
>         ocfs2_del_inode_from_orphan()
>           inode_lock(orphan_dir_inode)   [class 0] <- warning!
> 
> However this is a false positive. write_iter() is never called on a
> directory, and orphan_dir is always a directory, so these two locks
> can never actually conflict in practice.
> 
> Fix by using inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2) in
> all three places where orphan_dir_inode is locked in namei.c, placing
> it in a separate lock class so the rtmutex PI chain walker understands
> these locks have distinct roles and does not warn about their ordering.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Reported-by: syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ce129763ce7d7e914739
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> 
> ---
> Changes in v2:
> - Replaced inode_lock() with inode_lock_nested(orphan_dir_inode,
>   I_MUTEX_NONDIR2) in all three call sites in namei.c
> - Dropped incorrect v1 changes to aops.c and namei.c that
>   restructured lock ordering, as the deadlock was a false positive
> - Approach suggested by Matthew Wilcox
> ---
>  fs/ocfs2/namei.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 1277666c77cd..4cfd7b3d3e1a 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2126,7 +2126,7 @@ static int ocfs2_lookup_lock_orphan_dir(struct ocfs2_super *osb,
>  		return ret;
>  	}
>  
> -	inode_lock(orphan_dir_inode);
> +	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
>  
>  	ret = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
>  	if (ret < 0) {
> @@ -2725,7 +2725,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> -	inode_lock(orphan_dir_inode);
> +	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
>  	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
>  	if (status < 0) {
>  		inode_unlock(orphan_dir_inode);
> @@ -2838,7 +2838,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>  		goto leave;
>  	}
>  
> -	inode_lock(orphan_dir_inode);
> +	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
>  
>  	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
>  	if (status < 0) {

