Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557FC335BA6
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 09:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764839402; cv=none; b=eoqB9wGEyUx09ImY1tzLp3MZUWX0BYgwwYD+OmtUMRW02ZzE1lbyc8jUXx+Ya8v4rWAhhaBRWss7BY5DzpMRR06hvLcSFEWVBMDmlQ5u7neJ74NvE0u7jyb7WaB+fiuFacqkYN772/tIta6Lk+tOle8DyARYgNGfxe01JU3xN3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764839402; c=relaxed/simple;
	bh=8AUgLofeOx7OFuw3X6aHkLt2xv7vDwcIE+tp4GpvyPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGZxuuaXr3cGV9MTNCi3KJoMLRqzfXoeoaNKrnZQrC7sb4lv/Lighp9jLldLdpsVSowz85oHVosWQjEgwc8s3WqZRFJbBRY+Cc5As8mZH6lU3BbrZry3YoUv62asPRFc5Y/ndTPERzJpTBFMoZconXtC19oMRXrhngljkSz4O38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XbQjBFMy; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbQjBFMy"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b739ef3f739so103984166b.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 01:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764839397; x=1765444197; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7eqrke6HaexOshxGTADqdm1JSzGJXLvfmhaa3OBjdj8=;
        b=XbQjBFMyEJn1fl88Yzm02ruwdYeA4Q/mm8PZsZJtrnrOQajyH9GCwaSRTLnsuRUhGr
         AeGOnRFaFlm4bQ1kAdMoiuMAvHMOwlx+AhqUHkhsIR/1K3OwfJC8rImwdMml0BdopFFf
         Cf2+XHHI6/+TSJ1wr6XM4YAfuV0V9iV2M5koC3hzTq/T7Phowzj9d0hSHMoOgC4nmCzQ
         2tGjB9qDzXsi1E9FEa9NpoLA1ge0siBc3ls4b3LradEsDtHC6Tsz1cOe9UbVkq4dp4Wk
         OwhiRyFzuUNH47jMv0h9sOGCrqs1+WO9TkT2eARHC/hAm18AMVgxhcLMgr1KvKfdXnmE
         M2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764839397; x=1765444197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7eqrke6HaexOshxGTADqdm1JSzGJXLvfmhaa3OBjdj8=;
        b=o7uVrDHA98ybuylMe55tARVEQAngLkOyvif9g8e8GH3sUVCkANUFYe2jn9+DgmELs9
         cFmLHQAdXasT2uzKkJWtSyjQE7DnHHYtSmE0OBvrg/EkoiuirAVnJJobRtjNPnF94DOm
         r1Hd7tj6N3dRCKdPTTpsXfhNC/jhwd6RmKmyJOznVoKqPX/M2xb1Zz67tpku/LmzUCeN
         iKSnU0iUmhom8uKgql0ylP38+RJneaya/2ye9zwJ1/7TIG+2DGceUMuVOcEWRAWzMZpb
         iWCGcV7c5YWo4JK05MlQDMInwVSlBYTF9Y79RJIaQhkJD9eUvYa8GNSCmrkDCRs/DZTH
         DEFg==
X-Forwarded-Encrypted: i=1; AJvYcCVAnJub8BxmhHVxSjprifFMf/ZTEtD8c+NhOdBVGhwGonBPCoBZik3xqh/XP6TszgnBfDe+sOlDXx5KyQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyoEqq7z3c/C5pDVDJpDkCUnBT19b3sp4Jrv5BBReNw2v88JOwC
	LDY6SdQSYQN/rvLYn2ti9oZS9b/jYWBBLeyDQTZgaXrQp+1tSl77owiU
X-Gm-Gg: ASbGnctyVKU1WcTRd76FZFRPiJV58ZqJhUXrwHL9qUdY8yTkoB++BElvhAoltKfEIRA
	/H7FZY6HwaMHwS0kWDJxpIkLnpfdbzWE6MwP9UCkzdZK+xUiVu3JbCrBSAZRG55f+w+0gkVk2AQ
	4VJTTckNHlQjZv6zdG5CnKXONuYDy3pJhh+kZb87DTgyzwkXIWRuQ4+AC1W0CmlpJ1Ch26r9ypz
	Zvy3x+lod74RJbDTkW7BEIFw+LylDcHSfs1/ydDGrdQEdqZ/bvdKvkvVOd/QuGNzcVbITlKxale
	kDzN3Zx8hG41iZRc7jWzctx0weRLgPN8aFqwjaYn9jCVxMrnqND4Bd8iyknx/pkH03+isZAOxI6
	977tqeeJ65h38eUuT42+D7rvES1eUbNXLqvXwFGRLVR2vF34ym9RIJXYqUOIqH50KY6YTv99LsU
	u3mQxMp/3313WnqzYjfC42a+i94gwZNyukth9rXRGd6YVAex3tSGI/jK5g
X-Google-Smtp-Source: AGHT+IFbTW/+fHtVzDrjcryAcIHB1xLVq7wJo6ovWVsH10nGEfXaRnZ65K63K5Q3ny09+PmT45BMyw==
X-Received: by 2002:a17:906:6a28:b0:b76:d825:caca with SMTP id a640c23a62f3a-b79ec6740b0mr230359966b.38.1764839396765;
        Thu, 04 Dec 2025 01:09:56 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f449c375sm85120966b.24.2025.12.04.01.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:09:56 -0800 (PST)
Date: Thu, 4 Dec 2025 10:09:47 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
Message-ID: <27ec3nl274o3u3rx6gu6vqaqtwmmflgb45wflfyy3ihqs5w4fc@pdvkacnfnhrw>
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


#syz test

diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b9..87c99149a152 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1896,6 +1896,14 @@ static inline int may_lookup(struct mnt_idmap *idmap,
 {
 	int err, mask;
 
+	struct dentry *_dentry = nd->path.dentry;
+	struct inode *_inode = READ_ONCE(_dentry->d_inode);
+	if (!d_can_lookup(_dentry) || !_inode || !S_ISDIR(_inode->i_mode)) {
+		spin_lock(&_dentry->d_lock);
+		VFS_BUG_ON_INODE(d_can_lookup(_dentry) && !S_ISDIR(_dentry->d_inode->i_mode), _dentry->d_inode);
+		spin_unlock(&_dentry->d_lock);
+	}
+
 	mask = nd->flags & LOOKUP_RCU ? MAY_NOT_BLOCK : 0;
 	err = lookup_inode_permission_may_exec(idmap, nd->inode, mask);
 	if (likely(!err))
@@ -2527,6 +2535,14 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		return 0;
 	}
 
+	struct dentry *_dentry = nd->path.dentry;
+	struct inode *_inode = READ_ONCE(_dentry->d_inode);
+	if (!d_can_lookup(_dentry) || !_inode || !S_ISDIR(_inode->i_mode)) {
+		spin_lock(&_dentry->d_lock);
+		VFS_BUG_ON_INODE(d_can_lookup(_dentry) && !S_ISDIR(_dentry->d_inode->i_mode), _dentry->d_inode);
+		spin_unlock(&_dentry->d_lock);
+	}
+	
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		struct mnt_idmap *idmap;
