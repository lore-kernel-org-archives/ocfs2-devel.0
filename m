Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140FA3C38
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 05:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765774864; cv=none; b=KLK8kTgyXcALOz3mi09z92Oz0Q1BSh84tATv09q4axiGt4MX0Hv7LgI64lBypJGzhZ5Zy3eJsgxqw2zEJf0qqVESwv8cco7mGGnZ70JOUSQVKRNsjMMgS/eKrUjuiff+TmmpeGR3LXiXdvePcy1wRHTixRixg12daKduaK9VuLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765774864; c=relaxed/simple;
	bh=gLZwWSs4u+cruR2xgZMiMDVFAgmrPn2jph4iW9NNK/M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UXbLxiJ1Zi0N2KAWb+IfDipuuqaigN/cAYuyfWYRE8vdylGuWgcAE9hUL/n79qGfNw7kl+VNP+hEH3IeTk2xn+yY4wMyaj6Zadob0pqBFmlbDusnaBUBeuXkaJWQW9lmIMuIP4waATLi2GQi5y/ZPUBFXZ7lKXc520olP0erPPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7c7032a5b40so3498220a34.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 21:01:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765774862; x=1766379662;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKRJ1XRnk7KG3B+7Ar1huYVUWQfvzIDJvvwL5D5iHWQ=;
        b=cPF9lLZ74LLh9ahgx2nstrVB+irEfz2JRASGO2m2mNZKvKsSM4iERWQwyOuMNvgs7c
         DOcuSEcNllIOiXOOv3OgdT9wAGgG0bysOdNtPdpwvS5GzzsQ3l9Ve/wSDfHbIKnTClk4
         Pi+hlKUL5Go4liBjj+fINWW2haGI+5UqcI1B81cxs6LSL8pLTUDFlSsiYaWrxDkaHgSC
         fJoIO50VqSXxqlNjed80VzqKfP94TeHvVPICjt2XslmKwEPhWRVPb8g6zi1ppWJA7xVO
         9nJgcijQk/jTq8g5pZYUdfr+1W9966UpH29OO5vAIf6f5f0tAhsHxUEmDE29J2sTiGs0
         ZEkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMZxfRAOjdE6Ct/ryd19rcTEjpD0T6IySoOQH6IJ0VGOK1t+ncs199VlNNeHZUegofed34utvjwGSegQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywik5CkHmYFITeu9wxfJUdw54hrvSIWnFnXcnPCiEltq+FPyHvK
	0tPyBNL+sUw4zfHhxk6ubYXIlGLMZCnW0kO8WHLVCHT9x8YssqIwluDlsBX4L4e6wrluSr7+ZAh
	q3mdg1GgulDx/zKENGwfqSP5Lm5L88PYhh3PDz0DeFoH0Qn8ifKdJmk0/Gfc=
X-Google-Smtp-Source: AGHT+IHibkrkH09l6FBP8y118eTWtBoVaF/bC/rLQXiubSjnXp40wPpiWUyVa9HDSKrxP15gsEPDjoaC+FT73HD/+qW0/Qx47TMO
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1989:b0:659:9a49:8dcf with SMTP id
 006d021491bc7-65b4515174bmr4096064eaf.17.1765774862043; Sun, 14 Dec 2025
 21:01:02 -0800 (PST)
Date: Sun, 14 Dec 2025 21:01:02 -0800
In-Reply-To: <20251215043813.9536-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693f960e.a70a0220.104cf0.0336.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com

Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12c5d11a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1599d11a580000

Note: testing is done by a robot and is best-effort only.
