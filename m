Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859147;
	b=mIAS1KREp5RUZk1Y3heyBYvtygWOmEXvD3xkXTGK2e94B9Vw28hDLw2pR7XYDjV+VmLe
	 FFgbes6PQbOGP+s8e6NugMoaUwTGHsOm/4dOe2iuLLoMrGDAXksIsBz9RDouy2SXUAk8n
	 5pCy7q7ePP+LsmOesgyxKQTvbyyW+1V/pbdw2laCo+EVp9foGbUdpMqTwBfRTMYY8mKvo
	 gBRU0KnZqyJS5xrvy2/MOSrQO1nQ7KLGK7gcc0bj+KyPkzIsCdiSRldP0Ei4NzwNYAJsL
	 0iJ/0qrkwj7PWt6FDj9+J1EZl6uD9/LgtLoSyXXa9CJ40BkZDkct25N9vDttpAt8mWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859147;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=NrnZscWyj9crJ/SaqHEjGZjptWpIZAvXl4BIL7lTILo=;
	b=PFs5FG5gCaa7h6Rbt58ZGWViYRktTvHqLDtjswn0XfrHcCJ3usX66JhbWSqRDhp0i1sn
	 IXh8RjaZw+sahjb5/P/AGWKvkIaFQ/ltt/a0u4aIUBXgcMuzHVXUsQaY28P+y2+KCxYwE
	 r3H8x7ImjLe9mwj0Fm4wZNqLWpnFjjgd9A0PmHiy0KkPoaULjLTi+Hyvq8I6Qc9b1dG1o
	 XK7VB8D06vCaRrQQ2ASD+KkUybqX8p5dx64/nRMAUOA468qfGK4rkRAh5zEzPExbHpj8d
	 Ln/qkPHxUz2dz1ttD4Bf+WOHCaFbOt6+VzwyzEMcyInziCl7mikFlB92bbBtvjaTjxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Gi9C+HII;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89385606A31A
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89385606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Gi9C+HII
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792859142; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NrnZscWyj9crJ/SaqHEjGZjptWpIZAvXl4BIL7lTILo=;
	b=Gi9C+HII4Urmre1UuzordZZHJQl8zGsUtPhY9PS1HnrX+j8u8ai2xQ643fWjgK+6N477fFQAEx83k1RuEURPczhHSxi7Y1vItZK0Qgwzbfte16m+UNC1ul5/8i0hOtfEsCYXJg2TRIcd1Dh8Qm5QqvQfvV6X5M6DVYqSTe2klAQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDOU24s_1792859140;
Received: from 30.251.227.55(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDOU24s_1792859140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 25 Oct 2026 00:25:41 +0800
Message-ID: <9cb9736b-a668-460c-bd1e-a691486741b9@linux.alibaba.com>
Date: Sun, 25 Oct 2026 00:25:40 +0800
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
Subject: Re: [PATCH v2 1/2] ocfs2: replace ocfs2-specific falloc ioctls with
 generic ones
To: Anthony Iliopoulos <ailiop@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261022130457.69343-1-ailiop@suse.com>
 <20261022130457.69343-2-ailiop@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261022130457.69343-2-ailiop@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 9:04 PM, Anthony Iliopoulos wrote:
> Replace custom ocfs2 space reservation structures and ioctl definitions
> with the generic file space allocation interfaces.
> 
> Those were originally copied from xfs in commit b25801038da5 ("ocfs2:
> Support xfs style space reservation ioctls") for compatibility reasons,
> which were eventually lifted to vfs and made generic. As such there is
> no reason to carry around the redundant definitions any longer, they can
> be dropped at this point.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/file.c        | 26 +++++++++++++-------------
>  fs/ocfs2/file.h        |  4 +++-
>  fs/ocfs2/ioctl.c       | 19 ++++++++++---------
>  fs/ocfs2/ocfs2_ioctl.h | 26 --------------------------
>  4 files changed, 26 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 62f45a1b5ca1..5ccc2a613e2d 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1944,7 +1944,7 @@ int ocfs2_remove_inode_range(struct inode *inode,
>   */
>  static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  				     loff_t f_pos, unsigned int cmd,
> -				     struct ocfs2_space_resv *sr,
> +				     struct space_resv *sr,
>  				     int change_size)
>  {
>  	int ret;
> @@ -2008,8 +2008,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	}
>  	size = sr->l_start + sr->l_len;
>  
> -	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64 ||
> -	    cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) {
> +	if (cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64 ||
> +	    cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) {
>  		if (sr->l_len <= 0) {
>  			ret = -EINVAL;
>  			goto out_inode_unlock;
> @@ -2026,8 +2026,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  
>  	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  	switch (cmd) {
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> +	case FS_IOC_RESVSP:
> +	case FS_IOC_RESVSP64:
>  		/*
>  		 * This takes unsigned offsets, but the signed ones we
>  		 * pass have been checked against overflow above.
> @@ -2035,8 +2035,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		ret = ocfs2_allocate_unwritten_extents(inode, sr->l_start,
>  						       sr->l_len);
>  		break;
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
> +	case FS_IOC_UNRESVSP:
> +	case FS_IOC_UNRESVSP64:
>  		ret = ocfs2_remove_inode_range(inode, di_bh, sr->l_start,
>  					       sr->l_len);
>  		break;
> @@ -2090,16 +2090,16 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  }
>  
>  int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> -			    struct ocfs2_space_resv *sr)
> +			    struct space_resv *sr)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	int ret;
>  
> -	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
> +	if ((cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64) &&
>  	    !ocfs2_writes_unwritten_extents(osb))
>  		return -ENOTTY;
> -	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
> +	else if ((cmd == FS_IOC_UNRESVSP || cmd == FS_IOC_UNRESVSP64) &&
>  		 !ocfs2_sparse_alloc(osb))
>  		return -ENOTTY;
>  
> @@ -2122,9 +2122,9 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
>  {
>  	struct inode *inode = file_inode(file);
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct ocfs2_space_resv sr;
> +	struct space_resv sr;
>  	int change_size = 1;
> -	int cmd = OCFS2_IOC_RESVSP64;
> +	int cmd = FS_IOC_RESVSP64;
>  	int ret = 0;
>  
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -2141,7 +2141,7 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
>  	}
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
> -		cmd = OCFS2_IOC_UNRESVSP64;
> +		cmd = FS_IOC_UNRESVSP64;
>  
>  	sr.l_whence = 0;
>  	sr.l_start = (s64)offset;
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index 97492ee5789e..7f587dc06dab 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -10,6 +10,8 @@
>  #ifndef OCFS2_FILE_H
>  #define OCFS2_FILE_H
>  
> +#include <linux/falloc.h>
> +
>  extern const struct file_operations ocfs2_fops;
>  extern const struct file_operations ocfs2_dops;
>  extern const struct file_operations ocfs2_fops_no_plocks;
> @@ -64,7 +66,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
>  			     struct buffer_head *bh);
>  
>  int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> -			    struct ocfs2_space_resv *sr);
> +			    struct space_resv *sr);
>  
>  int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
>  				   size_t count);
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 36c7c9ac8b5d..2d95c1e5ad8b 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -11,6 +11,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/compat.h>
>  #include <linux/fileattr.h>
> +#include <linux/falloc.h>
>  
>  #include <cluster/masklog.h>
>  
> @@ -857,12 +858,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	int status;
>  
>  	switch (cmd) {
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
> +	case FS_IOC_RESVSP:
> +	case FS_IOC_RESVSP64:
> +	case FS_IOC_UNRESVSP:
> +	case FS_IOC_UNRESVSP64:
>  	{
> -		struct ocfs2_space_resv sr;
> +		struct space_resv sr;
>  
>  		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
>  			return -EFAULT;
> @@ -971,10 +972,10 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	void __user *argp = (void __user *)arg;
>  
>  	switch (cmd) {
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
> +	case FS_IOC_RESVSP:
> +	case FS_IOC_RESVSP64:
> +	case FS_IOC_UNRESVSP:
> +	case FS_IOC_UNRESVSP64:
>  	case OCFS2_IOC_GROUP_EXTEND:
>  	case OCFS2_IOC_GROUP_ADD:
>  	case OCFS2_IOC_GROUP_ADD64:
> diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
> index 2de2f8733283..30244c94239b 100644
> --- a/fs/ocfs2/ocfs2_ioctl.h
> +++ b/fs/ocfs2/ocfs2_ioctl.h
> @@ -10,32 +10,6 @@
>  #ifndef OCFS2_IOCTL_H
>  #define OCFS2_IOCTL_H
>  
> -/*
> - * Space reservation / allocation / free ioctls and argument structure
> - * are designed to be compatible with XFS.
> - *
> - * ALLOCSP* and FREESP* are not and will never be supported, but are
> - * included here for completeness.
> - */
> -struct ocfs2_space_resv {
> -	__s16		l_type;
> -	__s16		l_whence;
> -	__s64		l_start;
> -	__s64		l_len;		/* len == 0 means until end of file */
> -	__s32		l_sysid;
> -	__u32		l_pid;
> -	__s32		l_pad[4];	/* reserve area			    */
> -};
> -
> -#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
> -#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
> -#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
> -#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
> -#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
> -#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
> -#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
> -#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
> -
>  /* Used to pass group descriptor data when online resize is done */
>  struct ocfs2_new_group_input {
>  	__u64 group;		/* Group descriptor's blkno. */

