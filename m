Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037691C578E
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Sep 2024 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726391585; cv=none; b=ZgcKzPvpXAM7GKxYHOUrv8peqcA9MttmUBKvlAQJYAalzubjrTS/ungbjR0Lxm8UFNiPmk7O/V+LB244U4WgBlJRbIEaWcg5/3sjwwSRNUY7kRtQuYbQ+cka23JbC7VvON7ZZa5KifTVvlnXRJga7c+USkHm8MGxAndjGnf+8TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726391585; c=relaxed/simple;
	bh=obcogjNcsqjeuEQcVMzw3nQV5MzC37SJTeEb1i3ZsA4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sSEesckqiU0PYTBoUrzvvrsmr02d2CK0wJXdDZLQfAP8hG8Ai6HlgvtJWXv8kWz5J9fgFN+Bohm6kG5kkRN3wp7XQ/YeDtiIOC7MCSlLYSbqnIhSnJC9SgTfv0g7XKYa82GrLRKo/Lvs8lnaciIrv7V5SRX3TtoNpUURoSyIsWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a099015de4so29389105ab.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Sep 2024 02:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726391583; x=1726996383;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nX/PHEcxAF6yOVeouz2VAmJYKjpm4n2mEyY9/W9VhY=;
        b=hmCPX6pw5fjqTxVtSnOpL/G2XEWOfXLlXFEsgZglsXQlz88V6jL7J25H/GRldrEmy8
         VqmoH6Po/S+OiqJzjhYFjfpJ3sm9sXGL5z4i18J0jRVCePG3k516ZWA55jHbvGf+OYpw
         mvMNxvB0K0NNlJ5vZbKuD9SZf42FbCgu7PYqsUz2UUf7+SD5Ndo1DJ3eKTfp0j6J3PbS
         XQ3EHClpym4AmdNJa1z9j7jn62Zo7Hr5CY1X7pI5lYVFWmIqf1NXMkFnrxyIBriKpcgb
         OcL3WA2nB7c74upwqldo+eFzhtYE9nNUdU9+e0bW/lzquiq1qFwW5pIqd569Qvn5oklo
         jWrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOAT8z7wHzo74B0cwrVgRddQuRdJcBQZUsSnsnDtFuVqQqLbVrajZy3deM0lKcLtIMYzIi10rkfOUW9g==@lists.linux.dev
X-Gm-Message-State: AOJu0YygJxwtBWSXSKS6O/JcWa+k5Walm50eBPjZCul7GhQxEAps0u1v
	dRRz/kepu9zv2pKQnOvH76WC1yBfnDrGyhDncYOY/Tt50x9iazpY37tt37+TanaUBhj/2aOLbvP
	NJ4dpRG9CfLgC8G5ceHh4MIfuY9dueJDLnfpz7nsnFgru/d3VX4eneT8=
X-Google-Smtp-Source: AGHT+IFkt6/rWrHU6SRdfTGZ5jbGwpASvKEEgPHh+DkBFDbmyxA/gLNYFAbBOUjMGepbj9wDL7QqYIFfGK1xvLBqZIpnKheRIyv/
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2147:b0:398:a9b3:d6b1 with SMTP id
 e9e14a558f8ab-3a08464e152mr107788645ab.12.1726391582997; Sun, 15 Sep 2024
 02:13:02 -0700 (PDT)
Date: Sun, 15 Sep 2024 02:13:02 -0700
In-Reply-To: <000000000000ac4a9d062044e498@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000c5506062224dd83@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_reserve_local_alloc_bits
From: syzbot <syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com>
To: elic@nvidia.com, jasowang@redhat.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	mst@redhat.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	parav@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a3c06ae158dd6fa8336157c31d9234689d068d02
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Jan 5 10:32:03 2021 +0000

    vdpa_sim_net: Add support for user supported devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174bbc77980000
start commit:   0babf683783d Merge tag 'pinctrl-v6.11-4' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14cbbc77980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10cbbc77980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c9e296880039df9
dashboard link: https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129a6407980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167617c7980000

Reported-by: syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
