Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F15143736
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729043531; cv=none; b=KpseBBSk4wqnaxl/L5sSPsRfAWpAMPgDJExfl/kGW/+njQx5vr5DmTx89rWIMGsndc58+4eP8CuMmvzEhA6uAM3C7swc744ECRx1LW8JM3Hh94Tdbfao4IiZzvnsuxSDunFe89+jrbD+0glcN59IC6Q/+sNSrd2nXSEN9MwmKyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729043531; c=relaxed/simple;
	bh=9hgfdoCZzl6xbXZAKFXjYm1OLVfPjKDVl7L7UxyQ/hg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pUv2BbwJVcGyg1H+rmer41wQH/PUR8qg/Z4u7gp9ahhX8t8j+wU2k9zreWpmlZSq2gjRxTpdQhGmI8VMYFoiPdcH0cZAqRMM9eEhOEH9YXJivYiYJ7BU1hjmxMl64upWIbmeUnm1WI40bb7XrRTUrfFd/2vF5OL9k3thjCNaQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dUSavsEj; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dUSavsEj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729043520; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Wk4MVMy950lrir4c46lAmv5mk+cqkqzTOJLVI5hRLWE=;
	b=dUSavsEjDwREbpzgdjBEH86Fug49iDH5Rha/qRhr8kt6oq4LTWZUhjY7FLM1F30vJQeM2LiW6IEh/pZgKG24kO1bjWUu11RgNWcrqXlqg5TFOlVyqHSVnb+ctq55eWvJQIXM0w9bn7o7Lz0FhmXlBY7MIPo+Tpp0VQWklbkMeaY=
Received: from 30.221.129.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHFDQ12_1729043519 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Oct 2024 09:52:00 +0800
Message-ID: <e028897f-eb29-4bc9-9b2e-fe102810fba5@linux.alibaba.com>
Date: Wed, 16 Oct 2024 09:51:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] libocfs2: fix non-zero value in Next Leaf field
 in the rightmost leaf metadata block
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 ocfs2-devel@lists.linux.dev
Cc: ghe@suse.com, mark@fasheh.com
References: <20241015161109.156497-1-gautham.ananthakrishna@oracle.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241015161109.156497-1-gautham.ananthakrishna@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

This is patch for ocfs2-tools, so please submit a pull request in
ocfs2-tools github repo.

Thanks,
Joseph

On 10/16/24 12:11 AM, Gautham Ananthakrishna wrote:
> One of our customers reported read-only filesystem. fsck.ocfs2 -ny showed the
> following issue:
> Pass 1: Checking inodes and blocks
> [EXTENT_LIST_FREE] Extent list in owner 658435 claims 231 as the next free chain record, but fsck believes the largest valid value is 227.  Clamp the next record value? n
> 
> debugfs.ocfs2 also showed the corruption:
> 
>         Inode: 658435   Mode: 0644   Generation: 974589382 (0x3a170dc6)
>         FS Generation: 432631804 (0x19c96ffc)
>         CRC32: 00000000   ECC: 0000
>         Type: Regular   Attr: 0x0   Flags: Valid
>         Dynamic Features: (0x0)
>         User: 0 (root)   Group: 0 (root)   Size: 121633767424
>         Links: 1   Clusters: 14848000
>         ctime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
>         atime: 0x66fa5e5d 0x34514ed8 -- Mon Sep 30 08:16:29.877743832 2024
>         mtime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
>         dtime: 0x0 -- Thu Jan  1 00:00:00 1970
>         Refcount Block: 0
>         Last Extblk: 539186   Orphan Slot: 0
>         Sub Alloc Slot: 0   Sub Alloc Bit: 2
>         Tree Depth: 1   Count: 227   Next Free Rec: 231
>         ## Offset        Clusters       Block#
>         0  0             129024         525859
>         1  129024        129024         526883
> 
> The "Next Free Rec" had overshoot the "Count".
> 
> Upon running fsck.ocfs2 -fy, the fsck managed to fix only the
> root metadata block and updated it with a new "Last Extblk"
> 
>         Inode: 658435   Mode: 0644   Generation: 974589382 (0x3a170dc6)
>         FS Generation: 432631804 (0x19c96ffc)
>         CRC32: 00000000   ECC: 0000
>         Type: Regular   Attr: 0x0   Flags: Valid
>         Dynamic Features: (0x0)
>         User: 0 (root)   Group: 0 (root)   Size: 121633767424
>         Links: 1   Clusters: 14644224
>         ctime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
>         atime: 0x66fa5e5d 0x34514ed8 -- Mon Sep 30 08:16:29.877743832 2024
>         mtime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
>         dtime: 0x0 -- Thu Jan  1 00:00:00 1970
>         Refcount Block: 0
>         Last Extblk: 535090   Orphan Slot: 0
>         Sub Alloc Slot: 0   Sub Alloc Bit: 2
>         Tree Depth: 1   Count: 227   Next Free Rec: 227
>         ## Offset        Clusters       Block#
>         0  0             129024         525859
>         1  129024        129024         526883
>         2  258048        129024         536099
> 
> However fsck.ocfs2 did not set "Next Leaf" to zero in the updated "Last Extblk".
> 
>         SubAlloc Bit: 16   SubAlloc Slot: 0
>         Blknum: 535090   Next Leaf: 536114
>         CRC32: 00000000   ECC: 0000
>         Tree Depth: 0   Count: 252   Next Free Rec: 252
>         ## Offset        Clusters       Block#          Flags
>         0  29159424      256            7845889         0x0
>         1  29159936      256            7846145         0x0
> 
> This patch addresses this issue by checking the last leaf metadata block
> and setting "Next Leaf" to zero if not done.
> 
> Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> ---
>  libocfs2/extents.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/libocfs2/extents.c b/libocfs2/extents.c
> index d72ae66..c2a3a88 100644
> --- a/libocfs2/extents.c
> +++ b/libocfs2/extents.c
> @@ -277,6 +277,7 @@ static int extent_iterate_el(struct ocfs2_extent_list *el,
>  				if (el->l_tree_depth == 1)
>  					ctxt->last_eb_blkno =
>  							el->l_recs[i].e_blkno;
> +
>  				ctxt->last_eb_cpos = el->l_recs[i].e_cpos;
>  			}
>  
> @@ -478,6 +479,7 @@ errcode_t ocfs2_extent_iterate_inode(ocfs2_filesys *fs,
>  	struct ocfs2_extent_list *el;
>  	errcode_t ret;
>  	struct extent_context ctxt;
> +	struct ocfs2_extent_block *eb;
>  
>  	ret = OCFS2_ET_INODE_NOT_VALID;
>  	if (!(inode->i_flags & OCFS2_VALID_FL))
> @@ -543,6 +545,26 @@ out_abort:
>  	if (!ret && (iret & OCFS2_EXTENT_CHANGED))
>  		ret = ocfs2_write_inode(fs, inode->i_blkno, (char *)inode);
>  
> +	/*
> +	 * Check i_last_eb_blk and set
> +	 * its next leaf to zero.
> +	 */
> +	if (!ret && el->l_tree_depth) {
> +		ctxt.errcode = ocfs2_read_extent_block(fs,
> +					inode->i_last_eb_blk,
> +					ctxt.eb_bufs[0]);
> +
> +		eb = (struct ocfs2_extent_block *)ctxt.eb_bufs[0];
> +
> +		if (!ctxt.errcode && eb->h_next_leaf_blk != 0) {
> +			eb->h_next_leaf_blk = 0;
> +			ctxt.errcode = ocfs2_write_extent_block(fs,
> +						inode->i_last_eb_blk,
> +						ctxt.eb_bufs[0]);
> +		}
> +		ret = ctxt.errcode;
> +	}
> +
>  out_eb_bufs:
>  	if (ctxt.eb_bufs) {
>  		if (!block_buf && ctxt.eb_bufs[0])

