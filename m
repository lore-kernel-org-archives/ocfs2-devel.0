Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5018C02C
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724154127; cv=none; b=tFwCJ0ssE3CCwGD93kWFPQITFi/8pOIqR+o0pYtg+OCRgwDILlDNejDX71Ex/U3M9uTiqV/Q/Zsnz8lleo2Do8gsjS71zPcr9pfghLw5OJ+hI0KSil+++qW1vJvEN2Dln8T/yTQRjDv9pCJJ2vLZAGUAInkdb+dVwe4mT83Mv/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724154127; c=relaxed/simple;
	bh=tGz0CFUpVz2XMmR3DZodz9LNNboiS2c4O6AY0YJbFVM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oLDhCTUgWcPaSGP8d3ifpOAc0UMQYEzBrkL4eE0YWEGJTRC1EIsDYR1XMpQMZbmL4oaz6F47UyvIn/hk9FQoH7YpfPGlGAtOK0LlocLSOi7wPhsaYLbjsqT6YvHJGk9qHvXGyjx/gzSMK4SVGnrKFZdq2YlPa76Zjb745+BzXzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f9612b44fso542911439f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 04:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724154125; x=1724758925;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oP+rrcaUj2pjmXYdxoX0IqYzciBafa45rW89d9lEwvs=;
        b=bmZiNEjypN/rB04dEuVomOCRyiXeIMNbKGtdIMf10BHXqLJSDRo67Sty6rDqX3DlfD
         K+M5nMDBedRBBhxSVAH3/KwHZW5YxJ6QKT9L7TOPXNjUyu2OfEy4HYQ7orszFhNtrbxo
         z7iPgfWOMFdyPSIX3KLC8zLAafAVSvZK+1rmGdyLjZo62WKZ/OVs3MdHeNnKxwPQfB7+
         zL3VG4HSP1YZ5eWKwzvTPD7CmeSlbI09Pulhzm4rtMGWww0ZBF3lNKysmcHVTU3dlxDd
         8UMxqzC6FlDNg2ZK5XXnSs4LVzOX1MvBm2E6moYrsxb4DhPMkpH8vANRM5bix06IJnKN
         SWAA==
X-Forwarded-Encrypted: i=1; AJvYcCUdji1298opPIvx3SggazIhYHYhxNLb8rzvh//hAofvuMQhpqvUeik6xC17MVYYewZinpfBas1A9rJ7Ug==@lists.linux.dev
X-Gm-Message-State: AOJu0Yws81nQ5a15hKaOlyiG0PkphDWN2xDIcIE0LfpaHz1RQis3vgnu
	ljDPqSMDb3dkVT+YUJHy+D/bli42cqvkld7g/juOlwD6Xxuw7fPWkaY6cMkbYrhIEMb5eg+R1Z4
	HFtCnoqNn2k2Lf4CszE7dHsAgGsu7ZtaJqd0dl9dMzHO4VjCMDhGYFoE=
X-Google-Smtp-Source: AGHT+IE79W/VMO1o2pdJVO+5dY6B30MzvtsxKxCPjHgfdpr0CDC05Rd9epPtPmgOvCbyHLkW8Ob/kzgilgljgruFNhuo5R47/S4W
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:410e:b0:4c0:9a05:44c4 with SMTP id
 8926c6da1cb9f-4cce13e9a9fmr610344173.0.1724154124900; Tue, 20 Aug 2024
 04:42:04 -0700 (PDT)
Date: Tue, 20 Aug 2024 04:42:04 -0700
In-Reply-To: <tencent_152025FEBA06BB5533C69ED71B124BA11B08@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002732eb06201beaf7@google.com>
Subject: Re: [syzbot] [ocfs2?] general protection fault in ocfs2_prepare_dir_for_insert
From: syzbot <syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com>
To: eadavis@qq.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
Tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com

Tested on:

commit:         b0da6408 Merge tag 'printk-for-6.11-rc5' of git://git...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15c8a7c5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=5a64828fcc4c2ad9b04f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15e4dbd3980000

Note: testing is done by a robot and is best-effort only.
