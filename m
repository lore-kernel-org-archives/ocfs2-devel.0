Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859170;
	b=4Zobo82qVxaR6tbkj8+sMDbrv1p7GNiEtRBBSGiIPcUDzYf6EHDWzmjaI8eReuDwjkHq
	 RmXdH2IRvpx9fhg6ILxBVOPzK82ELvDTAucMvVUJxZFOan2ww36GG7JIb6jqpHqPGQyzL
	 tZXYXHLJYJRToXLXxv6s31bA7fIcYqvtULB9amlp0L+4Zw09NPbYLzddsA8Au+LdBOdmH
	 ixxt0WCCdOzm/57n+NUuBNt/1ThF/kEbTbWbduGcrMoOg//XcheZGC72D087ngLel8OBe
	 pbqqXoyPM0xLYwZbim60CuEimDiIA8aGuJXBJlnl4M1W2cvQtTZmxZu4o/RWMHKttZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859170;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=z/p2VUdb1mRboXHrAHabwKrriZCrUMsu8HfRneN5UBc=;
	b=1pHVrAm+YC8p5pu2JRYFiFe6juKBxNdMyeS406Dj6i3bWJCn78MbhL3u5O8Whxp8TowL
	 +AvS6qYR4tGO7VEXzPxEeU10KN1ZVB/1UCZ7DxjsUpcjRSmMukqgqEnQ0/jpi6Nn+EFYi
	 ayhlWLcFm8zd9ecEYrEwK6/mGpxgVLJfKD7tQukyy9LbuR/3FA7B9Latlie4Ze/IZyco6
	 hNxmvB+i6SclhzUa70y1FXn7IYFUVVWbxlEk2HsmoV4Mpnj/t2zjSsefWhG5Wiwprcl/e
	 +fPKxYW4AZ2iWhpoXVkeoVXh5lJ/ApQcQwGdwi7ZJ+P6e631Vonza0sx4Hzz3Oh8L7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=c7au+LeJ;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1697606A327
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1697606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=c7au+LeJ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792859166; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=z/p2VUdb1mRboXHrAHabwKrriZCrUMsu8HfRneN5UBc=;
	b=c7au+LeJFC6fIK4KmU1przhw+K89Mz43517nZqJrJsPz8/GqDyo5g/io+6dzQ6iO7IKdJySomoffTATDqduozK3Ox1tHH2N3Ifo4MEHNZyHfpvZFwdN+MeqfiR3YaerAmAUUA7Cs2uDXt+XgApKqVXOyU6naHBrdFzBjgb7hY1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDOXgDK_1792859165;
Received: from 30.251.227.55(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDOXgDK_1792859165 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 25 Oct 2026 00:26:06 +0800
Message-ID: <d7cc3c11-c99e-4f25-8de8-bf8779810239@linux.alibaba.com>
Date: Sun, 25 Oct 2026 00:26:05 +0800
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
Subject: Re: [PATCH v2 2/2] ocfs2: replace ocfs2-specific inode flags with
 generic ones
To: Anthony Iliopoulos <ailiop@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261022130457.69343-1-ailiop@suse.com>
 <20261022130457.69343-3-ailiop@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261022130457.69343-3-ailiop@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 9:04 PM, Anthony Iliopoulos wrote:
> The ocfs2 inode flag macros are alias definitions for the generic fs
> flags. Remove these redundant macros, most of which are anyway unused,
> and use the generic flags directly.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c    | 24 ++++++++++++------------
>  fs/ocfs2/ioctl.c    |  8 ++++----
>  fs/ocfs2/ocfs2_fs.h | 27 ---------------------------
>  3 files changed, 16 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 180107a11046..64d92d30aa31 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -107,16 +107,16 @@ void ocfs2_set_inode_flags(struct inode *inode)
>  	inode->i_flags &= ~(S_IMMUTABLE |
>  		S_SYNC | S_APPEND | S_NOATIME | S_DIRSYNC);
>  
> -	if (flags & OCFS2_IMMUTABLE_FL)
> +	if (flags & FS_IMMUTABLE_FL)
>  		inode->i_flags |= S_IMMUTABLE;
>  
> -	if (flags & OCFS2_SYNC_FL)
> +	if (flags & FS_SYNC_FL)
>  		inode->i_flags |= S_SYNC;
> -	if (flags & OCFS2_APPEND_FL)
> +	if (flags & FS_APPEND_FL)
>  		inode->i_flags |= S_APPEND;
> -	if (flags & OCFS2_NOATIME_FL)
> +	if (flags & FS_NOATIME_FL)
>  		inode->i_flags |= S_NOATIME;
> -	if (flags & OCFS2_DIRSYNC_FL)
> +	if (flags & FS_DIRSYNC_FL)
>  		inode->i_flags |= S_DIRSYNC;
>  }
>  
> @@ -125,18 +125,18 @@ void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi)
>  {
>  	unsigned int flags = oi->vfs_inode.i_flags;
>  
> -	oi->ip_attr &= ~(OCFS2_SYNC_FL|OCFS2_APPEND_FL|
> -			OCFS2_IMMUTABLE_FL|OCFS2_NOATIME_FL|OCFS2_DIRSYNC_FL);
> +	oi->ip_attr &= ~(FS_SYNC_FL | FS_APPEND_FL | FS_IMMUTABLE_FL |
> +			FS_NOATIME_FL | FS_DIRSYNC_FL);
>  	if (flags & S_SYNC)
> -		oi->ip_attr |= OCFS2_SYNC_FL;
> +		oi->ip_attr |= FS_SYNC_FL;
>  	if (flags & S_APPEND)
> -		oi->ip_attr |= OCFS2_APPEND_FL;
> +		oi->ip_attr |= FS_APPEND_FL;
>  	if (flags & S_IMMUTABLE)
> -		oi->ip_attr |= OCFS2_IMMUTABLE_FL;
> +		oi->ip_attr |= FS_IMMUTABLE_FL;
>  	if (flags & S_NOATIME)
> -		oi->ip_attr |= OCFS2_NOATIME_FL;
> +		oi->ip_attr |= FS_NOATIME_FL;
>  	if (flags & S_DIRSYNC)
> -		oi->ip_attr |= OCFS2_DIRSYNC_FL;
> +		oi->ip_attr |= FS_DIRSYNC_FL;
>  }
>  
>  struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 2d95c1e5ad8b..2d962da9ba5c 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -78,7 +78,7 @@ int ocfs2_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	flags = OCFS2_I(inode)->ip_attr;
>  	ocfs2_inode_unlock(inode, 0);
>  
> -	fileattr_fill_flags(fa, flags & OCFS2_FL_VISIBLE);
> +	fileattr_fill_flags(fa, flags & FS_FL_USER_VISIBLE);
>  
>  	return status;
>  }
> @@ -105,11 +105,11 @@ int ocfs2_fileattr_set(const struct mnt_idmap *idmap,
>  	}
>  
>  	if (!S_ISDIR(inode->i_mode))
> -		flags &= ~OCFS2_DIRSYNC_FL;
> +		flags &= ~FS_DIRSYNC_FL;
>  
>  	oldflags = ocfs2_inode->ip_attr;
> -	flags = flags & OCFS2_FL_MODIFIABLE;
> -	flags |= oldflags & ~OCFS2_FL_MODIFIABLE;
> +	flags = flags & FS_FL_USER_MODIFIABLE;
> +	flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
>  
>  	/* Check already done by VFS, but repeat with ocfs lock */
>  	status = -EPERM;
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index c501eb3cdcda..53ddeb5e762f 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -235,33 +235,6 @@
>  #define OCFS2_INDEXED_DIR_FL	(0x0008)
>  #define OCFS2_HAS_REFCOUNT_FL   (0x0010)
>  
> -/* Inode attributes, keep in sync with EXT2 */
> -#define OCFS2_SECRM_FL			FS_SECRM_FL	/* Secure deletion */
> -#define OCFS2_UNRM_FL			FS_UNRM_FL	/* Undelete */
> -#define OCFS2_COMPR_FL			FS_COMPR_FL	/* Compress file */
> -#define OCFS2_SYNC_FL			FS_SYNC_FL	/* Synchronous updates */
> -#define OCFS2_IMMUTABLE_FL		FS_IMMUTABLE_FL	/* Immutable file */
> -#define OCFS2_APPEND_FL			FS_APPEND_FL	/* writes to file may only append */
> -#define OCFS2_NODUMP_FL			FS_NODUMP_FL	/* do not dump file */
> -#define OCFS2_NOATIME_FL		FS_NOATIME_FL	/* do not update atime */
> -/* Reserved for compression usage... */
> -#define OCFS2_DIRTY_FL			FS_DIRTY_FL
> -#define OCFS2_COMPRBLK_FL		FS_COMPRBLK_FL	/* One or more compressed clusters */
> -#define OCFS2_NOCOMP_FL			FS_NOCOMP_FL	/* Don't compress */
> -#define OCFS2_ECOMPR_FL			FS_ECOMPR_FL	/* Compression error */
> -/* End compression flags --- maybe not all used */
> -#define OCFS2_BTREE_FL			FS_BTREE_FL	/* btree format dir */
> -#define OCFS2_INDEX_FL			FS_INDEX_FL	/* hash-indexed directory */
> -#define OCFS2_IMAGIC_FL			FS_IMAGIC_FL	/* AFS directory */
> -#define OCFS2_JOURNAL_DATA_FL		FS_JOURNAL_DATA_FL /* Reserved for ext3 */
> -#define OCFS2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
> -#define OCFS2_DIRSYNC_FL		FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
> -#define OCFS2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
> -#define OCFS2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
> -
> -#define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
> -#define OCFS2_FL_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
> -
>  /*
>   * Extent record flags (e_node.leaf.flags)
>   */

