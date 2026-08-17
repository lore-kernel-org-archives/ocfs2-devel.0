Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DA43EC68E
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Aug 2026 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787008805; cv=none; b=uGGw5eCqxgt4JKb9W6B4gX/i+y0twxLthS8k1DmAiAv5d+bDdZwJJC0rx6FXK0lSEh540W+WtMzfI82vXM66jmq0jWRJBaSnCH5uPbUaE3HiTq1+0BdqlAno4liNd4gkGS9+JNQKR8cS0LmXD6av0rGyAHtBBT5xJlWVZoQ340g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787008805; c=relaxed/simple;
	bh=iLjeVV55Fcw34Rf9/V9Y7KfCCfd+XfalLgM/aPC/AZ8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ZlUabBfETS4e/b993pOG0BIQIAluNdyEQFFQgCT1zr5LeHlGczehIO+kkylDdibshWkYaKqBMou65zNieIJvsK1o3dKcReMnfsWnjxoKVJmpiKnak2F/jc/narB4kSM3rpGSOmqL11Ciy/Ddo8PL7t0sTVK/44J7x5dgPBT17yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6b026a31fcdso4434739eaf.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Aug 2026 16:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787008803; x=1787613603;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lgcDQhtaB4Hm6vLhZWeOiFt/hMdrxuNVdLV0aKbT9FM=;
        b=ntpaIsF4MuAkJdx+T9FATGA8ecFGMAoOP7eU1mNi6+EpwOXF6Y6Du0N9QNpQPcut6C
         PczKT9/sEEwwpurkA4mQj4FcAe8FI/sOQiMWHeMQXKMJLpHs9iP/z8XRYw8M60PmYwww
         v/3s+Yyhkle8/uf1S0PFMnsWA9XGQyK8AWbW4UYjXQZhI3qSen0X8RvkbZuDz9lbpJrN
         amZVhhbuGmhR6Jdgwg6NHOFjZEJVp/Zl6ZR3X4VL6uHNDIE8Rm1j/ZIPZmNfQWP1JKZ+
         K9TpJXgGGmHNuyVcZm4heHizpYm6SC+E/ulCnMhYEzFzDTlsoEAKgSPcD3HlJGrZ6q7e
         wpPw==
X-Forwarded-Encrypted: i=1; AHgh+Rr+9j4sLlDdRHOLcwRodzu/CgPxUiliVqwQrO/da4q33vdKmxQYmUT3g/DOwV4MXvOwfYeedDgH+tcscA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAJ5p2plLMgcsxgjbByYFfnLMT5pz6jWsmhE6INBNli3AaD2Cp
	ngd9nAdLgZv0rJXwPnRTLq6F14oMf2JE6xS6XeDYOkg+2nhCwJw9KD4gj+LUvNdV6XWxc7z6Qkz
	/oyrGkuL/CSpbiS4DDwG+nRXrzSXKv/v0q2sBeJ7KKWuS9J0YsKmTGRpm+nM=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a4:b0:6b0:4a79:5d31 with SMTP id
 006d021491bc7-6b0d68f62f5mr21095447eaf.30.1787008802761; Mon, 17 Aug 2026
 16:20:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 16:20:02 -0700
In-Reply-To: <69725516.a00a0220.3ad28e.ea7a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a839722.f7a79266.2f965f.002e.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_remove
From: syzbot <syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, nogikh@google.com, 
	ocfs2-devel@lists.linux.dev, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, teddy.astie@vates.tech, 
	tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f24df84cbe05e4471c04ac4b921fc0340bbc7752
Author: Thomas Gleixner <tglx@kernel.org>
Date:   Tue Jun 9 15:14:45 2026 +0000

    time/jiffies: Register jiffies clocksource before usage

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156f3949580000
start commit:   5862221fdded Merge tag 'parisc-for-7.1-rc3' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=7df4afa14aeda476a7a1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f2200e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ae9636580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: time/jiffies: Register jiffies clocksource before usage

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
