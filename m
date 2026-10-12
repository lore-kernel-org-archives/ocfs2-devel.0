Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30F52BD0B
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 06:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791785931; cv=none; b=Rfkjl2eNDss12DjcpKxoikHyxweXVwL2YAgYKwHhI4lWBChq85e25iWhR3D8SkBd3Ipruoy4IgD0H7THA06xDOo5DnNALd4pggach2eUPZ4NXN/K3QZP4cCgat66yyR40HABm9tlnc2f6sZqofwwyHJlZoFZwAl0gFDGN7gMXdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791785931; c=relaxed/simple;
	bh=ajcf+C7EzYhUa7Facl4cM+ChcL26UOOO6Zih/WqVUtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5zxzdTQOT7lw9ZBe8oQS/dN+jFkXJp3oUKJcZLOerBjbnuvODvYFj6AUnkbTOBe4fO6W1riN87lMEbXMp/eulNOyuL7dRYGbHVjPQrZveSvvwPl2AkuPenLZDcT0FJLEKbmBv0RQdICwoUv66qt/uJAaCQsqKG4i/oZV7h9lWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=L6/532jn; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="L6/532jn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791785923; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cTJvQnt5f08iJf6+hSRkkNjD2SJEXzZtSNnxZDI6k+I=;
	b=L6/532jnQosF8fSY2wtLgmC3FvrCynnZSY2/3DzbcBc1NC+JT9ekBwwtWlUlR3j6rq5W71xvTw6CpbgPQ1fEBlVf1aSrhP7teCeD7ISCkNyT539Rd8gRVenJJeu61VJ+CwmXGR7WWoEBWPNs9NNoSZE+ewWoQeS829+Tkh07WLQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XCb4ok1_1791785922;
Received: from 30.221.146.44(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCb4ok1_1791785922 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 14:18:42 +0800
Message-ID: <246803f3-d63a-4dd9-bd4a-4ff0c4066d17@linux.alibaba.com>
Date: Mon, 12 Oct 2026 14:18:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs
 attributes
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm@linux-foundation.org,
 ghe@suse.com, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 6:04 PM, Cen Zhang wrote:
> ocfs2_filecheck_create_sysfs() initializes the filecheck allocation
> before calling kobject_init_and_add(), but assigns entry->fs_fcheck
> only after that call returns. The default attribute group can already
> be visible while registration is in progress. A concurrent read can
> therefore enter ocfs2_filecheck_attr_show() with a NULL fs_fcheck and
> try to lock its fc_lock.
> 
> Assign the initialized owner before adding the kobject, so every
> activated attribute has valid state. Clear the pointer when addition
> fails, preserving the existing teardown guard and error cleanup.
> 
> A controlled probe-instrumented test kernel with the original OCFS2
> registration ordering produced this Oops during a concurrent sysfs read:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
>   RIP: 0010:kasan_byte_accessible+0x15/0x30
>   Call Trace:
>    <TASK>
>    __kasan_check_byte+0x13/0x50
>    lock_acquire+0x113/0x300
>    _raw_spin_lock+0x31/0x40
>    ocfs2_filecheck_attr_show+0x138/0x5f0
>    ocfs2_filecheck_show+0x5d/0x90
>    sysfs_kf_seq_show+0x1d3/0x360
>    seq_read_iter+0x480/0x1110
>    kernfs_fop_read_iter+0x419/0x5a0
>    vfs_read+0x7d2/0xc20
>    ksys_read+0x111/0x200
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>   Modules linked in:
> 
> Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")

It seems the right Fixes tag is:
5f483c4abb50 ("ocfs2: add kobject for online file check")

Also Cc: <stable@vger.kernel.org> tag is wanted here as well.

The code change looks fine to me. So with the above addressed,
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/ocfs2/filecheck.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index be713d7d24a76b9aa8fcded3d83b3d91d124eb6e..862c1ee7099c943b2e3e57e31f887380c6dc8a88 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -181,2 +181,4 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  
> +	/* Publish the initialized owner before activating its sysfs callbacks. */
> +	entry->fs_fcheck = fcheck;
>  	entry->fs_kobj.kset = osb->osb_dev_kset;
> @@ -186,2 +188,3 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  	if (ret) {
> +		entry->fs_fcheck = NULL;
>  		kobject_put(&entry->fs_kobj);
> @@ -191,3 +194,2 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  
> -	entry->fs_fcheck = fcheck;
>  	return 0;

