Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7D35E1C3
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 May 2026 10:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049529; cv=none; b=PBMVNNoJv3xe5eHxepjkvWz1yMRnek/v2dD61Cobd96lV5I670T2701SM4S/PStY2JrUSeabb72E2oGQBCxc/K8buoIoPwXWSq+I1M7v6rs7GnpgLtuNv1/nPwp3Y+pOhUQ5hvruwQb0bPWX0QOfO5Ie5vUk2YnsA+IJEbvRxYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049529; c=relaxed/simple;
	bh=w/fPZc8VZYOg5IBXFIIIuw4jjGwRXjAGRosx1Obg8r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLYsvaqe2XyRqDu3CTapMiUX99z/taFmTOkpW7i6TtPVDyJbd4Q7hu/xXPQEi+Lcq7dfWQG+WYzgU3ez+6oyGQVaTmYv/jMkSkBSCP8MvtOX9m3ToojktRbYIJOq/KI9Z03iI8ao5GKpuGYdKjewKhtnr6dAzcJGPSfJ9Ir3XZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wHBX6tZv; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wHBX6tZv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780049523; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7fd2Y8Ql9k72hSwi04NGSL/jCuVf0ona1HA/C8TxvGE=;
	b=wHBX6tZvfr/0CrZhnEttFu5MR/cahmy4rFVg5eM4u/1DnGBR5bnL+RW+e26RY4rvWBNQQFpIZ6i36Zg2R4sB8Jmqbdl+XszeCGSsCDzm0wrIyAfD/xUhBoMH9CLdMNpO6kX1zxyDuN0c5/Bzh77I4VleDjNLZNwbqeTmnTsk9+k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3p0tiO_1780049522;
Received: from 30.221.145.52(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3p0tiO_1780049522 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 18:12:02 +0800
Message-ID: <0d12ccb1-72ce-4ee0-ad3d-fe7af5ba1ca4@linux.alibaba.com>
Date: Fri, 29 May 2026 18:12:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ocfs2: NULL osb->journal deref via ocfs2_checkpoint_inode
 on unmount
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: falemi@asu.edu, Tiffany Bao <tbao@asu.edu>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CA+0ovCjF9enBdtPGJ-b=ewXnZBV0QmjThaOrvhOx0KavCFft5Q@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CA+0ovCjF9enBdtPGJ-b=ewXnZBV0QmjThaOrvhOx0KavCFft5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/29/26 1:39 PM, Farhad Alemi wrote:
> Hello Joseph, Mark, Joel, and the ocfs2 team,
> 
> I am reporting a KASAN null-ptr-deref GPF in the ocfs2 unmount path
> found by syzkaller as part of research at the SEFCOM Lab at ASU.
> 
> Summary:
> During unmount, ocfs2_clear_inode() calls ocfs2_checkpoint_inode()
> without checking that osb->journal is still live. At
> fs/ocfs2/inode.c:1223-1224:
> 
>   if (!(oi->ip_flags & OCFS2_INODE_DELETED))
>           ocfs2_checkpoint_inode(inode);
> 
> ocfs2_checkpoint_inode() (fs/ocfs2/journal.h:192) reaches
> ocfs2_ci_fully_checkpointed() (fs/ocfs2/journal.h:91), which loads
> osb->journal and dereferences it:
> 
>   struct ocfs2_journal *journal =
>           OCFS2_SB(ocfs2_metadata_cache_get_super(ci))->journal;
>   spin_lock(&trans_inc_lock);
>   ret = time_after(journal->j_trans_id, ci->ci_last_trans);   <-- :98
> 
> On the unmount-side slot-info eviction, ocfs2_journal_shutdown() has
> already set osb->journal = NULL (fs/ocfs2/journal.c:1130) before
> ocfs2_delete_osb() evicts the slot inodes, so the journal->j_trans_id
> load at journal.h:98 faults. The KASAN range is [0x70, 0x77] (see
> crash-report.txt); the RIP chain is:
> 
>   ocfs2_ci_fully_checkpointed fs/ocfs2/journal.h:98 [inline]
>   ocfs2_checkpoint_inode fs/ocfs2/journal.h:199 [inline]
>   ocfs2_clear_inode fs/ocfs2/inode.c:1224 [inline]
>   ocfs2_evict_inode+0x244c/0x43c0 fs/ocfs2/inode.c:1303
> 
> Observed on:
> - Linux v7.1-rc3-200-g70eda68668d1-dirty,
>   x86_64, QEMU Q35
> - KASAN enabled
> - The only local dirty file in my tree is
>   drivers/tty/serial/serial_core.c, a ttyS0 console guard for the
>   fuzzing harness, unrelated to fs/ocfs2/.
> - Source inspection of linus/master at commit e8c2f9fdadee
>   (v7.1-rc4-754-ge8c2f9fdadee) shows the structure is unchanged:
>   ocfs2_clear_inode() at fs/ocfs2/inode.c:1223-1224 still calls
>   ocfs2_checkpoint_inode() with no osb->journal check, and
>   ocfs2_ci_fully_checkpointed() at fs/ocfs2/journal.h:98 still
>   dereferences journal->j_trans_id unconditionally. As no reproducer
>   is available for this seed, I have not re-run it against e8c2f9fdadee.
> 
> Impact:
> An ocfs2 unmount kills the kernel with a GPF / KASAN null-ptr-deref.
> The full Oops header, register dump, and call trace are in
> crash-report.txt.
> 
> Expected behavior:
> Either ocfs2_clear_inode() should skip ocfs2_checkpoint_inode() when
> osb->journal is NULL (the same shape as the existing guard at
> fs/ocfs2/inode.c:1286), or ocfs2_ci_fully_checkpointed() should treat
> a NULL journal as "fully checkpointed".
> 
> Reproducer:
> A standalone .syz or C reproducer was not produced for this seed; the
> crash fired during automated ocfs2 mount/unmount fuzzing. The console
> report is attached as crash-report.txt.
> 
> Novelty check:
> I searched the syzbot dashboard's upstream open, fixed, stable, and
> invalid (per-subsystem ocfs2) namespaces; the Android dashboard; the
> marc.info linux-fsdevel archive; and lore, for
> "ocfs2_ci_fully_checkpointed", "ocfs2_checkpoint_inode",
> "ocfs2_clear_inode" + journal, and "ocfs2_evict_inode" + GPF. I did
> not find a prior report of this specific dereference.
> 
> There are three closely related syzbot reports, all titled by the
> outer frame:
> "general protection fault in ocfs2_evict_inode" (id 9d4aa7d1...),
> "general protection fault in ocfs2_clear_inode" (id 9eca3ca3...),
> and "...ocfs2_clear_inode (2)" (id 9e34a0dc...). They share this
> unmount slot-info eviction reach path but fault at offset 0x8 of the
> NULL pointer (KASAN range [0x8, 0xf]); this crash faults at offset
> 0x70, inside ocfs2_ci_fully_checkpointed() at journal.h:98 (the
> journal->j_trans_id read) -- a distinct dereference site. Commit
> f46e8ef8bb7b ("ocfs2: prevent release journal inode after journal
> shutdown", first in v6.17-rc5) added an osb->journal guard before the
> jbd2_journal_release_jbd_inode() call at fs/ocfs2/inode.c:1286, but
> the earlier ocfs2_checkpoint_inode() call in the same
> ocfs2_clear_inode() is not guarded.
> 
> 
> I appreciate your time and consideration, and I'm grateful for your
> work on this subsystem. I'd be glad to test any candidate patches.
> 
A simple fix, please have a try:

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 6397170f302f..f8b3b2a3d630 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
        if (ocfs2_mount_local(osb))
                return;

+       if (!osb->journal)
+               return;
+
        if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
                /* WARNING: This only kicks off a single
                 * checkpoint. If someone races you and adds more

