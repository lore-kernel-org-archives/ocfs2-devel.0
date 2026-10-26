Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001002;
	b=e3pZftTnf3GGApC3P6LRy1phINTwxvhy1PDrKkK4ulvpQ1x574mVc2sEuqJ10KDnBxpV
	 L9sgvbfJHr3TYqz7TEsf0gY75GCQ+oTgjOBirpFAy+QeBULoNMDkuJV8F6uPwOUap7iHN
	 L1GaRI/H08lJTpoEATkppWFzd+oIWG6ILC4zqdWgeJjSoLJov6Rjmd0loE4iYrahBjfo2
	 cl/zhJRUrHQTx0Iuu6pi/qVL5xxGhCVP7iaWE+dhF5H7mjtYehcLRW9s7WwqYatuDiwvd
	 wiUJrrfXfi00FaP4EzR1hNtsroyuNjxlU5NJQa4WR8Bnwl5P2WtOrhYQ5oRpXZGMMrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001002;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=cC8d3l53v5l/BIJ4xOgSZEiDzx24DTRPibd1xKzhImY=;
	b=iyxXFbFXfX12XPgeYTjurvq1795DbPrUdKDDOw7c1DgspbGGrjLi2F5QE03zhrmmaHr5
	 XThxLcZ2FIEuX9x3BbX6a8a/TO7+o5fagzykmSjr2zyPDRx5y7SOY2mqYvJEgfZQzk27T
	 jQ0jxkZt0AXIffzIvKttzQkwge7OoLi2SV7fXzA78vaz2eR+vTO712rLPr9wHo+Egcug2
	 +xdCl5W1I64TCK7x9GHmIljiS1e9xRFTyGxEpNg4+UQXmo8H/eVP6+Py5XGLgWAP3g46g
	 FY6nQcasQHLJhrL3+lrQKiWy7Fi8IsKbN4F7P5DHj768DTGyQ832u8WiCxLhjDPMwdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hBmLkvSM;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0470606A31A
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 07:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0470606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hBmLkvSM
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793000992; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cC8d3l53v5l/BIJ4xOgSZEiDzx24DTRPibd1xKzhImY=;
	b=hBmLkvSMNRUZGloJv1yxQN4VHeLdayAyFsqTg3g2u8p9MINl3Tb69zVt+zo/dkbSCEQdPb0aU9GYq7Xt0K7E5UH/awCgz7KywGHeuHe6cJbVvzzvCwulIrDzliIiR8/AiNUaKFZ9WDrfXGVeizRoxBcb2laIgOHLGTS05HnFKPc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDU8Vi6_1793000991;
Received: from 30.221.130.82(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDU8Vi6_1793000991 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 15:49:51 +0800
Message-ID: <9f777a27-8e65-48e8-b5fb-9e7decdaaee2@linux.alibaba.com>
Date: Mon, 26 Oct 2026 15:49:51 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: wait for filecheck kobject release after a
 failed add
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0087-v6-78f3c3d6d70887d6e0cc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0087-v6-78f3c3d6d70887d6e0cc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/26 12:18 AM, Cen Zhang wrote:
> The filecheck kobject and its release completion are embedded in
> ocfs2_super, so the osb must outlive the kobject. On a failed
> kobject_init_and_add(), creation clears fs_fcheck and calls
> kobject_put(), but returns without waiting for the release callback.
> 
> With CONFIG_DEBUG_KOBJECT_RELEASE, the last put queues delayed cleanup.
> Mount failure can then free the containing osb before the embedded
> release timer expires:
> 
>   Mount failure                     Delayed cleanup
>   -------------                     ---------------
>   ocfs2_filecheck_create_sysfs()
>     kobject_init_and_add() fails
>     fs_fcheck = NULL
>     kobject_put()
>       queue delayed release
>   return to mount error cleanup
>   ocfs2_dismount_volume()
>     remove_sysfs() skips the wait
>     kfree(osb)
>                                     expire embedded release timer
>                                       access freed osb
> 
> The normal removal path waits for fs_kobj_unregister, but it returns
> early when fs_fcheck is NULL. The failed-add path therefore leaves the
> delayed work and its completion in freed storage.
> 
> Wait for the existing release completion after the failed-add
> kobject_put(), before returning to mount error cleanup. This keeps the
> enclosing osb alive until the kobject has finished releasing, matching
> the normal teardown path.
> 
> KASAN report as below:
> 
>     BUG: KASAN: slab-use-after-free in __run_timers+0xa6d/0xa90
>     Write of size 8 at addr ffff8881178a5658 by task swapper/0/0
>     
>     CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy) 
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <IRQ>
>      dump_stack_lvl+0x93/0xd0
>      print_report+0xce/0x630
>      ? __run_timers+0xa6d/0xa90
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __virt_addr_valid+0x20e/0x420
>      ? __run_timers+0xa6d/0xa90
>      kasan_report+0xe0/0x110
>      ? __run_timers+0xa6d/0xa90
>      __run_timers+0xa6d/0xa90
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx___run_timers+0x10/0x10
>      ? __lock_acquire+0x5a3/0x2140
>      ? __pfx_do_raw_spin_lock+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      timer_expire_remote+0xfa/0x160
>      ? __pfx_timer_expire_remote+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on+0x18/0x160
>      tmigr_handle_remote_up+0x4ba/0x9d0
>      ? __pfx_tmigr_handle_remote_up+0x10/0x10
>      ? tmigr_handle_remote+0x21a/0x340
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? __pfx_tmigr_handle_remote_up+0x10/0x10
>      __walk_groups_from+0x5a/0x160
>      tmigr_handle_remote+0x24f/0x340
>      ? __pfx_tmigr_handle_remote+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      run_timer_softirq+0x222/0x270
>      ? __pfx_run_timer_softirq+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lockdep_hardirqs_on_prepare+0xb8/0x1a0
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      handle_softirqs+0x1fa/0x8d0
>      ? __pfx_handle_softirqs+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? _raw_spin_unlock+0x23/0x40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __hrtimer_rearm_deferred+0x1fb/0x5d0
>      __irq_exit_rcu+0x113/0x1e0
>      irq_exit_rcu+0xe/0x20
>      sysvec_apic_timer_interrupt+0x6c/0x80
>      </IRQ>
>      <TASK>
>      asm_sysvec_apic_timer_interrupt+0x1a/0x20
>     RIP: 0010:pv_native_safe_halt+0xf/0x20
>     Code: fa 18 01 e9 ee 37 ff fa 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 23 c7 14 00 fb f4 <e9> c7 37 ff fa 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
>     RSP: 0018:ffffffff87c07cf8 EFLAGS: 00000206
>     RAX: 0000000000045d0f RBX: ffffffff87c2d4c0 RCX: ffffffff86111e95
>     RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff815b508e
>     RBP: fffffbfff0f85a98 R08: 0000000000000001 R09: ffffed10310c68ba
>     R10: ffff8881886345d3 R11: 0000000000000000 R12: 0000000000000001
>     R13: 0000000000000000 R14: 1ffffffff0f80fa4 R15: dffffc0000000000
>      ? ct_kernel_exit.constprop.0+0xc5/0xf0
>      ? do_idle+0x3ae/0x650
>      default_idle+0x9/0x10
>      default_idle_call+0x6c/0xb0
>      do_idle+0x3ae/0x650
>      ? __pfx___schedule+0x10/0x10
>      ? __pfx_do_idle+0x10/0x10
>      ? rest_init+0x1cd/0x330
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      cpu_startup_entry+0x54/0x60
>      rest_init+0x1e1/0x330
>      ? __pfx_acpi_read_bit_register+0x10/0x10
>      ? __pfx_rest_init+0x10/0x10
>      ? acpi_os_write_port+0x23/0xb0
>      ? __pfx_kernel_init+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? acpi_ut_status_exit+0xd6/0x180
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? acpi_ut_status_exit+0xd6/0x180
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? acpi_enable_subsystem+0x2b0/0x4e0
>      ? __pfx_x86_late_time_init+0x10/0x10
>      start_kernel+0x417/0x4b0
>      x86_64_start_reservations+0x18/0x30
>      x86_64_start_kernel+0x111/0x120
>      common_startup_64+0x13e/0x158
>      </TASK>
>     
>     Allocated by task 494:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      __kasan_kmalloc+0xaa/0xb0
>      __kmalloc_cache_noprof+0x28d/0x610
>      ocfs2_initialize_super.isra.0+0xab/0x3070
>      ocfs2_fill_super+0x801/0x3920
>      get_tree_bdev_flags+0x35d/0x5f0
>      vfs_get_tree+0x93/0x320
>      fc_mount+0x1d/0x200
>      path_mount+0x592/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     Freed by task 494:
>      kasan_save_stack+0x33/0x60
>      kasan_save_track+0x14/0x30
>      kasan_save_free_info+0x3b/0x60
>      __kasan_slab_free+0x5f/0x80
>      kfree+0x308/0x580
>      ocfs2_dismount_volume+0x43c/0x9b0
>      ocfs2_fill_super+0x258f/0x3920
>      get_tree_bdev_flags+0x35d/0x5f0
>      vfs_get_tree+0x93/0x320
>      fc_mount+0x1d/0x200
>      path_mount+0x592/0x1e00
>      __x64_sys_mount+0x24b/0x2d0
>      do_syscall_64+0x114/0x620
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     
>     The buggy address belongs to the object at ffff8881178a4000
>      which belongs to the cache kmalloc-8k of size 8192
>     The buggy address is located 5720 bytes inside of
>      freed 8192-byte region [ffff8881178a4000, ffff8881178a6000)
>     
>     The buggy address belongs to the physical page:
>     page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1178a0
>     head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>     flags: 0x200000000000040(head|node=0|zone=2)
>     page_type: f5(slab)
>     raw: 0200000000000040 ffff888100043880 dead000000000122 0000000000000000
>     raw: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
>     head: 0200000000000040 ffff888100043880 dead000000000122 0000000000000000
>     head: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
>     head: 0200000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
>     head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>     page dumped because: kasan: bad access detected
>     
>     Memory state around the buggy address:
>      ffff8881178a5500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>      ffff8881178a5580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     >ffff8881178a5600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                         ^
>      ffff8881178a5680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>      ffff8881178a5700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     ==================================================================
> 
> Fixes: b9fba67b3806 ("ocfs2: fix error path kobject memory leak")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> 
> 
> ---
> Changes in v2:
> - Name ocfs2_super explicitly in the lifetime comment and describe kobject
>   release without assuming CONFIG_DEBUG_KOBJECT_RELEASE.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0087-v5-4888399e71ae6d93613f@gmail.com
> 
>  fs/ocfs2/filecheck.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index 75334e4bd082..e3b79bc749f5 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -189,6 +189,8 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
>  		/* Mount failure still calls ocfs2_filecheck_remove_sysfs(). */
>  		entry->fs_fcheck = NULL;
>  		kobject_put(&entry->fs_kobj);
> +		/* Keep ocfs2_super alive until the kobject is released. */
> +		wait_for_completion(&entry->fs_kobj_unregister);
>  		kfree(fcheck);
>  		return ret;
>  	}

