Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC6C19E979
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 12:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733313687; cv=none; b=RQh6q31q/Hwf2enf8jwF8NQ4Ak0wo5AUzttLysdXJh9ZdcxlM0hHp+QHBSkXLJrnZ5hyOu4rStwN7clNTvkBM6BZCVOmIWfelmz6LUckCAREuTFY/dtuzRV9Q0hf2c/TIDlg4BHQMrTy9ThI8ff54jzDmHxFuyabTpLbvxuXkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733313687; c=relaxed/simple;
	bh=3IWv7y4HDPW7q+P25AxWFprKm+Y7FbpQpdLUsjjXv/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oz4CCSySqCjn6MyRuUaEXjXY31s2a89xAwDiCTwM7SPrjNR5WEYW/rhoOK1MLX2j63aUZL/Q+5Yh+9d/5QlUSlPq7NpH+dGjt4+xtFv2UYsTZKhDvId34CQJM3iXOFI2lEdfIFg4ywdKco3nh4oTgbAy8fbuYn49pL9CEBZZxno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dBQJg0zD; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dBQJg0zD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733313676; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EGUTfO6ydHomI3T23FHv1soefb5pbwpzqCG9zzWBxqY=;
	b=dBQJg0zDWOxRDP/8mdCnBrQK7cwawuTUXIuyQazq0cKZJ3ca4Bv+Tr/ULVTxdnyg8WSfG4UT3fNDSz+WQX7CJ871aMkbaTHi3QUie0z1IK+LXfbt8L9EQPyBem4Z/8kXi+cqQOi5gFEPLUg0u/uxuz/5sInblaz14pXWJ9AXT5s=
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WKq-Sz9_1733313674 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Dec 2024 20:01:15 +0800
Message-ID: <8ca093f7-7b47-4032-af02-2e6103cdd5cf@linux.alibaba.com>
Date: Wed, 4 Dec 2024 20:01:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] dlmfs: convert to the new mount API
To: Eric Sandeen <sandeen@redhat.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: brauner@kernel.org
References: <20241028144443.609151-1-sandeen@redhat.com>
 <20241028144443.609151-2-sandeen@redhat.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241028144443.609151-2-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/24 10:41 PM, Eric Sandeen wrote:
> Convert dlmfs to the new mount API.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 7fc0e920eda7..2a7f36643895 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -20,6 +20,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/fs.h>
> +#include <linux/fs_context.h>
>  #include <linux/pagemap.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
> @@ -506,9 +507,7 @@ static int dlmfs_unlink(struct inode *dir,
>  	return status;
>  }
>  
> -static int dlmfs_fill_super(struct super_block * sb,
> -			    void * data,
> -			    int silent)
> +static int dlmfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  {
>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
>  	sb->s_blocksize = PAGE_SIZE;
> @@ -556,17 +555,27 @@ static const struct inode_operations dlmfs_file_inode_operations = {
>  	.setattr	= dlmfs_file_setattr,
>  };
>  
> -static struct dentry *dlmfs_mount(struct file_system_type *fs_type,
> -	int flags, const char *dev_name, void *data)
> +static int dlmfs_get_tree(struct fs_context *fc)
>  {
> -	return mount_nodev(fs_type, flags, data, dlmfs_fill_super);
> +	return get_tree_nodev(fc, dlmfs_fill_super);
> +}
> +
> +static const struct fs_context_operations dlmfs_context_ops = {
> +	.get_tree       = dlmfs_get_tree,
> +};
> +
> +static int dlmfs_init_fs_context(struct fs_context *fc)
> +{
> +	fc->ops = &dlmfs_context_ops;
> +
> +	return 0;
>  }
>  
>  static struct file_system_type dlmfs_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "ocfs2_dlmfs",
> -	.mount		= dlmfs_mount,
>  	.kill_sb	= kill_litter_super,
> +	.init_fs_context = dlmfs_init_fs_context,
>  };
>  MODULE_ALIAS_FS("ocfs2_dlmfs");
>  

