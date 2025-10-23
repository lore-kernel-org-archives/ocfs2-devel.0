Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492513009FE
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761208387; cv=none; b=NFE9VFwoGaK6F2qjphxjk1M27Mm/MWUw55Zy/3dhcU+OOhtkcedcMAapnZV6Qu63T8eYlE/8uHz4Fy1FlycRI/in93Gjy31+GDVIOnvpNCFkS/QRXWJfDI694Ad7591veebTS2aSW5O1z9zNdE4VfIP1VooRv9RIv04HZRMv7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761208387; c=relaxed/simple;
	bh=jva66kR4NZ3M1ov3McIzikQzcfgbDJM7ZZ0MaSesmb0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KJ1k8ebeLiLq+Oi6hEjXdFgnTzk4f5MEPDO1iSL5KmS65amSbvKodd8KVCt73eT0GLd9hz6BvATALO481AqR4FXzfHRP000mmJ4VzAuAcun9gwARA4qIrZvC7016UslRqvpaQOC3LJks55fw/2jsJYQmsyX8rC1Z35N/M87PM4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430afceae09so5988535ab.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 01:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761208383; x=1761813183;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bo0duX95EeaqTX/n7Bu28C+Uf1XrNKZNf+CW/BIermM=;
        b=gFzJmkheoPnUviSP5Tcbqd6xKPm11IUHVcQ5XPfyap5t9RWdjr65MApaGJTsbN/ijW
         g3HL0qoH5hHh4Bv9YKdxCfI9Ze//yS7aZNXdY/pgK7CR//3LIKHAgfPxDAZBFbGfEvZp
         TyF6PzULu2qLWchQSUsyEVjdpvI4A8Hwgxqj1TknTniKTEYH70K7ZCZ0coiHPbJyGEce
         X47qu6nJNffMB6qqwqn/7gLC37JVjMYzlGGWT84SgmVFiiFfgvpDXSHaQip6ZriHLY7P
         MCWzKBB/hitXbDgZXCKwRHJOV9YP9DO/euBLoFzEUiiyCEKTc+9gVew2ZgYsJ85MzK+B
         AoHg==
X-Forwarded-Encrypted: i=1; AJvYcCVR6hWiQhX+GIXVI5izaWFUXCIOJC9mpJ2bTqCXkqDVAImyr/4/kKRYMaS9wv+877QbRDWZYd7QRLsVvA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJyx4MLy+DFnD0ribz9mWiNZ2A7P7nD4D6jJKm5Aq3kw6YxiLT
	+SyVczv4Vd//N7eXIOlpcL0kVn6AAbSUg/+WMs8FK0oDgo1x1cb0idqHAnNKVdhEyEC9R4/KHZa
	dvjDVPjUacvma5g4dhpK6kfmC/RBw6HA1sDhKuj5B8hEiSt/y33DndYSgj/A=
X-Google-Smtp-Source: AGHT+IHF6OvyWR2tzTt/jUjGg88oGb6mphS+JUm7X2abQm9CNSmCy3hN5F5l/ZA2IncHZ0LBqfVoQfDH9qSN/LL0ssgazN6DQVXA
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d98:b0:430:c49d:750c with SMTP id
 e9e14a558f8ab-430c528fc97mr317958155ab.27.1761208383281; Thu, 23 Oct 2025
 01:33:03 -0700 (PDT)
Date: Thu, 23 Oct 2025 01:33:03 -0700
In-Reply-To: <000000000000cb688206213d1bda@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f9e83f.a70a0220.3bf6c6.0035.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_fiemap
From: syzbot <syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, elic@nvidia.com, jasowang@redhat.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	lizhi.xu@windriver.com, mark.tinguely@oracle.com, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 04100f775c2ea501927f508f17ad824ad1f23c8d
Author: Mark Tinguely <mark.tinguely@oracle.com>
Date:   Fri Aug 29 15:18:15 2025 +0000

    ocfs2: fix recursive semaphore deadlock in fiemap call

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bead42580000
start commit:   c330cb607721 Merge tag 'i2c-for-6.17-rc3' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133b6c42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b9a862580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: fix recursive semaphore deadlock in fiemap call

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
