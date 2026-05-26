Received: from forward501b.mail.yandex.net (forward501b.mail.yandex.net [178.154.239.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A51258CCC
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779803976; cv=none; b=KVIfgN+VllKDI1DxAp2JYkpFB4dC6qiyxBw/cwtVhT/gHDGYvCWjggVvKqnN02kOPBy0uaD6I489mUSyD8UqZweEaFmwCCcvJEfIQHULMVFURdE4Wr35O3utFs6bfTx11MCQZ/rOqthJ5sPIc7RJH3H21urSHyTEwbtNfjIeESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779803976; c=relaxed/simple;
	bh=lyTkxROTLhFNsI824jPQxCjUDL+gNylI2vklpsgn7F8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RWPsMRKXdJFRrnY5OvgTzNDUpQA4+p6IbDWxH74hWgcWTnLcZAaUlIgAFJQrxCZql/uqUHv47BWWP/DfY5Z59oKrVFiIlfToY9cXqmFkRr2qx9rrtRAAWZh3ET5OJKeFb3Bv0EYiQGj70mWWJpyakRbf07+s70EswV3DqWN7ha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=g/v1LXjt; arc=none smtp.client-ip=178.154.239.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="g/v1LXjt"
Received: from mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:221f:0:640:b03f:0])
	by forward501b.mail.yandex.net (Yandex) with ESMTPS id 00C57818B9;
	Tue, 26 May 2026 16:59:24 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net (smtp) with ESMTPSA id MxYjhH0dEuQ0-8rNCP9BO;
	Tue, 26 May 2026 16:59:23 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1779803963; bh=YDRJvffVWiAsk2h9NEbx36ZI9UwDSH9NmDpz6TLjdPY=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=g/v1LXjt4uOySHdrTYgrHEgsZRzN6ukNEr3cTxFPBah2lUkAzrgMyP+3UBG/ZLRfH
	 6CV+MTbMdFtNez/WsZGJ/RBL7S/Gl6vbv4V5omsq9rapie4uNMmGQSs1Wfe8HiUV48
	 2hyyBiVfa9hV0gSgHQ0xHV01xifMYhR04kJxA35E=
Authentication-Results: mail-nwsmtp-smtp-production-main-67.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Date: Tue, 26 May 2026 16:59:22 +0300
In-Reply-To: <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
	 <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-05-26 at 21:18 +0800, Joseph Qi wrote:

> Don't understand in which case we will see a corrupted dr_list in
> ocfs2_dx_dir_lookup_rec().
>=20
> When ocfs2_validate_dx_root() fails, it will jump to read_failure logic
> and buffer is not set to uptodate.
>=20
> Could you please list a detail flow for it?

Good question. At least C reproducer from https://syzkaller.appspot.com/bug=
?extid=3D30b53487d00b4f7f0922
works for me again, and the backtrace (reported with KASAN) is very similar=
 to one reported with UBSAN
at https://syzkaller.appspot.com/bug?extid=3Dcaacd220635a9cc3bac9 (see cons=
ole log from there):

[   42.097756][ T5684] loop0: detected capacity change from 0 to 32768
[   42.104863][ T5684] JBD2: Ignoring recovery information on journal
[   42.113619][ T5684] ocfs2: Mounting device (7,0) on (node local, slot 0)=
 with ordered data mode.
[   42.135689][ T5684] (repro-30b53487d,5684,2):ocfs2_check_set_options:124=
4 ERROR: Invalid heartbeat mount options
[   42.208624][ T5684] loop0: detected capacity change from 32768 to 32767
[   42.214609][ T5684] OCFS2: ERROR (device loop0): int ocfs2_validate_dx_r=
oot(struct super_block *, struct buffer_head *): Dir Index Root # 74 has ba=
d signature XDIR01
[   42.215237][ T5684] On-disk corruption discovered. Please run fsck.ocfs2=
 once the filesystem is unmounted.
[   42.215663][ T5684] OCFS2: File system is now read-only.
[   42.215891][ T5684] (repro-30b53487d,5684,0):ocfs2_find_entry_dx:1065 ER=
ROR: status =3D -30
[   42.216256][ T5684] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   42.216601][ T5684] BUG: KASAN: use-after-free in ocfs2_dx_dir_lookup_re=
c+0x23c/0x6f0
[   42.216971][ T5684] Read of size 4 at addr ffff88802fdfd2c0 by task repr=
o-30b53487d/5684
[   42.217341][ T5684]=20
[   42.217452][ T5684] CPU: 0 UID: 0 PID: 5684 Comm: repro-30b53487d Tainte=
d: G        W           7.1.0-rc5-00006-ge8c2f9fdadee #7 PREEMPT(full)=20
[   42.217459][ T5684] Tainted: [W]=3DWARN
[   42.217460][ T5684] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996=
), BIOS 1.17.0-10.fc44 06/10/2025
[   42.217462][ T5684] Call Trace:
[   42.217465][ T5684]  <TASK>
[   42.217467][ T5684]  dump_stack_lvl+0xe8/0x150
[   42.217473][ T5684]  print_address_description+0x55/0x1e0
[   42.217479][ T5684]  ? ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
[   42.217484][ T5684]  print_report+0x58/0x70
[   42.217490][ T5684]  kasan_report+0x117/0x150
[   42.217496][ T5684]  ? ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
[   42.217502][ T5684]  ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
[   42.217508][ T5684]  ? __pfx_ocfs2_dx_dir_lookup_rec+0x10/0x10
[   42.217513][ T5684]  ? ocfs2_dx_dir_name_hash+0x252/0xb50
[   42.217518][ T5684]  ? __asan_memcpy+0x40/0x70
[   42.217522][ T5684]  ? ocfs2_dx_dir_name_hash+0x9fb/0xb50
[   42.217527][ T5684]  ocfs2_dx_dir_lookup+0xd3/0x530
[   42.217532][ T5684]  ? __pfx_ocfs2_dx_dir_name_hash+0x10/0x10
[   42.217537][ T5684]  ? __pfx_ocfs2_dx_dir_lookup+0x10/0x10
[   42.217543][ T5684]  ocfs2_find_entry+0xefe/0x2050
[   42.217549][ T5684]  ? __pfx_ocfs2_find_entry+0x10/0x10
[   42.217554][ T5684]  ? console_unlock+0x150/0x1c0
[   42.217560][ T5684]  ? __pfx_console_unlock+0x10/0x10
[   42.217566][ T5684]  ? irq_work_queue+0xc3/0x140
[   42.217571][ T5684]  ? ocfs2_read_inode_block+0x152/0x1c0
[   42.217576][ T5684]  ? __pfx_ocfs2_read_inode_block+0x10/0x10
[   42.217580][ T5684]  ? do_raw_spin_unlock+0xf5/0x210
[   42.217584][ T5684]  ? ocfs2_inode_lock_full_nested+0xaad/0x1b30
[   42.217589][ T5684]  ? ocfs2_read_blocks+0x119f/0x1510
[   42.217594][ T5684]  ? __pfx_ocfs2_inode_lock_full_nested+0x10/0x10
[   42.217599][ T5684]  ocfs2_check_dir_for_entry+0x13c/0x410
[   42.217605][ T5684]  ? __pfx_ocfs2_check_dir_for_entry+0x10/0x10
[   42.217609][ T5684]  ? do_file_open+0x23e/0x4a0
[   42.217613][ T5684]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   42.217618][ T5684]  ocfs2_mknod+0x6bc/0x2240
[   42.217623][ T5684]  ? __pfx_ocfs2_mknod+0x10/0x10
[   42.217626][ T5684]  ? __pfx_ocfs2_find_entry+0x10/0x10
[   42.217631][ T5684]  ? ocfs2_inode_lock_full_nested+0xaad/0x1b30
[   42.217636][ T5684]  ? register_lock_class+0x31/0x2e0
[   42.217642][ T5684]  ? __lock_acquire+0x683/0x2cd0
[   42.217649][ T5684]  ? start_dir_add+0x19c/0x270
[   42.217654][ T5684]  ? do_raw_spin_lock+0x12b/0x2f0
[   42.217658][ T5684]  ? do_raw_spin_unlock+0xf5/0x210
[   42.217662][ T5684]  ? _raw_spin_unlock+0x28/0x50
[   42.217670][ T5684]  ? rcu_is_watching+0x15/0xb0
[   42.217675][ T5684]  ? ocfs2_lookup+0x5f4/0xa00
[   42.217681][ T5684]  ? __pfx_apparmor_path_mknod+0x10/0x10
[   42.217686][ T5684]  ocfs2_create+0x195/0x460
[   42.217691][ T5684]  ? __pfx_ocfs2_lookup+0x10/0x10
[   42.217697][ T5684]  ? __pfx_ocfs2_create+0x10/0x10
[   42.217703][ T5684]  ? bpf_lsm_inode_permission+0x9/0x20
[   42.217707][ T5684]  ? security_inode_permission+0xb7/0x2e0
[   42.217713][ T5684]  ? may_o_create+0x2d2/0x370
[   42.217717][ T5684]  ? bpf_lsm_inode_create+0x9/0x20
[   42.217720][ T5684]  ? __pfx_ocfs2_create+0x10/0x10
[   42.217726][ T5684]  path_openat+0x17ba/0x3890
[   42.217733][ T5684]  ? __pfx_path_openat+0x10/0x10
[   42.217737][ T5684]  ? stack_trace_save+0xa9/0x100
[   42.217742][ T5684]  do_file_open+0x23e/0x4a0
[   42.217746][ T5684]  ? __pfx_do_file_open+0x10/0x10
[   42.217753][ T5684]  ? alloc_fd+0x5f8/0x660
[   42.217759][ T5684]  do_sys_openat2+0x113/0x200
[   42.217764][ T5684]  ? __pfx_lo_ioctl+0x10/0x10
[   42.217772][ T5684]  ? __pfx_do_sys_openat2+0x10/0x10
[   42.217777][ T5684]  ? blkdev_ioctl+0x5e3/0x740
[   42.217782][ T5684]  ? rcu_is_watching+0x15/0xb0
[   42.217788][ T5684]  __x64_sys_openat+0x138/0x170
[   42.217793][ T5684]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   42.217797][ T5684]  do_syscall_64+0x15f/0x560
[   42.217808][ T5684]  ? trace_irq_disable+0x3b/0x140
[   42.217813][ T5684]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   42.217817][ T5684] RIP: 0033:0x42025d
[   42.217821][ T5684] Code: d5 48 8d 3c 0a eb 91 66 0f 1f 44 00 00 f3 0f 1=
e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0=
f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 f0 ff ff ff f7 d8 64 89 01 48
[   42.217825][ T5684] RSP: 002b:00007fff7b8ee288 EFLAGS: 00000246 ORIG_RAX=
: 0000000000000101
[   42.217830][ T5684] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000=
000000042025d
[   42.217833][ T5684] RDX: 0000000000105042 RSI: 0000200000000080 RDI: 000=
00000ffffff9c
[   42.217836][ T5684] RBP: 0000200000000040 R08: 00007fff7b8ee2b0 R09: 000=
07fff7b8ee2b0
[   42.217839][ T5684] R10: 00000000000001ff R11: 0000000000000246 R12: 000=
0200000000100
[   42.217842][ T5684] R13: 0000200000000040 R14: 0000000000000002 R15: 000=
00000004b10a0
[   42.217846][ T5684]  </TASK>

Dmitry
