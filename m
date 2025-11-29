Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45432255E43
	for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764443141; cv=none; b=rP8g+4S2HaGHCcmVn2eezj9i3wF3rbjYU6mmErFKVN87N7C0zywZAq6b9tl34l+7lt24WLFqlPTH0ryfNI0VwRgrVHCzqtRZCQlZYMvRBNDUw4Bh5/xFNzBvhlwonqQPzK8hsVGcWdkg6JsotXwizWl5SJEqzXNbeAv03dl08ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764443141; c=relaxed/simple;
	bh=4Plgm8CS7BUNJ+7oKCv+C/cFEwKHY618XTWx6oyzpRA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Rjky2S+rH7HV8aNLn6fAx+g+vgZcWca4dGxeHAKs0CBVIMwNe+EUzBFgYz10M+IyHxSndKbBSB2ctUtljTktyBl/DdMUTS1oaD5HMRiWYjXKfjgDlt1OZOv5W1DD3I7TxJyi+4uRDOhW3tz/fTMNTRscEf06VhPHvX1jBMyTPRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43329b607e0so19097845ab.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 29 Nov 2025 11:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764443139; x=1765047939;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFV2klhvX3KdWbx6MtBUgp5ytbVcmrA40AYH/DdVb0s=;
        b=DN+BB1A/U3bitxW0hqZp9K7jZooh1L5lEAwE+fxGkOe1upofw0rPcmYseEe3tK3NzU
         +vcxf91KBKhz20dnOD2jCXH0rgzD9AJB6xBmVOumMZ8uLap/F0sx6JvZVn7K51gOGmgK
         mskuPEKgJIXJvRw07gYBll8Vnv2Tvn0RNwITqzpc992oEedNx3SCbX0MUX9ncRY2atfL
         zy98AOpgmg+E/WGG8w2gZ/qEsjQJNsT+SNEl4mKjatTpcI29iEdTPAZsukoUIOXEvqG+
         M4x2QTyAjXvJxR9jtReqiz6vAAT/ITp8y4N0PbVMLdJr5OgUnM/caoBeMul2hc109QzJ
         3gtw==
X-Forwarded-Encrypted: i=1; AJvYcCXhXOCCnhQN8z7sksUQp0tow9813owaBmzaKKi8hnn88RN2qjOongMY9HGaiNSY2ZbJJnww/SkQ2FdQYw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzC/+RWK1gl7ldWdOgFA1abaUomjKAoeSCuT7Xd89WsXRcw4uzE
	4sBQAFAj41fB7VDWbnY2EZEJqNeAKN+AOPcjPHiiIrBA5c4BIgiqzEZzzOUovEJM9g8GmVwfxXW
	Fau/gcelqN9vY1m7q5lwrprGYRh3ejqfgyzrfMvVc2n8dXRJshMmtkOtpKNE=
X-Google-Smtp-Source: AGHT+IHMR+3xJKvE8Bqzs/XEd/UDzBocmwM2h/yDFlosDTc9gU+hS/s2AtMYwt4Mcbd0LNQhh0UzgLPgM7O3BeC5Y4e8e7cqoOT0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc6:b0:433:46fa:6a7a with SMTP id
 e9e14a558f8ab-435b8e6950emr257795625ab.25.1764443139407; Sat, 29 Nov 2025
 11:05:39 -0800 (PST)
Date: Sat, 29 Nov 2025 11:05:39 -0800
In-Reply-To: <20251129190507.543570-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692b4403.a70a0220.2ea503.009f.GAE@google.com>
Subject: Re: Syzbot test for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: activprithvi@gmail.com
Cc: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

I see the command but can't find the corresponding bug.
Please resend the email to syzbot+HASH@syzkaller.appspotmail.com address
that is the sender of the bug report (also present in the Reported-by tag).

>
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..c7eb6efc00b4 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>  
> +	if( le16_to_cpu(cl->cl_next_free_rec) == 0) {
> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +				     "Chain allocator dinode %llu has 0 chains\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
> +
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
>  
>
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
> -- 
> 2.34.1
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/20251129190507.543570-1-activprithvi%40gmail.com.
