Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71A436A377
	for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781352993; cv=none; b=M6lgwhjx8HcGw4INn+hnrQNU8UFrzE407zinAGJcTb/fhWfnFsddN2v/VAF24rGmsSNc7MsNJubSAfwm3HRBAnB8IB0UI/Du8K4wLfD9F2y0vq1d5UWHYsUmaAuf90BNjOgCOR54YE+f2FxXwBI5L/YRlXJVIbDJjgGXjxDHVfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781352993; c=relaxed/simple;
	bh=WMDqXV0y9nOqsd9GMM+If73rP/cJli2bQAOMsVGLoFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGYr6ossNm9pbSDvmGqfVvuFj6KF8uLDgp8geIAmvwIOlUNXGqkiM7LSYYA08XFJuRq9KOS1G1jZt9FrLeISLu4uafi9JeQNSqAm0YQxH/9mHDzZfdwCB/+eaS0MgA6LUHZL8/F4uc01aW/DOZ+do5Mtfdm3K07Zz0DcD9EFBKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=Ecsu5/LY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iqZLWMJB; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="Ecsu5/LY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iqZLWMJB"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id EAF6213800A7;
	Sat, 13 Jun 2026 08:16:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Sat, 13 Jun 2026 08:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1781352989; x=1781356589; bh=YQpprGmUnH
	raOsF/RH0vVaj2Kf9OjMkpR8KNxTK7RnE=; b=Ecsu5/LYEl7yw0lsB1LmEdMAGj
	3FlOhCWlNRFGz5W2e3jVZgRS56OY3ZpaLtjsccq4Glg2zLxog6O3TPkEl6H+hScl
	McBqUgJOhVTf6D6DOlQ996c0ZxMiGFst6LUsp7voCvEfiYNV/uU6aum2gBHpe7sd
	z/XsXdl/AnxxOwASqRlS80JDxXwl8wISDVKQSO8Momn876Xbrl/CoUWeZgHExEe5
	4QeX0yhRu85fiIRh8olUfCjS1muV6/m/mWXEolUr29detUJDxN6WLPAfOJujtt7m
	4JaFiEkytYEBvFtmZQbE/5itFoafizmOYlwQMiUVpLc/qyAHfBI7g3lgBtyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781352989; x=1781356589; bh=YQpprGmUnHraOsF/RH0vVaj2Kf9OjMkpR8K
	NxTK7RnE=; b=iqZLWMJBE+q6+lkBBRpKjMX2+gbDB9Zl5xZyIWWVY7gneMBX6IA
	FeindRrGhSC5yYdXRzwOXikjv5U2bppyWPYEA6MTea+G9vY8iWmp/EwmE8bI183Z
	NsDzZr0pZBrvU0Bh7TaweegDwZVFklgfIk13r3lMAIGL3eWomhI/hbvx0zPzADJD
	RX1SGIHGaEpOvBfdA78T1Zuv6CKGaTuYJGUBVyjWJcDHLrN4eObvH85zN3OpRtvw
	bzhS8TaIrZ6aKL/zQZMI2hGrG3f9raYmvh1c1nr63kzVn7LOJVuy3jzF5kjOHySH
	dMQRke0emeoPcIYLxm3w0kYbS081uLGnZDQ==
X-ME-Sender: <xms:HEotamQ4uHyPpyzxWK1GiXi10DarxAh5a2zyTyaFd_iig27PIyODnw>
    <xme:HEotamv5eeARYP1ZdrIHdZTVvuT8gAFMkFdMdFLmTh_7wmhwXYuBeA-Srm_xV1zH5
    mwpwW4njHqFUFkerVcm0qkJtfu9BhOIZleqzlfsXPLYy3vu-Lb6Cw>
X-ME-Received: <xmr:HEotai3LsfD8nUvP_lzgftEIhZEMNiicuTDGyKAjgqrk_-cPloHgqvNG378>
X-ME-Proxy-Cause: dmFkZTGQrz5w4w2DQhIcdP/q9qpX3+tXgBT0GgUzIhZL5CKu+fWVBXO/4kFMuBMqLV75k5
    yqRgrw1jzGEaeQwrPP/sPR6Hea+Cjqn5gJKnpZLGQKCw/8yEz4O+yY6dUI9uMy4PnaLIuH
    GP9fnwaeTOkXe/W9ed5/1rLJMVsDmcJgQUF2y5j3bSosd87ht1vV8JryPw8TgZx7+QBZqL
    ihjnZAeE9N6CwBqx0zKcNXSqeRnQ9DD8mykpImuOhwJfZlFqP7pRJxdhwEc9Ns5p9coUqQ
    /4oH7WkbEVeuV+1iJKJtwKstodYya+FNe3jHr9yasYvnuVTK6Z2RPPWLmGbgfFEFwoyXR4
    etc1gL0UotlKLqFsURrvuoW55WGqcb9oXKouf69OVFs9PGz0Mp2vxcxrdaGTwqGMQGx5/s
    kVH+LfL7Q8RKaHXoWK8r9YeZZkW4OjXQipULwFvmBAxy6phBrZFv3n9N+OmrUWUCfYXDSU
    eXpHfRpuHnMKSsAU/f1xHWQuYvzmlDzXUorVZ0U3AWKaCsQcsFxc3+RN+ck3HTomgVBco6
    CdepJYEoyVTUHnbNx5Dvaky79TlgI1e1DeRZn2MG4UyvJ4Dj/ZhNV+Y5PFk62T5zjaPQfk
    3ilricOpobRJs0NEN5FIVtdvTEVWJNBsLJgeMe8QYFLO9VjadpGS/mTMo2Vw
X-ME-Proxy: <xmx:HUotanX0h4qqjM9M4e2ki9BRdCHnQoYq3O14T5pcXC9ZDLd64Ci1Aw>
    <xmx:HUotatIPpN6dMlE8HZyyYMhZ55yww5OniM1KVi1YZzD3lyZHVbsn5Q>
    <xmx:HUotap3WWHLPIgBoGqbtBhbD06Bn12mareXK3nqUMF-iGeR08IC1Ig>
    <xmx:HUotaj5DFccSaR-0zrUUcyEdnc2AlXU1HZm09V59vHJCvkwO9jh-Dg>
    <xmx:HUotajhzYaljvS7kHO28-8i1quHvxQQTfvxEhqWEV7kjQ91Lu7VZY2gi>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Jun 2026 08:16:28 -0400 (EDT)
Date: Sat, 13 Jun 2026 07:16:26 -0500
From: Ian Bridges <icb@fastmail.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: fix NULL h_transaction deref in
 ocfs2_assure_trans_credits
Message-ID: <ai1KGobnHDtU2x_4@dev>
References: <airKTsM1fRVN-Wj7@dev>
 <dd6f703a-9877-468f-9a02-886e59770e25@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6f703a-9877-468f-9a02-886e59770e25@linux.alibaba.com>

On Fri, Jun 12, 2026 at 09:19:31AM +0800, Joseph Qi wrote:
> 
> 
> On 6/11/26 10:46 PM, Ian Bridges wrote:
> > [BUG]
> > A direct write over unwritten extents can panic the kernel in
> > ocfs2_assure_trans_credits() when the journal aborts during DIO
> > completion. The crash is a general protection fault from a NULL pointer
> > dereference.
> > 
> > [CAUSE]
> > ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
> > marking each written under a single journal handle. If the journal
> > aborts (for example after an I/O error) while the extent tree is being
> > updated, the handle is left aborted with its transaction pointer
> > cleared. The extent merge treats that failure as not critical and
> > reports success, so the loop keeps using the handle.
> > ocfs2_assure_trans_credits() reads the handle's remaining credits
> > without first checking whether the handle is aborted, and that read
> > dereferences the cleared transaction pointer.
> > 
> > [FIX]
> > A journal abort is recorded in the handle itself, so callers are
> > expected to test the handle rather than rely on a returned error.
> > Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
> > helpers already do, and return -EROFS when the handle is aborted.
> > 
> > Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
> 
> It seems this is introduced by commit d647c5b2fbf8 ("ocfs2: split
> transactions in dio completion to avoid credit exhaustion")?
> 
> Thanks,
> Joseph

The pattern of the bug appears present in the commit before d647c5b2fbf8.
(510a75028707).

The loop reuses one handle for every extent (fs/ocfs2/aops.c):

    handle = ocfs2_start_trans(osb, credits);
    ...
    list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
        ret = ocfs2_assure_trans_credits(handle, credits);
        ...
        ret = ocfs2_mark_extent_written(inode, &et, handle, ...);
        ...
    }

ocfs2_mark_extent_written() reaches a restart that sets h_transaction
to NULL. jbd2__journal_restart() (fs/jbd2/transaction.c) leaves it NULL
when start_this_handle() fails on an aborted journal:

    stop_this_handle(handle);
    handle->h_transaction = NULL;
    ...
    ret = start_this_handle(journal, handle, gfp_mask);

ocfs2_extend_trans() (fs/ocfs2/journal.c) is what reaches that restart:

    status = jbd2_journal_extend(handle, nblocks, 0);
    ...
    if (status > 0) {
        ...
        status = jbd2_journal_restart(handle, ...);
        ...
    }

ocfs2_try_to_merge_extent() (fs/ocfs2/alloc.c) calls ocfs2_extend_trans()
through ocfs2_extend_rotate_transaction() and swallows its error, so
ocfs2_mark_extent_written() returns success with h_transaction left NULL:

    if (ctxt->c_split_covers_rec) {
        ret = ocfs2_extend_rotate_transaction(handle, 0,
                jbd2_handle_buffer_credits(handle), path);
        if (ret) {
            mlog_errno(ret);
            ret = 0;
            goto out;
        }
        ...
    }

The next ocfs2_assure_trans_credits() call in the loop then reads that
NULL h_transaction and faults.

Ian

> 
> > Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ian Bridges <icb@fastmail.org>
> > ---
> > This patch contains a proposed fix for a crash reported by syzbot
> > in ocfs2_assure_trans_credits().
> > 
> > The file names and offsets in this description are from commit
> > 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> > 
> > I also have a small test harness that reproduces the original panic,
> > which I can make available as well.
> > 
> > The Bug
> > 
> > OCFS2 supports unwritten extents. These are ranges that fallocate()
> > has allocated on disk but flagged as holding no data, so reads return
> > zeros until the range is written. Clearing that flag is a journalled
> > metadata change. For a direct write, OCFS2 makes that change when the
> > write completes rather than when the write is submitted.
> > 
> > When a direct write to unwritten extents completes, ocfs2_dio_end_io()
> > (fs/ocfs2/aops.c:2401) calls ocfs2_dio_end_io_write()
> > (fs/ocfs2/aops.c:2266). That function opens one jbd2 handle and loops
> > over the extents the write covered (fs/ocfs2/aops.c:2319). For each one
> > it calls ocfs2_assure_trans_credits() (fs/ocfs2/aops.c:2334) and then
> > ocfs2_mark_extent_written() (fs/ocfs2/aops.c:2339). The same handle is
> > reused on each pass.
> > 
> > ocfs2_assure_trans_credits() (fs/ocfs2/journal.c:474) makes sure the
> > handle still has enough journal credits for the next extent operation.
> > Its first action is:
> > 
> >     int old_nblks = jbd2_handle_buffer_credits(handle);
> > 
> > jbd2_handle_buffer_credits() (include/linux/jbd2.h:1817) is an inline
> > accessor that reads handle->h_transaction->t_journal without a NULL
> > check. t_journal is at offset 0 of struct transaction_s, so a NULL
> > h_transaction makes this a read of address 0.
> > 
> > A handle's h_transaction is set to NULL when a transaction restart
> > fails. The bug is that ocfs2_dio_end_io_write() can keep using such a
> > handle. The sequence is:
> > 
> > 1. ocfs2_mark_extent_written() reaches ocfs2_try_to_merge_extent()
> >    through ocfs2_change_extent_flag() and ocfs2_split_extent(). When the
> >    marked extent merges with a neighbor (ctxt->c_split_covers_rec,
> >    fs/ocfs2/alloc.c:3820), the merge reserves rotation credits with
> >    ocfs2_extend_rotate_transaction() (fs/ocfs2/alloc.c:3822), which calls
> >    ocfs2_extend_trans() (fs/ocfs2/journal.c:428).
> > 
> > 2. ocfs2_extend_trans() cannot grow the running transaction, so it
> >    restarts the handle with jbd2_journal_restart()
> >    (fs/ocfs2/journal.c:454).
> > 
> > 3. jbd2__journal_restart() (fs/jbd2/transaction.c) sets
> >    handle->h_transaction to NULL, then calls start_this_handle() to
> >    attach a new transaction. If the journal has aborted,
> >    start_this_handle() returns an error (fs/jbd2/transaction.c:366) and
> >    h_transaction stays NULL.
> > 
> > 4. The error reaches ocfs2_try_to_merge_extent(), which ignores it.
> >    At fs/ocfs2/alloc.c:3827 it resets ret to 0 and returns success, so
> >    the loop does not stop.
> > 
> > 5. The loop moves to the next extent and calls
> >    ocfs2_assure_trans_credits(handle) again (fs/ocfs2/aops.c:2334), now
> >    on the handle whose h_transaction is NULL.
> > 
> > 6. ocfs2_assure_trans_credits() calls jbd2_handle_buffer_credits()
> >    (fs/ocfs2/journal.c:476), which dereferences the NULL h_transaction.
> >    This is the general protection fault syzbot reports.
> > 
> > The Proposed Fix
> > 
> > A failed transaction restart records the abort in the handle itself, as
> > a NULL h_transaction. It is not threaded back through return values, so
> > an intermediate caller that ignores the error, like
> > ocfs2_try_to_merge_extent() above, does not lose the abort. Each user is
> > instead expected to check the handle before touching it.
> > 
> > ocfs2 already does this. ocfs2_journal_dirty() (fs/ocfs2/journal.c:834)
> > and ocfs2_update_inode_fsync_trans() (fs/ocfs2/journal.h:603) both test
> > is_handle_aborted() before they read handle->h_transaction.
> > 
> > ocfs2_assure_trans_credits() is the one place that reads h_transaction,
> > through jbd2_handle_buffer_credits(), without that check. The fix adds
> > that check. is_handle_aborted() returns true when h_transaction is NULL,
> > so the NULL dereference cannot happen. Returning the error makes
> > ocfs2_dio_end_io_write() take its "goto commit" path and stop using the
> > handle.
> > 
> >  fs/ocfs2/journal.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index f9bf3bac085d..64a26da8eb28 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -473,8 +473,12 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
> >   */
> >  int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
> >  {
> > -	int old_nblks = jbd2_handle_buffer_credits(handle);
> > +	int old_nblks;
> >  
> > +	if (is_handle_aborted(handle))
> > +		return -EROFS;
> > +
> > +	old_nblks = jbd2_handle_buffer_credits(handle);
> >  	trace_ocfs2_assure_trans_credits(old_nblks);
> >  	if (old_nblks >= nblocks)
> >  		return 0;
> 
