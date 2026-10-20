Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497921;
	b=rGGPRT+2qW1XBRW8Rotg6JFndpNIEv+zvD/64gU9JQ53TuIltVfn3vA08/W66DzvkT1c
	 eA1LDyw9ueE78qHnRneR9N3gA80+x/dZR0BPRRmHYmce4ivzWyIbGLiRNtjaH8NFdgU61
	 0slfK9BwmC4U25ExAWEN6NqZbDsfOy6IkGDxAIeQ3GzhSXiRYp37NrPNDInvUsXG/W4ex
	 Z0Ccala6ZXNRBZBsUiww76RilpU0w8Mo4Q9SnrYCVHrSRyzpe6+dHGTtaosQ2voJQJKQa
	 g+zeHO6L0aOakhqvZY50HMlJPgvcanvkZWevqhKDnDdQ+SA/KOCaz9ta9BJOqMPtkFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497921;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=037It5JgAOu4z9VMKcMbYkeaMZRVptrSOJrPIu7UqgY=;
	b=oCIAZLjEMZhLDZyiXeAZA8Mw1q9um33zL1TePEm/h06C66GK+aX6+89l6nGQ2O3i4oBY
	 rk2CYBxOO+GXg34hG0md1YDpmRpFAiq0/l88qiQKrF2TmXpmw9dj+fBhlfLFHCed0bm1G
	 E/5BgOiGtq/6BVud20LCJ+4vBXTk+nybDyBo9UYGe4GCfTH7ce+C/Q+leUhQ/JJSOO8E5
	 /ZJNArViI2WZVhb5M/pnh/4gpT3OnRkaLFoT2c8IXuIlpfSZFcIGS0d95UXmZA+HaBXO3
	 heeO8BXmvJcfu3HGU54794rZ6XV1zQqgeAiClccEzk5SuB29qSNLM8UKKxAuXyTJ87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NApZQGOH;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E09606A31D
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 12:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03E09606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NApZQGOH
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792497916; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=037It5JgAOu4z9VMKcMbYkeaMZRVptrSOJrPIu7UqgY=;
	b=NApZQGOHBBTy9cGr4Nsiq6EF2M0qrLExdlkDTU0Pz/32rncqOj1cXGH88zGdTPN1jNgnbz0AXanQUoQaRdyfeym79X3Q8qwo1gIwGUSyKOAo4+SvmcNT13BfsaW1IDSP5zOOU5/9FUkDgx5q0S3+Vw4DliZ5RIboI6Vjrr8Wbe0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDDJQnq_1792497915;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDDJQnq_1792497915 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 20:05:15 +0800
Message-ID: <018d8feb-2e63-4a73-ba36-10a5f94f3341@linux.alibaba.com>
Date: Tue, 20 Oct 2026 20:05:14 +0800
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
Subject: Re: [PATCH v2] ocfs2: Cache the mount context for dentry lock
 callbacks
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0012-v6-17b58652a3505eeecb0c@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0012-v6-17b58652a3505eeecb0c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/19/26 9:49 PM, Cen Zhang wrote:
> ocfs2_drop_dentry_lock() drops the inode reference before releasing the
> DENTRY lock. This lets inode eviction release the local inode and open
> locks before a remote unlink can proceed past the DENTRY lock.
> 
> A DLM callback can still arrive before the DENTRY lock has been dropped.
> ocfs2_get_dentry_osb() obtains the mount context through dl_inode->i_sb,
> which can access a freed inode when the downconvert thread drops the
> last inode reference in its post-unlock callback:
> 
>   Downconvert thread                     DLM callback thread
>   ------------------                     -------------------
>   ocfs2_process_blocked_lock()
>     ocfs2_dentry_post_unlock()
>       ocfs2_dentry_lock_put()
>         ocfs2_drop_dentry_lock()
>           iput(dl->dl_inode)
>           [inode reclaimed after RCU]
>                                          ocfs2_blocking_ast()
>                                            ocfs2_get_dentry_osb()
>                                              dl->dl_inode->i_sb
>           ocfs2_simple_drop_lockres()
> 
> Store the mount context in the DENTRY lock resource's l_priv field and
> use the default mount-context lookup. Recover the containing dentry
> lock with container_of(), as already done for refcount locks, and remove
> ocfs2_get_dentry_osb(). ocfs2_dismount_volume() shuts down the DLM before
> freeing the mount context, so callbacks can use it without accessing the
> inode. Preserve the existing iput-before-unlock order to avoid delaying
> local inode and open lock release until after the DENTRY lock is released.
> 

ocfs2_dentry_convert_worker() still reaches the inode via
OCFS2_I(dl->dl_inode) and writes oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED
before its OCFS2_LOCK_FREEING/dl_count guard, and ocfs2_unblock_lock()
invokes the worker without testing OCFS2_LOCK_FREEING.

Thanks,
Joseph
