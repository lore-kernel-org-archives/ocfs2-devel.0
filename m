Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4C29D260
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774466141; cv=none; b=o77PSbPp1bx+8RDvPbMq7dhvjy+E35FLuVl38VGgD0IMjDDrMDHv9Zs1FWbYI5/mmrknKXLtEouz8ns+ijATioHPCiL2cR0RbKijPhBBnina9H2/xxKQ5eviLPDzGlTq+d4f1NtfS7855tMM3wsddRFkh6K3XYlNR51uXrtzWkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774466141; c=relaxed/simple;
	bh=7MGpR4kWhLfDE/4clOpw6ZRXV2tC5Agy6i7B7x5Rh8Y=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=gZmMf52N5CG1PXDpEmp1C8EphiJ3pjC3zLJ3zQCN62XVgi3BnJLEy3Ksf71Gi7a1wDsETJ12UfZaY1z7abeJCuLawspKlgwMA6j+zxz/NtKbLXR61yQosJKlCJrUEXYQAIdev+njxB7TXfnHAfOzoNtD6StR0vzMfe91Y9OivlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOLAbhg8; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOLAbhg8"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899d6b7b073so1627046d6.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774466139; x=1775070939; darn=lists.linux.dev;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8l/iAW9FeplP77LiyNOL3zF7+FM+hjZe4VxtGQ34t0=;
        b=XOLAbhg8kGLGWpVh5zdGOMhxXJYbJM528ZzMot2NPTX9C6DSZW5exWZAXopMKwJJ26
         11zBzaUIYAGUl5yZvjKDTkLADw3Kb/7/Ryd2vr+sMsfwK3yGPXzhyaWdlAGSFTEAQKvL
         pQ/MpjCUlm2PkyiJ3tj8jk1mVywwwq7MNnFFOsKw7uw2mhAQh1AaGQ4TJ9K/+rapTasw
         R9tBXDjqNnvd/yZ0EVVFRZDMw0exTVbr7dHZjSiL/0uLAdffPi4KTYjaN0wJwbsidoQo
         HIp8I2tzYXFNSLVQEx0ziRLKnQ39Y7Bcv1ttqlzCO+G0RSfO61ykdsl2ioz09S9y5bgo
         8ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774466139; x=1775070939;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U8l/iAW9FeplP77LiyNOL3zF7+FM+hjZe4VxtGQ34t0=;
        b=aa0y+YzjkHRMhz1GwCREvt+RK77dowN2W8iu2Kjc1IDnbzKD/uudsTjDR0vceTjWT6
         akh0/Hxjs4hCVCXPs0O8wcsU+8JqpcN4+0rSh21BK1mAq035O3Hn1xr/JR1onWVOM+FX
         jgMCw8D/Q6kvlGl4FLmSKBu+jJhZ+OOhZumegsXbojEJ/2x21/ozvi1dIJOVTOpyEM1c
         1c0DfiLqj2vLUUIx6Ra9SkYHK6jrYmi69gdXZsU4GsZ83BQbp214ea0QFY4mtt9uXCR3
         aPds+19coid5Oom7WoWL1na/lRMjAHDL12UnG19GAAJD98aG//lqUkYD0Z0Vpjncy6Uq
         q4qw==
X-Gm-Message-State: AOJu0YyFh2Nid7D+iFKTso/Ea7aOa93bHCdpomSbtVl7Oa946rVW1czw
	cF+PQg+HeSKw3PjFwEoWnhgIUzOziLIyury6ZtfnVi4jx4AJWlSToaAkHcE2NvALR+w=
X-Gm-Gg: ATEYQzylFu7DLs90xjJa4YlhOI5pE5Kzrddie0KbJZILe5UPAf3Nv6x312zjYIRKk4s
	3+IeMV24rSiBPWmxQMa+5JWlr7CBoUWFmwlb1G6Q5EkVCoKY9HzJou1KMxpZ00Jtzs9A6Wvi6Uw
	o6qr5/rWCSxTXFOklyH23btVAVjQWK/AK1tAMSxxbsfughbez+DID0bOSAJyn9HgnRE/EFW6hl1
	DcaqTqH7iDLQaqp+NLJiqH1orW9hc3x19Wy2EiScmKatHnyszWHnKiofYy9sCfAGjxvPfR4+Leu
	9TdlunkcevPqGcfJYY9yAeHj4DcrDEfxGE+lF/1noIPQn+S1/LDKrpPIRwdpZB209+4zeGs7kun
	om/0sWZpg5WyDGTZEc1DSpu8e9cUms+3vYMTk2RyIjFKAmfMTIxiWlZvNlS3lqdqREqUjNYjpSk
	odpgOVo7ypslnPGjrnP45IIJMpMqWeLjcvm3TpP8k5wD6/ji3EAIetLT4VioP24JZP
X-Received: by 2002:ac8:5796:0:b0:509:1cf9:ea0e with SMTP id d75a77b69052e-50b80de068bmr76845801cf.41.1774466138328;
        Wed, 25 Mar 2026 12:15:38 -0700 (PDT)
Received: from smtpclient.apple ([104.39.146.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b923f2d3esm5096791cf.31.2026.03.25.12.15.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2026 12:15:37 -0700 (PDT)
From: Shuangpeng <shuangpeng.kernel@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: [BUG] ocfs2: slab-out-of-bounds in down_read_trylock from quota-on
 path
Message-Id: <40B9252B-5C73-47A8-BFE0-1A76B1D9F437@gmail.com>
Date: Wed, 25 Mar 2026 15:15:27 -0400
Cc: mark@fasheh.com,
 jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org
To: ocfs2-devel@lists.linux.dev
X-Mailer: Apple Mail (2.3864.400.21)

Hi Kernel Maintainers,

I hit the following KASAN report while testing current upstream kernel:

KASAN: slab-out-of-bounds in down_read_trylock

on commit bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)

The reproducer and .config files are here:
https://gist.github.com/shuangpengbai/d2612321387d8c6be057b1a9a2e1c422

The faulting access happens in ocfs2_read_virt_blocks() when it calls
down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem), but KASAN reports that
the accessed object belongs to f2fs_inode_cache. This looks like OCFS2 =
code
may be interpreting a non-OCFS2 inode as an OCFS2 inode, but I am not =
fully
sure yet.

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>


[   52.307203][ T8456] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   52.310017][ T8456] BUG: KASAN: slab-out-of-bounds in =
down_read_trylock (./arch/x86/include/asm/atomic64_64.h:15 =
./include/linux/atomic/atomic-arch-fallback.h:2583 =
./include/linux/atomic/atomic-long.h:38 =
./include/linux/atomic/atomic-instrumented.h:3189 =
kernel/locking/rwsem.c:1295 kernel/locking/rwsem.c:1576)
[   52.312429][ T8456] Read of size 8 at addr ffff8881641a21d0 by task =
a.out/8456
[   52.313159][ T8456]
[   52.313410][ T8456] CPU: 0 UID: 0 PID: 8456 Comm: a.out Not tainted =
6.19.0-08383-g99a19d63fa32 #34 PREEMPT(full)
[   52.313417][ T8456] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
[   52.313421][ T8456] Call Trace:
[   52.313423][ T8456]  <TASK>
[   52.313425][ T8456]  dump_stack_lvl (lib/dump_stack.c:122)
[   52.313433][ T8456]  print_report (mm/kasan/report.c:379 =
mm/kasan/report.c:482)
[   52.313462][ T8456]  kasan_report (mm/kasan/report.c:597)
[   52.313480][ T8456]  kasan_check_range (mm/kasan/generic.c:? =
mm/kasan/generic.c:200)
[   52.313486][ T8456]  down_read_trylock =
(./arch/x86/include/asm/atomic64_64.h:15 =
./include/linux/atomic/atomic-arch-fallback.h:2583 =
./include/linux/atomic/atomic-long.h:38 =
./include/linux/atomic/atomic-instrumented.h:3189 =
kernel/locking/rwsem.c:1295 kernel/locking/rwsem.c:1576)
[   52.313498][ T8456]  ocfs2_read_virt_blocks =
(fs/ocfs2/extent_map.c:994)
[   52.313540][ T8456]  ocfs2_read_quota_block =
(fs/ocfs2/quota_local.c:147)
[   52.313556][ T8456]  ocfs2_local_check_quota_file =
(fs/ocfs2/quota_local.c:175)
[   52.313585][ T8456]  dquot_load_quota_sb (fs/quota/dquot.c:2455)
[   52.313591][ T8456]  dquot_load_quota_inode (fs/quota/dquot.c:2499)
[   52.313598][ T8456]  f2fs_quota_on (fs/f2fs/super.c:3414)
[   52.313604][ T8456]  __se_sys_quotactl (fs/quota/quota.c:960 =
fs/quota/quota.c:916)
[   52.313629][ T8456]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   52.313633][ T8456]  entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:130)
[   52.313638][ T8456] RIP: 0033:0x7f00b1646f29
[   52.313646][ T8456] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f =
44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 48

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	00 c3                	add    %al,%bl
   2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   9:	00 00 00=20
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	48                   	rex.W
[   52.313651][ T8456] RSP: 002b:00007fff9de6e208 EFLAGS: 00000246 =
ORIG_RAX: 00000000000000b3
[   52.313658][ T8456] RAX: ffffffffffffffda RBX: 0000000020000944 RCX: =
00007f00b1646f29
[   52.313661][ T8456] RDX: 0000000000000003 RSI: 0000000020000040 RDI: =
ffffffff80000202
[   52.313665][ T8456] RBP: 00007fff9de6e2f0 R08: 0000000000000000 R09: =
0000000000000000
[   52.313668][ T8456] R10: 0000000020000080 R11: 0000000000000246 R12: =
000056025d47a220
[   52.313671][ T8456] R13: 0000000000000000 R14: 0000000000000000 R15: =
0000000000000000
[   52.313675][ T8456]  </TASK>
[   52.313677][ T8456]
[   52.342046][ T8456] The buggy address belongs to the object at =
ffff8881641a1dd0
[   52.342046][ T8456]  which belongs to the cache f2fs_inode_cache of =
size 1144
[   52.343498][ T8456] The buggy address is located 1024 bytes inside of
[   52.343498][ T8456]  allocated 1144-byte region [ffff8881641a1dd0, =
ffff8881641a2248)
[   52.344931][ T8456]
[   52.345181][ T8456] The buggy address belongs to the physical page:
[   52.345836][ T8456] page: refcount:0 mapcount:0 =
mapping:0000000000000000 index:0xffff8881641a3ba0 pfn:0x1641a0
[   52.346859][ T8456] head: order:3 mapcount:0 entire_mapcount:0 =
nr_pages_mapped:0 pincount:0
[   52.347717][ T8456] memcg:ffff8881641a7c39
[   52.348161][ T8456] flags: =
0x17ff00000000240(workingset|head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
[   52.349030][ T8456] page_type: f5(slab)
[   52.349443][ T8456] raw: 017ff00000000240 ffff88810e6f0640 =
ffff88810e6d1690 ffff88810e6d1690
[   52.350313][ T8456] raw: ffff8881641a3ba0 000000080019000c =
00000000f5000000 ffff8881641a7c39
[   52.351182][ T8456] head: 017ff00000000240 ffff88810e6f0640 =
ffff88810e6d1690 ffff88810e6d1690
[   52.352063][ T8456] head: ffff8881641a3ba0 000000080019000c =
00000000f5000000 ffff8881641a7c39
[   52.352941][ T8456] head: 017ff00000000003 ffffea0005906801 =
00000000ffffffff 00000000ffffffff
[   52.353818][ T8456] head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000008
[   52.354693][ T8456] page dumped because: kasan: bad access detected
[   52.355345][ T8456] page_owner tracks the page as allocated
[   52.355932][ T8456] page last allocated via order 3, migratetype =
Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|_7
[   52.358085][ T8456]  post_alloc_hook (./include/linux/page_owner.h:? =
mm/page_alloc.c:1884)
[   52.358576][ T8456]  get_page_from_freelist (mm/page_alloc.c:? =
mm/page_alloc.c:3950)
[   52.359133][ T8456]  __alloc_frozen_pages_noprof =
(mm/page_alloc.c:5245)
[   52.359722][ T8456]  allocate_slab (mm/slub.c:3240 mm/slub.c:3411)
[   52.360179][ T8456]  refill_objects (mm/slub.c:7092)
[   52.360653][ T8456]  refill_sheaf (mm/slub.c:2790)
[   52.361091][ T8456]  __pcs_replace_empty_main (mm/slub.c:2808 =
mm/slub.c:4546)
[   52.361651][ T8456]  kmem_cache_alloc_lru_noprof (mm/slub.c:4640 =
mm/slub.c:4773 mm/slub.c:4807)
[   52.362239][ T8456]  f2fs_alloc_inode (fs/f2fs/super.c:1753)
[   52.362732][ T8456]  alloc_inode (fs/inode.c:?)
[   52.363169][ T8456]  iget_locked (fs/inode.c:1472)
[   52.363616][ T8456]  f2fs_iget (fs/f2fs/inode.c:575)
[   52.364048][ T8456]  f2fs_fill_super (fs/f2fs/super.c:5026)
[   52.364550][ T8456]  get_tree_bdev_flags (fs/super.c:1695)
[   52.365071][ T8456]  vfs_get_tree (fs/super.c:1754)
[   52.365522][ T8456]  do_new_mount (fs/namespace.c:1194 =
fs/namespace.c:3760 fs/namespace.c:3836)
[   52.365987][ T8456] page last free pid 1 tgid 1 stack trace:
[   52.366581][ T8456]  __free_frozen_pages =
(./include/linux/page_owner.h:? mm/page_alloc.c:1433 =
mm/page_alloc.c:2973)
[   52.367108][ T8456]  free_contig_range (mm/page_alloc.c:7237)
[   52.367618][ T8456]  destroy_args (mm/debug_vm_pgtable.c:?)
[   52.368088][ T8456]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
[   52.368590][ T8456]  do_one_initcall (init/main.c:1378)
[   52.369084][ T8456]  do_initcall_level (init/main.c:1439)
[   52.369596][ T8456]  do_initcalls (init/main.c:1453)
[   52.370043][ T8456]  kernel_init_freeable (init/main.c:1692)
[   52.370580][ T8456]  kernel_init (init/main.c:1580)
[   52.371027][ T8456]  ret_from_fork (arch/x86/kernel/process.c:164)
[   52.371506][ T8456]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   52.372006][ T8456]
[   52.372254][ T8456] Memory state around the buggy address:
[   52.372827][ T8456]  ffff8881641a2080: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   52.373641][ T8456]  ffff8881641a2100: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   52.374456][ T8456] >ffff8881641a2180: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   52.375275][ T8456]                                                  =
^
[   52.375962][ T8456]  ffff8881641a2200: fc fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc
[   52.376779][ T8456]  ffff8881641a2280: fc fc fc fc fc fc fc fc fc 00 =
00 00 00 00 00 00
[   52.377593][ T8456] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Best,
Shuangpeng

