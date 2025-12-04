Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151AD1CD2C
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 00:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764809191; cv=none; b=Q8L+8Ez7t8iUFhuWfzuLcRRg5qI10W5cWXbT1+gtAS3XRVpuVUM09hAES3dhyo2MJRFbhNJhs1PfjJiO/EPlI/u1UBlatfPpzRlqBgKXlVYHo+W2AT4l0/qmmYcg15KrY3Rth78XkiVX2DJ/wpbJwO2zUrAeqPehUWU1zuFLUCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764809191; c=relaxed/simple;
	bh=/Proxpje5Kq9U5+LGh9YjChxdtMfjcmxgnlDjrIvJaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpJSPQ0R73CbkCCJalfjkelteW/n8ZG3XVhcl4OUJS+v7wijnKhSr7nDnVkHxmHMtcNy0ZpceqK5Ae/GDVh1gBiTsmWoAMqICmFzPXKPG4+CAcWuGQlBEjC5uF2pU5ODGMMdemCjKmMDDhtZFm9sYRchfk48FSzo8p/pUFB9i30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqspxF8h; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqspxF8h"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so532489a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 03 Dec 2025 16:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764809188; x=1765413988; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3O7orj/gU5qxGlxOcOBJ9ZjiaJ1G9m77oYGF5XZ47E=;
        b=VqspxF8h13s0E5cobVEFYmnYaO0XghFVXGFQuaAoWWf+g9TKJyRlgb7W7tN7upb1Sf
         HR6h/hqX/VA2lLuQ4sGyjZp+3K2d7XOS1maGN0LRs38BT0hy93q3aHswCFTTM98RD1yz
         Pc0bV6ECB37d7l0E7lwX4F3Y23CEBljKWtI4hp0Uj1WLUZfgXSrKvz2aKGI6Ff9MNMXR
         N7pPO45/d4AvHBzcR6OrpHfg2oH+z+mag9pYGKkvj4dDxQB6SmRqn/C7aL7Kcxfc4ACV
         vHo0dRkm+MODkaQikz5BJIdXty+GDKj+v7HKnmVt4kHv6O9t2wfpE3E0zFUJp/jl27cS
         0nxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764809188; x=1765413988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g3O7orj/gU5qxGlxOcOBJ9ZjiaJ1G9m77oYGF5XZ47E=;
        b=SQZS81GUH2gMCfj2jzV+m7NiAXN5ufLi26+i717whP7XgywGDsrsfdEEhs/rm+6ERy
         080A3Dej+pWI/u3HMO5JiQHuBH0zKefHkXH04yejh9jpoi57cpgRItV1EZTOhlUvyPNI
         qpjsv2lxzkWg8ppyutZ1ic1g8LwUyL2qgp3/h7AwQ+LqoEVb3rriSI4vs16B6A1xJ9tj
         KGHwa5D3mxqbQNZLZl1IV8yur/XHejPdR2Q1z0Jszi+iXJZOyTAOSYDB89R4GeWQmJt7
         6OFBfdsYZN9orVIfl2gRv47OUy2ALMUoIDCnq8qs7h4OOZrjeNeVhfye7lNJdDY4oeaW
         YrNA==
X-Forwarded-Encrypted: i=1; AJvYcCXCbYbXlCkcL2slyDeeNRwYubDLNAOKox35NPNsQrvpfeisXF+d7C0LVgkV4cb/WDw5X3LGNrMCpaKH0g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz23NkCCDL/mTQSKVQCAw1LnXz68M/S/q3GFWM2+u7MCNqkPvVk
	buKBDIps2l6nnwsRdFUSfN3LBNrONRthB1QId05Do+BGVm/hV41Owv8fTjfwIhVg
X-Gm-Gg: ASbGnctpvgwVbmdjvZ0AN/9mutnDtUhIp6Hoai2iMQ7J/9QmZFIwwnS6RMMy4Ubv9t2
	FFgaJOVohWdG6K7ZzGdfsxIDs0ol04KQX7MWQAumfgE2pS2ru09PZZH6l7s/VPipxW7PioeZXzu
	DSPxnuPrhHKb+oU5i4yDOFDAvsebPhYFfEK4CRSTCfmRw0mdwbVht06JvXJrcXr7Tmq4uroOrJq
	BV1o40+F9Ykrq9+3VwCZ91CPcgNtSyhgQRxAQEAstOvi4nbSB5Ed7h/ZNZc/+Ln6ccZUJlBI+p6
	VTQZ7v+oUQV06LYbd7bomLUOI17yRyOhVil5MkngQ4QfjcctfGuPiHss2e8c6CxAW9LwtEr3Yq6
	iQzRHPhepyspDval/YU9yFi45R0S/ghqD+QzyJNqptHnSZpPbRuhsN5sF8CFMfT/7VhlyC8Mrqo
	ufCt5Lc5BHQ4ZVnKKd3IrV0bRJSX18E1bexxWRpGPjJgmKS5QKu/OnTGkR
X-Google-Smtp-Source: AGHT+IEykNwKbWaUQatJwFBnfSp0CrUndnWOa9ZCgPdLibCDsOt+oD+Hxo9T9dKfLs1QBkCyItPdAw==
X-Received: by 2002:a05:6402:2352:b0:63b:feb1:3288 with SMTP id 4fb4d7f45d1cf-647abdd9a77mr740678a12.25.1764809188215;
        Wed, 03 Dec 2025 16:46:28 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a6eca9sm19293843a12.1.2025.12.03.16.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 16:46:27 -0800 (PST)
Date: Thu, 4 Dec 2025 01:46:20 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
Message-ID: <6w4u7ysv6yxdqu3c5ug7pjbbwxlmczwgewukqyrap3ltpazp4s@ozir7zbfyvfj>
References: <6930d0bf.a70a0220.2ea503.00d4.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6930d0bf.a70a0220.2ea503.00d4.GAE@google.com>

On Wed, Dec 03, 2025 at 04:07:27PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7d31f578f323 Add linux-next specific files for 20251128
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1612b912580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6336d8e94a7c517d
> dashboard link: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172c8192580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c3b0c2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de/disk-7d31f578.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vmlinux-7d31f578.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab2411/bzImage-7d31f578.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/ec39deb2cf11/mount_0.gz
>   fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12c3b0c2580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
> 
> VFS_BUG_ON_INODE(!S_ISDIR(inode->i_mode)) encountered for inode ffff88805618b338
> fs ocfs2 mode 100000 opflags 0x2 flags 0x20 state 0x0 count 2
> ------------[ cut here ]------------
> kernel BUG at fs/namei.c:630!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6303 Comm: syz.0.92 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:lookup_inode_permission_may_exec fs/namei.c:630 [inline]
> RIP: 0010:may_lookup fs/namei.c:1900 [inline]
> RIP: 0010:link_path_walk+0x18cb/0x18d0 fs/namei.c:2537
> Code: e8 5a 1f ea fe 90 0f 0b e8 b2 96 83 ff 44 89 fd e9 6a fd ff ff e8 a5 96 83 ff 48 89 ef 48 c7 c6 40 d8 79 8b e8 36 1f ea fe 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55
> RSP: 0018:ffffc900046ef8a0 EFLAGS: 00010282
> RAX: 000000000000008e RBX: ffffc900046efc58 RCX: f91f6529a96d0200
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffff88805618b338 R08: ffffc900046ef567 R09: 1ffff920008ddeac
> R10: dffffc0000000000 R11: fffff520008ddead R12: 0000000000008000
> R13: ffffc900046efc20 R14: 0000000000008000 R15: ffff88802509b320
> FS:  000055555cffa500(0000) GS:ffff888125e4f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc32730f000 CR3: 0000000072f4e000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  path_openat+0x2b3/0x3dd0 fs/namei.c:4783
>  do_filp_open+0x1fa/0x410 fs/namei.c:4814
>  do_sys_openat2+0x121/0x200 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_open fs/open.c:1444 [inline]
>  __se_sys_open fs/open.c:1440 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1440
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4644d8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe02ccf2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007f4644fe5fa0 RCX: 00007f4644d8f749
> RDX: 0000000000000000 RSI: 0000000000145142 RDI: 0000200000000240
> RBP: 00007f4644e13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4644fe5fa0 R14: 00007f4644fe5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:lookup_inode_permission_may_exec fs/namei.c:630 [inline]
> RIP: 0010:may_lookup fs/namei.c:1900 [inline]
> RIP: 0010:link_path_walk+0x18cb/0x18d0 fs/namei.c:2537
> Code: e8 5a 1f ea fe 90 0f 0b e8 b2 96 83 ff 44 89 fd e9 6a fd ff ff e8 a5 96 83 ff 48 89 ef 48 c7 c6 40 d8 79 8b e8 36 1f ea fe 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55
> RSP: 0018:ffffc900046ef8a0 EFLAGS: 00010282
> RAX: 000000000000008e RBX: ffffc900046efc58 RCX: f91f6529a96d0200
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffff88805618b338 R08: ffffc900046ef567 R09: 1ffff920008ddeac
> R10: dffffc0000000000 R11: fffff520008ddead R12: 0000000000008000
> R13: ffffc900046efc20 R14: 0000000000008000 R15: ffff88802509b320
> FS:  000055555cffa500(0000) GS:ffff888125e4f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc32730f000 CR3: 0000000072f4e000 CR4: 00000000003526f0
> 
> 
> ---


this is probably mine, but first some extra debug:


#syz test

diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b9..0df3bd2b947d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1896,6 +1896,7 @@ static inline int may_lookup(struct mnt_idmap *idmap,
 {
 	int err, mask;
 
+	VFS_BUG_ON(!d_can_lookup(nd->path.dentry));
 	mask = nd->flags & LOOKUP_RCU ? MAY_NOT_BLOCK : 0;
 	err = lookup_inode_permission_may_exec(idmap, nd->inode, mask);
 	if (likely(!err))
@@ -2527,6 +2528,9 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		return 0;
 	}
 
+	VFS_BUG_ON(!d_can_lookup(nd->path.dentry));
+	VFS_BUG_ON(!S_ISDIR(nd->path.dentry->d_inode->i_mode));
+
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		struct mnt_idmap *idmap;
