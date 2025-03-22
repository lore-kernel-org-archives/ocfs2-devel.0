Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05001FBE8B
	for <ocfs2-devel@lists.linux.dev>; Sat, 22 Mar 2025 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742665992; cv=none; b=o+h1f3HAXIgK7HoeYKhsUOoTxsk8x4LFwy7npxHHEhgzPNWhmRast5ypkAI0atqwpTKKxYBI6bSZOkCNHC75ROjooZi5JfjGH6T+67bi63D8KaaKUWDKOWa1p6szi2T4zySyM9Ummg+jLNagr0PaWMu3f4Kz5TDNXCz+H/uy9Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742665992; c=relaxed/simple;
	bh=tmtEIbsWyNywcdc7xXNKcatnpc3yUWgEIBW0lF0HLpM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eaJtxFu0sg9DUg/OWBIAEzhoNxWopcNHWINxd78gU6FZrRFselFqrdeoQI8EEKwO+GUEs11p6UdGP4GLMhYcLSUDimQtjaN00TcV0hDZEgsr2UmGtzkRm2s8t2wFqQ4bSdCheGDDCdhvHhRHD/X8ZC8WOE6zo92VI5mN1QrorYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/G7Tzd5; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/G7Tzd5"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-477282401b3so12426301cf.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 22 Mar 2025 10:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742665988; x=1743270788; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PBCKG58OWbq4NvEZOol9u+x0f2IAGLNFGfS/6kDnnOs=;
        b=H/G7Tzd5u5Cj6prLxbZIEZ6YBmi27UdGZGuLP+dQ4xTlZaDq1sEtmx/sYfORuTut7C
         YEEaP7PtPSJY6WqSFneAG6GRlboGhA89RKMT6G2wgjcqTuTWGqh0g1+Aan20vvcYkwEl
         0zq4yC3gxb0X9ajHeTBl7tDSUI9NNn8FzLF3a9pdT6XHOUxXcgJ2ivMzgVRkLc5GneD6
         KfKh22wqXJDIh/KgvfzyX1sYsHxNxTLol/MtwFpcivpwDd6GdCDEXTCDfhra5+ZKtF05
         wXrDfhL3QUmSYOcQSm+gSh5RAT7tM5eDwKZs+3G68YtMmMg6lRIUA2WgfhimGA5+WvJW
         DXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742665988; x=1743270788;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBCKG58OWbq4NvEZOol9u+x0f2IAGLNFGfS/6kDnnOs=;
        b=RHnTw6bL6LBcEQo36Iv3SXo8hxg3g0h2mLISgTwUTb+tOGfuBIujx8OM7RE65E3s4u
         hlQUJ3oVWSLr5sleuSTDbh2G1cHxWXlj0BBodxGC6CKini8gM+DEx0pmfhqZOytpXn/7
         Z59yjxcp2tL2DqaJDs6OZJ6ePm6uRtF+AR0mILHYIymsxSbyZzHOGfZrhTTZ2C6j3Dgk
         8f/IZDHHjUoz7+sIYzqrsePka2J57D9s5vlKXKLXnLNp3FXSNleVVtm8urZmsrR4UpRy
         ZcHLozw2D1qt52LdSFrzvCIm/s94ysUqJYvvIcx5b7kDruwyIbJDJabZ+lnHUnctzcpi
         0djg==
X-Forwarded-Encrypted: i=1; AJvYcCXE3YH4apBo9A/A4ICpP2e4EvX7EGOuxWA6lSUh8H1DL+HUxr/gMuW2wan/fKKL9g19LIIYPpTXoCrv0Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3TW30I5T+pHvdF/bg6JNaC7VN+1SJyyh9jp29ChNt5xjMTpXc
	hUGvA7NlSiSa5Euc+5F91z6ZfkeQwxyhjV6A6S3XMRkOFw1vCF6UhmFipzZcQZEUG+OLQMcKO9X
	xLtOQhNFYS4dncbdw0xj0J0B4EMk=
X-Gm-Gg: ASbGnctagZcpXTNp0ZMvNy1rNKrUiWrdlgCe2WOhvjsz1mrlHCWEUUGWgxieyI3ZZjv
	43198gdn5xpUXrObgLZISF5R+MRrlvLFcKWcMazvj2AntbJKlCdFarbSRYFJZLNVgsGFHHeBD4Z
	as2P59drq7xJOJfnLh4/hsyvPzW3sJEbOrKp7T
X-Google-Smtp-Source: AGHT+IGKK3NV4bw7gpIlEDbh27zEF4Gn+ZrEB8R9BgsJQaz208yDYG9AhP01a8FuE9lZ3805g1ZbUm04iE5GwYxdvJw=
X-Received: by 2002:a05:622a:4c12:b0:476:9296:80a4 with SMTP id
 d75a77b69052e-4771dd57f2dmr102326501cf.7.1742665988449; Sat, 22 Mar 2025
 10:53:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Date: Sun, 23 Mar 2025 01:52:57 +0800
X-Gm-Features: AQ5f1Jrp16QlfX2NcM--u10pTmWnZ6Q-G-eiKeKZdQgh0QhR53jQFg-Ds2gxi7c
Message-ID: <CALf2hKtnFskBvmZeigK_=mqq9Vd4TWT+YOXcwfNNt1ydOY=0Yg@mail.gmail.com>
Subject: [Kernel Bug] BUG: unable to handle kernel paging request in const_folio_flags
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

Dear Developers and Maintainers,

We would like to report a Linux kernel bug titled "BUG: unable to
handle kernel paging request in const_folio_flags" found in
Linux-6.14-rc7 by our modified tool. We have reproduced the crash and
applied a patch that can avoid the kernel panic. Here are the relevant
attachments:

kernel config: https://drive.google.com/file/d/1vHuHlQyiKlXbyuo03sZTiuaA5jZ5MtV6/view?usp=sharing
report: https://drive.google.com/file/d/11LD1uFid1u3r7brsvd85-SrBzvXwH-w2/view?usp=sharing
syz reproducer:
https://drive.google.com/file/d/10v3FtkewHcAnTjsUGqFCDl7k7hiCJ12-/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1L9WTVbO2pfqXLjXyQcMy4f-Am3obTJcN/view?usp=sharing
crash log: https://drive.google.com/file/d/1zwYU3061pnTSVIEpuZ-EBR7FYvWPxX4z/view?usp=sharing

We speculate this vulnerability arises from a missing check for error
pointers in the array folios[i] within the function
ocfs2_unlock_and_free_folios(). When the kernel fails to write or
allocate folios for writing (e.g., due to OOM), the wc->w_folios[i]
may be assigned an error pointer (e.g., -ENOMEM) in
fs/ocfs2/aops.c:1075, which is then returned as an error to
ocfs2_write_begin_nolock(). Within ocfs2_unlock_and_free_folios(),
there is no proper handling for error pointers, so the function
attempts to process folios[i] directly. This results in the kernel
attempting to dereference an invalid pointer during the call chain:
ocfs2_unlock_and_free_folios->folio_unlock->folio_test_locked->const_folio_flags.
Specifically, during debugging, we observe that the kernel attempts to
read data from rbx+0x8 (where rbx = 0xfffffffffffffff4), causing a
page fault and kernel panic.

I tested the following patch, which prevents the kernel panic by
checking for error pointers before accessing folios[i]:

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -767,7 +767,7 @@ void ocfs2_unlock_and_free_folios(struct folio
**folios, int num_folios)
        int i;

        for(i = 0; i < num_folios; i++) {
-               if (!folios[i])
+               if (!folios[i] || IS_ERR(folios[i]))    // or use
IS_ERR_OR_NULL instead
                        continue;
                folio_unlock(folios[i]);
                folio_mark_accessed(folios[i]);

However, I am not sure if the analysis and patch are appropriate.
Could you check this issue? With the verification, I would like to
submit a patch.

Wish you a nice day!

Best,
Zhiyu Zhang
