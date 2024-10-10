Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF6CBE57
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Oct 2024 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728534724; cv=none; b=Jmk9bvS9oHijutJirjK+K9bjG4HOSYO/pAz2KM+OzpK6V1XehqdGt5YmC29OYPWyIzf018FsQCecJBcLq2ws7bUrK8y83vEUD0ImdyADfAmOOxG+MiHtrvRQxclH1exbJExqNIigxgHmHkm2Epy3pyFipPH9g9Sqpr7heeFlJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728534724; c=relaxed/simple;
	bh=5sD1af4gith+Awmmh+0wJpTaScf7C5Zm8ofdPZIX8NU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=idTZuV+ZQVH0cA5T6VU4qXSStrLyZIexguclJI4+Nf7YRJKqh/0+8bgimydSGR1aRMSMg5pt/TUsT7ajP3ROWrrrIzKfMPakLEP6n4nsF3QowB5ZUUDLPUpPNUmiem4cN9Ur8cRF8iRay3VB6o9Og5wzlPnJEYV8KVCH8nzk5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3a5f6cb13so4929205ab.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 09 Oct 2024 21:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728534722; x=1729139522;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMpDAUxgPVVo0KWf9TTglqsCqzidS2Z3dz80X3V+fAU=;
        b=NtH3iMLgzjg8J64DMGVaWhSJCUfG/qm1I6RLod5nfSd1s+nPUIZdWdfX9Gv4umBrKe
         qTDU14Gq0XBB/+eTEsX2xHZVuTmIEtsJPA3DuqV5lrudaTPK+rEAx7Z1+2ibZCk4yUsL
         ybXlb1S+DLaBwr7rMe39/9ro2JTtYkaM9OMuapvcrA5tfAOPcTG8abh7WvFJhmou/SDp
         8DmG4xdxPzb44jpyTknE0VcOnwzuIAaAJB7ocDKoYkgiO/F8tum5Mr4SmD3uhV5zsi26
         e7wHqezrD1oZ8+gtRwYoOKAz4jCHX4upx058FLnpUzxqlULmlhF5CfPVHNi1BQEY7ls1
         6+2w==
X-Forwarded-Encrypted: i=1; AJvYcCXpoz9zo8QaEGTW5MHgwiHg7j5waldgJVSumRP0DC7mH+B2YptSpgUAiIvMeAeqW+OQWe0pRG86q07ZRQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzXO7uzcXlEeUrRqMyIxh4vjqsQca5a9sECbZKNN0K0Bg/5MgTV
	Q59k5jpgWwW733rRVNgYziGV7hMxIL+sB8kGJ2Z6X//0cwDdHI3RaeKYZqkR1Sj3QqYH5u0Eb1i
	5Vts9Xmg2JqSfCAyl+7KhY2O7bw1SUR3iKIP4mcjJm7MI/2xwiLDIzrc=
X-Google-Smtp-Source: AGHT+IFistMOGGyGr6Z3Ds0d2bojp+sLNDzqS4U7jqigj9B87caqrsghgcRN5OpwYBqK1sLvc2+M2nl9C16/nocKgBjYPH2VY0kO
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a69:b0:3a0:9954:a6fa with SMTP id
 e9e14a558f8ab-3a397ce58abmr37847415ab.9.1728534722587; Wed, 09 Oct 2024
 21:32:02 -0700 (PDT)
Date: Wed, 09 Oct 2024 21:32:02 -0700
In-Reply-To: <20241010040835.1648107-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670758c2.050a0220.67064.005a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: use-after-free Read in __ocfs2_find_path
From: syzbot <syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, lizhi.xu@windriver.com, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Tested-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com

Tested on:

commit:         d3d15566 Merge tag 'mm-hotfixes-stable-2024-10-09-15-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13f3ff9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10784b27980000

Note: testing is done by a robot and is best-effort only.
