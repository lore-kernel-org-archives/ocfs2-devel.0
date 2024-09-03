Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F01B12E1
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Sep 2024 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725366724; cv=none; b=NlseO/Cmz4/oT2fUAOcZzkZkO6dBT1TcwnBQ6L9y7OrefwpSahWEjtf3rnrEFCdWBztPoyS90K/oAF2LceIPmxbMixH+0NysXEMitY60TmNut5k/+XAqJnYE2CFBW6tMFuUo9+aB4SWn9yjUZzQ3yyMTQ/zporv72+VE8bbj8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725366724; c=relaxed/simple;
	bh=wJvkkAwFqkh9LG7i3tDrwGeYoqWiVtR0TR3aaaHgIaU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=flGNncRR2SC+u2S/XdJ6piL25YVZVSVusxixSn0hGYJw0jSgelvbqrihEcviXkNHXkmnXgE6lrGx+bvm7a4oeuf6y31irMW98BMaDEsKphH0ufNuX6mbzjBL8SIejezGygIh3Ify8Ro1ToxoY7/pKd1uSV6SARjZ4pRudDDyEA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82a1c57f4dcso635081239f.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Sep 2024 05:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725366722; x=1725971522;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73CfKD8IJsXt8neaGQU7/N60BW2ml7fVPqmUt7/0+Ic=;
        b=lTUKafWcDchGotFZVZIrwOB6/Sp9V1uhjaH5AlbwxiUFM9GeivSNaD9KrNeNKeJytC
         lAeLd/LLKwkK2DNUfX8BrWZehsaIjTAbid8GQ9+PEKemTIwA3RIY472t+8e+IumWg8iD
         ElPQqrBO/wB0zkAzEjJIzmDcyPiXIXGo1SkJxxW84MShO32uPdKxXogz9vvuhd5clbr1
         xcwzFmGPWXSWorqhrNADrqxSwSA1o6PhckPWC6DraqciA6HcLIqwBjU9787dfEXb1A8h
         v9tS9s5sJ29qM/CPTcIFqX4R0+RdP1ic5NVbuIWwgxS6W53AJ2ScLR72S6cGdtbpjOAK
         +5Mg==
X-Forwarded-Encrypted: i=1; AJvYcCUeBWt1DDJrhPdGxfLOoBN68IWZY8HsMYirNexLbf/QolLpK54tdFLjOauIe2/XpwAVx5P4brsZcA6mHg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQFRU2b/8Znf4bJWWSf2W3791OSjt58Bk/Z+fVHU8cK+vBfhOX
	tklewtgUzpo1vlC5oRmJMNrD0xcs+F+2lvC7hvIw6jZyqAFDETggl+7TiLE85aBodB49tsz4iB/
	hZjLaWrVamM6CnASYjqLnC+zJNTJnnRjJbqzYSss6IXpxP37f/DSDA6A=
X-Google-Smtp-Source: AGHT+IFDB08SISapjhDvQRPxgF7T0pDDXhwUAoTPI+gGkKaLPrbec4TrE0dajdrtP1KE7sZilxfNk6WkGc7voOecMi/GmpU/X059
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6c:b0:380:f12f:30de with SMTP id
 e9e14a558f8ab-39f40f03924mr7659335ab.2.1725366722399; Tue, 03 Sep 2024
 05:32:02 -0700 (PDT)
Date: Tue, 03 Sep 2024 05:32:02 -0700
In-Reply-To: <b9efefaf-76ea-4ffb-8601-ad83b593ef7a@linux.alibaba.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098a0df0621363e09@google.com>
Subject: Re: [syzbot] [ocfs2?] WARNING: ODEBUG bug in ocfs2_local_read_info
From: syzbot <syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com

Tested on:

commit:         8efd4bbd Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10dbfb47980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d29b390765df150d
dashboard link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12198963980000

Note: testing is done by a robot and is best-effort only.
