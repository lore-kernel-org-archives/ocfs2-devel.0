Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C52356777
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Jun 2026 02:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366705; cv=none; b=NzU2s5rvATLrEd8pnJO+I/MZG/gK5BgmR1o7tM2F5Bz1NNOHdJoX/4sejFTPdCc1UiotMzkM5DB/0V6fAZbRDqHYLMvJhD7y1xip7bMtxBvsGwDaE9vCv1sl6Zb6wxmIuZCIgyQVyPgZZfZ3uIoDV7fhOBaKoIy9WEVzPBHTAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366705; c=relaxed/simple;
	bh=5T2wDKOdW2HbLJbw9Fuq67U1R2pG+jqWQduUzI4ZreU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=VoAFBpaE1SijoKSzlpgn83BUeVv7IRDiN4tg3ntxWxJt4E+I9I6HOwX+B9fuQex+YMM+UC5MFHpsJgyjQRE8M4kSq1+GrzhWMfpyV/WFN9LKOan6Ro1QtlOPocIpJ8iu6ht4ITNaB8F/fUWgsgeTZWDIAtLxU1wjbyu830qu5Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RjfP/zXB; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RjfP/zXB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780366695; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9bDBeMgWCG5X2Z0ZLEs6sFz90iFIP1LtxBCqcG2hN2A=;
	b=RjfP/zXB2Xt4bQp05KMN44YdTWTtShqcyM+t9ZpmIyyGe+LsoJ+84q+9EoBToEhvDKxnBO5DCvV9XdxbrORqlYWHv8Dlll0WzG9y8UApYSIESG4TmXdbmsi3vBN+QmjYKzTMeiOjWRa4MeqIYlnlH6ev99MWL9cE8GS+a+zyZno=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X42YrvM_1780366693;
Received: from 30.221.145.10(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X42YrvM_1780366693 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 10:18:14 +0800
Message-ID: <cd5b155f-a580-4103-b87f-6d9eb3dc9b5f@linux.alibaba.com>
Date: Tue, 2 Jun 2026 10:18:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix out-of-bounds write in
 ocfs2_remove_refcount_extent
To: Ian Bridges <icb@fastmail.org>, akpm <akpm@linux-foundation.org>
References: <ah3TESOsEO9j_JLU@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ah3TESOsEO9j_JLU@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/2/26 2:44 AM, Ian Bridges wrote:
> [BUG]
> Unlinking a refcounted file whose refcount tree has leaf blocks
> triggers a fortify panic due to an out-of-bounds write.
> 
> [CAUSE]
> When the last leaf block is removed from a refcount tree,
> ocfs2_remove_refcount_extent() converts the root back to leaf mode
> with a bulk memset on &rb->rf_records. rf_records sits in an anonymous
> union with rf_list. rf_list.l_tree_depth aliases rf_records.rl_count,
> and is 0 for a single-level tree. With rl_count equal to 0, the memset
> writes past the 16-byte declared size of rf_records, which the fortify
> checker catches.
> 
> [FIX]
> Replace the bulk memset on &rb->rf_records with a correctly-bounded
> memset on rl_recs[] alone, after setting rl_count to the correct value.
> 
> Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
> Signed-off-by: Ian Bridges <icb@fastmail.org>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> This patch contains a proposed fix for a crash reported by syzbot
> in __ocfs2_decrease_refcount().
> 
> The file names and offsets in this description are from commit
> 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> I also have a small test harness that reproduces the original panic,
> which I can make available as well.
> 
> The Bug
> 
> The ocfs2_refcount_list structure (fs/ocfs2/ocfs2_fs.h:935) contains
> two fields relevant to this bug: rl_count, the maximum number of
> refcount record slots, and rl_used, the number of occupied slots. The
> flexible array member rl_recs is annotated __counted_by_le(rl_count)
> (fs/ocfs2/ocfs2_fs.h:942), which instructs the compiler to use
> rl_count as the runtime bound for __builtin_dynamic_object_size
> queries on rl_recs when CONFIG_FORTIFY_SOURCE is enabled.
> 
> ocfs2_remove_refcount_extent() (fs/ocfs2/refcounttree.c:2066) is
> called when the last refcount record is removed from a leaf block. If
> that leaf was also the last one, the root is converted back from tree
> mode to leaf mode. The restore path (fs/ocfs2/refcounttree.c:2131–2137)
> zeros the header fields and resets the on-disk record area with a memset
> on &rb->rf_records (fs/ocfs2/refcounttree.c:2134).
> 
> This is an out-of-bounds write of the rf_records struct member.
> rf_records and rf_list share the same memory in an anonymous union; the
> first field of rf_list, l_tree_depth, occupies the same bytes as
> rf_records.rl_count. A refcount tree is always single-level, so
> l_tree_depth is 0, which means rl_count reads as 0 at the memset call
> site. The declared size of rf_records is therefore 16 bytes (the fixed
> header with zero record slots), but the memset writes the full remainder
> of the block (past the end of the struct member).
> 
> Here is a step-by-step breakdown of how the crash is triggered by
> unlinking a refcounted file:
> 
> 0. Inode eviction calls through to ocfs2_commit_truncate()
> (fs/ocfs2/alloc.c:7241), which calls ocfs2_remove_btree_range()
> (fs/ocfs2/alloc.c:5714) for each extent range. Because the extents
> are refcounted, ocfs2_decrease_refcount() (fs/ocfs2/alloc.c:5800)
> is called to decrement the reference count for each cluster.
> 1. For each cluster whose reference count reaches zero,
> ocfs2_decrease_refcount_rec() (fs/ocfs2/refcounttree.c:2158)
> removes the corresponding record from the leaf block.
> 2. When the last record is removed from a leaf block, rl_used reaches
> 0 and ocfs2_remove_refcount_extent() (fs/ocfs2/refcounttree.c:2203)
> is called to detach it from the tree root's extent list.
> 3. If that was the last leaf, the root has no remaining extents and
> the restore-to-leaf-mode path at fs/ocfs2/refcounttree.c:2125 is
> entered.
> 4. The memset at fs/ocfs2/refcounttree.c:2134 writes past the
> 16-byte declared size of rf_records. The fortify checker reads
> rl_count, which is 0 because it aliases l_tree_depth in the union,
> and fires.
> 
> The Proposed Fix
> 
> Replace the bulk memset on &rb->rf_records with explicit initialisation
> of each header field of ocfs2_refcount_list, followed by a
> correctly-bounded memset on rl_recs[] alone. rl_count is set before the
> memset so that the fortify checker can read it at runtime to verify the
> write against the declared array size.
> 
>  fs/ocfs2/refcounttree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 8eee5be4d1ed..7323bde70caa 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2131,10 +2131,15 @@ static int ocfs2_remove_refcount_extent(handle_t *handle,
>  		rb->rf_flags = 0;
>  		rb->rf_parent = 0;
>  		rb->rf_cpos = 0;
> -		memset(&rb->rf_records, 0, sb->s_blocksize -
> -		       offsetof(struct ocfs2_refcount_block, rf_records));
> +		rb->rf_records.rl_used = 0;
> +		rb->rf_records.rl_reserved2 = 0;
> +		rb->rf_records.rl_reserved1 = 0;
> +		/* rl_count determines the memset size and fortify object size. */
>  		rb->rf_records.rl_count =
>  				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
> +		memset(rb->rf_records.rl_recs, 0,
> +		       le16_to_cpu(rb->rf_records.rl_count) *
> +		       sizeof(*rb->rf_records.rl_recs));
>  	}
>  
>  	ocfs2_journal_dirty(handle, ref_root_bh);

