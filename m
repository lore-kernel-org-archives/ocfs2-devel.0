Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FD21E1C2B
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 Nov 2024 22:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731106328; cv=none; b=D2/Us3HqI8ehsRoO8SlSD0ZslPbqH82UR5uoTAgE2jLDwLU3X/S61RZUgCcKD3jZvg30L4UrnmV7/MRSptiDh4KWgKDh9iSS19FWnYd51eY5Sx/6UvAZCvTGahzOOMBpt2oXvGh3EyHAuWgRSBf+CijYi9PnoV7dB1Ptv2xMxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731106328; c=relaxed/simple;
	bh=gXuLGF578FK4RZlFtxXap1q1f9VhDLzruBlXgif8FQ0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SG/sRfrMbAuU1Kbif+r4t8hZ+nAlzRVcMR8+FJqeV6ZIGqbEz0dHrvAf+EC9akXu2+uZrtyFsLi1WxRujiKIoz1YRq9Qoc+Z3+/OdP4cBiuyiZuGJrmqF/IZlKO1zfG9vkU2Y8b0hlTqyPBpB6HcJDm60xhviCW7jImtBEyv6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a6b563871eso30025645ab.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 Nov 2024 14:52:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731106326; x=1731711126;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIxqD+aLEH51VZN4dZGxv/q7c0bPHrWNxFiPAB9YqpQ=;
        b=LrBdajLM9qkOgfU5MI6Soi+Vr8yeob966uKt3cD2UCvVmzB9t7OoTpVqVdJpLJYLHY
         s/iqA3bGx9jl+2kUcr0hZY3v1cBhkqiuO+3rKUJofYGYJ1CQAE0qN0vfWKuELuNqXxq9
         NA83ozGnqQn0pXyAxELAQuktn0zSJ+Li0yYSv3l4qaR3uwR4T1jfkr55cJMBlxjPiYu5
         rHW5rGkM775iwjPV2tB+BjoTIFOXb0KwIfCnyBHZUdsws6eDIsFEd6flqKymMzTyXA2i
         pNRQJ5mfy5T2Vcrkl3CFwAGmRA8VygAjvu2SeFHKLZF7DI8ylwV/XLmMvVKZPKRlu5SL
         2Twg==
X-Forwarded-Encrypted: i=1; AJvYcCW8rrFrVdDiw7cNxRo+me/Aw7pO9Kzi9YiM6EOAnqwBCf1xACN9iLiCHQhfvg/geJW9FL+GwYrwNhCxng==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqbQ78JQ9bfd8wIpXI7G2culf4HSJ7T78GMgzv74NnL4BLuaSl
	0emSFViK3O53CnflckSV6UBv/tJpfuPx5q/v5BbE0aGhVszLCzvisJQ0KqdeYvQC+AX+WWZe97A
	dX0Fq3DxkdsYcZ00mtmlfWVElMVyRpY47GDWIMRQ/XuMf9WoKkCm1uBk=
X-Google-Smtp-Source: AGHT+IHYLwe/jDyb+uvjyVbo2F1hg9+ZmWROr3ediAD7vJOcWA0mv5EcUjS01nO6RSDEi6GiY7/7geX5jGYVVDzYIXxXk6JH4klM
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0a:b0:3a5:e3bc:c1bf with SMTP id
 e9e14a558f8ab-3a6f1a592f1mr54177235ab.23.1731106326139; Fri, 08 Nov 2024
 14:52:06 -0800 (PST)
Date: Fri, 08 Nov 2024 14:52:06 -0800
In-Reply-To: <66e9830e.050a0220.115905.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672e9616.050a0220.138bd5.0034.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] INFO: trying to register non-static key in ocfs2_dlm_shutdown
From: syzbot <syzbot+d7935821694d430624ea@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	ocfs2-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org, vvidic@valentin-vidic.from.hr
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit da5e7c87827e8caa6a1eeec6d95dcf74ab592a01
Author: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Date:   Fri Nov 5 20:34:49 2021 +0000

    ocfs2: cleanup journal init and shutdown

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128b2ea7980000
start commit:   c88416ba074a Add linux-next specific files for 20241101
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=118b2ea7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=168b2ea7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
dashboard link: https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1445ab40580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1200e987980000

Reported-by: syzbot+d7935821694d430624ea@syzkaller.appspotmail.com
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
