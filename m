Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E98329C7E
	for <ocfs2-devel@lists.linux.dev>; Tue,  6 Jan 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767700747; cv=none; b=kIO5FdTLQCxlfJN1d9ZWtZAK/VfCE7iSoYkLhT9x1ona+cNTSNyvgIkPz1M7Oc59XpTCZMpVJ6yoHh2PtzFH2BsKF7i2SEmG0abXpqhKP8HlYqMWxhIvkcOTGQPJjN/rukFuHQOu8nGTqdksrCjg+jup+me1PrsB/qOphFpsgo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767700747; c=relaxed/simple;
	bh=VjRKbLDs4TGhrrQgaw5S1lRgUEWrdcAV+cFpMDnXPN4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kAiBPFur5Ya3vy2gs7H/12s7XxkOoSy2ot+qgZ9uul28T78vDah4ZmkpsjgBSq6C3ZYZm1aen2HDZOniS9z4GuPtR5c+QML7SPnSn7w7ENSSz/lB3mBxGSSrUjkoR99V0F8P7XIWMob3N1xGqCphzCllW2ULpME8kpHd/h0hd9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65744e10b91so1210007eaf.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 06 Jan 2026 03:59:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767700743; x=1768305543;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NveP3xCiM+ciUVqp1cRf4CAQgB0941ekTrV0WppkIos=;
        b=KCVQza28jtqp8VBiHiRhyy0LvNk+DTbM2pAErCaHnfAOWQ8vcj+zvNIV5Zj2hhTecK
         UlbPlJuANWKLiUscBsrDZ3Dswq+jNmPCdMX3P4ZTqS4YWJ3U6Lb4WwfMw0i+T/M/1ISu
         El/T5VKZiw5HKEKUzNVqqvuIMSLiCkTsJ2jQJQifboJrgJDYFX1QTy+8E/cKcTPjl2t1
         BTvmW8tTbfPClg98svBDByAG4OJyYhJVRa8pliqP0PsFG4UKAh49Q7gWO6vpb40tAPPu
         3g19ttfl10B6jDFIUwDWgQabAo9eL512tyHYD7h1RidD/lYzYqN4CchpqeJLdLSwU8dA
         1Bjw==
X-Forwarded-Encrypted: i=1; AJvYcCXUbcJIMdRc5WrHFEDzfnjm/1xKDQ0wQP4Xg/5fMC1abRtZ2LQ8SK51CmJmPx2b7/504A/xJtAXaujPFA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKjw6y6zh+xFKPcXPilKjCZIP+ybYvdBjKX7ddJUckIHRa8dbR
	AzIEuKF+gw/IuuBBNy+AKFTOjQrU1tOIWCQ0kQoGequR0XAmPk4o6COxEiIDY48r5bAltx2QMOD
	K39yWL9XNhp/1t9MU9xCw3JCQbDqQq8zZN7SDtIluiHrWYeCq+WKcKPzJOIE=
X-Google-Smtp-Source: AGHT+IGIe4FqnAyIQ1nqwg4+yzvrIyvGQkGIZ/ZaJgCUQVBco+bt4BNBeo0VtrWkgoa8R4f6MQu0W0dLmbW05/uoiTwmx+nKpqG8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2202:b0:659:9a49:90c8 with SMTP id
 006d021491bc7-65f47a68ee3mr1645395eaf.71.1767700742764; Tue, 06 Jan 2026
 03:59:02 -0800 (PST)
Date: Tue, 06 Jan 2026 03:59:02 -0800
In-Reply-To: <20260106113053.284336-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695cf906.050a0220.1c677c.033f.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_del_inode_from_orphan
From: syzbot <syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Tested-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com

Tested on:

commit:         765e56e4 Merge tag 'v6.18rc7-SMB-client-fix' of git://..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1723be9a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
dashboard link: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=107b8044580000

Note: testing is done by a robot and is best-effort only.
