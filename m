Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF953BBFBC
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Jun 2026 13:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781445487; cv=none; b=AXqDN/UofjjDGlI16Sq6TOsyYSvONnfRqZUvH7CnKG+izHeXoe0eNsQZkmX+tYgl3l+UEJ7vNefZDqPtHdqmduyhOIU4sauOjeBma2C8IacaHkte6iuKdW4MqUvun5OXLU//JKEVVGCLeqaIMfvd6XMcMAybUZPKIKWOcxk1ZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781445487; c=relaxed/simple;
	bh=TxNdc/t3Cf2PZtap8vVrP3O8nGBDu69nufxjw/OtEI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=jRZtXYNc7BcUxGuAykEYP9Qud+Du21gH3ZCtEDEwVT+n4GZ7BC1+v0WLUNL6LT11LePCk1qLT2nVOfONOB9xzUTm35lBXF5qDVXwrgnCqAOneipq2t9ulTtDMSF0yIKttQIXgUf6zryfnJKrGMqCdNqwHQg7iGnxMxYdfSwCQUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FXdmxRNO; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FXdmxRNO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781445475; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sA+T4QJHG15HUfyrpsQrLwy1Afce7hJ27rQLeCW/N30=;
	b=FXdmxRNOFzkddyqhoGC+zYZTEDavNC982tEGCQnZTP4qnSUO8YmdJ/FATXIwgoPykTAe2AQ9wAr1AcjW+ZiJp3swOGTgB3Edp1AHmIEw1tCtxoJK5FlJVHkQacdQsaUpAjTkXUGsR216rkPQqu3T9IZ3+WQnvUzSRdF6TIvx+n4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X4nVW4H_1781445474;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4nVW4H_1781445474 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 14 Jun 2026 21:57:54 +0800
Message-ID: <d73e1f39-8207-4e8c-9c86-94a6b3d737c2@linux.alibaba.com>
Date: Sun, 14 Jun 2026 21:57:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix NULL h_transaction deref in
 ocfs2_assure_trans_credits
To: Ian Bridges <icb@fastmail.org>, akpm <akpm@linux-foundation.org>
References: <airKTsM1fRVN-Wj7@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <airKTsM1fRVN-Wj7@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/11/26 10:46 PM, Ian Bridges wrote:
> [BUG]
> A direct write over unwritten extents can panic the kernel in
> ocfs2_assure_trans_credits() when the journal aborts during DIO
> completion. The crash is a general protection fault from a NULL pointer
> dereference.
> 
> [CAUSE]
> ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
> marking each written under a single journal handle. If the journal
> aborts (for example after an I/O error) while the extent tree is being
> updated, the handle is left aborted with its transaction pointer
> cleared. The extent merge treats that failure as not critical and
> reports success, so the loop keeps using the handle.
> ocfs2_assure_trans_credits() reads the handle's remaining credits
> without first checking whether the handle is aborted, and that read
> dereferences the cleared transaction pointer.
> 
> [FIX]
> A journal abort is recorded in the handle itself, so callers are
> expected to test the handle rather than rely on a returned error.
> Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
> helpers already do, and return -EROFS when the handle is aborted.
> 
> Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
> Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> This patch contains a proposed fix for a crash reported by syzbot
> in ocfs2_assure_trans_credits().
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
> OCFS2 supports unwritten extents. These are ranges that fallocate()
> has allocated on disk but flagged as holding no data, so reads return
> zeros until the range is written. Clearing that flag is a journalled
> metadata change. For a direct write, OCFS2 makes that change when the
> write completes rather than when the write is submitted.
> 
> When a direct write to unwritten extents completes, ocfs2_dio_end_io()
> (fs/ocfs2/aops.c:2401) calls ocfs2_dio_end_io_write()
> (fs/ocfs2/aops.c:2266). That function opens one jbd2 handle and loops
> over the extents the write covered (fs/ocfs2/aops.c:2319). For each one
> it calls ocfs2_assure_trans_credits() (fs/ocfs2/aops.c:2334) and then
> ocfs2_mark_extent_written() (fs/ocfs2/aops.c:2339). The same handle is
> reused on each pass.
> 
> ocfs2_assure_trans_credits() (fs/ocfs2/journal.c:474) makes sure the
> handle still has enough journal credits for the next extent operation.
> Its first action is:
> 
>     int old_nblks = jbd2_handle_buffer_credits(handle);
> 
> jbd2_handle_buffer_credits() (include/linux/jbd2.h:1817) is an inline
> accessor that reads handle->h_transaction->t_journal without a NULL
> check. t_journal is at offset 0 of struct transaction_s, so a NULL
> h_transaction makes this a read of address 0.
> 
> A handle's h_transaction is set to NULL when a transaction restart
> fails. The bug is that ocfs2_dio_end_io_write() can keep using such a
> handle. The sequence is:
> 
> 1. ocfs2_mark_extent_written() reaches ocfs2_try_to_merge_extent()
>    through ocfs2_change_extent_flag() and ocfs2_split_extent(). When the
>    marked extent merges with a neighbor (ctxt->c_split_covers_rec,
>    fs/ocfs2/alloc.c:3820), the merge reserves rotation credits with
>    ocfs2_extend_rotate_transaction() (fs/ocfs2/alloc.c:3822), which calls
>    ocfs2_extend_trans() (fs/ocfs2/journal.c:428).
> 
> 2. ocfs2_extend_trans() cannot grow the running transaction, so it
>    restarts the handle with jbd2_journal_restart()
>    (fs/ocfs2/journal.c:454).
> 
> 3. jbd2__journal_restart() (fs/jbd2/transaction.c) sets
>    handle->h_transaction to NULL, then calls start_this_handle() to
>    attach a new transaction. If the journal has aborted,
>    start_this_handle() returns an error (fs/jbd2/transaction.c:366) and
>    h_transaction stays NULL.
> 
> 4. The error reaches ocfs2_try_to_merge_extent(), which ignores it.
>    At fs/ocfs2/alloc.c:3827 it resets ret to 0 and returns success, so
>    the loop does not stop.
> 
> 5. The loop moves to the next extent and calls
>    ocfs2_assure_trans_credits(handle) again (fs/ocfs2/aops.c:2334), now
>    on the handle whose h_transaction is NULL.
> 
> 6. ocfs2_assure_trans_credits() calls jbd2_handle_buffer_credits()
>    (fs/ocfs2/journal.c:476), which dereferences the NULL h_transaction.
>    This is the general protection fault syzbot reports.
> 
> The Proposed Fix
> 
> A failed transaction restart records the abort in the handle itself, as
> a NULL h_transaction. It is not threaded back through return values, so
> an intermediate caller that ignores the error, like
> ocfs2_try_to_merge_extent() above, does not lose the abort. Each user is
> instead expected to check the handle before touching it.
> 
> ocfs2 already does this. ocfs2_journal_dirty() (fs/ocfs2/journal.c:834)
> and ocfs2_update_inode_fsync_trans() (fs/ocfs2/journal.h:603) both test
> is_handle_aborted() before they read handle->h_transaction.
> 
> ocfs2_assure_trans_credits() is the one place that reads h_transaction,
> through jbd2_handle_buffer_credits(), without that check. The fix adds
> that check. is_handle_aborted() returns true when h_transaction is NULL,
> so the NULL dereference cannot happen. Returning the error makes
> ocfs2_dio_end_io_write() take its "goto commit" path and stop using the
> handle.
> 
>  fs/ocfs2/journal.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f9bf3bac085d..64a26da8eb28 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -473,8 +473,12 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
>   */
>  int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
>  {
> -	int old_nblks = jbd2_handle_buffer_credits(handle);
> +	int old_nblks;
>  
> +	if (is_handle_aborted(handle))
> +		return -EROFS;
> +
> +	old_nblks = jbd2_handle_buffer_credits(handle);
>  	trace_ocfs2_assure_trans_credits(old_nblks);
>  	if (old_nblks >= nblocks)
>  		return 0;

