Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D67F17C8B
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727688064; cv=none; b=t5cOy+hBqSPiup0Yv20VQg3syWDyHQY8QVteKlp6NBAGxbQ5/60l/uw0mHPdfcmIsmgI8OHGpXXlwwkdz8RrYncM+yE4JCwtmvELoN4x8iNvVOA+VOoGX5e/yVC8dQGBvfGNU3CWdrstuJ6uAyal0kdfPzksW2XWSQPwf2Xxw74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727688064; c=relaxed/simple;
	bh=SLJ+RRSfxIzeKlGc2Ua7t5UNFnR8HkkmUgO8NEber54=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=be+FFdfJWMQ6WR01Uai0J52q7dLgxAeKUPw9N4MiZ3RQi1HqbrgC3jdAQBAgMXAdDrDpb7xEMZf0dtoLEjTTEsj6tYmSTJ+crSfgRqw5RNZIOu3X5oGqhm43l2fmEp4K2UHvHl43mNVifEHdF/3W9L4MBqCOyoQBojbEx6dotEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a342620d49so34346175ab.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 02:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727688062; x=1728292862;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0w24/xfJIXAOeOh8EjVG7NPTqFUC9dPWQKNVHk8S2gA=;
        b=S5Ryiu9IiyfnMX5jAAmh45Ast76nYhbigEHYj6oGDzN7hG82AgikgPH1iKNLADspm0
         jHCerfpwSE5YROYHqI413J28UAnQf7BeBzpLLiTD2KsCVywibB+dUvzWd+fNsEYI7lXY
         Qr/fiq7sqZKscRz+8JCt/Hgovgq96wH2StTig5iw6Z25sq+EPL5o/C4/N+C9AGeh9UZl
         mJ13nYDj1OwcC+VUXs01SsojSVLtsOWgAgq4h8lkyqImR2lNauNUPWkpvxAcPWaQWGos
         WvZVXt+1PQt8DIZRxEEVpzUIz+MScAt9miIoKduf4fdeV+2KpWo8EM7E2YwFEsnkMMqg
         IUaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKCYmM5dw+bTUY0wCFTvw7KVwtl7ZHc+9cnv6QPj5ek4z0EecXzl0OG0TYZEUkqMrzw80lYaky3k7m6w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2Fckm9smC392wIC36bQyzWAkjhoM5Rsreiktakv2532aZEvaj
	ecUb6L1TDsGofCnQfENQeyaPygeasBzfquM9E6Dd0zqV6k/AuUULUwiZEl6lp8XOyIW0vkfky2Y
	Q9s/3ORKZ4KElw9zJ++Q2x9JXcRQXAFgR4qBi5JDUuQgHIKY7DkBA8o0=
X-Google-Smtp-Source: AGHT+IHH8uXRWjljiT7eyFQ5CxacmjCY1B/aC0aedcxVKrWCaeSzkIO4TAGOGZeRgl02hLHY83gIVx/VR6UdGQjARThBbsQYiUUG
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1564:b0:3a0:4df2:52e2 with SMTP id
 e9e14a558f8ab-3a34515ca34mr92890105ab.4.1727688061860; Mon, 30 Sep 2024
 02:21:01 -0700 (PDT)
Date: Mon, 30 Sep 2024 02:21:01 -0700
In-Reply-To: <20240930090009.174420-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fa6d7d.050a0220.aab67.002f.GAE@google.com>
Subject: Re: [syzbot] [ext4?] [ocfs2?] WARNING in jbd2_journal_update_sb_log_tail
From: syzbot <syzbot+96ee12698391289383dd@syzkaller.appspotmail.com>
To: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lizhi.xu@windriver.com, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+96ee12698391289383dd@syzkaller.appspotmail.com
Tested-by: syzbot+96ee12698391289383dd@syzkaller.appspotmail.com

Tested on:

commit:         9852d85e Linux 6.12-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d33d07980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e38805c95ef88a95
dashboard link: https://syzkaller.appspot.com/bug?extid=96ee12698391289383dd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10e36980580000

Note: testing is done by a robot and is best-effort only.
