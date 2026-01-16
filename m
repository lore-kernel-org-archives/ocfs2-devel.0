Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22B91F92E
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 06:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768543265; cv=none; b=Tzj+sUd+AFHpEXaExwS1ckU1mbTCzHB1oEVRsYASJ5pasL+zEitX7FkEsrN4NvWGyi9LCsvnscUgVNjgxbF/mbx4pnjMC4Zk3AKpx9bhbSgEbJ+jcWjqhYQY1RMv1TktQK2uDRChWOFiK4+ex9IzOhrbBWuXUZ/aoWEFvKq5bRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768543265; c=relaxed/simple;
	bh=93I/oMEzhd/e3i+NwOuCZv4NZFaytmGEp7ozk/HGMh8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dS1mlnZLkQ5d6l28DdGg111ZpRFEoW18Q5fjGLVcUHbXzI0AC6nRiAb7o/L6QEIhQxnDtRrkldfb0MKrbVqofbDFWRiGeq4AzbtAMJtsihJ8nbz9Q1YMkKVFTlqzXbmsWrK1bHRWJpjFTyj8fQqQxnNF7CGQIVk8vSu/0XK3ImA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65f6e15ad8aso4381508eaf.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Jan 2026 22:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768543263; x=1769148063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqxeTpOTSPSaeYMkDqzGlSX59eRy8+Mpf+mJ9vwFUWQ=;
        b=F4EAntw+Tmeblhz0xdSgV8S43bBIZEGJaSTbOz6h9hyXujyI15zG2nig7PpNZPQfX1
         nYh7IOxCizkJeUQTP+CeT5CPNlPHx3UshyqNePLzMC1sPYCkigr/uzkgiYMRAVGYMcJO
         8iF7sBO2aPAHZZovMnmbDJ6QszwIJzzD8slQ2ART6ntVrFWmcjIYbBibCi9shqpdpUKx
         VrKAqRsXW1Ydcgeo1Szvftmo/ntyjuronEQBBqVNB7SItjjgmLXqzmwpGsFmT4R2/z+l
         5EwrzH0ZoMydRfGnD3r7T6yLs68PXp12zuApjeyrR4bbSo+jOz053A5+0NDM8NMuXr37
         z3yg==
X-Forwarded-Encrypted: i=1; AJvYcCWP9WWFHcz7OhDjWnwWEdVf4ipQ7yPxlLOvPCrA8cDf6j42EoQr5b619+nOVyu4KY3TC3vVTjNbyHltOg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWzrAuTeV55x0eDczPPwRoClsPWVVDh4i8epT2k7QGluFr84Dp
	d42AGTs5Qlp9pVPtlC7sSdAS5IvF+sxiBd/fINF8npGDfAiMHkvBPzQWTBxvuI7icUDBkwZYF9T
	X7H304n3/tMJZXf0YcDaRq/xqBKy442XiaYMuNP66Ok587Gm2QS2SbEzu7VY=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ca0a:0:b0:659:9a49:8e2e with SMTP id
 006d021491bc7-6610e65373cmr3170889eaf.32.1768543262921; Thu, 15 Jan 2026
 22:01:02 -0800 (PST)
Date: Thu, 15 Jan 2026 22:01:02 -0800
In-Reply-To: <67117fd9.050a0220.10f4f4.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6969d41e.050a0220.58bed.003e.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, akpm@linux-foundation.org, 
	david.hunter.linux@gmail.com, dmantipov@yandex.ru, heming.zhao@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, khalid@kernel.org, 
	linux-kernel-mentees@lists.linux.dev, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, skhan@linuxfoundation.org, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit e1c70505ee8158c1108340d9cd67182ade93af4a
Author: Dmitry Antipov <dmantipov@yandex.ru>
Date:   Thu Oct 30 15:30:02 2025 +0000

    ocfs2: add extra consistency checks for chain allocator dinodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=140a0852580000
start commit:   36c254515dc6 Merge tag 'powerpc-6.12-4' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13444727980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11861440580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: add extra consistency checks for chain allocator dinodes

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
