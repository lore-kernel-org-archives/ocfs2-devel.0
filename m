Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ACC51C059
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074015; cv=pass; b=Da4XCxet/Wn13/VyYaQMtA3g5Mh4iM+Q1S7gvHmdx9VI2JJLDWdnMEall3LUCvfKj2dy9d3xd/0bYNNj/PxnErjCI9EUvgBdRaOkde4uXRgPAcZe5q7pmtsSio6kn9CP0Gx9i6THrqdERObb+o1cGHgepMLG/eG8ViAR1CcvTWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074015; c=relaxed/simple;
	bh=5q68nD75mUwwpPx78vqnUM4U6C+IpjBmz1+55T3EIzs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QsNJeP3gOYHvLPT6JdWdUmEcbQFUDNt5bHEf0xi+zifYz4Tn0aC3f8cc5r56jCfuH+BhDVYwMX9vNXHIf6kAW6tHf47d1OXI6svS7NqFpfrdq1RKYrCDQ1xHM39gft689Vy63AMmElUZHnETOoYcc4QSwt7prm00u6ZW3IWhvhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3ODf5jx; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3ODf5jx"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2e8e738ae0so951600766b.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 07:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792074012; cv=none;
        d=google.com; s=arc-20260327;
        b=fpqquA1Fr0NJdd4grCZJirjAweHYsiQtgU/VYrMRjhlLtZzePARSnrXJNW0VlZS2aj
         SQfJNu1I8aQp7Fx+aAeU9YxUTWbcmz8pQqi/Hy2O1D1Gj4vBchEqZck/n55AuKBhmdpC
         tUUOHzDfMjARsFPWfBd3s2DW8XFm6zsFGVvnM6kVaIG4AS6xwyt+8esDFHtnlrsX5Vzu
         tdHw031Xo4FFfz12zw2Ju0iIcSm4mrhmsTfLK7Id66k3TFA1D2oz1duCMbIptg7rq9ez
         GFSi6DAmT5IzkekM94tXvCGJyQ5QYmipLFfG8FtEv1Ch3f0nB9Pnl2FTtgFyRnS///xg
         QmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=I8fxzl9R9NonqR3UkCEFDRrhPu6nkInjtd6haYZAzdw=;
        fh=ruFjDZwp049HJANbad/Gi/XbYSTiMYUwk1amOOQA8Nw=;
        b=VLoLN8BtziDvHDNhvYgX1i2QWx+WHy/RFJqpdiHV9n5AFpUpsjKQibd2UBxxjsgNT7
         VTD9rcoP8UDE/qmml6nhPOSKrI4YA3iEBm3ebj9F7VCAfE5Z4r2VnqwTGJ/BibmMceLS
         cYDf7iWdmUedWIUaPdYsSitjPpA2GQQe1eMQGku8nquyXFMBpQHB6NSO8+843Puj18l4
         /2S7hkErafJgBOYm3zATsHXmtQCrK95Uxm0KAiU3cLcBt5ywHxeJohHNgsgV+KRBX7LH
         8RuHIRiP7Tml5x/oMnBSeVDNTRirE6N/DA0WwxIq6yciHweBHzmMGgXUZypDTefhJhOr
         cIGQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792074012; x=1792678812; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I8fxzl9R9NonqR3UkCEFDRrhPu6nkInjtd6haYZAzdw=;
        b=T3ODf5jx+IUkqyGL4L64bPUTc0XFY4GQ/4MDgPE8pG9zOAPQh4o2fl+Vg8Dr0cvKt8
         x/lJmIS2KV6gLjdo6g/oP8+6omQSxSiqY94mPG9jGu7dxbMx8NG7D/zmirSFq5hPNB7e
         6zYV/lRgiQEQ0pEkqc1I6bV/7PdR7gI/FSO0IQh5DMgBW5cGZ3zP+4rdUmgnaMIp5xcy
         bMLUrhhw8xaEO5+rgHKrKoxQFo7VRyShAx8lbKv4bf4TaUR3/jmVSlF8aM2hEXO2Ioe0
         NwrJn4RTiwwI/Q2CMTuAZ2hdPxxCfOMlBTXhKk4d3H9ChMvCfTsFeyFV2WbWcrJTbEv/
         TQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074012; x=1792678812;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I8fxzl9R9NonqR3UkCEFDRrhPu6nkInjtd6haYZAzdw=;
        b=k7g/6wwfxl62LeHVubiLBp8GBFpKyNn5nIk9on7A/NC8MoDhmr+8vKW8lTb/jpopPM
         fBGcT7zhqtcgHjbIkL5feipoy5aNuRRXHqPFBloIxvAvV15N71FflXGAowvFQDaLaZ56
         9JbArwHwYJ7Gc9xsJ+N6TXq43XwsjWjqb4JjVvKIthmgUx9W4Y7k5uN+qCbT/Rp04eBs
         LU6g2HRo4SdpI+PPFmyo+HDh7SZwwqicaIv5VXz2v0mbrvQaW4sCmgxB4wD65i5X3YEa
         CZrZOPHkSjZ7tqf1APP608weJYvTNt7Q/cJ6f3AXr2Kbj3sNSNmVfjWL6dtpSZnncs0D
         dkmw==
X-Forwarded-Encrypted: i=1; AKwUvBy97bDlppw7ZX0UQJv7yimjOcVqolFofiiXXn0jCPUL/TOc/27Ntl5P6teriakNlPMXA7UR147zxHYd0w==@lists.linux.dev
X-Gm-Message-State: AFq9FYKvUPSY3LGu6Z4gUR+FDIDjWZGDKy8zbmVwz2e1MX8cGLgNPqKX
	XMYldAoqU7MJoNMViYC4xxL9e4wJxXbPA9enXlkcvz6XYh/1zVeSZrws8uQevvqudMeIyghiuZQ
	vJN3NAJXD8cc47UPxOalYcKmdTaaLZ1I=
X-Gm-Gg: AYBFou18pkqlitPzWXEiPwAKE0PqD3f/h6IlVZNErVofZ3aZ1nGthT3BvRZyO9P2qCs
	P6FQlq70S0mLbNLDz07E8g/Wr9pCiDXbjuTugopTnRwA2xo1C1JM10Gdq4eRtjAwQCuMM1MOSEn
	GzwyfEyaklHKKvlewN4syzCtEuNb6QJMjNTtyezXChVSio9A9u6YBc+SkOGK6sNKHt/aQgAAV97
	iPdW20ToVHBYsVi7rDIs6/p+4ybKQTyPSTVU0iKrxwcSDC9rhu/7RumodTBZVVJly0+AHtI/M2P
	uWaZjFs886L5YlJfmiDKXRit3muPJvohTCYDzQ4YojrLKcWYFlSJ9JJD1ugsU4cgfXk=
X-Received: by 2002:a17:907:3ea0:b0:c3f:98d4:dfd0 with SMTP id
 a640c23a62f3a-c3f98d4e648mr142302166b.45.1792074011520; Thu, 15 Oct 2026
 07:20:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Thu, 15 Oct 2026 22:19:32 +0800
X-Gm-Features: AclHuK8Eopw4NagnovXsrD2YLqs4Ei_fvd0nEsjlE6_Wb7YAbvsTTDxRBggZkrU
Message-ID: <CANypQFbjcxXjiigMCCyErN=DSEh3ZG3NMWRpq=Hic8KJ76cwew@mail.gmail.com>
Subject: [Linux Kernel Bug] KASAN: use-after-free Write in olq_alloc_dquot
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev
Cc: heming.zhao@suse.com, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com, r772577952@gmail.com
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We are writing to report an issue discovered in the OCFS2 subsystem.  The
issue is reproducible on the latest version of linux (v7.3-rc7, commit
24a19b953e2a3d0ea5a8c4951a0ab8f32720c907).  It is triggered by mounting a
crafted ocfs2 image that has quotas enabled (which needs CAP_SYS_ADMIN)
and then creating a file on it.  Below is the kernel report:

==================================================================
BUG: KASAN: use-after-free in instrument_write
include/linux/instrumented.h:41 [inline]
BUG: KASAN: use-after-free in ___set_bit
include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
BUG: KASAN: use-after-free in __set_bit_le
include/asm-generic/bitops/le.h:36 [inline]
BUG: KASAN: use-after-free in _ocfs2_set_bit fs/ocfs2/ocfs2.h:930 [inline]
BUG: KASAN: use-after-free in ocfs2_set_bit_unaligned
fs/ocfs2/ocfs2.h:961 [inline]
BUG: KASAN: use-after-free in olq_alloc_dquot+0x7a/0xd0
fs/ocfs2/quota_local.c:1211
Write of size 8 at addr ffff88806b34fda0 by task syz.0.17/12574

CPU: 0 UID: 0 PID: 12574 Comm: syz.0.17 Not tainted 7.3.0-rc7 #56 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
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
 ___set_bit include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
 __set_bit_le include/asm-generic/bitops/le.h:36 [inline]
 _ocfs2_set_bit fs/ocfs2/ocfs2.h:930 [inline]
 ocfs2_set_bit_unaligned fs/ocfs2/ocfs2.h:961 [inline]
 olq_alloc_dquot+0x7a/0xd0 fs/ocfs2/quota_local.c:1211
 ocfs2_modify_bh+0x240/0x470 fs/ocfs2/quota_local.c:116
 ocfs2_create_local_dquot+0x1511/0x1a90 fs/ocfs2/quota_local.c:1261
 ocfs2_acquire_dquot+0x7dc/0xb20 fs/ocfs2/quota_global.c:897
 dqget+0x73c/0xc50 fs/quota/dquot.c:1002
 __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1462
 ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:206
 ocfs2_mknod+0x88d/0x2000 fs/ocfs2/namei.c:315
 ocfs2_create+0x195/0x450 fs/ocfs2/namei.c:678
 lookup_open+0xf95/0x18e0 fs/namei.c:4596
 open_last_lookups fs/namei.c:4796 [inline]
 path_openat+0x6b1/0x1f20 fs/namei.c:5026
 do_file_open+0x203/0x440 fs/namei.c:5058
 do_sys_openat2+0x107/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ad6ba778d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3ad7b32018 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f3ad6e35fa0 RCX: 00007f3ad6ba778d
RDX: 0000000000000042 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f3ad6c4eb3d R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3ad6e36038 R14: 00007f3ad6e35fa0 R15: 00007ffe36ca1410
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f0af21c8
pfn:0x6b34f
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea0001acd7c8 ffffea0001d459c8 0000000000000000
raw: 00000007f0af21c8 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask
0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 12556, tgid 12556 (9),
ts 160210821197
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x205/0x260 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x235b/0x23e0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x209/0x5a0 mm/page_alloc.c:5436
 alloc_pages_mpol+0x241/0x4a0 mm/mempolicy.c:2486
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2505
 vma_alloc_folio_noprof+0xdb/0x1e0 mm/mempolicy.c:2540
 folio_prealloc+0x30/0x180 mm/memory.c:-1
 do_cow_fault mm/memory.c:6024 [inline]
 do_fault mm/memory.c:6136 [inline]
 do_pte_missing+0x519/0x3350 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x19bb/0x36d0 mm/memory.c:6876
 do_user_addr_fault+0xa7e/0x1360 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x71/0xd0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
page last free pid 12556 tgid 12556 ts 160322719585 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 free_unref_folios+0xd80/0x14c0 mm/page_alloc.c:3022
 folios_put_refs+0x7b4/0x8a0 mm/folio.c:1036
 free_pages_and_swap_cache+0x25e/0x440 mm/swap_state.c:592
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x3a2/0x680 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x473/0x9c0 mm/mmap.c:1328
 __mmput+0x118/0x430 kernel/fork.c:1193
 exec_mm_put_old fs/exec.c:920 [inline]
 setup_new_exec+0x30e/0x360 fs/exec.c:1400
 load_elf_binary+0xbd1/0x2860 fs/binfmt_elf.c:1024
 search_binary_handler fs/exec.c:1779 [inline]
 exec_binprm fs/exec.c:1811 [inline]
 bprm_execve+0x933/0x15c0 fs/exec.c:1867
 do_execveat_common+0x522/0x6b0 fs/exec.c:1965
 __do_sys_execve fs/exec.c:2038 [inline]
 __se_sys_execve fs/exec.c:2032 [inline]
 __x64_sys_execve+0x97/0xc0 fs/exec.c:2032
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88806b34fc80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806b34fd00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88806b34fd80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                               ^
 ffff88806b34fe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806b34fe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================

Following is the root cause analysis for this issue, note that the analysis
is performed with the assistance of LLM, but we try our best to ensure the
accuracy.

Every ocfs2 node keeps a local quota file, divided into chunks.  Each chunk
starts with a header block whose bitmap records which quota entries of that
chunk are in use.  When ocfs2 hands out a new entry, olq_alloc_dquot() sets
the entry's bit in that bitmap.  The issue occurs because the bit it is
asked to set lies far past the end of the bitmap, which fits in a single
block.

The bad bit position comes from dqi_blocks, the number of blocks the local
quota file says it uses.  ocfs2_local_read_info() reads it from disk at
mount time and never checks that it agrees with dqi_chunks, the number of
chunks.  Later, when no chunk has a free entry,
ocfs2_extend_local_quota_file() works out how many entry blocks the last
chunk already has from dqi_blocks, and places the new entry right after
them:

    chunk_blocks = oinfo->dqi_blocks - ol_quota_chunk_block(sb,
            chunk->qc_num) - 1; ... *offset = chunk_blocks * epb;

A chunk can hold at most ol_chunk_blocks() entry blocks, so for a valid
file this number is small.  On a crafted image whose dqi_blocks is much
larger than the chunks can account for, the last chunk appears to hold
thousands of entry blocks.  The resulting bit position then points
kilobytes past the header block, and setting it corrupts unrelated memory.

To fix this issue, we can check the local quota file header in
ocfs2_local_read_info(), right after dqi_chunks and dqi_blocks are read
from disk.  The two values agree when:
- the last chunk has its header block and at most ol_chunk_blocks() entry
  blocks, or
- there are no chunks, and the file consists of the info block only.

A file that fails the check should be rejected with ocfs2_error(), the same
way ocfs2_read_quota_block() handles a corrupted quota file.

If this solution is acceptable, we will submit a formal patch.

The kernel console output, kernel config, syzkaller reproducer, and C
reproducer are available at google drive:
https://drive.google.com/drive/folders/1apOZQcX2fl3fQYSipzCoQy9HI1PYDwwf?usp=sharing

Please let us know if any further information is required.

Best Regards, Jiaming Zhang
