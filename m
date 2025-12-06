Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9713244675
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765035784; cv=none; b=k1kFK6oJdqiWlR5VyF4kfjXfr+3A2CmRDQwJEu8PZso5vZYoqTm9ZcxwDGJp63KkVoFFoHk+favG0uKWCQJ0ObasW8qmmrs+VWaX5DrOhK2PqEE0QdFYSfnrpqUDgKl4NURB2ok8PzvD3l2r1jpLk64RHCY2ORYgHTa1ZNxZqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765035784; c=relaxed/simple;
	bh=+gNhZn9P3uGgQo9T/KUIxGLSJKvRdT3srt1ZjeO3EOc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MWc6/PCP6qTrUNQaP9KVL6IaUbdQvHAod0w6+ZUKq9WWwIv7amTNJ048D6/i+TwcJXz8OUxla58yO+r97qp1VK7QsnM2IEpIw24Dmk8/rrOS1iVfqjWGU9E0KkrrS8xyXQuQ8w9ykCVmAISImGHvbNet/9yg98M2u9WPxKdEQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65746235dd4so2111360eaf.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 07:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765035782; x=1765640582;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkZ3BUgxtdC3Jpxqqd2QZ8q3vqflHH3oAgxmShrb3fs=;
        b=LAlQmCEAVmXSu28aeDTYcylICS2JoFDhmamqbZnsuKTKwUlpJ2H27Vq4fPqN/ZYnTP
         N8eTuVZWyaIf6XvveX3skhmwkoOqVDyBt0ZlC1HDnBUEq5Oeonop0yDKBEq3Ydjd5ziA
         7aJMxfGkR9q7+WLJD+f9PSCt7KJDsvpY6stP6fN1cRXytbPwRBU6brUBfhap8XggZN5d
         g/DAUDHeqdkKQ18hhFO71Av56Xc/O9UcmPoP6Jn6Vwf30iFbEG89sorE2DKfvsRoVHYj
         fjW3ZkL2fCfTbiSgBG7HvFZXM0Xx3nQK4MGmx8PdERxp5GJ07eVDaTRroZiWPF/m+M+t
         wfFA==
X-Forwarded-Encrypted: i=1; AJvYcCUUHnhBHoA0izaB78hDRijCTmXIi9XoZxzhwjmDEiTl3ZmteYIMlpFwEpelyb53Gj7zYZg7O/6QpDtW+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxlDiY9cIcYvW0ChcOnDBlU5UYxAoCUN159p0K9rdwrXNBD4PHp
	BwMzT+9uufRE4O0/iUQZmBGl4cFk4FgnWvT4Cn5/2k/L1sunvP8oirjPtYNUU8td+Aj+ytiwjwI
	3GNuvm2oCo9QusuCzhDJBlCpGfy5q/M6zG0x8D5x+jCUSWUbjy/yma8663UQ=
X-Google-Smtp-Source: AGHT+IF8kWUtA1lEBL20RdWiqST6w9ernqVcruZdfolEGS2FZyOUIh2E65L+oH3SKCclGfbHX3RZDzShtPd3/edUneDDgmdisrlk
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:220e:b0:659:9a49:8e47 with SMTP id
 006d021491bc7-6599a8c4bbbmr1167182eaf.23.1765035782063; Sat, 06 Dec 2025
 07:43:02 -0800 (PST)
Date: Sat, 06 Dec 2025 07:43:02 -0800
In-Reply-To: <20251206152000.174746-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69344f06.a70a0220.38f243.002e.GAE@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10470eb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10074992580000

Note: testing is done by a robot and is best-effort only.
