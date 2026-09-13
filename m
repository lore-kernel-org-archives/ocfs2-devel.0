Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B5C377EDC
	for <ocfs2-devel@lists.linux.dev>; Sun, 13 Sep 2026 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789309712; cv=pass; b=AeH1VDRBeag38THWviDB3B4zaKRgxLuy6o5BTNDvPAweOfGzWn8kKIC4tpE51J1WXoJLxvFZNtCH5a6SUd/2S/PifCz0+Y1TMhrD0onj+pRgaIcNV5D+0xvXINm1igb5cWt0k7cHEcbk53sr566pLYbFMOipR7kTGbbnioG6/WA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789309712; c=relaxed/simple;
	bh=kIP/NSc+NG49XnW2lRINixurcituYfURHS9tdp58HYU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hf4IVJ4ExJjJOdmoyzjt9dFB3uAbrH1lWNKux0oaVKRlKjwtTlItYJxyJExE+EKZCgAnU1Yy3jKJPL5CLWaGcyGFRrDUGnA+yNiQ80qmI/zda3kDUojPUD1f+d9EfpIcA44OxjYpSZDfhKxBDxka66cksb1k/fp+fSuMNTmX5SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S2bjNoes; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2bjNoes"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c29667ed561so299526966b.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Sep 2026 07:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789309709; cv=none;
        d=google.com; s=arc-20260327;
        b=ZrvHExrSFVW0jXlh+Uk03zqifXUtjDmoUjYr2J37MUZtXio2Nl8xPj/sM+EDbXh5ZD
         QKYRmAtx4+tTRvENbDKn9A19JOYAlO6KzjUGmagfUtV9Qn7MoZJ0elGGH1+ePu/QeJDc
         EJ3MsdtirGRAwoIugqfSo7A9D0qbF7uNPdoM4TCeR0Q2pgSIEgGAPnY2hD6/K/baFZzP
         mwUATWYwUuNmt7r8QfQps+qGaDQp+/JpEwHmZ5C/7IGJBSZ+rNs4d+b4PKcR+XeSQhcX
         jCWKKDb3wtl7gfNNZAInFNSkv+i4F9hTiu1zpUxV4YNe1kNct2MDyPYbyMnfNi3PC88j
         Gxuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=7trDYjh2yt11cs0oE8ruC/twVqcjXd8qaoj0XJ827QE=;
        fh=fPohftG5U4fH5YRpeihqKvK9g58DbGyh/A7E0oVl+DE=;
        b=FFs+AK0QmAmvZtkrD3wEnUhtwG6wDRMpDCTk+hi3rZ9+UOLpNyzcwbvl64NmZ5Lo98
         /702xS/yTu6u4vBwmUbAFpOGSyJT92V0CvjJokIZMXtL/qPPl1FfZzyOd1UfK5eAl/dZ
         nXf305Yifd45MFIsmUJ0Ps4FbPjV16+GQzBAepIRMrO01ZfhsRW1qvAEBZz62lwFh2dj
         NpRJrGcpVMyJWyxMbqzho0pC2ZTq7YUk5neAg9hTgiLNuAPpH+BBu/79DdZl8uofB80f
         TqJbbfFPqLXa6o35oq2Z6mtuQkc2IGhY/QMklh0sP0TJ+GEiYtmrFPFA4oObSlxIbDSF
         1nig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789309709; x=1789914509; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7trDYjh2yt11cs0oE8ruC/twVqcjXd8qaoj0XJ827QE=;
        b=S2bjNoespsmHlpOfgMXnBxvkvjSK33aLGGAHKDtzkzHDhxog4k7o3qiW1lAAh/Sv8J
         4SWWl2LjcGVsL3rCjS7A4pTGgaPfqkZFmz1Q0Y5/7nXDDdBzIUyUU82R1czbQ4f0XAvj
         a8quYZZJe0F2NIJ9VvXxYhOKNZlU6SzW2ADajPrjboBqwQdc6kUnoEL0T9uc2YDxf3Du
         1Qlijfu1gKL6QL3VoL/dpdcmETryM568bYeje/Mu8w3AUXZVnMr2kVwgoJgs3pr2M5z7
         L/zrwqIP/k0gYFAalsQiJukKqr1uByoucIEDO5phVA5l8NpIPa8FPerYfzoN/4RWWSqM
         W1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789309709; x=1789914509;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7trDYjh2yt11cs0oE8ruC/twVqcjXd8qaoj0XJ827QE=;
        b=HhFLP/N48pve9n49baEz3qRFlQaLcnv8LDxv9TCAfGVrZ3w/vDmKuCzharf5tLn2YF
         giQLfEPfLdqWzwwx4AP6BwrBZmq25jKjg4P1X8KthdCrKyyroOlOYrmPlLiNc3L0wa9X
         GgLSIzQ9jSRP/iR+ocncigV1B4Z27mE+RJNjFw3AtLCYCSi+EYmMF+qKxn3ruxOeL/Dh
         sSNg+w1LA4xr54cflCw6Vc5w6bnkoEBRRuM4faMz/376OB9n9WbfUYCu6SwGhKE5v3Lp
         2g105cB/i9LUdIR38RdQuSvRHZxVTmMFw7fLiS0OgElWmUFG80nH3xKsV7c6z7EJZbJK
         mt+g==
X-Forwarded-Encrypted: i=1; AKwUvBySpYPIUxcAQer1RReLZFsIgIOJvO/LcC2cp59nYM0/RRBiiwZ6vewC5OoDM6J811c1YIaz+EpkC2BJ2w==@lists.linux.dev
X-Gm-Message-State: AFuF++ki0+eNnJ5bRcc6KXtRV3ePe1nnbKn4ndOGsSnQpaLav2KqAtIy
	3pfkfeJ/iz9Kt2ZDQ8v2Zkqx7JNQQOg2Aw1/oUN9V//aj4y2dWc8zMK4xg4LuAFQi8ArdNtPICi
	+XCYp4KGsgRG6I92XVVyHLPTZRByISFY=
X-Gm-Gg: AYBFou0SMSJn2qRtbVJrkcTHtKKMMsmXd+rb7bj2Xc9NSdgMyNNWLvNR8FIe6njfp5M
	C+UnS+RZso9qtDSi4IQU13/+bnvri5lfDmzjL8q+f/Dn0F8ysEnBVFyWkIYiQK3DI5nG6b0QJk1
	yJpJNIqGfDitIlJ1dlBqCUgGItjtKAekNqYR51SVVUunCJlE5TxfAnfgeXH6abpkL35eGGXc34v
	bMMoRY/v7G1VtJr6C23JO2nSsqfMLn5cqyF99cXizPyh2icnAM7LwdOPXX0ldKm/Dz1+q1YxZo0
	UipdQglDqNO10brqL6TOHa33P2dQZ5d3y7otMGMjyer5Tjodyi3oxiUS
X-Received: by 2002:a17:907:d11:b0:c26:19de:9aea with SMTP id
 a640c23a62f3a-c2966713402mr589875466b.41.1789309708478; Sun, 13 Sep 2026
 07:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sun, 13 Sep 2026 22:27:49 +0800
X-Gm-Features: AcwNN1Uxew88DlzjKA8nEKsYeSnPIAeHERYOSbNvvu8LNi-jNKqOsNY36mliCUM
Message-ID: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
Subject: [Linux Kernel Bug] KASAN: use-after-free Write in ocfs2_local_release_dquot
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, syzkaller@googlegroups.com, 
	r772577952@gmail.com
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We are writing to report an issue discovered in the OCFS2 subsystem.  The
issue is reproducible on the latest version of linux (v7.3-rc2, commit
df2908090cda368b01ff43709f51890076c56157).  Below is the kernel report:

==================================================================
BUG: KASAN: use-after-free in instrument_write
include/linux/instrumented.h:41 [inline]
BUG: KASAN: use-after-free in ___clear_bit
include/asm-generic/bitops/instrumented-non-atomic.h:44 [inline]
BUG: KASAN: use-after-free in __clear_bit_le
include/asm-generic/bitops/le.h:41 [inline]
BUG: KASAN: use-after-free in _ocfs2_clear_bit fs/ocfs2/ocfs2.h:936 [inline]
BUG: KASAN: use-after-free in ocfs2_clear_bit_unaligned
fs/ocfs2/ocfs2.h:967 [inline]
BUG: KASAN: use-after-free in ocfs2_local_release_dquot+0x44c/0x6a0
fs/ocfs2/quota_local.c:1298
Write of size 8 at addr ffff8880569ef400 by task kworker/u10:1/37

CPU: 1 UID: 0 PID: 37 Comm: kworker/u10:1 Not tainted 7.3.0-rc2 #47
PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: quota_events_unbound quota_release_workfn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10e/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x153/0x7e0 mm/kasan/report.c:482
 kasan_report+0x147/0x180 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_write include/linux/instrumented.h:41 [inline]
 ___clear_bit include/asm-generic/bitops/instrumented-non-atomic.h:44 [inline]
 __clear_bit_le include/asm-generic/bitops/le.h:41 [inline]
 _ocfs2_clear_bit fs/ocfs2/ocfs2.h:936 [inline]
 ocfs2_clear_bit_unaligned fs/ocfs2/ocfs2.h:967 [inline]
 ocfs2_local_release_dquot+0x44c/0x6a0 fs/ocfs2/quota_local.c:1298
 ocfs2_release_dquot+0x626/0xc70 fs/ocfs2/quota_global.c:793
 quota_release_workfn+0x35f/0x610 fs/quota/dquot.c:867
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc85/0x18f0 kernel/workqueue.c:3479
 worker_thread+0x8a3/0xda0 kernel/workqueue.c:3560
 kthread+0x38c/0x480 kernel/kthread.c:436
 ret_from_fork+0x509/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x569ef
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea00015a7bc8 ffffea00015a7bc8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffff8880569ef300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880569ef380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880569ef400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff8880569ef480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880569ef500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================

Following is the root cause analysis for this issue, note that the
analysis is performed with the assistance of LLM, but we try our best to
ensure the accuracy.

When ocfs2 releases a quota structure, it clears the structure's bit in the
bitmap of the local quota file chunk that holds it, and the position of
that bit is computed from the chunk's number.  A bogus chunk number can
push that position far outside the bitmap, so the write lands on unrelated
memory.

The chunk number is wrong because ocfs2_local_quota_add_chunk() appends the
new chunk to the list first, and then numbers it one past the entry before
it:

list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
chunk->qc_num = list_entry(chunk->qc_chunk.prev,
  struct ocfs2_quota_chunk,
  qc_chunk)->qc_num + 1;

If the list was empty, the entry before it is the list head itself.  The
head is a member of struct ocfs2_mem_dqinfo, not a chunk, so the "previous
number" it reads is part of the dqi_gqinode pointer stored next to the
head.  A crafted image gets a first chunk numbered with part of a kernel
pointer instead of 0.

ol_dqblk_off() turns the chunk number into a file offset by shifting a
32-bit block number left by the block size bits, and a block number built
from such a large chunk number loses its top bits there.  When the entry is
released, the offset is converted back into a bit position using the full
chunk number, so the lost bits push that position far outside the chunk,
and clearing it corrupts unrelated memory.  Depending on where the write
lands, testing also triggered the following reports:

- BUG: unable to handle kernel paging request in ocfs2_local_release_dquot
- KASAN: slab-out-of-bounds Write in ocfs2_local_release_dquot
- KASAN: slab-use-after-free Write in ocfs2_local_release_dquot
- KFENCE: use-after-free write in ocfs2_local_release_dquot

To fix this issue, the chunk number should be computed before the chunk is
added to the list, and set to 0 when the list is empty:

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..d351cda9211f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk
*ocfs2_local_quota_add_chunk(
  goto out;
  }

+ if (list_empty(&oinfo->dqi_chunk))
+ chunk->qc_num = 0;
+ else
+ chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
+   struct ocfs2_quota_chunk,
+   qc_chunk)->qc_num + 1;
  list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
- chunk->qc_num = list_entry(chunk->qc_chunk.prev,
-   struct ocfs2_quota_chunk,
-   qc_chunk)->qc_num + 1;
  chunk->qc_headerbh = bh;
  *offset = 0;
  return chunk;

After applying the patch, the reproducer no longer triggers the issue on
our machine.  If this solution is acceptable, we are happy to submit a
formal patch.

The kernel console output, kernel config, syzkaller reproducer, and C
reproducer are available at google drive:
https://drive.google.com/drive/folders/1-LzPTgOALEc3eOjmgM6oOfRKkYXJ-bnO?usp=drive_link

Please let us know if any further information is required.

Best Regards,
Jiaming Zhang
