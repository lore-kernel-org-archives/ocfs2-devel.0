Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B618F2CF
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Sep 2024 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726971186; cv=none; b=L5mnOdh3aLaKfr/ZdfMzVKELA1KhpChHGOYWYG16hmyKUcUDpfDDHY6s36YadXE2C9cLPzS1b83+bNKTi3sfBiX55GFASnIfYeTa0M/+CJ23jY9pPUuywhCnBcqzGIohCiq4C5DNYY0oAn7NdYZUy1dkpeyUsXyNDL3qepJso3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726971186; c=relaxed/simple;
	bh=tPythR43N46qifXmGl2Sou0mptrtOYSZCbJV5vs55EI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Cg7Gxfo9d9OoM/w4kvGxWU8sVi9OaXFmwYQaA3TdGGQZ94HKoOcZzLHxglD7TqwiUc0ohkvEnypz5kwKFyESlmbysW+C1QzJzTfYJFGGmpgpe1IP3fDFFxfPN4HcVbRlOaRtxF6tPvSU12izbf/lbLVEgwzzYfCojK1FGzmD1aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82ce92f8779so322991239f.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 19:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726971183; x=1727575983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krDJ/VhAuktIN8TEcOdkBXdCHPqMNoTFdn0OaEq9HTw=;
        b=M1kX08C5lZNxi4a/bHd6nkS8sEVZXfDOa3btd/njjc3MaNz7dUYNXnqNrjcCiZLLaT
         KxvU4WgYZNFvbsIEsp2pnq6vvioCs8d1t2AcEby0xkeWsPTUq74OatlLrigePTIC4Sqb
         u8tEHmb+YIU2Vs7uwmmTBQ0RZdYJoMO1287N3NWvXFBW3tknS2ju5ezIx0vFoV1N3dfl
         VpnpHDySrojcspTvQGvV7CduHaSP9Hfb5jqhaOSwcN2dJi148T4Z6BAR6pyK8+xFmkZP
         DgzpnAMZsQACFeQN3C5fG7d5LNMdzFu1tatBqBOi10gB9+lTV3dmWcEnL6rWtCQN6zhc
         vcxA==
X-Forwarded-Encrypted: i=1; AJvYcCUqs/vlNHODTkNIPX9ZaYgt9j5cGTMbZAcy5IcniwfSwy6N3xmyVrf1BqYz32mgIK8iHKqyyvFdBOdDgg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzHCOVWsV7vm7cpJ40dm75sKBswBHe3THUsb6s5nrst4lPGrTG
	A8WvgWvZjXkBPlqeOJem8iRwK82P3dizBohT6ygGDrwzy3NaB06YS45q21U1pG3woDieWQpyh3c
	VvnyQe8+w5oHfYToO7Cph/KqBO7BG4tjUWAIUD2BJTLxoIT2YJdhGEVM=
X-Google-Smtp-Source: AGHT+IF/5zVBwYYrjQdOTmoArFXbIqkP5L6QVj6+aZygIuvFLDj+sOdWC+si3TJD9ySzJZfZbFNSmZ+L2FWNu+0UNMXCeMWVR49s
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:3a0:9cd5:92f7 with SMTP id
 e9e14a558f8ab-3a0c8d0b9e2mr73689335ab.17.1726971183622; Sat, 21 Sep 2024
 19:13:03 -0700 (PDT)
Date: Sat, 21 Sep 2024 19:13:03 -0700
In-Reply-To: <tencent_8006C812E1C657C99D2EF6EECB4C9E67CA06@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ef7d2f.050a0220.3195df.0079.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in from_kuid (2)
From: syzbot <syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com>
To: eadavis@qq.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

fs/ocfs2/file.c:1133:33: error: passing 'vfsuid_t' to parameter of incompatible type 'kuid_t'
fs/ocfs2/file.c:1134:33: error: passing 'vfsgid_t' to parameter of incompatible type 'kgid_t'


Tested on:

commit:         88264981 Merge tag 'sched_ext-for-6.12' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea86c03799707382
dashboard link: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17113080580000

