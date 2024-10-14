Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D7133991
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728908644; cv=none; b=Pb4kjC9GpRRcLZbq5E6/gJfrRtXgpJvuSG1h362spuYmRz8YRK6p87ZkidDjk2SStQ9IeA9u4jwia/hN5y6GGkHry4qsofmn9DWjiQ5h7cmNGHbY1meRQwCyqGh/goMKoHpZJv/y55t63OR0Sxtc9m0u0bURmgLkxNkSQIOh4/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728908644; c=relaxed/simple;
	bh=4uo1yrIKZRlZBhNcFPhEdGxh2rozWeponJyUN09cGPo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MSD77Ebn/21yVlP82oF8z9McT4ShNd1TwCYC9HpBtW7Dk2ktVsfxlYsECli0qjnkmp6tQmHE2IOkzKGHSkXjwXcx0xdV9ktEb38kZwtk5PWBsA7+CFrwENDQRqZ1CgpkPfcymCbmiiQ6DOpsog5R6Rmkef7MLflaiRyIU1Fpq4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3b7ecad71so13137335ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 05:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728908642; x=1729513442;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RB3MG0tXgK4yNbGMLIpzHlvd8r6IXM/6IENmhQbfx0=;
        b=ebd/ajm/EQEhkicpGCHiYv2ZH0PlooI9u8X2nAw5RJyGW8tKF68dHlTdUjGnQIdP1k
         Qoz50DkC5HKKPPLO1Py21O6PIGNo+U5WfLKIGwmJepCZ4r+ZlpSeLFvykdc/q4dZklRX
         xNTNcl+fU6LuEE7w/IXJpGpxuArP1HXWW1rEbMk+nmgfFqNckalgUBv6ez2BhucxmiTr
         /BTN0DqMacF2GEh3oDv4BT6//J/VuftYhXhS7ClANrnbqlPxBA5mgUw6chz5/bnaEPIw
         0787HZiQh4/1lYdd4uQbclLLXSV5CP3OETkUpyMEv34f37N5vHProMLtOm8x54Hw3Ovl
         ozJg==
X-Forwarded-Encrypted: i=1; AJvYcCVwtMsmuOCQPMe43UpE/S/EPLfkV1JVksnG72INQJMvS3Ygslco4XAt2e7Vh2MvXF70IHmrRmOB1NAfWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYccFmqmF5KjUy9jRkFEhGB5s3kWwmb/qOiyqK7vd01hs8q2oq
	GQDaE7R/MSLQ0Xdb4jNwQRP06IgJafZRv4y5oBGQC0l3h7p23yEa3DS3wYmGfUag19JnAg4FWIt
	0HpOBoj5H9eC+mpo3XSVcqy/WPpDNjD6HEIc7AzDGf15Aa4pX4lYmmC8=
X-Google-Smtp-Source: AGHT+IGxoGj8a67YFnUIJmALzL/ACJqsQ8w6PShHANxjqQvnFcbbipN6ft8JXniI7L9waVO51xsn1PRh+ed+T0u4h9JdoP0t53tr
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e07:b0:3a0:a80a:997c with SMTP id
 e9e14a558f8ab-3a3b5fb085cmr76536545ab.19.1728908642037; Mon, 14 Oct 2024
 05:24:02 -0700 (PDT)
Date: Mon, 14 Oct 2024 05:24:02 -0700
In-Reply-To: <tencent_C8EA75F1764366383C3F373A972436904A09@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670d0d62.050a0220.3e960.005e.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_read_virt_blocks
From: syzbot <syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com>
To: eadavis@qq.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
Tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com

Tested on:

commit:         6485cf5e Merge tag 'hid-for-linus-2024101301' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17186887980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=164d2822debd8b0d
dashboard link: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14cb0030580000

Note: testing is done by a robot and is best-effort only.
