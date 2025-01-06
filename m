Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B6535962
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736145312; cv=none; b=NfbjVt4rrYXd4mglM4ue8VJrIe1kfcUu7MBWAfVIujoKHTeBN2MRqI1Oh49fmm80JtXppOZdF3jtf+JvT0+fPci443wedMW/l9f29ul4mvnRCIyYfj6J6yKfUpVSR9PJlZDH8cCLe1c0xRQ/RRNAU200ipPSGW/BsPJriER8xCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736145312; c=relaxed/simple;
	bh=6mK2RNei7va8KJpwXL7dSmjM8lRTpUb3YbPg4EhvlAU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nZc72zaQWvJ983THM09akieOnhEj2gITYFOkDsFVHJl2jCLW/mnBV8Te0SF4GQdI9BpU6gZimCUCsFjjUvXWPDPwK6QsslDK/PAlBDxYTYOgs8mjLyojlHw2xAjvJjkRBQCd4F732I/f0+Q70hvLeexKxamHPdaPhyvNaUwPdvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J0IvKpX9; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J0IvKpX9"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385de9f789cso10553126f8f.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 22:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736145308; x=1736750108; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGuKjhzdZ1w9RW2Ts422TOjYh6RPESo4RHcn3CHAjRc=;
        b=J0IvKpX9ZbdI7L+RY/LA/3nX/GMjMeJtmr+OG5KFv1vuqctfpR9zvZvyvMz04VRiOi
         rIk5uW6F33VQubwVdVB/uJOytcEg+ZuWvYoQPCkKBo/j6fFVDKbWlA0YH/1qu5wOh4qx
         gqdx5/i4oBp1Qi0kcjlfBJlp3ngPTc94vNBsN7d3tqpZl9wI2IiWdW8mYsJ/1Zl53Pyh
         aQ+PLXco0JZhEvQ3xRVxFaW5rOcjdroHomtQ4f+znrZ/NTG6M2gMvLxBJJi6rl56gJkT
         KYcoQMubyajZpnMT8PTl8zk1zlbWq48mQmtT9rPPDJslHPUgmhCCkSX/8lnBbnCTOVKS
         J/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736145308; x=1736750108;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGuKjhzdZ1w9RW2Ts422TOjYh6RPESo4RHcn3CHAjRc=;
        b=JBEeZhvpaXbmfxrjfBxRgH4X0xcmRKlFXpKwlPAL6MSaqv5QFPmhqZJfk/KO9So3JP
         iY9jaCv2Rplj6sVg6al1SHoZyPx1koCBDUQfB9Bxnig4+FOKeR5ZXiYps3ApIMoL16pi
         UuVgCQ3mrEtileuVROP0vAkyOHNCghwTiEtl3cNuFw57uuJ0riPjIV+ocm2SaNolGYIa
         mQ9gSe3RSXmfHshfQBN9O6BD/Y8fjP2QAfygwbmDzYS9rlyGCwLHSWjxtN0gRoAz1jcK
         McRLDMBuKPWLi8BDse0te4PtR4YAFDfLiNz68aSErf/u2+8lbG4gzi/uzhEpDq84gfcS
         TwIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhQOwAyMV6ko6umI0uveeMpfFHy2BdMg2UorvRCkZiWe2VWMsrs06I2f3yBuzV++j1I29xhXSq4aevMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyXLnnE6Dy2N2LSnMA+xVXixparq2kOC7WGjzayyllrk6BF4yBS
	9ao9BLhpYnELRfbfWfiSfvsrUeG/UFu4nAwGDthniypAoQxR51RqvsmsRkfT6ok=
X-Gm-Gg: ASbGncsHbg+oD3ZaHG9/4EyWhO//0iHkpH6R01g3fhbNYvq6niQYMJUihfFiJ6mV0Vw
	COHSQ31RLEB3mVf9EXffGoQ+CkR6CwiVtfbdIjQnOMuivHEGHUNTJl8tKuMZbnIQ+IF1bII5QFa
	ysxL1rhbxKCM7H7gBovn/lTYYcpzZxg+I5hdsIRxAZUyGo4OHvKCiVHsDqj00W4xUKkvEGwLxaf
	nlOYDu4fUb/HDV9MNCaTvuULVDWrFC/UciDjsVwIEnS2Y48uUO2wgqP77E=
X-Google-Smtp-Source: AGHT+IGPZG4Jn91X7nFg1k/nB7gFJ1hqPZF3eIHCjqBpnzXsNcX0FbYSkkeKNgH4yUC0+ZP2wRRAvA==
X-Received: by 2002:a5d:5e09:0:b0:385:fb8d:8658 with SMTP id ffacd0b85a97d-38a223ffbf0mr55397858f8f.40.1736145308533;
        Sun, 05 Jan 2025 22:35:08 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac2bbfc5sm1480696485a.1.2025.01.05.22.35.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jan 2025 22:35:07 -0800 (PST)
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
In-Reply-To: <677b773f.050a0220.3b3668.0004.GAE@google.com>
Date: Mon, 6 Jan 2025 14:34:51 +0800
Cc: jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 linux-kernel@vger.kernel.org,
 mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B66223A-7AB0-4591-B431-088A3D94551F@suse.com>
References: <677b773f.050a0220.3b3668.0004.GAE@google.com>
To: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 6, 2025, at 14:25, syzbot =
<syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot has tested the proposed patch but the reproducer is still =
triggering an issue:
> kernel BUG in ocfs2_truncate_log_append
>=20
> (syz.0.15,5818,0):ocfs2_truncate_log_append:5874 ERROR: bug =
expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || =
tl_count =3D=3D 0
> (syz.0.15,5818,0):ocfs2_truncate_log_append:5874 ERROR: Truncate =
record count on #77 invalid wanted 39, actual 2087
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/alloc.c:5874!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5818 Comm: syz.0.15 Not tainted =
6.13.0-rc4-syzkaller-g7dace56f464b #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 0f 85 0d 8e ba f2 16 00 00 48 c7 c1 =
00 4b 47 8c 4d 89 f0 41 89 d9 50 e8 ed 7d 20 00 48 83 c4 08 90 <0f> 0b =
e8 91 bd 21 fe 90 0f 0b e8 89 bd 21 fe 90 0f 0b e8 e1 22 40
> RSP: 0018:ffffc90002a7ef60 EFLAGS: 00010296
> RAX: 3de6beb9eda26200 RBX: 0000000000000027 RCX: 3de6beb9eda26200
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90002a7f090 R08: ffffffff817f0a8c R09: 1ffff9200054fd5c
> R10: dffffc0000000000 R11: fffff5200054fd5d R12: 1ffff11007e58958
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff88804f32c008
> FS:  00007f7dae2556c0(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 0000000056b52000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
> ocfs2_remove_inode_range+0xff3/0x29c0 fs/ocfs2/file.c:1907
> ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
> ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
> ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2740
> vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1584
> __do_sys_copy_file_range fs/read_write.c:1670 [inline]
> __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7dad37e719
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7dae255038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> RAX: ffffffffffffffda RBX: 00007f7dad535f80 RCX: 00007f7dad37e719
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f7dad3f132e R08: 000000000000d8c2 R09: 0000000000000000
> R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f7dad535f80 R15: 00007ffffb564de8
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 0f 85 0d 8e ba f2 16 00 00 48 c7 c1 =
00 4b 47 8c 4d 89 f0 41 89 d9 50 e8 ed 7d 20 00 48 83 c4 08 90 <0f> 0b =
e8 91 bd 21 fe 90 0f 0b e8 89 bd 21 fe 90 0f 0b e8 e1 22 40
> RSP: 0018:ffffc90002a7ef60 EFLAGS: 00010296
> RAX: 3de6beb9eda26200 RBX: 0000000000000027 RCX: 3de6beb9eda26200
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90002a7f090 R08: ffffffff817f0a8c R09: 1ffff9200054fd5c
> R10: dffffc0000000000 R11: fffff5200054fd5d R12: 1ffff11007e58958
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff88804f32c008
> FS:  00007f7dae2556c0(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 0000000056b52000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>=20
>=20
> Tested on:
>=20
> commit:         7dace56f ocfs2: check dir i_size in ocfs2_find_entry


#syz test: https://github.com/Damenly/linux ocfs2-syz

> git tree:       https://github.com/Damenly/linux ocfs2-syz
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D12b4b9c4580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3De5ad6ebf66b1e197
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Da66542ca5ebb4233b563
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
>=20
> Note: no patches were applied.

