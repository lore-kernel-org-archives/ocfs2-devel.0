Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45F02E2DF4
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914069; cv=none; b=lETL0HcljkgT6gBgWsNt6kqoetAli73f6oLgdNrcDpjgWJicsqRgBcvZQbmIRoLBccJN1Ne2OOIfi947edtjrZif96xfMczWgYL2bgFradzL3n3ojfX46DW8zxa/EDvJbaQlMvsZTKrnPBYh65DAF9azfGlj+wm8GrqEFHSmDjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914069; c=relaxed/simple;
	bh=UvtW+SBHaB5c5FAgIacC3Qy1p74nG2A/tUHFiFpPvU8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Z0artQPeetJiKbQMEPvWdWBNx6duUeSf8B5P85NN/jJ8gq1zpLQOb3gZlCLXbUWg08LZfp0vf6fhqJWKBH6ebHddAla+j/LDWzoEvUiCf8sgDAWu1sHQUdQ4+deMKdZV8sqJSDL2a+/cqyLkPXui0vtBa7eJ+xarMkYjjy6+DqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-656b7cf5c66so6903148eaf.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 11:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765914064; x=1766518864;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4QppjgcUxju3jmB3uSUdbwjBP+NNUGPFxJdNMMccMk=;
        b=hDHEs5o+4W2cAxP+h6XkmJpjtXblGa0gcJeKx2+n0lL1pyB/ySPLCgcviIShd+yyrP
         298TcELGp6CutNBJPiK3p4o8GPDs3BGMJkr7XGMD/vqrpUOwJbL6I5YBEbaZCGZqClWK
         LldQzAGJSGwqKmBwI+djoTgaJ/tBBlqK+zfosgtEuAV3oqtW9uc0L1NbMrOPZKQviZlG
         OO/fdsKkAzZGLHcL8zEN0K4nMtyVja+P+7yXqA78ERQuWN0deH/vVYHDNTrT7suD1hJ9
         b2gMgU/9S+5m4kfo8B+ZItbLxG8TLvqLIPmeSQhQNMYtqExNmEifeFwsoyPU1Dy3Nf6G
         /Y3A==
X-Forwarded-Encrypted: i=1; AJvYcCX4t23ZzA4N+PzkzMplDI+eGQ+WUnrgUHn/Ki/EylSGRBS44c3+l+bj5hcHPdPZwTgFwWwv3mrp/6Uz2g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLNl1ZGpXxZLnqp/aFtwkiE2b9odJYRvw1FT8p6cgV1uZS8cmg
	MLg10cmgh8YeUS2/i7eLNrgFda3pUD6/gXNvD1+alSa1tis2/rnbkCLea2eqHImWSrFihmaUw/H
	GoM8lB30Wvywy76VAcD6/Rcy5z+ka9plPDNhEnDdLUF/M3nHdL9D/o1LfPgs=
X-Google-Smtp-Source: AGHT+IGdKS5eWI8QwQsz9ytKs9lzEZF37vooPrmmu8JJ3NTrNoAHYvwuiWddHQSbwD5AJ/ldZ+EkqloW2nkhlPNH6u5VzkKiZBjF
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6aca:b0:659:9a49:8f28 with SMTP id
 006d021491bc7-65b4522426bmr7001029eaf.57.1765914064393; Tue, 16 Dec 2025
 11:41:04 -0800 (PST)
Date: Tue, 16 Dec 2025 11:41:04 -0800
In-Reply-To: <20251216185221.31843-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6941b5d0.a70a0220.25eec0.0007.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_populate_inode
From: syzbot <syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com
Tested-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com

Tested on:

commit:         d76bb1eb Merge tag 'erofs-for-6.15-rc6-fixes' of git:/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1479e77c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b20d1657eb8978a6
dashboard link: https://syzkaller.appspot.com/bug?extid=779d072a1067a8b1a917
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13c41d92580000

Note: testing is done by a robot and is best-effort only.
