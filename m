Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CE76F2F4
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Sep 2024 07:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726039707; cv=none; b=cJoIs8jeDvB12G8CAEbXFUgVMyhL9hI0JpElBSSUEnPHJWD/mDwXAmILzlfvz0wSeMhBAqMtX/pg5k5nvA/Rw3Ce348et1orK4YV6iW1phCHYL2xHA+/3McT5GLOFm6WBLpVKPQ3CVyN2Gft/wzLDZ40gyPSqzPHHWGvoS3990I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726039707; c=relaxed/simple;
	bh=APdJph7gaicjs+tOowsU3frR0yv8vE0vROecMhOCPmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j1Yg2MdPfIMiCu5vW2k1ZfFOQkkum4aEBoyoeyrfOQu8KbnwMvI6UFkBKE0ei5bshqY5IdcI6Q81fxgLWEbEf9Uf6k6ga17Fxxhh3gmIf4bBj263epNCM4UudQEmhp6k5mYUtfnIlJjHhRuz7sOldN+GLYc/4MFgZV+mY5kf2HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=A9kfiGP1; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="A9kfiGP1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1726039696; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1FVrW79iD8OZdNUG6s51hH/WHjboDl1XekYbQsR2hew=;
	b=A9kfiGP1OxeXSvsdvhRzzsICYzUuk1IXn3ahwQDVcY/EGBNWSepu73SrH6IOMUY0EZE5F8BA+XXGfmnCW0nhyaQ0PW0QkWc3CtkoQs7C+osmF8SBIElaLEdw7sXILm4e7BQsEYCfQ12utDSkDd2Y2K7gz7ExhE+G+/jcnBGeDG0=
Received: from 30.221.129.31(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEmyeU6_1726039695)
          by smtp.aliyun-inc.com;
          Wed, 11 Sep 2024 15:28:15 +0800
Message-ID: <6b8f2dee-12a7-4a8d-a67f-e4c67277d230@linux.alibaba.com>
Date: Wed, 11 Sep 2024 15:28:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before
 attaching reflink tree
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Cc: junxiao.bi@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
 ocfs2-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240910044045.257958-1-gautham.ananthakrishna@oracle.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240910044045.257958-1-gautham.ananthakrishna@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/10/24 12:40 PM, Gautham Ananthakrishna wrote:
> One of our customers reported a crash and a corrupted ocfs2 filesystem.
> The crash was due to the detection of corruption. Upon troubleshooting,
> the fsck -fn output showed the below corruption
> 
> [EXTENT_LIST_FREE] Extent list in owner 33080590 claims 230 as the next free chain record,
> but fsck believes the largest valid value is 227.  Clamp the next record value? n
> 
> The stat output from the debugfs.ocfs2 showed the following corruption
> where the "Next Free Rec:" had overshot the "Count:" in the root metadata
> block.
> 
>         Inode: 33080590   Mode: 0640   Generation: 2619713622 (0x9c25a856)
>         FS Generation: 904309833 (0x35e6ac49)
>         CRC32: 00000000   ECC: 0000
>         Type: Regular   Attr: 0x0   Flags: Valid
>         Dynamic Features: (0x16) HasXattr InlineXattr Refcounted
>         Extended Attributes Block: 0  Extended Attributes Inline Size: 256
>         User: 0 (root)   Group: 0 (root)   Size: 281320357888
>         Links: 1   Clusters: 141738
>         ctime: 0x66911b56 0x316edcb8 -- Fri Jul 12 06:02:30.829349048 2024
>         atime: 0x66911d6b 0x7f7a28d -- Fri Jul 12 06:11:23.133669517 2024
>         mtime: 0x66911b56 0x12ed75d7 -- Fri Jul 12 06:02:30.317552087 2024
>         dtime: 0x0 -- Wed Dec 31 17:00:00 1969
>         Refcount Block: 2777346
>         Last Extblk: 2886943   Orphan Slot: 0
>         Sub Alloc Slot: 0   Sub Alloc Bit: 14
>         Tree Depth: 1   Count: 227   Next Free Rec: 230
>         ## Offset        Clusters       Block#
>         0  0             2310           2776351
>         1  2310          2139           2777375
>         2  4449          1221           2778399
>         3  5670          731            2779423
>         4  6401          566            2780447
>         .......          ....           .......
>         .......          ....           .......
> 
> The issue was in the reflink workfow while reserving space for inline xattr.
> The problematic function is ocfs2_reflink_xattr_inline(). By the time this
> function is called the reflink tree is already recreated at the destination
> inode from the source inode. At this point, this function reserves space
> space inline xattrs at the destination inode without even checking if there
> is space at the root metadata block. It simply reduces the l_count from 243
> to 227 thereby making space of 256 bytes for inline xattr whereas the inode
> already has extents beyond this index (in this case upto 230), thereby causing
> corruption.
> 
> The fix for this is to reserve space for inline metadata before the at the
> destination inode before the reflink tree gets recreated. The customer has
> verified the fix.
> 
> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>

Fixes: ef962df057aa ("ocfs2: xattr: fix inlined xattr reflink")
Cc: <stable@vger.kernel.org>

> ---
>  fs/ocfs2/refcounttree.c | 18 ++++++++++++++++++
>  fs/ocfs2/xattr.c        | 11 +----------
>  2 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 3f80a56d0d60..c0edb32a7ff6 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -25,6 +25,7 @@
>  #include "namei.h"
>  #include "ocfs2_trace.h"
>  #include "file.h"
> +#include "symlink.h"
>  
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> @@ -4182,6 +4183,23 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>  		goto out_unlock;
>  	}
>  
> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_XATTR_FL) &&
            ^ align it here, please.

> +		(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> +		/*
> +		 * Adjust extent record count to reserve space for extended attribute.
> +		 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> +		 */
> +		if (!(OCFS2_I(new_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
                    ^ ditto.

And since there are many places access OCFS2_I(new_inode), I'd like
define a variable for it. This can also make code in one line much
shorter. e.g.
struct ocfs2_inode_info *oi = OCFS2_I(inode);

> +			!(ocfs2_inode_is_fast_symlink(new_inode))) {
> +			struct ocfs2_dinode *new_di = new_bh->b_data;
> +			struct ocfs2_dinode *old_di = old_bh->b_data;
> +			struct ocfs2_extent_list *el = &new_di->id2.i_list;
> +			int inline_size = le16_to_cpu(old_di->i_xattr_inline_size);
Add a blank line here.

BTW, also cc lkml.

Thanks,
Joseph

> +			le16_add_cpu(&el->l_count, -(inline_size /
> +					sizeof(struct ocfs2_extent_rec)));
> +		}
> +	}
> +
>  	ret = ocfs2_create_reflink_node(inode, old_bh,
>  					new_inode, new_bh, preserve);
>  	if (ret) {
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 3b81213ed7b8..a9f716ec89e2 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6511,16 +6511,7 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
>  	}
>  
>  	new_oi = OCFS2_I(args->new_inode);
> -	/*
> -	 * Adjust extent record count to reserve space for extended attribute.
> -	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> -	 */
> -	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> -	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
> -		struct ocfs2_extent_list *el = &new_di->id2.i_list;
> -		le16_add_cpu(&el->l_count, -(inline_size /
> -					sizeof(struct ocfs2_extent_rec)));
> -	}
> +
>  	spin_lock(&new_oi->ip_lock);
>  	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
>  	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);

