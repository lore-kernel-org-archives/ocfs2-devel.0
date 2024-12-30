Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B11A08D1
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 08:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735547404; cv=none; b=qBivtRF5vc11eXDq7m+PxAD4n+XKkN7p6/A4qsJhLdRhbglRi5mdGpwcSataq1zNmSEcBsSfZgaI1/XshdZWTjbiNJRHoqot31D2LHrPrfllwrHgWCzwOvPm3cQF7hMpa9q9FTAzm6ETzyWWDf+BxBn+Gg7g9+Aa/EPZUq6rY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735547404; c=relaxed/simple;
	bh=yrgvx5zv6UbGC7joq0o1vVxcBObcFdjXGqeccuK1Cjk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=j+Z2gJBRgXPGNIaSjK+8gcffmY6TKu4icfZNZqhZbzgLoNZQddY3KemtbwNWP+SqV8MeQwyLkTGjV/lkyj7onujfZSBQvzSqCIT8W+SDeg1XH0ezj/x6s+/ZPU4ksyAGcmBp5VXbmS4FbFJIKKH9YCAqDSMq0WxO37IjTFSvsvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-84730592e44so761465139f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 00:30:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735547402; x=1736152202;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QC0S9raidUkSN5tHkZjHEL+soiAwh2Y12sjxuTgr5IA=;
        b=cpt0fYJx9rDMuSk9ElCWJtZN7F5f7o08WHFa4fbFSykDyfapO4qTjxeUSHRT7fIfGU
         jj7jExLz74cSHXpPOVHCq6S8V1oU+IpZnojnK98dqzGL/oHPe8/b/HM5qLgkI0sQ1TNT
         i1Wdgkp8ap05B7VPVyh9riH9zghB3KA0AGTxZG4RAEGMt1JN+kBAM2z/biEnoQcadW9K
         nLhQNTBESeenCI+gl8zQAVja0D+Xvx8RGGc3aVlAprnGWpiIOsP7HeHZk7/LGhuPmuVY
         keacYOSWTGMqfFScYmzMkqIM26aM+dSw9Ck/GKlRJ5TvILNgiTqJBQzWeGZlIIYa4pmJ
         ZkyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqmXBqZygV23ueSdfJGyVBfglT9rUezxHbcjmykwEpYIgRnKR5tbzb2hni+4WrhVabryC+0d+wzriGWg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDOsk3hMknuch4tRognsuN0dKm1GrxPpT1mRbQJ38A560SqLwA
	b4tzOKjM9Z9ttpW/yjQYbOFPPzQSp99PgCq+kQDY2H+pPehX0BkorapNfykYZrC6vYuLp2iyFUS
	pGEEMOi5i7+MoZZ8sooTlF407+FOPHElZFrX67s51Ntac/pno6OGFVlA=
X-Google-Smtp-Source: AGHT+IESITfRlZ2rcQSR7cR0pqqa3m4lZuzlmbDO/GeX5IqRxfFoJVi4veHEEjBaZop1CDEf+4LxhiyqaGQnFipdnZxHXY4T4lSo
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d02:b0:3a6:b445:dc92 with SMTP id
 e9e14a558f8ab-3c2d2568b0emr287811225ab.10.1735547401961; Mon, 30 Dec 2024
 00:30:01 -0800 (PST)
Date: Mon, 30 Dec 2024 00:30:01 -0800
In-Reply-To: <671ff85a.050a0220.11b624.04b3.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67725a09.050a0220.2f3838.04bb.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_journal_toggle_dirty
From: syzbot <syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com>
To: axboe@kernel.dk, djwong@kernel.org, hch@lst.de, jack@suse.cz, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 98ded54a33839e7b8f8bed772e01a544f48e33a7
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Mar 30 05:29:10 2022 +0000

    loop: remove the racy bd_inode->i_mapping->nrpages asserts

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144cf0b0580000
start commit:   48f506ad0b68 Merge tag 'soc-fixes-6.13-2' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=164cf0b0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=124cf0b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=ea8d1726e1e3367085ce
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146998c4580000

Reported-by: syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com
Fixes: 98ded54a3383 ("loop: remove the racy bd_inode->i_mapping->nrpages asserts")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
