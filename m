Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58525325710
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765822928; cv=none; b=dAck18iJS1Pq1K8ZbAMH1MndJEKaBRLmIKCh1cIY1JCunZn9RUkpDi/ZLtCyj8VqtCMFPlbSyxhwPHDiXq7xdzT3tvfg902pMXnzW8Zh7H+PNRSGrVwQP/DgQ2TmMaVF0DPufO4EDuuPA1K/H3/62EP6wLUgGNXT+/dILK987fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765822928; c=relaxed/simple;
	bh=cxvRY8KlwlokvOGW88zzSDTM38EQTtRg2oG76aZ/sz8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FHFxL3K7CWospvzWDutx6Nu9EvgKlhIvPbmDsTiI1i1G7kVrDx+JBRR8BuEZDUOa4NCgUJEuOcXYr/jOeS8Kq/Ws5q52dsED1VRH6wzNcOSg0gAFhpWQXnu3RzaRvf2c6iYi7MMiPqjX2OumZjSj+lfySZzJ6gLRJjBiash52dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-453109b60a5so3079202b6e.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 10:22:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765822924; x=1766427724;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAizxGUytQStBcQGQv+a3E7N3GZNIeWabvxVqMv/qBU=;
        b=fcgG8Wxowf+ASBIa/lqEVdoaqg1fxDqYmpF+I+0j3d6D5vl0F+Gx7a42bThrP0iklx
         uo7rmw68hbMrJ1No7urhA7XgYxbj99I9L3a/mEywHEPhODVvvHGC/suTI+xox0hkMmoM
         KAwZYyWGiFGHjEwuvr8oONbsWBf0g0NWy8FmS5d17fzru2o9GI+hzoBDXZ3jVdPxdCJj
         lihtrz6FuN6LLx8kSARo84ehoB4W1dX//Mr7FMWZ69JtHM0zi0JRNjOiXSBp4kaUpW+A
         3T9ogHiQEF8IvDnvFWlbKkNLERM3ca+nzFtW6wAp6hoAWPzZTvlPbzkcyBuzDBi1urzD
         BI0A==
X-Forwarded-Encrypted: i=1; AJvYcCWiDJXzBBYEMH5wibDMWslpzMG12Eab8FnJnv54QNn9c7Jgslm1IIhVLQDwy1VAD16OGFs7KRdbRvg3ew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxd0V0skn7zZEXVAo2xh+cx/L8nK5uv/B8MhNakCtp5osylBw0+
	Urw/dwp3/5sz0PFxKCXDbx5ZVjF30hwglFWnsPU7RuWvsHqxHXX0zhF4wuVuyqHeGQqRlusuCjC
	Gg6vkKMqZq43JBWgi3QZS5pcleATcDxm4Pe9If5UZ5p0y5J2NOM2/ozKfW0k=
X-Google-Smtp-Source: AGHT+IF+Y6zIZgq7ekSBkd2aKGR+44nTCOeo0pC5XEg1Xhcy1lnq2nsqfHRZWZ6Chy3NylLsYjTTLejjEVx4jz52RmtYd11KWuGJ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1caa:b0:659:9a49:90ac with SMTP id
 006d021491bc7-65b451c2ceemr4853039eaf.43.1765822924347; Mon, 15 Dec 2025
 10:22:04 -0800 (PST)
Date: Mon, 15 Dec 2025 10:22:04 -0800
In-Reply-To: <20251215171602.20574-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694051cc.a70a0220.104cf0.033f.GAE@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=122439c2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17d0b11a580000

Note: testing is done by a robot and is best-effort only.
