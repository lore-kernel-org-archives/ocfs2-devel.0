Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916472C032C
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781189204; cv=none; b=F5bi5YW47j8KnUuCHBeoABZaiycOmbC0YXh6z3xG+lB/A8syoPA3PtVQUU9OBSD/ZVx7/UwpXmq6bMLVwKIFDQRxMu7XOjyNShMzDLgKzUVTNZgR1G2SA3Iv7FRhZcSp9RFh/XgyNcHv8nzYqlC1gQf7rG4rbpoj9y01SKLktsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781189204; c=relaxed/simple;
	bh=hmKnfMJxEbWiFPgNbECFHY/POyBsvUnTky/IYUR4UTg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Y065EN4r73P7pZvNN9sU3shllE4nA00/o877PwV96ibsXvQ5kqWNF/s4mVYMQhaMIP1F7Ltf9rZpsGnT75iNJcK/xQ5ISeYJ/B7g3MHbQQLGY6xp14nEzFQ39kMtr41LpnmM+WXZHFfyGWF4PBtx1azorBnw6OSrw/iB65/OBtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=WLD6An9k; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jA6/iY1t; arc=none smtp.client-ip=103.168.172.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="WLD6An9k";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jA6/iY1t"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id D96AF138073A;
	Thu, 11 Jun 2026 10:46:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 11 Jun 2026 10:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1781189201; x=1781192801; bh=gQiafm0XtIDt4mC43QdXxY+gxOveb46m
	9OZx7Diwu24=; b=WLD6An9kRU3R5d+6sMQjLF7L/COxZlRjxg2qKpim2GhKx1eD
	SKPT/tFuZ/Mm5SbSvGgeIRPtYvIg5bFOVXqQkrZ9a4ISFS/5Kh43w0DMEsgIFVkD
	RXPPkkBk+GJ3t+sYQYD1+ZnMNOvV057YNG8MlD+my8QDdJdIcLCTmb/B6QH9jdhw
	95mizhXTPYqor3x0dy2quXq6qdNwHXAwdpLsgIJVOrTMfcM7Bt7+10S/DcchD7jr
	YnJs5q0jp6bqmhODBv6RPZxmumpBFb+CwliJ7a+bfT/ODWYtzKMM9EqwpdLcfYNC
	wQXNpwnXMuoqPp4s85tcQIb2ETymCLq3m6xMDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781189201; x=
	1781192801; bh=gQiafm0XtIDt4mC43QdXxY+gxOveb46m9OZx7Diwu24=; b=j
	A6/iY1tKGzIaRwxSFZSVJK5tptyZqy0sEnG2sS+u/JkQBb+ANzz8mSXe0j58h4bR
	btCD/7XfiLe4JpxfMq17SWhPkewmTat4bKjZ2K54qm7LdSN3bFz9r/wtfhx5uCh7
	w8hvgwjIBnRGT8TZAuF9sEPF6uCPT4QIsiNMpiZD6cKRHLXS0cKTh3w8TayjYcyD
	d6kP/sHrSo1YZEprKMSP2APdAAfM5Nzc8a5jKM3z27DIPBfv5t9rDmJ+tM99PZXB
	cakrOyS/mfEq0sZ+3y+ZAwN0QzRtXRPDAdbmECdc2tCb2sFDJ3FdKTKwaoZF1WrU
	sFiU4PTYrbUNQIvIgS2Xg==
X-ME-Sender: <xms:UcoqagSLnIgw8uKFxQ349GO0cKgkis8WySavM18ClxOISSfzuBdt9g>
    <xme:UcoqamsiOXM9erTTBcbaNRsbxQAN2ghbi-2shBMkXoPBu8wDWDGZ5pao_53vYH23c
    Tw8srNEK7ci8_be9GcYjpSUArvX_2hrL5uzXakjRZeSnFicXiZWhO0>
X-ME-Received: <xmr:UcoqapYRHT9aZWl69qBWFLqqjRh7DRMEl3Tvqo-mni1UdxCMyT3F1N1Xq0M>
X-ME-Proxy-Cause: dmFkZTGQ4d5FkQw+j1UwUCbSCKzPpYSC0KmG7ybDhK3O9UeRNrSgQxbrBkZe6fIh+XGa2v
    r4iq+DQ9Nu8N8G48lmxv3SDxbsnMpCsVMBKhGr7Yh3jhux2Cz5fpBw4XgI2a/jl5T7QCm2
    SOE+Drvx0D58Re3qWhydPB1kXoQ6zbka9zuvNHpQQ/ZtifYRK84f24a/a32u+Zf2700FWp
    ztqV0PS7X8BtuWdNrz8uEGYDETkgCLcriInPYSkNqXoznND9GKGcNmPr9aJielj96Yv+cy
    z7aekV1B8KfFVNJ4eJwjSeXxFdTqktn0cIIb4/SOS176J4U/jPsUuBIptfedsYbdF5RokL
    +qx31nApZxphtwP6CS862SeQpS1raM9dXtJ5BH/GpAQiNgqx6g7Ku7faF24qEIoi0pI94z
    /7DCK+VTKAfzY5DSCPS0PmG0nLkRK9XFoFYKcqicE6Q8S+ENTEB2XTwgkto7q3Xa2yJfFK
    IDQ+xusBx087Scy8HCcEXF8jbe290xXbROZ+HGNus7VwcEcFPg6FJcUSqzDgBMSB7KlIPD
    jPzLnihieDanwocB2tsJ2V3AkmgkZG4q5hcYTKE/u5Bgy/d2d1jQgLZZy9Ga+TwjpnApcd
    cfl6uuAtoyOrj/Si51EIUUmWEmUqiDfSa+LVuX2Z8RAPpNPEE0kqOr084i8g
X-ME-Proxy: <xmx:UcoqakGC5j4M9Ci2r-x0hjxHDXB7to6x_31QCWz7AHy51DJMG3P5wA>
    <xmx:Ucoqalw225tcWbrbxo2cyYvFgJXa0DRSIPwWLdNU1vFbj7fZPESMcA>
    <xmx:Ucoqauk86hesXGhTHy0KiIIBWH08MK-VogJfvXKkhpsjnr1rGDBI6w>
    <xmx:UcoqamkUtzzozTRwzQBv64zVnTzqfJQuGMc0sfJ_8VdsW-JsvoikAQ>
    <xmx:Ucoqas_1dU11Ed3SCpHN2QaL7LirmhVqErlP0cWA7-QXFaVsQgaV1SOt>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Jun 2026 10:46:40 -0400 (EDT)
Date: Thu, 11 Jun 2026 09:46:38 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix NULL h_transaction deref in
 ocfs2_assure_trans_credits
Message-ID: <airKTsM1fRVN-Wj7@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[BUG]
A direct write over unwritten extents can panic the kernel in
ocfs2_assure_trans_credits() when the journal aborts during DIO
completion. The crash is a general protection fault from a NULL pointer
dereference.

[CAUSE]
ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
marking each written under a single journal handle. If the journal
aborts (for example after an I/O error) while the extent tree is being
updated, the handle is left aborted with its transaction pointer
cleared. The extent merge treats that failure as not critical and
reports success, so the loop keeps using the handle.
ocfs2_assure_trans_credits() reads the handle's remaining credits
without first checking whether the handle is aborted, and that read
dereferences the cleared transaction pointer.

[FIX]
A journal abort is recorded in the handle itself, so callers are
expected to test the handle rather than rely on a returned error.
Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
helpers already do, and return -EROFS when the handle is aborted.

Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
This patch contains a proposed fix for a crash reported by syzbot
in ocfs2_assure_trans_credits().

The file names and offsets in this description are from commit
7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

I also have a small test harness that reproduces the original panic,
which I can make available as well.

The Bug

OCFS2 supports unwritten extents. These are ranges that fallocate()
has allocated on disk but flagged as holding no data, so reads return
zeros until the range is written. Clearing that flag is a journalled
metadata change. For a direct write, OCFS2 makes that change when the
write completes rather than when the write is submitted.

When a direct write to unwritten extents completes, ocfs2_dio_end_io()
(fs/ocfs2/aops.c:2401) calls ocfs2_dio_end_io_write()
(fs/ocfs2/aops.c:2266). That function opens one jbd2 handle and loops
over the extents the write covered (fs/ocfs2/aops.c:2319). For each one
it calls ocfs2_assure_trans_credits() (fs/ocfs2/aops.c:2334) and then
ocfs2_mark_extent_written() (fs/ocfs2/aops.c:2339). The same handle is
reused on each pass.

ocfs2_assure_trans_credits() (fs/ocfs2/journal.c:474) makes sure the
handle still has enough journal credits for the next extent operation.
Its first action is:

    int old_nblks = jbd2_handle_buffer_credits(handle);

jbd2_handle_buffer_credits() (include/linux/jbd2.h:1817) is an inline
accessor that reads handle->h_transaction->t_journal without a NULL
check. t_journal is at offset 0 of struct transaction_s, so a NULL
h_transaction makes this a read of address 0.

A handle's h_transaction is set to NULL when a transaction restart
fails. The bug is that ocfs2_dio_end_io_write() can keep using such a
handle. The sequence is:

1. ocfs2_mark_extent_written() reaches ocfs2_try_to_merge_extent()
   through ocfs2_change_extent_flag() and ocfs2_split_extent(). When the
   marked extent merges with a neighbor (ctxt->c_split_covers_rec,
   fs/ocfs2/alloc.c:3820), the merge reserves rotation credits with
   ocfs2_extend_rotate_transaction() (fs/ocfs2/alloc.c:3822), which calls
   ocfs2_extend_trans() (fs/ocfs2/journal.c:428).

2. ocfs2_extend_trans() cannot grow the running transaction, so it
   restarts the handle with jbd2_journal_restart()
   (fs/ocfs2/journal.c:454).

3. jbd2__journal_restart() (fs/jbd2/transaction.c) sets
   handle->h_transaction to NULL, then calls start_this_handle() to
   attach a new transaction. If the journal has aborted,
   start_this_handle() returns an error (fs/jbd2/transaction.c:366) and
   h_transaction stays NULL.

4. The error reaches ocfs2_try_to_merge_extent(), which ignores it.
   At fs/ocfs2/alloc.c:3827 it resets ret to 0 and returns success, so
   the loop does not stop.

5. The loop moves to the next extent and calls
   ocfs2_assure_trans_credits(handle) again (fs/ocfs2/aops.c:2334), now
   on the handle whose h_transaction is NULL.

6. ocfs2_assure_trans_credits() calls jbd2_handle_buffer_credits()
   (fs/ocfs2/journal.c:476), which dereferences the NULL h_transaction.
   This is the general protection fault syzbot reports.

The Proposed Fix

A failed transaction restart records the abort in the handle itself, as
a NULL h_transaction. It is not threaded back through return values, so
an intermediate caller that ignores the error, like
ocfs2_try_to_merge_extent() above, does not lose the abort. Each user is
instead expected to check the handle before touching it.

ocfs2 already does this. ocfs2_journal_dirty() (fs/ocfs2/journal.c:834)
and ocfs2_update_inode_fsync_trans() (fs/ocfs2/journal.h:603) both test
is_handle_aborted() before they read handle->h_transaction.

ocfs2_assure_trans_credits() is the one place that reads h_transaction,
through jbd2_handle_buffer_credits(), without that check. The fix adds
that check. is_handle_aborted() returns true when h_transaction is NULL,
so the NULL dereference cannot happen. Returning the error makes
ocfs2_dio_end_io_write() take its "goto commit" path and stop using the
handle.

 fs/ocfs2/journal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9bf3bac085d..64a26da8eb28 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -473,8 +473,12 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
  */
 int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
 {
-	int old_nblks = jbd2_handle_buffer_credits(handle);
+	int old_nblks;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
+	old_nblks = jbd2_handle_buffer_credits(handle);
 	trace_ocfs2_assure_trans_credits(old_nblks);
 	if (old_nblks >= nblocks)
 		return 0;
-- 
2.47.3

