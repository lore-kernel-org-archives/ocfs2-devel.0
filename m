Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DDF2EE608
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765393808; cv=none; b=j+ioft5BBuJdCtrHJpmf0etScqq9vLlnpnKZzJARuo1suyygx/0dh8lEeU63RXHeEytH3zY4cSNNxCrVORmZFtP9OEi3+NSZObnGpSD82hiqZPqndTrHPPmVLnBX0K8V2KSUiX9Qp+iWF5fAmgJIr/fVHnid38D10oJIprUKeh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765393808; c=relaxed/simple;
	bh=Vm0ydrDzS5Kvf8Dru8NK4tCouNNSjGFUoEDoNmT6mrU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NO1Dw8D5cqrqawrnQttwbCpAv9LFGavTvxvTRWkKtEZ1qaJeunsKBR3nUa9uVeplY6PJ/JYw39558jsHXBNir7gDSS4S+kqY3iuaWQlEhwtVTss9PcxoYxOVvmZ6V3MRjgi4LOa/ZAE+O+BnbRqOl/DV5OVAsOw17gAEyDqhges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-65703b66ebfso255469eaf.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 11:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765393806; x=1765998606;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++8xteggjsb/xUOjCcZlFw6RFMLiYeZRmEplfqmrkqg=;
        b=aYhLPiIiHBxE3bgsXowspVAyoYNmpm6LR2reTn6lqe77mURb3Z3k6RluW4zgjqW0yz
         Cd83sn7vNI97Frmz1ZELyVhEaZNU2KGf63oW2fAzeRT9npx6yU7hjecxwCMdpQ2J3Jj2
         gHFZDnZ1mS+w3PS6+Gs/IsEgOYWOKGqh62NQwuv1nIxO17sjLev5GqwPJaHbX4JYrBh3
         PmzoAMArmJFLLd5TdAlA0dKkM3aHxfQBUl8TLmsWxyYIyrslviuz5y2PEBt35g1ts7Ks
         AwB+EXLWmHow/emY64+LpQzrmvGeAwRFRsfz0Z4yAWDAyDLFDH5ILA5Emf5ldWGnLbt6
         8YyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWF+M8GRFAC6zbVTAH84KfChki5ZQuW1MK48SWzvAqR/OzaNFe1nzkHQhggTcmEdoQ0E5v5dW/poHvIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwupZEdtF8M0xvyv2UTvUPxGdVd/9Xj5t9UXP07qgrNYORoRjU
	iYMeqbcZxrNOFiBxsE+t7bwyTeoZL33zktdmXYg/zMOSQmnMPKQ6EMHFLz34t+CLDki7Rey9rmI
	97oOeje1zU6KNlmB+13+04cGRw4kq+PE2phKATLut5cCKZus/A55gqMRziIg=
X-Google-Smtp-Source: AGHT+IGPr9o7NL/T+tH+/fEFI1IVxU6dSDdzJXaWKqZGhZ1Y1P8UQI42tJKWN53x+Os7oiVVYJDe2FFUbTQPKAropPvj12QJznR3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6387:b0:65b:24e3:6435 with SMTP id
 006d021491bc7-65b346efff2mr178222eaf.35.1765393806233; Wed, 10 Dec 2025
 11:10:06 -0800 (PST)
Date: Wed, 10 Dec 2025 11:10:06 -0800
In-Reply-To: <20251210184014.22798-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6939c58e.050a0220.4004e.01d7.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com

Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=132c3eb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17e43eb4580000

Note: testing is done by a robot and is best-effort only.
