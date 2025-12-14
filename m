Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BC12E1730
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765738747; cv=none; b=m3wO15/AluANm3jYI1B7UA7rA3pKcuEZjSPs+RDu59xhz1dZcyd6FtA0fndiBOxg11zSGvxO+0+QDuYXa/Fnhuxphp37LQr9vnuLxRqVStUUgyzjE5oVLaEuLXigEGDzhCRK1vRXFvYvD3lIMD47Y7EAEa3jrQecRrVa96peWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765738747; c=relaxed/simple;
	bh=yB6ynOI4L26y+3FU6WNhELzuiCuDsnY0svrbpD3I6V0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=W2GWxrLTXCVmEY4yvPD/tD9OFyEC6ngAXAiktSTL+pzoHcA5pziJGK5CkVvclNBgLjbE7pT+Bt4DRTfyxSMdtCK/MJwQ/VhIR36St3T0V+W6V82xyKyw6htOE8iRYpvqfxXeNtVcIy3O1FF7g1T5cv+ws5p7Q2zmb5XIU/9V3Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-45396d397e0so2241206b6e.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 10:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765738743; x=1766343543;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKV7d64/7hB7AaUH6Ln502TdryLivU5cNzHk/1yQSH0=;
        b=mJcHPA6u8K0+DD8JDB3E48XN16XbJTQ+ToIowwzM/idc7HlF/Z60myoyhfy1Ma8RDL
         XiKicwfZa5jMbj4+PllVkSUnnWwjYC2NTySADEhVya49eWJ+tYGm6jGcu+sA34fwIKry
         4rwRZy8QVfdzU1FutM7mkDyjQA5yebFncJtas1FhuoNTjbNuUDyR8Vlco9jvoaK4S1HK
         9n91sCI+nwN8otz3VQ4sPsXKIH1izsKafIDPWSzslaOrnDaRuAp1VISO1A8G0fYBY8Dr
         2PRzSKav/0nu3IHawtyMlbMiLDFosBQrnMLHj2pHUX9FCBvLlQy2QWAg54L6fMaOJzZm
         iajA==
X-Forwarded-Encrypted: i=1; AJvYcCUOQrN0EvKP+K+33sDQ1qmcdR5PvUqgLV8bWCI5Jkd5IsVvy9FKDbq2CEcKwV7uwpvbrOViPDwlEypx+A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfikV6ORUg0kIal3T9kZBhJOU624nDvRm1i53NyAR4M9s4D1sC
	MZwadptQD7R5/DlGxv/TUKSDkqm9DDdht+GB4Ns+aMiMVS+nFvrCT2/vq+bS+9DzPTvKnHCUKuy
	mH6B/xu9EA2QcVmbaz9kLzaA7jwsS9P72loXKXb8lEtQrLFXABkK1NrJlgNk=
X-Google-Smtp-Source: AGHT+IGhM7X3Axv+kss48hfqlms2GxUAG9hrWYf1laCx/a0cuZEdmotnxlx2+1JmRKW0/ou2HVXmXt/NvxlknqDMaFGcPkc4wrva
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:298f:b0:659:9a49:8e63 with SMTP id
 006d021491bc7-65b45253c0bmr3937312eaf.51.1765738743320; Sun, 14 Dec 2025
 10:59:03 -0800 (PST)
Date: Sun, 14 Dec 2025 10:59:03 -0800
In-Reply-To: <20251214183443.21515-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693f08f7.a70a0220.33cd7b.00cf.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

fs/ocfs2/slot_map.c:136:5: error: use of undeclared identifier 'ocfs2_validate_slot_map_block'; did you mean 'ocfs2_validate_inode_block'?


Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=103299c2580000

