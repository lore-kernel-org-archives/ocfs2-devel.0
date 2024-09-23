Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294DE2C95
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 22:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727129044; cv=none; b=FHz4gApBpfYeiv1Kb/0VoCUipfiH+Yd6Co5RKNKvR1uQnEHIlfn9YB+87alfU6mlGHhrEp5YUziSOehSh5MKFpgEvqFq+1jAqu0SZTIgIhZiG4NCvwInZ4bXGdR3EHJN5yoVzSwBou0KQyVss9m83mkNsbbLx9VjLciaF6dv2cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727129044; c=relaxed/simple;
	bh=h/Kh/4ihRaTZWCDJUjsWAub24OCXdZphUlAwufe879E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dV7ZFhEO1S/rrd5q+CxLQiO6oJN8wgbilPWKyr2L4vDn8OGr3KCXsR8dZUBV8DaoovjCcTDe9gvzHc72iYEqtdgpJbHjZpt+ZZzk3d+HPwNlcwbIDITDsL9BZzys8fLt4+A9zagFEyTpyrWlPx7OuKBYPGlkQmljqz857DFTZnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0a08aa0f1so66202485ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 15:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727129042; x=1727733842;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQMax4HhqwTv6Gt4Rt+eMIQV9ULWIeqJRLKYlQdnQ3w=;
        b=irP4WEq7kRsUS+WXmoB+V46/wZHwsb/BlTzWQeqXYlyRLdkkuqzlnhwJrG5zHCWA1X
         x341vn8TIsV5blQczHY1h/fDU82WkRC8RmnlmUkEvPBX2x2CwnDTriwbTLim/QaQimX4
         qfMqazkVlWolG0wSZPQlteTbmnlCxf8jMVOqOWMpyg9fcEy5dvAafxtRfOPQ5+EaWiOz
         3HShZFxPDzpE/yI+mjzSG/pesxEXV7tqoRDwX823f4BAqPiD8Ir6RJ1v4sw3PdB82EtZ
         p73QlNhZaquUadEDGLv27OJm83Sn8K0Xz/P6fk6xX9+xbO3F4wtSbkY9k7epSGJ9mhX8
         F8xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhmeH/8RqOLfhPvLYCwYv2xlyhtuxQhpWpxEANPqwmr3Ztsbwixmh8wgi3TQ25wV3onjCrPec8OlR6WQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfRflxQtCC9jaKs/ApNOs5Lw0dsCdrGGgrklGotGpzC5LEiKt/
	YzYxHJYy/yHL7GP/n+AtVPyE6QcTrC4+tq8AmJzSP2kNKWKdAqLk3YoWtGkqlvejhiY6YyY26ZT
	yNNDTfSvFJaR3VzCgepjIyegfRSKMR/GwubbrW+mWWiiLUbYYUKwGvJY=
X-Google-Smtp-Source: AGHT+IHcOid/VFKx1yq8EM7fYZcnhzf2KHqDZPsgGE/+Ce1IK/o3bKwulkMGwU/7rKHTd0y5ctAOFNZTIVptWvAa//qymdmGDaZE
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2d:b0:3a0:9ea3:8d79 with SMTP id
 e9e14a558f8ab-3a0c8d12eebmr110480395ab.16.1727129042225; Mon, 23 Sep 2024
 15:04:02 -0700 (PDT)
Date: Mon, 23 Sep 2024 15:04:02 -0700
In-Reply-To: <00000000000032dd730620055fde@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f1e5d2.050a0220.3eed3.001a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_try_remove_refcount_tree
From: syzbot <syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com>
To: djahchankoike@gmail.com, eadavis@qq.com, elic@nvidia.com, 
	jasowang@redhat.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, mst@redhat.com, 
	ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, parav@nvidia.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit a3c06ae158dd6fa8336157c31d9234689d068d02
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Jan 5 10:32:03 2021 +0000

    vdpa_sim_net: Add support for user supported devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f6ca27980000
start commit:   de5cb0dcb74c Merge branch 'address-masking'
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13f6ca27980000
console output: https://syzkaller.appspot.com/x/log.txt?x=15f6ca27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=74ffdb3b3fad1a43
dashboard link: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f23880580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15851c27980000

Reported-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com
Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
