Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EDB3F7E98
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 12:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775045214; cv=none; b=QNtuM/sHZaKwVtLWe3NLxX/9rektqI9ugJ+Mx3ib7NsLkRnSbtW+DGK/kINT8gKsE3wWMhd18adb6XYW71ks80o429/j9wuLUAKBKcHCjJAVatlZ6iSvniGeoOx49fQ8c/aNnA4A3GYA+/7IYFv5QALthEQqQuPZnX4oXenxzAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775045214; c=relaxed/simple;
	bh=g8Krtz87LtbN4MqAwkC/v5bpUkj/RIy9lWxBL8GwXaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsuH1UkCe3m1GgYhNgeBh1iOE9wFj1OhN7AQXeebKN1pDp9eEw2K+/RnvSGQYlWDtQ5PyuwsU/hhDGIcXr3olKWICvXBBmQVCD5sxyLZkjETmCm2oqH7bwaIONfz/1M9jspSY7LfZSCWIkXlT83svZz3oAqZp8KRVCghEsqtbgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+bpcjTf; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+bpcjTf"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12732e6a123so3325857c88.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 05:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775045212; x=1775650012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vw2bboZopkLPG684quKZAMeLZ+pzg8JHou1D9tTeMZE=;
        b=a+bpcjTfRxkIRo5XswCWbge52Ea/XgCK6Ar0om/vlUBk/UF8XVS9zQ6JnHsPhZ9DAV
         I1yfd0QhYzzoMDKQ5YpQeMr72A8Z9/J31HVI4TOwsjRFbSl8Ed9n2y3/nGFvVvNxowOF
         2gmVmPtULI3MfpJg5EhCLad1VUcQT54ohhU9YOemOJ1b9dAdlzCGeUZ90TU8xy5bUEid
         PDXVtRvI14z9gMwZq/pZKo/CK5lecmJ5vfudaaDelNE2sWYAdAlOURFhTAXvw4KN9vb5
         NH8R3sVVTnpq/GGwrdW7YCdWkSAObbrMzgRMi/ps1FN+nRrpwHIzorS/7a9m9WQd5k26
         CUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775045212; x=1775650012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vw2bboZopkLPG684quKZAMeLZ+pzg8JHou1D9tTeMZE=;
        b=J46XiCLh/XXjhYbZfHz2IBkEgs2w6LWOcF4P/q6QEOwR2FzSkXvn51jfny74NFtR2n
         oLnR3Avf9bC1mSiOZmTDUS4Qyrln5TbQ1GiF6BHHiwpgv2LFcAF3C1klgYiXuBi5+mPh
         BKAYP5SS1MeLgkyZ52ww0DjjAocxdgNwkkqi+Nxgguq9OOIpRAuky8M3PMuPPR87P+Cv
         opUHj2BwPpgo9pRs5RFKSsRrygeHfyVkW6mjeBSepmrFS4ofJFcpXpYWcjcDvt9A2smY
         c+RmUsAZZBlKePA4O8+Hjt3Hk5a6KI3CTVEmcfm0c/PUBobnKLzjhDGl0Kst+wyenJoM
         4xhw==
X-Gm-Message-State: AOJu0Yz5p/BtVdKq6dJq4lBPeBzETlclDUf0luhetkxpf9sn1er8ocrJ
	iedZyPBuXpjJzR1Tx7EtIMXf3U9lTkVFNbWxlqya5m8gZKM8vgWJ7XKh
X-Gm-Gg: ATEYQzy9Qc4X3ufwMswxHfXAMCxUBMeDWPUovmqXKfekU6jO/zD5KG6QHD6H++OsJJK
	g8GLXBkZP7Qj1CP6/bcKrVRehjM31WahlO3Nku5L2Q2IbGaQp9jmWNv1cqAxb6FIjXKltid5kST
	sQ7d1t5VkN1eEvV6ou47HERPR52x/QGsJL9AU6xRfwAr4bot4qVWZMLNljBjAmFGVX65yQEkVn1
	VwEG7+culXGFpoOVufc6U5zgyvfJ9vOALlT82mKcUvVaP7glUAplrJwcNaHHlkMCAqafszcOr3/
	hbYFjulo4pl6SJ7iSKlj9ePK2gJJqpt20//r5+jgBouHc7Be7PHgOnoDZeu7FdoKnUt3LdTsoki
	avtJJG1uVnW5FyxjlulS98B6VEl7HB1xqVNTpYNbKmkXuj0l31CVQNJ9M+aA306Q8vV/DLoz4F0
	nEJHZ6SiDhv4aDYr31raS5pdZq851Vd4ewgrn5o4CNq8x/J6r6B6RyVzZBWRE=
X-Received: by 2002:a05:7022:394:b0:128:bb45:35b2 with SMTP id a92af1059eb24-12be6447ce9mr1946311c88.12.1775045211559;
        Wed, 01 Apr 2026 05:06:51 -0700 (PDT)
Received: from fedora ([2804:30c:2764:a200:5385:27ed:62fd:1204])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12abde65313sm12088171c88.14.2026.04.01.05.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 05:06:51 -0700 (PDT)
Date: Wed, 1 Apr 2026 09:06:45 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Shuangpeng <shuangpeng.kernel@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ocfs2: slab-out-of-bounds in down_read_trylock from
 quota-on path
Message-ID: <ac0Buq9DS9kREZvt@fedora>
References: <40B9252B-5C73-47A8-BFE0-1A76B1D9F437@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <40B9252B-5C73-47A8-BFE0-1A76B1D9F437@gmail.com>

On Wed, Mar 25, 2026 at 03:15:27PM -0400, Shuangpeng wrote:
> Hi Kernel Maintainers,
> 
> I hit the following KASAN report while testing current upstream kernel:
> 
> KASAN: slab-out-of-bounds in down_read_trylock
> 
> on commit bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)
> 
> The reproducer and .config files are here:
> https://gist.github.com/shuangpengbai/d2612321387d8c6be057b1a9a2e1c422
> 
> The faulting access happens in ocfs2_read_virt_blocks() when it calls
> down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem), but KASAN reports that
> the accessed object belongs to f2fs_inode_cache. This looks like OCFS2 code
> may be interpreting a non-OCFS2 inode as an OCFS2 inode, but I am not fully
> sure yet.
> 
> I'm happy to test debug patches or provide additional information.
> 
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> 
> 
> [   52.307203][ T8456] ==================================================================
> [   52.310017][ T8456] BUG: KASAN: slab-out-of-bounds in down_read_trylock (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-long.h:38 ./include/linux/atomic/atomic-instrumented.h:3189 kernel/locking/rwsem.c:1295 kernel/locking/rwsem.c:1576)
> [   52.312429][ T8456] Read of size 8 at addr ffff8881641a21d0 by task a.out/8456
> [   52.313159][ T8456]
> [   52.313410][ T8456] CPU: 0 UID: 0 PID: 8456 Comm: a.out Not tainted 6.19.0-08383-g99a19d63fa32 #34 PREEMPT(full)
> [   52.313417][ T8456] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [   52.313421][ T8456] Call Trace:
> [   52.313423][ T8456]  <TASK>
> [   52.313425][ T8456]  dump_stack_lvl (lib/dump_stack.c:122)
> [   52.313433][ T8456]  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> [   52.313462][ T8456]  kasan_report (mm/kasan/report.c:597)
> [   52.313480][ T8456]  kasan_check_range (mm/kasan/generic.c:? mm/kasan/generic.c:200)
> [   52.313486][ T8456]  down_read_trylock (./arch/x86/include/asm/atomic64_64.h:15 ./include/linux/atomic/atomic-arch-fallback.h:2583 ./include/linux/atomic/atomic-long.h:38 ./include/linux/atomic/atomic-instrumented.h:3189 kernel/locking/rwsem.c:1295 kernel/locking/rwsem.c:1576)
> [   52.313498][ T8456]  ocfs2_read_virt_blocks (fs/ocfs2/extent_map.c:994)
> [   52.313540][ T8456]  ocfs2_read_quota_block (fs/ocfs2/quota_local.c:147)
> [   52.313556][ T8456]  ocfs2_local_check_quota_file (fs/ocfs2/quota_local.c:175)
> [   52.313585][ T8456]  dquot_load_quota_sb (fs/quota/dquot.c:2455)
> [   52.313591][ T8456]  dquot_load_quota_inode (fs/quota/dquot.c:2499)
> [   52.313598][ T8456]  f2fs_quota_on (fs/f2fs/super.c:3414)
> [   52.313604][ T8456]  __se_sys_quotactl (fs/quota/quota.c:960 fs/quota/quota.c:916)
> [   52.313629][ T8456]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
> [   52.313633][ T8456]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [   52.313638][ T8456] RIP: 0033:0x7f00b1646f29
> [   52.313646][ T8456] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 48
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	00 c3                	add    %al,%bl
>    2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
>    9:	00 00 00 
>    c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>   11:	48 89 f8             	mov    %rdi,%rax
>   14:	48 89 f7             	mov    %rsi,%rdi
>   17:	48 89 d6             	mov    %rdx,%rsi
>   1a:	48 89 ca             	mov    %rcx,%rdx
>   1d:	48                   	rex.W
> [   52.313651][ T8456] RSP: 002b:00007fff9de6e208 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
> [   52.313658][ T8456] RAX: ffffffffffffffda RBX: 0000000020000944 RCX: 00007f00b1646f29
> [   52.313661][ T8456] RDX: 0000000000000003 RSI: 0000000020000040 RDI: ffffffff80000202
> [   52.313665][ T8456] RBP: 00007fff9de6e2f0 R08: 0000000000000000 R09: 0000000000000000
> [   52.313668][ T8456] R10: 0000000020000080 R11: 0000000000000246 R12: 000056025d47a220
> [   52.313671][ T8456] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [   52.313675][ T8456]  </TASK>
> [   52.313677][ T8456]
> [   52.342046][ T8456] The buggy address belongs to the object at ffff8881641a1dd0
> [   52.342046][ T8456]  which belongs to the cache f2fs_inode_cache of size 1144
> [   52.343498][ T8456] The buggy address is located 1024 bytes inside of
> [   52.343498][ T8456]  allocated 1144-byte region [ffff8881641a1dd0, ffff8881641a2248)
> [   52.344931][ T8456]
> [   52.345181][ T8456] The buggy address belongs to the physical page:
> [   52.345836][ T8456] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881641a3ba0 pfn:0x1641a0
> [   52.346859][ T8456] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> [   52.347717][ T8456] memcg:ffff8881641a7c39
> [   52.348161][ T8456] flags: 0x17ff00000000240(workingset|head|node=0|zone=2|lastcpupid=0x7ff)
> [   52.349030][ T8456] page_type: f5(slab)
> [   52.349443][ T8456] raw: 017ff00000000240 ffff88810e6f0640 ffff88810e6d1690 ffff88810e6d1690
> [   52.350313][ T8456] raw: ffff8881641a3ba0 000000080019000c 00000000f5000000 ffff8881641a7c39
> [   52.351182][ T8456] head: 017ff00000000240 ffff88810e6f0640 ffff88810e6d1690 ffff88810e6d1690
> [   52.352063][ T8456] head: ffff8881641a3ba0 000000080019000c 00000000f5000000 ffff8881641a7c39
> [   52.352941][ T8456] head: 017ff00000000003 ffffea0005906801 00000000ffffffff 00000000ffffffff
> [   52.353818][ T8456] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> [   52.354693][ T8456] page dumped because: kasan: bad access detected
> [   52.355345][ T8456] page_owner tracks the page as allocated
> [   52.355932][ T8456] page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|_7
> [   52.358085][ T8456]  post_alloc_hook (./include/linux/page_owner.h:? mm/page_alloc.c:1884)
> [   52.358576][ T8456]  get_page_from_freelist (mm/page_alloc.c:? mm/page_alloc.c:3950)
> [   52.359133][ T8456]  __alloc_frozen_pages_noprof (mm/page_alloc.c:5245)
> [   52.359722][ T8456]  allocate_slab (mm/slub.c:3240 mm/slub.c:3411)
> [   52.360179][ T8456]  refill_objects (mm/slub.c:7092)
> [   52.360653][ T8456]  refill_sheaf (mm/slub.c:2790)
> [   52.361091][ T8456]  __pcs_replace_empty_main (mm/slub.c:2808 mm/slub.c:4546)
> [   52.361651][ T8456]  kmem_cache_alloc_lru_noprof (mm/slub.c:4640 mm/slub.c:4773 mm/slub.c:4807)
> [   52.362239][ T8456]  f2fs_alloc_inode (fs/f2fs/super.c:1753)
> [   52.362732][ T8456]  alloc_inode (fs/inode.c:?)
> [   52.363169][ T8456]  iget_locked (fs/inode.c:1472)
> [   52.363616][ T8456]  f2fs_iget (fs/f2fs/inode.c:575)
> [   52.364048][ T8456]  f2fs_fill_super (fs/f2fs/super.c:5026)
> [   52.364550][ T8456]  get_tree_bdev_flags (fs/super.c:1695)
> [   52.365071][ T8456]  vfs_get_tree (fs/super.c:1754)
> [   52.365522][ T8456]  do_new_mount (fs/namespace.c:1194 fs/namespace.c:3760 fs/namespace.c:3836)
> [   52.365987][ T8456] page last free pid 1 tgid 1 stack trace:
> [   52.366581][ T8456]  __free_frozen_pages (./include/linux/page_owner.h:? mm/page_alloc.c:1433 mm/page_alloc.c:2973)
> [   52.367108][ T8456]  free_contig_range (mm/page_alloc.c:7237)
> [   52.367618][ T8456]  destroy_args (mm/debug_vm_pgtable.c:?)
> [   52.368088][ T8456]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
> [   52.368590][ T8456]  do_one_initcall (init/main.c:1378)
> [   52.369084][ T8456]  do_initcall_level (init/main.c:1439)
> [   52.369596][ T8456]  do_initcalls (init/main.c:1453)
> [   52.370043][ T8456]  kernel_init_freeable (init/main.c:1692)
> [   52.370580][ T8456]  kernel_init (init/main.c:1580)
> [   52.371027][ T8456]  ret_from_fork (arch/x86/kernel/process.c:164)
> [   52.371506][ T8456]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [   52.372006][ T8456]
> [   52.372254][ T8456] Memory state around the buggy address:
> [   52.372827][ T8456]  ffff8881641a2080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   52.373641][ T8456]  ffff8881641a2100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   52.374456][ T8456] >ffff8881641a2180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   52.375275][ T8456]                                                  ^
> [   52.375962][ T8456]  ffff8881641a2200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   52.376779][ T8456]  ffff8881641a2280: fc fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00
> [   52.377593][ T8456] ==================================================================
> 
> 
> Best,
> Shuangpeng
> 

Hi Shuangpeng,

This looks like a quota format mismatch rather than an OCFS2 bug itself.

Your reproducer creates an F2FS image with quota format id = 3, which is
specific to OCFS2. When quotactl() is issued, the following path is taken:

f2fs_quota_on
  -> dquot_load_quota_inode
      -> dquot_load_quota_sb
          -> ocfs2_local_check_quota_file

Inside dquot_load_quota_sb(), find_quota_format(id) resolves the format based
solely on the on-disk id. Since id = 3 corresponds to ocfs2_quota_format, the
quota subsystem ends up invoking OCFS2-specific handlers on an F2FS inode.

So the root cause is that the quota framework does not validate whether the
quota format is compatible with the filesystem.

