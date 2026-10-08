Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6521DDFE
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Oct 2026 09:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791451596; cv=none; b=NsrDgc6kD2gCob402AlV3vgvqmGiAATCDu4xDBwavijxEPZ0+BEApAZ7uS4yEeBParOF6Llphu1uzDraUdzx+cWBWrKp9C7pLe2L50sDU//nOEdPs/hLhyC2M+xre8CdLEgBF7euSO0YOebKN2Qq3W7xxXBopZ/pRr6ienBAiKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791451596; c=relaxed/simple;
	bh=AEAXAuTCdshlj5vRoyiPc7JMFlLaifZhRawd6zu8CKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k0yHQCTGj1HXpbPb12lkMSEI/L+9dA8T/zUjRqwW1ghnnfOk5BeYwzGe9JfL+TPqkiSXRWNBnRUeqVYN4i1VJ0Y0xX6AoGQdiSTtPh93BbonFxhDZ9JkMVX7psKtBFxFBeYzz2bX6lxyhycy8ESNZaxKyhoCprti2uPn+nREPEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JQOLT+2t; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JQOLT+2t"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791451589; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IvCHuh0QHvSSi6smvSQRsZh/QZENLvAcoAmd6HNiFHo=;
	b=JQOLT+2tVgaeLbjeDDOgqAi7FLDH8NAOStGHftLngpVPRUI399bhfFK6ReblyQYsKlEMTvmifwODDDJQtUi61P53bAPYK2s5MRoUNGKXQ3EsQFFtgL3winTFMvP1YLeF0UkZzpf4qPbGBii4+0Ys+UWCxvh+MlppvUydGiV8HZI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCNMuXW_1791451587;
Received: from 30.221.149.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCNMuXW_1791451587 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 17:26:28 +0800
Message-ID: <ad5a4d68-0667-46b4-ba28-a0ff0be5c1fb@linux.alibaba.com>
Date: Thu, 8 Oct 2026 17:26:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: validate la_size before
 ocfs2_clear_local_alloc()
To: Dmitry Morgun <d.morgun@ispras.ru>, ocfs2-devel@lists.linux.dev
Cc: heming.zhao@suse.com, mark@fasheh.com, jlbec@evilplan.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20261006122842.1537-1-d.morgun@ispras.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261006122842.1537-1-d.morgun@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/6/26 8:28 PM, Dmitry Morgun wrote:
> la_size, like the journal dirty flag, is read from disk. If dirty != 0,
> ocfs2_begin_local_alloc_recovery() is called, which invokes
> ocfs2_clear_local_alloc(). At this point, ocfs2_clear_local_alloc()
> uses la_size as the loop bound without validating it first. If
> la_size is oversized, the loop writes past the end of la_bitmap and
> may eventually start writing into memory that has already been freed.
> 
> BUG: KASAN: use-after-free in ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
> BUG: KASAN: use-after-free in ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
> CPU: 1 PID: 2386 Comm: syz.2.190 Not tainted 6.1.174-syzkaller-00520-g10c505401422 #0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
>  ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
>  ocfs2_check_volume fs/ocfs2/super.c:2448 [inline]
>  ocfs2_mount_volume fs/ocfs2/super.c:1819 [inline]
>  ocfs2_fill_super+0x2033/0x3dc0 fs/ocfs2/super.c:1082
>  mount_bdev+0x356/0x410 fs/super.c:1443
>  legacy_get_tree+0x108/0x220 fs/fs_context.c:632
>  vfs_get_tree+0x8e/0x300 fs/super.c:1573
>  do_new_mount fs/namespace.c:3078 [inline]
>  path_mount+0x6af/0x1f70 fs/namespace.c:3408
>  do_mount fs/namespace.c:3421 [inline]
>  __do_sys_mount fs/namespace.c:3629 [inline]
>  __se_sys_mount fs/namespace.c:3606 [inline]
>  __x64_sys_mount+0x283/0x300 fs/namespace.c:3606
>  do_syscall_x64 arch/x86/entry/common.c:46 [inline]
>  do_syscall_64+0x35/0x80 fs/namespace.c:76
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> The existing la_size check in ocfs2_load_local_alloc() runs after
> ocfs2_clear_local_alloc() on this recovery path. Memory corruption
> can therefore occur before the invalid size is detected and
> -EINVAL is returned.
> 
> Reject inodes without OCFS2_LOCAL_ALLOC_FL in
> ocfs2_begin_local_alloc_recovery() before copying or clearing the
> bitmap, returning -EINVAL. The recovery code interprets id2 as
> i_lab, so it must not proceed when the local allocation flag is
> missing.
> 
> Add la_size validation to ocfs2_validate_inode_block() for inodes
> marked with OCFS2_LOCAL_ALLOC_FL. Reject zero or a size exceeding
> the bitmap capacity through ocfs2_error(), which marks the
> filesystem read-only and returns -EROFS. The flag check in recovery

The behavior depends on errors= settings, so -EROFS is not always true. 

> prevents a corrupted inode from bypassing this validation by
> clearing OCFS2_LOCAL_ALLOC_FL.
> 
> Keep the existing size check in ocfs2_load_local_alloc(), whose
> flag check also accepts OCFS2_BITMAP_FL without OCFS2_LOCAL_ALLOC_FL.
> 
> The new checks can also return errors during node recovery. The
> recovery thread leaves a failed node in the recovery map and
> immediately retries it, so a persistent error prevents the loop
> from completing. Release the super lock and exit through the
> worker error path on failure, preserving the error status and
> leaving the failed node in the recovery map.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
> ---
> v4:
> - Supersede v3, which was an unintended resend of the v1-based
>   implementation.
> - Move la_size validation from
>   ocfs2_begin_local_alloc_recovery() to
>   ocfs2_validate_inode_block() (Joseph Qi).
> - Reject local allocation recovery when OCFS2_LOCAL_ALLOC_FL is
>   missing, before copying or clearing the bitmap (Heming Zhao).
> - Keep the existing size check in ocfs2_load_local_alloc().
> - Release the super lock and exit the recovery thread on error,
>   preserving the error status and the failed recovery-map entry
>   instead of immediately retrying the same node.
> 
> Link to v3:
> https://lore.kernel.org/ocfs2-devel/20260831143734.7243-1-d.morgun@ispras.ru/
> 
> v3:
> - Unintended resend of the v1-based implementation.
> 
> v2:
> - Not posted publicly.
> 
> Link to v1:
> https://lore.kernel.org/all/20260810113508.8513-1-d.morgun@ispras.ru/
> 
>  fs/ocfs2/inode.c      | 13 +++++++++++++
>  fs/ocfs2/journal.c    |  2 ++
>  fs/ocfs2/localalloc.c |  9 ++++++++-
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 9a6b1af4c..cc2233268 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1477,6 +1477,19 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	if (le32_to_cpu(di->i_flags) & OCFS2_LOCAL_ALLOC_FL) {
> +		struct ocfs2_local_alloc *la = &di->id2.i_lab;
> +
> +		if (la->la_size == 0 ||
> +		    le16_to_cpu(la->la_size) > ocfs2_local_alloc_size(sb)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: invalid la_size %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(la->la_size));
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 7f5fd16d3..46983a061 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1525,6 +1525,8 @@ static int __ocfs2_recovery_thread(void *arg)
>  			     status, node_num,
>  			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
>  			mlog(ML_ERROR, "Volume requires unmount.\n");
> +			ocfs2_super_unlock(osb, 1);
> +			goto bail;

This fires on any non-zero status from ocfs2_recover_node(), not only on
persistent ones, e.g. -ENOMEM returns from
ocfs2_begin_local_alloc_recovery().

Thanks,
Joseph

>  		}
>  
>  		spin_lock(&osb->osb_lock);
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c4426d12a..c5c80a17b 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -504,6 +504,14 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> +	alloc = (struct ocfs2_dinode *)alloc_bh->b_data;
> +	if (!(le32_to_cpu(alloc->i_flags) & OCFS2_LOCAL_ALLOC_FL)) {
> +		mlog(ML_ERROR, "Invalid local alloc inode, %llu\n",
> +		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>  	*alloc_copy = kmalloc(alloc_bh->b_size, GFP_KERNEL);
>  	if (!(*alloc_copy)) {
>  		status = -ENOMEM;
> @@ -511,7 +519,6 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
>  	}
>  	memcpy((*alloc_copy), alloc_bh->b_data, alloc_bh->b_size);
>  
> -	alloc = (struct ocfs2_dinode *) alloc_bh->b_data;
>  	ocfs2_clear_local_alloc(alloc);
>  
>  	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);

