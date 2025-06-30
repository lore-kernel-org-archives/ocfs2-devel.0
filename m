Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B12F1FE2
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 02:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751250081; cv=none; b=XypLo7BDmHYFBnihYkfKCizG2f0Gl4U18UlW0BDUKgWWad9Rbh3YAa4saC6MamYQA0ulvGqM0caZUpeyOzrtDqmYDQyzNri8mSPM7nvoxt2G7hQbQP9I3uBSCG0+7rE8u8ndwjGaqw6U0seRoXUmoHhUzg4oFGnieSmmWTKNJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751250081; c=relaxed/simple;
	bh=sd+hEuubeNX7x+n//vputEkXiioCsCDci36Y5z2H4ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=plNFlN0dAVIUqmPK2udww9CoHe78le6CqVgxTpxdkrgladFHMp6W0/HIGm5f6TSxhakDchEAue++X0n+qNMwUuu8Cxd0I0zhzyOgQdLSg0IvBDaGoLXZ3Bb8aZmUMYKf3FrDStFjLvy/tMsrex4j3JhU9qkjNkLiayBTFXBK0iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gWv5XsnT; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gWv5XsnT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751250075; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=snn11iIofgP++Dddc1FEAbZVKzJOLFhTlppIFtPl8TI=;
	b=gWv5XsnTmyKgl/OAgmswRuJ3UtHZMkUHi7spu/rGXQ97w0IX/qGpQkhACRik6PpoI/zIPhRTl98RqdRxm0PAPH0HNfd1U7QCuoewDqb652mfWL0L4OTViOolwxhuEKmsjU2zlnFECUFk5ZKNqJ/LOUSRwwDLWDyTtJG7Z3QMW40=
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wg31LMz_1751250074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Jun 2025 10:21:15 +0800
Message-ID: <d490a3ad-6309-42f3-9774-91871fbf7330@linux.alibaba.com>
Date: Mon, 30 Jun 2025 10:21:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key
 names
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/6/23 22:54, Tetsuo Handa wrote:
> Since lockdep_set_class() uses stringified key name via macro, calling
> lockdep_set_class() with an array causes lockdep warning messages to
> report variable name than actual index number.
> 
> Change ocfs2_init_locked_inode() to pass actual index number for better
> readability of lockdep reports. This patch does not change behavior.
> 
> 
> Before:
> 
>   Chain exists of:
>     &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> jbd2_handle --> &oi->ip_xattr_sem
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(&oi->ip_xattr_sem);
>                                  lock(jbd2_handle);
>                                  lock(&oi->ip_xattr_sem);
>     lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> 
>    *** DEADLOCK ***
> 
> After:
> 
>   Chain exists of:
>     &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> jbd2_handle --> &oi->ip_xattr_sem
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(&oi->ip_xattr_sem);
>                                  lock(jbd2_handle);
>                                  lock(&oi->ip_xattr_sem);
>     lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> 
>    *** DEADLOCK ***
> 
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Looks fine.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 12e5d1f73325..14bf440ea4df 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -50,8 +50,6 @@ struct ocfs2_find_inode_args
>  	unsigned int	fi_sysfile_type;
>  };
>  
> -static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
> -
>  static int ocfs2_read_locked_inode(struct inode *inode,
>  				   struct ocfs2_find_inode_args *args);
>  static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
> @@ -250,14 +248,77 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
>  static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>  {
>  	struct ocfs2_find_inode_args *args = opaque;
> +#ifdef CONFIG_LOCKDEP
> +	static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
>  	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
>  				     ocfs2_file_ip_alloc_sem_key;
> +#endif
>  
>  	inode->i_ino = args->fi_ino;
>  	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
> -	if (args->fi_sysfile_type != 0)
> +#ifdef CONFIG_LOCKDEP
> +	switch (args->fi_sysfile_type) {
> +	case BAD_BLOCK_SYSTEM_INODE:
> +		break;
> +	case GLOBAL_INODE_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GLOBAL_INODE_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case SLOT_MAP_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[SLOT_MAP_SYSTEM_INODE]);
> +		break;
> +	case HEARTBEAT_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[HEARTBEAT_SYSTEM_INODE]);
> +		break;
> +	case GLOBAL_BITMAP_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
> +		break;
> +	case USER_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case GROUP_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[GROUP_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case ORPHAN_DIR_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> +		break;
> +	case EXTENT_ALLOC_SYSTEM_INODE:
>  		lockdep_set_class(&inode->i_rwsem,
> -			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> +				  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case INODE_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case JOURNAL_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[JOURNAL_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_ALLOC_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);
> +		break;
> +	case TRUNCATE_LOG_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_USER_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_USER_QUOTA_SYSTEM_INODE]);
> +		break;
> +	case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
> +		lockdep_set_class(&inode->i_rwsem,
> +				  &ocfs2_sysfile_lock_key[LOCAL_GROUP_QUOTA_SYSTEM_INODE]);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unknown sysfile type %d\n", args->fi_sysfile_type);
> +	}
>  	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
>  	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
>  	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
> @@ -267,6 +328,7 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>  	else
>  		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
>  				  &ocfs2_file_ip_alloc_sem_key);
> +#endif
>  
>  	return 0;
>  }

