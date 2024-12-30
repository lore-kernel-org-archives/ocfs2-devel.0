Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D302713B288
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 02:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735525526; cv=none; b=AACpZRc4Gj8dB0kepkyZUGuvlZ3C0kxA3t0kIWnR/PzOXewK1p2KJsAl1sa2WvZ/Oe7aC9TJHb8sSWPYAdzkbBtF0QKrfYhV/kseo5wMYuz4TI2Wn/VxZgGbtN1ZB71XlUtgNSXFdieL+pzqb66/r/7jGKzN2sSLU7oDUVw0g2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735525526; c=relaxed/simple;
	bh=tR6gvS+YzlTFpm1Cb1a78s3Eg+s2SfmRFpsmLVUI/yQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=e0wRHzg/lVWX6JVGExg6IfVA+tnHdF7br2BKk/B7V8L+S7+OHPe4BB4ZX1WBLsVFo8BzB251TZ1v5fgeFSykb2a6+6oAEfabwfJrOSf0ahYSUMGUm8rjL2b4MfVQnY4uIC55IKCGDX/RZatNbPb96vUQyi99eji2xKkjb1hvL1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PowgMajk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PowgMajk"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436637e8c8dso88728985e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Dec 2024 18:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735525522; x=1736130322; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQi6suKXeQ9NTOvURgEK/00ecDb57h2CNzLoM405WqQ=;
        b=PowgMajkCxp30qP4OGs49kVvxrym5Kbf8iHvZ8Y6vlo/rCRcP22AeINlMSFtShH35s
         xG9dtnm+AeHEq5VI6DGoZqlhcbeG7XEdlVHU1ph8lAkou8KGpX3EPiOXsUotniMd36Iz
         48f0L2Kk1GGb9KuERSX6UEt0Y9FP613Lf16ZZLZ4S4u0WvfLUQqZ1VmWihyvLuiZzo4l
         2YC4X2lo3KgZV3+muxKTkeltcgCS2F0qiqHt/YHuca64s8zjc197wvAi5013eK3KCjy5
         GzZ4VmHUktl+PpzgnYOtLrkftEJk9ynNpLb4K+PM06Hp1cgjE4IAC7b+izFAzOV9b3Gf
         4BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735525522; x=1736130322;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQi6suKXeQ9NTOvURgEK/00ecDb57h2CNzLoM405WqQ=;
        b=icl9S281D2thajKYuTSAO3B7HLb6agfBEmh/yF+4cMRNvXlHTNQalZCfjLZTeWg7o5
         shkk+A1Hbqx4k3Tfn19y90eLjCkdIzjWLQtrCQGP3KcPtEa/rCWyq9qQXVkpinn3poj+
         4IlRAlqwUBz6xylzfUWXXKbDwvvmt4IPHjsAAV3D0+HAQ/rBYm8HAtIXj8we9Prw55xN
         40YzrSiKDvfOHhF8+kVMASLBA8JJiXRu2f78GTn7BcZR3vqGmMab18Mi2WrUBMmPZX50
         Ra2dP6JH/aRTmI1tl2JgHfeUBZfyBgpOGnrK8LsH012s4KkvSdRijE8Rl7ARa327gCc/
         AJcg==
X-Forwarded-Encrypted: i=1; AJvYcCWSxwHLqrHby0n8J+4AYsqOvLOy72yQcwO05cMNOlDwy4Q19Y0A1MhKqOMERmbJRsLv13Gan2q5gdG/EA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9ohR9H90x7wnEOOlIsvubZ4orx6l1MtJQeY5UKYX2JqVgNG3v
	eanxqnIA8FLpO9bPNcaegwvMx6MBc+dVR+npEPf31bU5C01Lz+FEadMLcDuFe8o=
X-Gm-Gg: ASbGncv+r3OE+agO18Q8uzblPRIp0JqAYi01OtW6BVF5YYpYFsm5qH5Lwvd6++gDx36
	d1c9ss80qd33YxntJavZuN9kOY3eJ3MihlwHGudMk9HEmcicHNnFgSIt1GkcCVu0VJL4AqldltE
	qiCfKLM1qAbehs/84n+gwJeQwkIf7f7ep3Y4v19ARy5oXtseujEriOcKMnApmanmwnWXG6WjOhJ
	9oMuvWZmlc2DJ7l0ANDa6fuXkNogK/tYwePpmK9lHja0Gsn0iP9eODbCgYJ
X-Google-Smtp-Source: AGHT+IEDkR+3eaas6nDkGkxzkH7LEXhzCfHSgApQ8HnkEPdQHjZg3xVKTlR8Rgsj8xhMriR5Ai48Qw==
X-Received: by 2002:a5d:6f15:0:b0:385:ecdf:a30a with SMTP id ffacd0b85a97d-38a221fa490mr30436890f8f.33.1735525522019;
        Sun, 29 Dec 2024 18:25:22 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd181c07dcsm99344756d6.80.2024.12.29.18.25.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Dec 2024 18:25:20 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: Glass Su <glass.su@suse.com>
In-Reply-To: <672ba960.050a0220.350062.0277.GAE@google.com>
Date: Mon, 30 Dec 2024 10:25:04 +0800
Cc: jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 linux-kernel@vger.kernel.org,
 mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <F98EECF0-AC75-4617-9D1B-5D095D3B7DFA@suse.com>
References: <672ba960.050a0220.350062.0277.GAE@google.com>
To: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Nov 7, 2024, at 01:37, syzbot =
<syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    11066801dd4b Merge tag =
'linux_kselftest-fixes-6.12-rc6' of..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D161ed630580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D672325e7ab17fdf7
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Da66542ca5ebb4233b563
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D10c0f55f980000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D12482b40580000

I can still repro the BUG_ON in my test box.

#syz test

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920632..cef3d5562e21 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6154,6 +6154,9 @@ static int ocfs2_get_truncate_log_info(struct =
ocfs2_super *osb,
        int status;
        struct inode *inode =3D NULL;
        struct buffer_head *bh =3D NULL;
+       struct ocfs2_dinode *di;
+       struct ocfs2_truncate_log *tl;
+       unsigned int tl_count;

        inode =3D ocfs2_get_system_file_inode(osb,
                                           TRUNCATE_LOG_SYSTEM_INODE,
@@ -6171,6 +6174,18 @@ static int ocfs2_get_truncate_log_info(struct =
ocfs2_super *osb,
                goto bail;
        }

+       di =3D (struct ocfs2_dinode *)bh->b_data;
+       tl =3D &di->id2.i_dealloc;
+       tl_count =3D le16_to_cpu(tl->tl_count);
+
+       if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) =
||
+           tl_count =3D=3D 0)) {
+               status =3D -EFSCORRUPTED;
+               iput(inode);
+               mlog_errno(status);
+               goto bail;
+       }
+
        *tl_inode =3D inode;
        *tl_bh    =3D bh;
 bail:
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-11066801.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/b062b193560b/vmlinux-11066801=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/5b6da4ee7c42/bzImage-11066801=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/3a77709f2405/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
>=20
> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug =
expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || =
tl_count =3D=3D 0
> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: =
Truncate record count on #77 invalid wanted 39, actual 2087
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/alloc.c:5874!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted =
6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 ac ae 12 8e ba f2 16 00 00 48 c7 c1 =
c0 18 49 8c 4d 89 f0 41 89 d9 50 e8 ad 90 20 00 48 83 c4 08 90 <0f> 0b =
e8 71 87 11 fe 90 0f 0b e8 69 87 11 fe 90 0f 0b e8 f1 d3 43
> RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
> RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
> FS:  00005555722df380(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
> ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
> ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
> ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
> ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
> vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
> __do_sys_copy_file_range fs/read_write.c:1705 [inline]
> __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd327167af9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
> R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 ac ae 12 8e ba f2 16 00 00 48 c7 c1 =
c0 18 49 8c 4d 89 f0 41 89 d9 50 e8 ad 90 20 00 48 83 c4 08 90 <0f> 0b =
e8 71 87 11 fe 90 0f 0b e8 69 87 11 fe 90 0f 0b e8 f1 d3 43
> RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
> RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
> FS:  00005555722df380(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20

