Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2994B30FF3C
	for <ocfs2-devel@lists.linux.dev>; Fri,  7 Nov 2025 23:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762557845; cv=none; b=qiCtlZBCv6SvZAH++J0HbKlbjacA6HWg1DSYmGfGrQ6IUT10fmEFJ7DIjUpGz83oBdu2sSQOZbcGp4nPGqYd2f/JdqgPnjlcajym8D+gs3zS8zokB4V3Aurl61fKWQZ1aVVURx8SznwI+E8+t48iP1y/dN+monkiuojWJJt0MpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762557845; c=relaxed/simple;
	bh=waTYczCQEgp17pu5N8pY2p4t7LpMf8ihAJm6REHY4gs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=f4fa/efaeKR1/Za77qal/4zUyF0tKInxIA5lYuu2lbbF0bU6BfTuc8Tsu0GSgzVRIKSQTJGDYL98TgtCM03KQ8uC2pe3h/MuOjFysVBZb6XaS8xYNxMREqDFRMBHOQE5Q0bhwiGs+JpdSXOKF2q6bdNlSE8BaOH8l/6cpfSCPFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-93e8092427aso121870539f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 07 Nov 2025 15:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762557843; x=1763162643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fzLpJRcmjKGxH9fQR+AOad1wVu2LzjX8BEl1l90zEM=;
        b=lr7CPVKKfCiOZ1bfL0mDrI1YgKTdhZ40DPgbuJrM2dw4nZ61edV0A+hg7A8VaM/VDg
         GHyhVuMLKjDwlLT9q05t6VMAmf/2daG1NuyFLxpUuVrlKjCtMe2TUYwztAfvZ2ej4QcH
         qDwiKZVx7H0kfTUxLnPrDvYuvsU35tsHtnwvNIz4XuiOTpqBnZzSxTXQ00mTyl0zS7NN
         yTMd7r0TvDltQarRmLyP1rPmPJwFcMT3IcVcHVnRch86MbqXjt5cq65XuT1mIhnQ8+Eq
         vCgAQ7mwdo5JF7d0pBQi+fT39sL8FMtMyREpsNkOSrPmd9fGuERFTEjGJSzc/KIDGgL7
         ecEA==
X-Forwarded-Encrypted: i=1; AJvYcCW3Tfuzc3zAIz5xiwADyZxudBFS2YVnynFa/Hp7ObFzfppNPYkqTEPPoGafPeg1/kztaLQdLfbJ6X1o9w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyhwClfjabX0QcmnCBx5oyPMgRSFgQyvKK/fzFXpgjwvHPlIrBM
	OobO+kzx1cJDKfn14rrU7qNOwE6zMo4CHCxwXrnwnPFqey41/nkoYvod0SICm1bKb9S+TRtEDfV
	Ja8UFP9OEH9DiF9IMLXlOQ+vDMoD0OOgd1JAWMVqs5q0Mu0anruXJarx543U=
X-Google-Smtp-Source: AGHT+IGV0J6I+DXJpQfF6fhES1GNQ/0RgjaURIuPZSNGK8AGa3ZXgVse0VcqsgsbPM/KO2jufdcsY4DjyxH+Xk1q19cuIKHo/m5L
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:433:306e:2c83 with SMTP id
 e9e14a558f8ab-43367e6744dmr15574045ab.28.1762557843164; Fri, 07 Nov 2025
 15:24:03 -0800 (PST)
Date: Fri, 07 Nov 2025 15:24:03 -0800
In-Reply-To: <68ac2451.050a0220.37038e.008b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690e7f93.a70a0220.22f260.006a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] KASAN: slab-out-of-bounds Read in igrab
From: syzbot <syzbot+a77d690840e60bc2ddd8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dmantipov@yandex.ru, heming.zhao@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit fe7a283b39160153b6d1bd7f61b0a9d5d44987a8
Author: Dmitry Antipov <dmantipov@yandex.ru>
Date:   Tue Aug 26 09:51:06 2025 +0000

    ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c14412580000
start commit:   6debb6904172 Merge tag 'drm-fixes-2025-08-23-1' of https:/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1248cc42580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
