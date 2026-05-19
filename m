Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE1A3D9DD2
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 11:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779190911; cv=none; b=C/3X1mFvhs4tS3pXr5x/YxoeaA7WB/cpw0bKhxfN+gEbPZzXKhb4McNdQk5khj6OYPhjEu1aiR46h77LLnSBxA2jw6X8bGdQdjYvHBpbvX0OIaycEED8A8QSo3DCbbsH27WiZ/Aao9i9UGcyijubouux7D31NQ4fuqWNa4UhhkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779190911; c=relaxed/simple;
	bh=x0FZObFEJQMecuFLfQ5aokC2AnRbGjx0Y0tNcwlTzp8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Iq6Z8w2TzPDgdiHpnAGCrxU+tL0DS7LcuwpvF+90ZErXg6rfMDsnH6WXwduTy5GvItdlYv+icqaSXJaDGZbztiWaHYPuvnwGmtN43bJkwNXNFI1xhUMKivTcmrLBA3950aFAT+himLnr66Xa7DgpoggBvDx74zbB+85GbhUL/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TXyksmL8; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TXyksmL8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779190899; h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type;
	bh=d+QJmmiMIte50I3REC3l01Cof7rAoBBQjbipXcycwQo=;
	b=TXyksmL8F9Iw8t5j7vyjh/vNTKXddwS7eLmo6yq/8wxRgS33eG6ZZEtW6Fx4nIaAEYHJkvNCax459lCYFi79WuaHqSj/wbwsHgfyIBx+HhqEHvHvNHLsCKhSeuhJuzOExZsLSZzChK1XJo8T2T8ZC4PjPCYFZNnL6lTlatiuzoE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X3FXdVr_1779190897;
Received: from 30.221.130.5(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3FXdVr_1779190897 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 19:41:37 +0800
Message-ID: <878d31bf-a50c-4f48-a451-bcab0bb46c8f@linux.alibaba.com>
Date: Tue, 19 May 2026 19:41:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] ocfs2: fix NULL deref in ocfs2_wait_for_recovery after
 recovery_exit
To: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Cc: Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20260519013629.1105967-1-xujiakai24@mails.ucas.ac.cn>
In-Reply-To: <20260519013629.1105967-1-xujiakai24@mails.ucas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/19/26 9:36 AM, Jiakai Xu wrote:
> In ocfs2_recovery_exit(), the recovery_map is freed via kfree() but
> osb->recovery_map is not set to NULL afterward. If ocfs2_wait_for_recovery()
> is called subsequently (e.g. during inode eviction in the dismount path or

evict_inodes() runs before ocfs2_recovery_exit(), which is called through put_super.

> via a racing stat() syscall), ocfs2_recovery_completed() dereferences the
> stale pointer, leading to a NULL pointer dereference at rm->rm_used.
> 
> Fix this by:
> 1. Setting osb->recovery_map = NULL after kfree() in ocfs2_recovery_exit()
> 2. Adding a NULL guard in ocfs2_recovery_completed() so that it safely
>    returns "recovery completed" when the map has been freed
> 
> Fixes: 553abd046af6 ("ocfs2: Change the recovery map to an array of node numbers.")
> Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
> ---
>  fs/ocfs2/journal.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f9bf3bac085d..5529a177f90e 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  	/* XXX: Should we bug if there are dirty entries? */
>  
>  	kfree(rm);
> +	osb->recovery_map = NULL;
>  }
>  
>  static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
> @@ -1225,6 +1226,9 @@ static int ocfs2_recovery_completed(struct ocfs2_super *osb)
>  	int empty;
>  	struct ocfs2_recovery_map *rm = osb->recovery_map;
>  
Seems still cannot fully close the race?

Thanks,
Joseph

> +	if (!rm)
> +		return 1;
> +
>  	spin_lock(&osb->osb_lock);
>  	empty = (rm->rm_used == 0);
>  	spin_unlock(&osb->osb_lock);

