Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4452877CD
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764574571; cv=none; b=TrxntS0+JJDEZGueS/HtM/WxwkmXdQpyYNWaL9yCrgB/rXAhWrCjoUHdSERfLM8iQcLuonZH7TgaKkwNkOpj3tzMfomid5exYeJ0Djl4aX2/Y+5/Rz1FCJ6F4rbLENoWsc58a7UwmtZA71DDf239O/LRIdSWYKhwEA7D3GgLigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764574571; c=relaxed/simple;
	bh=g98nUfZ5KoD7/0cFEkI0Ufb3Ny/tD/83BOyG0hfBt/k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ItfUJ7bsuhSl/eBqc0BuDFgT14uNAdpn+dV80RhddYa5GT/3t95vxESaby+bfZwrPeBD9Br0jPiNc9MUY+dbdz1u7aeofykmv/8xevO9P2tlja8b+AHoImN6Gd+hF+3lZ+6ve8V4wdU4HKMtOAzgkkIzMvoSTlr+pxbUX1aB3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43300f41682so24384215ab.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 23:36:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764574568; x=1765179368;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=430WqTi0CmldG45yTVrSKVUizL8hgcOGd57oatTnk/c=;
        b=BomkYwQ6w0oU7FOjbUo6CnhvPY00TxuM2UfzpG9HG16mKp3fke6ZLY686W6AJsJ+v6
         XALfV6UqWvLP1d4Jy2lvn2nWbYBfpzCK0O5SCMQ2FbT6zuD/XzmlyqNALYZDkud/swLb
         0URUH0LT8EgI5sG9DlCZlmLH9nlXYKBMY7xrv0/eekLAKwpE4AnQcitMNr+X/Ddawzr6
         tsibB5dApcgNva5f8dcrzUZdeR5pDa9mwVwSbGGLkrjUUfc2XaC/az+ll46osU4Hh5/D
         IcDoKDyImI4jODwmrf4h7Fw6skHZbWfXrynDWjbyMhkQUIdMigkB0b403M8zrm9e+LDZ
         5Fug==
X-Forwarded-Encrypted: i=1; AJvYcCXaKbds5SgBEn+PZsVHaetEYB4Begr5Ga3uYVWvGcEsR+r7ywp7snf/tCebqwZXEiu0qRJydRsEn7dUzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8tceqwf7x4ZXqTDzEvPy4p31KiGW2LXarUEKbrcV7DmgwDOZZ
	FeqSJ5gzeZdYoGq3sqD4Q6ROaVvGbMJEYoVulcfma3FSz/IKUTJ0lk80LPW3laXFbMpG8C1ZUZK
	qDJfHw7L9nAdVjCe5IdLkxsfV0Q4AbECjm/4oE7BcyS/0blfHk4nN4oiqd3I=
X-Google-Smtp-Source: AGHT+IGTy20eHPDZQFXzE97otIKRsGfvI0hGsx7f8UxIxazHRKA3VWFczeVWZJaRKfde/r+9Q5M2qZALd4VeU/qcgIP7Z6PCQ+ct
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f09:b0:433:72cb:cf with SMTP id
 e9e14a558f8ab-435b9852090mr330272065ab.7.1764574568419; Sun, 30 Nov 2025
 23:36:08 -0800 (PST)
Date: Sun, 30 Nov 2025 23:36:08 -0800
In-Reply-To: <20251201073538.47128-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692d4568.a70a0220.2ea503.00ae.GAE@google.com>
Subject: Re: Syzbot test for v2 for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
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
> index 6ac4dcd54588..f4e4ef08e0f9 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	if (!le16_to_cpu(cl->cl_next_free_rec) ||
> +		le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +				     "Chain allocator dinode %llu has 0 chains\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
>
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
> -- 
> 2.34.1
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/20251201073538.47128-1-activprithvi%40gmail.com.
