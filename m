Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F081E4AF
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765740485; cv=none; b=slRDGus9+xrFT2sov6Q3wss5sT27AJ0WmiHz6nA8wnaMQzgkkhvl8ielLomaNmB86LFxsyPqGP+RuMlkr51ncjMZrahNjV5P+YZpOTxhi4guZYLshP6/f5B2ghODoWNkrSBJAgNRo6lY/VfwgLtHDll+wBfcpj2zUzLOayuxGb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765740485; c=relaxed/simple;
	bh=8UmhtHKWMpWqWpDnJkRA/DdGrZl5Frw5XKA/M/wsgsQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qx91lGpJMmWDp2h23a5FKJG4ld1hEpLgTA82qopFcu90jMK0QteyNE2cGAYklZ1am1Pdyn+DQkixDYu7//9Q80kwKb+1NOhFSZAxNycB9D9lHCPc+0O9IxkceTZvGBZtlTA5YZxIoktcVnEu9zw6pK2wQPjlx6Hw39sVr07F6GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4510650aea0so4925840b6e.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 11:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765740483; x=1766345283;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e0V6uE3kxu97tWf7ZhLW0o18ehYzKv4vhG/Gpv7oR4g=;
        b=Kr1U2nuhQkT3Ol/7yFfZ1GkXlwJto7T0qoeMjS9NJxBCOqh90N02c2m4xne99tKFLD
         E06Kq3SU6JApaiAXfpsx0jZVkudpLJi0/H9QcQEmZnwnb7oy3P2yvzRyNamJrm3uySCY
         6MV+k5bVHGRwCypMBdSS6klw+WiX0lJaRTrDpncZhqwWYUkin80vBqQCHtxDf8mJSnDz
         q313MSPmd8r/MhHE8/Viarph5FTX2eImbdMwUY816AZw53ld30M99Bj6DwFpEjTNtue8
         W8fQa2YZyxy8YD+MUCM3gX/4/Hri7qFm7KZOPZ+UV6Q8ujNaRMAvA1zg5ElixFkpmoVs
         OC9g==
X-Forwarded-Encrypted: i=1; AJvYcCU/n4VdQBg9g14ekUctJ4GqnfXsQ6qwp/NR5wvQUF3uD/VoQtQ2mjSEzp3abnReVdb9sgPS4k+oSU578A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzmUKyLjZL0iXFZGFZ0ACU984K0+GTcfkeJ8viAecJeZFKXqXFp
	GVromUMOzhwNeh7gjgqonnqJjSPqztE/ktHGxmufgFFzl4XXEzkngbegyX1g97ynn8m+wkxx6Cn
	HuGVLnWWn3SRKMHIvgImd5NLIEC43/qkfYjlSWKI5CvcNS2ZT2GXzm+Qaj64=
X-Google-Smtp-Source: AGHT+IFqfKICI6fXdEoUInHVeaCJmCTFkT+2+wzsXMtLSf0oRZ6/3CtVmylpdpFwq+ALVK2+J89asMjpq3qJfYRgmy/BK/PtGQ8e
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1690:b0:65b:37a9:8b25 with SMTP id
 006d021491bc7-65b45287498mr4453652eaf.62.1765740482911; Sun, 14 Dec 2025
 11:28:02 -0800 (PST)
Date: Sun, 14 Dec 2025 11:28:02 -0800
In-Reply-To: <20251214192047.34811-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693f0fc2.a70a0220.104cf0.0327.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_block
From: syzbot <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, heming.zhao@suse.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

fs/ocfs2/slot_map.c:48:31: error: expected ';' after top level declarator


Tested on:

commit:         24172e0d Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10f4811a580000

