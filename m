Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09158140E3C
	for <ocfs2-devel@lists.linux.dev>; Sun, 16 Feb 2025 06:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739686265; cv=none; b=bq9p5+gZZFyq8nBNSPnS0/Ty5zSgncnMkCdbdpdqRleP5ATM9uO6YOjv2WjiNHvm8a6KOV7z/4IU8DT04x2NoIkJCqQ+f1Oi5t69uY59xafgVRWt8z/oxXPsBHt3b1Nz7To0Ed3/UFcBN4tQZMWv2nuH7fFfq0LShGbMmUfgyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739686265; c=relaxed/simple;
	bh=iLGpnbolH5+5uFQ9AF3pSfaKiI29JPa9lxa27DLdwew=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=L1QlvLIkXeKfmwGYROVlvkmONBqoB7IzmgKBkvdLSTQD2u0fI+cytyVOBZk9x1qS7OAYyaJB8d15wnPPMMKmyvFrshnTPkPOUK0pmsi6qbLQWLZQufmt84FE7fWLI23XwmDpwC18whlf5/FxELfkmv2gYpcvLQbZNKl8zMYd3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d187cab068so54675795ab.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 15 Feb 2025 22:11:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739686263; x=1740291063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5RQXIcx2qp8FY1Ol3TmBIxlirBrfFgu9UMo2NNP7n58=;
        b=jDUANh23a8BKebEUUftmmp1/Cezhi5oCloTf3DjSeNrJ9JQXR1eV3oBkOo+CQ+Kgzu
         0GlS0xdlH0qYkTnAu90IcvNyIjdhmEvncJvpaLUbDr9a0BcSApSsdISv78+Q7BKpuBOH
         BtCQcpNuP+LoTTdL5j/INI8lEtG6QO+0+OVvkYpaQk7nvYY1KsT0Z1Zz1ONaCKzExmIU
         ENsXEmR3HzetaqDvsOOXJzKjIgSclmQyJRdygvea4rPL3sqQcB3LdTZgLV/HlXiLafus
         ULDly9RLOnJ39GeoFxMDKndLVZ8/7iixwqqCkl9fB29dx4ryKSrtIAdLZCsUj0NDt9vp
         NOdw==
X-Forwarded-Encrypted: i=1; AJvYcCXimYmjaw3YltVx15i2VlG2Um6UVyfy69YrL8fTU1zsWR8LgVSa87nhtP2w0udZrJKnov1L5EBFp5FpCA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxLuBnaflqUvfWsx1xKZlNp5rYDzAD2dw6itTuLKhoRY1IJLkhN
	W80u6cFJrBXTzr5xzOwgItaTWcXH5YBkj6apnCokL/vUdGHgH+jqkUi8eD2lU3tjejS8q4RRD+G
	Gu/dGFCHVVWA1m8gAWmRA/Yc4atLtrWid6YJ0XIRMTNwLRL2NlyPVD7E=
X-Google-Smtp-Source: AGHT+IFB/Ait/METgdup/3vtWK3IG2/7Ust3BFMvWHwfNDuW/8r68ccLZFFqLsZFhGhclMLp3AxNKcTpyfwd2FyPZUhXRdCfPo7w
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3109:b0:3d0:2548:83c1 with SMTP id
 e9e14a558f8ab-3d2807b0f9amr43173555ab.6.1739686263229; Sat, 15 Feb 2025
 22:11:03 -0800 (PST)
Date: Sat, 15 Feb 2025 22:11:03 -0800
In-Reply-To: <6741d52e.050a0220.1cc393.0010.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b18177.050a0220.54b41.0004.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] [ext4?] WARNING in __find_get_block (2)
From: syzbot <syzbot+3c9f079f8fb1d7d331be@syzkaller.appspotmail.com>
To: Yuezhang.Mo@sony.com, brauner@kernel.org, daniel.palmer@sony.com, 
	hirofumi@mail.parknet.co.jp, jack@suse.com, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu, 
	viro@zeniv.linux.org.uk, wataru.aoyama@sony.com, yuezhang.mo@sony.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 70465acbb0ce1bb69447acf32f136c8153cda0de
Author: Yuezhang Mo <Yuezhang.Mo@sony.com>
Date:   Mon Dec 2 01:53:17 2024 +0000

    exfat: fix exfat_find_empty_entry() not returning error on failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d62bf8580000
start commit:   f44d154d6e3d Merge tag 'soc-fixes-6.13' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=3c9f079f8fb1d7d331be
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e302df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1265b4f8580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: exfat: fix exfat_find_empty_entry() not returning error on failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
