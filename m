Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F657404E
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 01:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742954347; cv=none; b=P49l9AYJrp1zqvrLcN5Fa74xCqA3pLAD+O9350EbfZhCLfhFGK/WRkAZKnyAoGoDsshk5ogKC/PYf3WlE12S35XcT7t2MyuUr4vDrSB0OhiDSWzhHJrtB/kvvNqqGkP8DTqK5XZDsz0McFPIojcTIFR0HOLbn23OPJWkabvMSdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742954347; c=relaxed/simple;
	bh=WVwXpsaxWtSxyJwhFPIYqMB7fzY/pHXBLGss72k/2SY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=CoZse84xPWKG1C92vmk3wPYGrkZWjJudNIPonh/JoilGhurXcw5mPVM3ftG6MX10hFqIHUghfIgq/kDGK8faU7Tq0CZopFQPkZrZrC7OmGBN/KynZ5LZZ9Kaj9jhfbkFrYV91+wjHTq6xmAJqazipFJR902Oz8+RDBIKUDUW91o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d3dee8d31aso50603105ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Mar 2025 18:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742954344; x=1743559144;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yy2nnZnPh0qyaK4Z14QpCXIUWFLUG2dFuN+uKSMqr4c=;
        b=XhKx40h1WqP63n7Qk7BkPB1WbT07EXpVNFRdrgSFjQCzdZL/s5YCrvR6mtTxCce5PF
         Ym+NonQoBEsBCYQ/GwxAgixZTgjnR0b8qb1L15lxyXdbj8lG19XSZIzoVXcnSR3bE11R
         KTL3Y8xjRz2/Q6ttop2PrTvpHlUhqWCU3LV1JvS9cfPVm3yBEZfCaEWkps5kaxD3rHTg
         xW81EfDoM6DbVhY5iF+FWcmtkoXTjdeRrjL14DFM04V1nYX4DuX0PvVbcYHNjVV8WCvt
         j81r14sIJ15EhfACmN26DgQ6j1X75YKqat7upGXMS+WDzkP5BapKDOn++OI78P4nKEl9
         6y7g==
X-Forwarded-Encrypted: i=1; AJvYcCWubLE7l40FzFSQn02BFGR8U2SsESO/xI3XMafkbDc1tW069ITJ6wEburr2E9Lt1U7t/96TKl6WzVcKzw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw15/zChcEftNEVjxWFos5dkvIF5O6tp4BDksGxE+76e5YWui3O
	S5zGxOBbHnHwtBYpKZTM/oDGajD71IYVtsAhjEaXNpsH4TKC26X0nEixlhK5LtpR1/bleQDAQkD
	vtcqV2x5KAmEuy3cIWATRVsDggmmHbNqdyRdHQtZig59L/PCSACPR/vc=
X-Google-Smtp-Source: AGHT+IEY3VY5yH8q/bMpJLgdmFKRteDTdiTCK3XfiyzhTWfW9vhxT/EujtU0R6hmbBh5ZsIL7KYPyTsnNlBPbxYiHfmzLoCTBxlI
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188b:b0:3d2:b0f1:f5bd with SMTP id
 e9e14a558f8ab-3d5960bf875mr177765045ab.3.1742954343786; Tue, 25 Mar 2025
 18:59:03 -0700 (PDT)
Date: Tue, 25 Mar 2025 18:59:03 -0700
In-Reply-To: <20250326012356.9099-1-richard120310@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e35f67.050a0220.1ec46.0004.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in _find_next_bit
From: syzbot <syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	richard120310@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

us 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    6.611729][    T1] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff windo=
w]
[    6.614346][    T1] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bff=
ff window]
[    6.616924][    T1] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfef=
ff window]
[    6.624654][    T1] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.628537][    T1] PCI: CLS 0 bytes, default 64
[    6.630437][    T1] PCI-DMA: Using software bounce buffering for IO (SWI=
OTLB)
[    6.632704][    T1] software IO TLB: mapped [mem 0x00000000bbffd000-0x00=
000000bfffd000] (64MB)
[    6.635938][    T1] ACPI: bus type thunderbolt registered
[    6.765209][    T1] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters=
, 10737418240 ms ovfl timer
[    6.850100][    T1] kvm_amd: CPU 1 isn't AMD or Hygon
[    6.851373][    T1] clocksource: tsc: mask: 0xffffffffffffffff max_cycle=
s: 0x1fb6eddb419, max_idle_ns: 440795238405 ns
[    6.857108][    T1] clocksource: Switched to clocksource tsc
[    6.883495][   T65] kworker/u8:4 (65) used greatest stack depth: 11832 b=
ytes left
[    6.889522][   T66] kworker/u8:3 (66) used greatest stack depth: 10984 b=
ytes left
[   27.208530][    T1] Initialise system trusted keyrings
[   27.218330][    T1] workingset: timestamp_bits=3D40 max_order=3D21 bucke=
t_order=3D0
[   27.231513][    T1] DLM installed
[   27.247670][    T1] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   27.271132][    T1] NFS: Registering the id_resolver key type
[   27.277462][    T1] Key type id_resolver registered
[   27.282686][    T1] Key type id_legacy registered
[   27.288363][    T1] nfs4filelayout_init: NFSv4 File Layout Driver Regist=
ering...
[   27.296225][    T1] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Drive=
r Registering...
[   27.333103][    T1] Key type cifs.spnego registered
[   27.339373][    T1] Key type cifs.idmap registered
[   27.352720][    T1] ntfs3: Enabled Linux POSIX ACLs support
[   27.358946][    T1] ntfs3: Read-only LZX/Xpress compression included
[   27.366297][    T1] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[   27.372753][    T1] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[   27.379120][    T1] QNX4 filesystem 0.2.3 registered.
[   27.384778][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[   27.392301][    T1] fuse: init (API version 7.42)
[   27.403332][    T1] orangefs_debugfs_init: called with debug mask: :none=
: :0:
[   27.412516][    T1] orangefs_init: module version upstream loaded
[   27.420673][    T1] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[   27.468138][    T1] SGI XFS with ACLs, security attributes, realtime, qu=
ota, no debug enabled
[   27.496532][    T1] 9p: Installing v9fs 9p2000 file system support
[   27.504768][    T1] NILFS version 2 loaded
[   27.509106][    T1] befs: version: 0.9.3
[   27.514617][    T1] ocfs2: Registered cluster interface o2cb
[   27.521829][    T1] ocfs2: Registered cluster interface user
[   27.531815][    T1] OCFS2 User DLM kernel interface loaded
[   27.557799][    T1] gfs2: GFS2 installed
[   27.602711][    T1] ceph: loaded (mds proto 32)
[   31.788483][    T1] NET: Registered PF_ALG protocol family
[   31.794660][    T1] xor: automatically using best checksumming function =
  avx      =20
[   31.802658][    T1] async_tx: api initialized (async)
[   31.808258][    T1] Key type asymmetric registered
[   31.813372][    T1] Asymmetric key parser 'x509' registered
[   31.819440][    T1] Asymmetric key parser 'pkcs8' registered
[   31.825504][    T1] Key type pkcs7_test registered
[   31.831461][    T1] Block layer SCSI generic (bsg) driver version 0.4 lo=
aded (major 238)
[   31.842315][    T1] io scheduler mq-deadline registered
[   31.848032][    T1] io scheduler kyber registered
[   31.853733][    T1] io scheduler bfq registered
[   31.872561][    T1] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN=
:00/input/input0
[   31.882251][  T127] kworker/u8:5 (127) used greatest stack depth: 10624 =
bytes left
[   31.896988][    T1] ACPI: button: Power Button [PWRF]
[   31.904914][    T1] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN=
:00/input/input1
[   31.915245][    T1] ACPI: button: Sleep Button [SLPF]
[   31.950129][    T1] ioatdma: Intel(R) QuickData Technology Driver 5.00
[   32.035057][    T1] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[   32.040824][    T1] virtio-pci 0000:00:03.0: virtio_pci: leaving for leg=
acy driver
[   32.114546][    T1] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[   32.120352][    T1] virtio-pci 0000:00:04.0: virtio_pci: leaving for leg=
acy driver
[   32.195707][    T1] ACPI: \_SB_.LNKB: Enabled at IRQ 10
[   32.201394][    T1] virtio-pci 0000:00:06.0: virtio_pci: leaving for leg=
acy driver
[   32.258757][    T1] virtio-pci 0000:00:07.0: virtio_pci: leaving for leg=
acy driver
[   33.408986][    T1] N_HDLC line discipline registered with maxframe=3D40=
96
[   33.416297][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enab=
led
[   33.429926][    T1] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A
[   33.462358][    T1] 00:04: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D =
115200) is a 16550A
[   33.491731][    T1] 00:05: ttyS2 at I/O 0x3e8 (irq =3D 6, base_baud =3D =
115200) is a 16550A
[   33.524186][    T1] 00:06: ttyS3 at I/O 0x2e8 (irq =3D 7, base_baud =3D =
115200) is a 16550A
[   33.577101][    T1] Non-volatile memory driver v1.3
[   33.587337][    T1] BUG: kernel NULL pointer dereference, address: 00000=
00000000000
[   33.594496][    T1] #PF: supervisor read access in kernel mode
[   33.594496][    T1] #PF: error_code(0x0000) - not-present page
[   33.594496][    T1] PGD 0 P4D 0=20
[   33.594496][    T1] Oops: Oops: 0000 [#1] SMP PTI
[   33.594496][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.1=
4.0-syzkaller-01979-g61af143fbea4-dirty #0 PREEMPT(undef)=20
[   33.624396][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 02/12/2025
[   33.634086][    T1] RIP: 0010:msix_capability_init+0x95c/0x18c0
[   33.644292][    T1] Code: ff ff ff 48 89 9d 60 fe ff ff 48 89 9d 08 ff f=
f ff 48 83 bd 30 ff ff ff 00 4c 8b 75 c8 0f 85 1d 02 00 00 48 8b bd 58 ff f=
f ff <44> 8b 27 b8 00 00 40 00 41 21 c4 e8 b4 b2 ad fb 8b 18 44 8b 3a 41
[   33.664287][    T1] RSP: 0000:ffff888100642fb0 EFLAGS: 00010246
[   33.664287][    T1] RAX: ffff8880bba43080 RBX: ffffc90000b3f008 RCX: 000=
0000100243080
[   33.674041][    T1] RDX: ffff888100243080 RSI: ffff88813fffacc0 RDI: 000=
0000000000000
[   33.684352][    T1] RBP: ffff888100643178 R08: ffffea000000000f R09: 000=
0000000000000
[   33.694105][    T1] R10: ffff8880bba43020 R11: ffffffff86cfbc29 R12: 000=
0000000000000
[   33.694105][    T1] R13: 0000000000000000 R14: ffff8881408d0b58 R15: 000=
000000000000b
[   33.704327][    T1] FS:  0000000000000000(0000) GS:ffff8881ab2b0000(0000=
) knlGS:0000000000000000
[   33.714083][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   33.724299][    T1] CR2: 0000000000000000 CR3: 0000000011a80000 CR4: 000=
00000003526f0
[   33.734034][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[   33.734034][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[   33.744273][    T1] Call Trace:
[   33.754028][    T1]  <TASK>
[   33.754028][    T1]  ? show_trace_log_lvl+0x268/0x3d0
[   33.764298][    T1]  ? __pci_enable_msix_range+0xad9/0xc40
[   33.764298][    T1]  ? __die_body+0xce/0x1a0
[   33.774026][    T1]  ? __die+0x20f/0x270
[   33.774026][    T1]  ? page_fault_oops+0xe58/0xfb0
[   33.774026][    T1]  ? exc_page_fault+0x56c/0x700
[   33.784287][    T1]  ? asm_exc_page_fault+0x2b/0x30
[   33.794040][    T1]  ? __pci_enable_msix_range+0xad9/0xc40
[   33.794040][    T1]  ? msix_capability_init+0x95c/0x18c0
[   33.804364][    T1]  __pci_enable_msix_range+0xad9/0xc40
[   33.804364][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   33.814074][    T1]  ? kmsan_internal_set_shadow_origin+0x6c/0x100
[   33.814074][    T1]  pci_alloc_irq_vectors_affinity+0x111/0x3a0
[   33.824317][    T1]  vp_find_vqs_msix+0x84d/0x1560
[   33.834083][    T1]  ? kmsan_internal_unpoison_memory+0x14/0x20
[   33.834083][    T1]  vp_find_vqs+0x6c/0xa80
[   33.844490][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   33.844490][    T1]  ? __pfx_vp_find_vqs+0x10/0x10
[   33.854046][    T1]  probe_common+0x3b4/0x970
[   33.854046][    T1]  ? __pfx_random_recv_done+0x10/0x10
[   33.864284][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   33.864284][    T1]  virtrng_probe+0x2d/0x40
[   33.874036][    T1]  ? __pfx_virtrng_probe+0x10/0x10
[   33.874036][    T1]  virtio_dev_probe+0x1640/0x19a0
[   33.884351][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[   33.884351][    T1]  really_probe+0x4dc/0xd90
[   33.894100][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   33.894100][    T1]  __driver_probe_device+0x2ab/0x5d0
[   33.904311][    T1]  driver_probe_device+0x72/0x890
[   33.914058][    T1]  __driver_attach+0x7ea/0xb50
[   33.914058][    T1]  bus_for_each_dev+0x350/0x540
[   33.914058][    T1]  ? __pfx___driver_attach+0x10/0x10
[   33.924300][    T1]  driver_attach+0x51/0x70
[   33.934048][    T1]  bus_add_driver+0x74c/0xdb0
[   33.934048][    T1]  driver_register+0x3fb/0x660
[   33.934048][    T1]  __register_virtio_driver+0xf1/0x120
[   33.944314][    T1]  ? __pfx_virtio_rng_driver_init+0x10/0x10
[   33.954051][    T1]  virtio_rng_driver_init+0x2e/0x40
[   33.954051][    T1]  do_one_initcall+0x228/0xbf0
[   33.964344][    T1]  ? __pfx_virtio_rng_driver_init+0x10/0x10
[   33.964344][    T1]  ? kmsan_internal_unpoison_memory+0x14/0x20
[   33.974071][    T1]  ? irqentry_enter+0x37/0x60
[   33.980235][    T1]  ? sysvec_apic_timer_interrupt+0x52/0x90
[   33.984318][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   33.994074][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   33.994074][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   34.004347][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   34.004347][    T1]  ? parameq+0x43a/0x470
[   34.014040][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   34.014040][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   34.024360][    T1]  ? parse_args+0xfde/0x10a0
[   34.024360][    T1]  ? kmsan_get_metadata+0x13e/0x1c0
[   34.034052][    T1]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[   34.034052][    T1]  ? __pfx_virtio_rng_driver_init+0x10/0x10
[   34.044310][    T1]  do_initcall_level+0x140/0x350
[   34.054046][    T1]  do_initcalls+0x1a6/0x2f0
[   34.054046][    T1]  ? __pfx_native_smp_prepare_cpus+0x10/0x10
[   34.054046][    T1]  do_basic_setup+0x22/0x30
[   34.066107][    T1]  kernel_init_freeable+0x306/0x4c0
[   34.074047][    T1]  ? __pfx_kernel_init+0x10/0x10
[   34.074047][    T1]  kernel_init+0x2f/0x800
[   34.084307][    T1]  ? __pfx_kernel_init+0x10/0x10
[   34.084307][    T1]  ret_from_fork+0x6d/0x90
[   34.094354][    T1]  ? __pfx_kernel_init+0x10/0x10
[   34.094354][    T1]  ret_from_fork_asm+0x1a/0x30
[   34.104353][    T1] RIP: 1f0f:0x0
[   34.104353][    T1] Code: Unable to access opcode bytes at 0xfffffffffff=
fffd6.
[   34.114061][    T1] RSP: 0000:0000000000000000 EFLAGS: 841f0f2e66 ORIG_R=
AX: 1f0f2e6600000000
[   34.124569][    T1] RAX: 0000000000000000 RBX: 1f0f2e6600000000 RCX: 2e6=
6000000000084
[   34.124569][    T1] RDX: 0000000000841f0f RSI: 000000841f0f2e66 RDI: 008=
41f0f2e660000
[   34.134075][    T1] RBP: 00841f0f2e660000 R08: 00841f0f2e660000 R09: 000=
000841f0f2e66
[   34.144315][    T1] R10: 0000000000841f0f R11: 2e66000000000084 R12: 000=
000841f0f2e66
[   34.154402][    T1] R13: 0000000000841f0f R14: 2e66000000000084 R15: 1f0=
f2e6600000000
[   34.164295][    T1]  </TASK>
[   34.164295][    T1] Modules linked in:
[   34.164295][    T1] CR2: 0000000000000000
[   34.174038][    T1] ---[ end trace 0000000000000000 ]---
[   34.174038][    T1] RIP: 0010:msix_capability_init+0x95c/0x18c0
[   34.184305][    T1] Code: ff ff ff 48 89 9d 60 fe ff ff 48 89 9d 08 ff f=
f ff 48 83 bd 30 ff ff ff 00 4c 8b 75 c8 0f 85 1d 02 00 00 48 8b bd 58 ff f=
f ff <44> 8b 27 b8 00 00 40 00 41 21 c4 e8 b4 b2 ad fb 8b 18 44 8b 3a 41
[   34.204268][    T1] RSP: 0000:ffff888100642fb0 EFLAGS: 00010246
[   34.214047][    T1] RAX: ffff8880bba43080 RBX: ffffc90000b3f008 RCX: 000=
0000100243080
[   34.214047][    T1] RDX: ffff888100243080 RSI: ffff88813fffacc0 RDI: 000=
0000000000000
[   34.224282][    T1] RBP: ffff888100643178 R08: ffffea000000000f R09: 000=
0000000000000
[   34.234034][    T1] R10: ffff8880bba43020 R11: ffffffff86cfbc29 R12: 000=
0000000000000
[   34.244291][    T1] R13: 0000000000000000 R14: ffff8881408d0b58 R15: 000=
000000000000b
[   34.254082][    T1] FS:  0000000000000000(0000) GS:ffff8881ab2b0000(0000=
) knlGS:0000000000000000
[   34.264357][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.264357][    T1] CR2: 0000000000000000 CR3: 0000000011a80000 CR4: 000=
00000003526f0
[   34.274080][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[   34.284395][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[   34.294083][    T1] Kernel panic - not syncing: Fatal exception
[   34.294083][    T1] Kernel Offset: disabled
[   34.294083][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod/golang.org/toolchain@v0.0.=
1-go1.23.6.linux-amd64'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod/golang.org/toolchain@v0=
.0.1-go1.23.6.linux-amd64/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.23.6'
GODEBUG=3D''
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build647643234=3D/tmp/go-build -gno-record-gcc=
-switches'

git status (err=3D<nil>)
HEAD detached at 22a6c2b175
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D22a6c2b1752ef57d8d612e233d35f6be8c3bf7df -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20250318-101307'" -o ./b=
in/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"22a6c2b1752ef57d8d612e233d35f6be8c=
3bf7df\"
/usr/bin/ld: /tmp/ccvpz9QI.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D1584024c580000


Tested on:

commit:         61af143f Merge tag 'Smack-for-6.15' of https://github...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc96d28eebe225e1=
2
dashboard link: https://syzkaller.appspot.com/bug?extid=3D7ea0b96c4ddb49fd1=
a70
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D1058024c5800=
00

