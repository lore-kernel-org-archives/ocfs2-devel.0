Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3195824676D
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782296741; cv=pass; b=LRCH3TThbc2Zk4v+BxuzPhAz/mDFBAm4pST50qzgrLvLUjGBFLn1RfjpFrgmEqHrmIpjx1rjL5jyxDsJkKIDhn/kr8FwD+7T69x8qUGliHLtO0kxuZBMTTqLt9YrT7yA8hRUm5TYVA/ruPWaN74im/ld+fva+R5Z+0g16KFIBLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782296741; c=relaxed/simple;
	bh=EjnWN26pbmnB86c3h7kHTdieHB7EEupi8EYBZshVfWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMFpPRNZkRdMqPTp/nPq/ZIopgW6SpXzrJIEtK+Ie7GeBmhC5hb51gVFP7NWPXCyYF3Vj9hLxTLg1Wm6RNNmkZ1+hz/ChrNL3dG2If6b2mOVtm0dM4tUCVwklOJPUuPtO7NtRIj91M5J8m0SUZDR7gM6n5pQ2xAj/KwN9vOwm48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTkyKWDz; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTkyKWDz"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8051ad12d23so7957547b3.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 03:25:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782296739; cv=none;
        d=google.com; s=arc-20240605;
        b=Xow931HDSCI99d1QVRlZR5l2XB97Ix4ZFar9t0rLVusDSPiz6OeQ3L6tEEvrympOB7
         fr4Lso2FOL9ob26n7cCnsWPe3n7QHI6YFKz59BfpUFNwQZmlcCpp9AObAKuub4fzvEzX
         WpBh0XOZoYCfxJVzaPcYusSLW7KctofYxfxb4jIx/1LAK/waOdPQ3+CBPUNzh0gqBB0T
         vrvkSG45ygkrva/9n5uUnbUoXOlF6zvh04UzNHaDUpLRFZFcYfmREYV7GxJdbhu/5XqG
         SnY6laoUx5hjW/lg+MSo8ORrh3mEpwYawwaKH6c7HdRr6KTL5+SUFdATXfZu+Qg/OonN
         CH7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EpMsLCgxZAbjwZTlWy6YJ0yk/Z70oktNa24EbVZ6ozA=;
        fh=RQlyaYf2oPl8uoFiYKizd1rx/WkRtV5R0DclO28Me/Y=;
        b=hGI+bZnxspkKGRExjqc48qptvqnnYi+pxQoTJSUdAnPYth+wtRf5KXTDKepsPfRhTv
         lsI7Fcy2smVbEse5lDRI5YmOd7A8nRi09OftQ2xzYrNNcQsZFk2+p5ua9W2HAf5OOSqQ
         wTFuL/0jWIO59MCsR4KiOt2JsGjMn7wr/lgsu+x/SqF2RnjymLbkMlPDbxHRscuwElcL
         2oNX0KXaWCSz1QEbxd6yLpMDM1MBxGgnNf4T8+BTUMOar45qLz3Hlob81hLujxKmOOrB
         nns/Ff/xxYe+XPDgQNGm1BMIsDxXgS1M1Rk+5YZ2gxvNiYUvXU58F6UtDCiV9MND4drR
         cIHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782296739; x=1782901539; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EpMsLCgxZAbjwZTlWy6YJ0yk/Z70oktNa24EbVZ6ozA=;
        b=lTkyKWDzfZYux75buZZXLTP/Pe9f4iVuVFudndHXMdAr5daVTAxgqA/4ycoC1sCqks
         USb8BkMuRXYirZISfc2Uhdqz8BxopWVWoooo1C8hORrzjgYNHeHz2ZPclg8lCx/cUvMr
         FWdC3E4Ud28epdKN6igFYdyu7nNE36bsy74EuU4gfGkKcvj1rLHy8rJ7XayCNi8w+XHQ
         EXEBMzzQFzz2SQ/O20XzYL6fGN44j5w/dXNsJfZwmGln2YhIoSJiwrvZPO6NMLdO3bIm
         /RyUZTDgHddlCMMPkiH+DlcjOse1BLzdupgJowTwu/l0igLyJqkIsaIBpP2inWxaFS4+
         QvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782296739; x=1782901539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpMsLCgxZAbjwZTlWy6YJ0yk/Z70oktNa24EbVZ6ozA=;
        b=XlAM54L8ZVLVvpAJpR3NI0m82FajSAr7bYQvG0F9J4mdiCZxuV7p2+H9UMP4x55Efk
         tgs4ZUkrHRZvcM1KNZYSfA2Y2rcNrK6gLNvHx8LYOU6+fr4CKw17Vvtm6A0cvjBqGBmX
         jJ+f/07y4uaoJQ65pDRWSPYdCDa+Xsd7kElWgg1MfPMSF37mC1LOYzSB+VpcGHY/d8bQ
         BiJLeNSaN0G5kMlodDAK2PhsVl+WTw7n6NJYAGSutBKxW9liecv2rQeFqrrPn91F3ejT
         tbKtGegpBTuDrx2IEe8wivBskj7xHee86UeeERu4wkP7uuZP8B8PgzE0E5cepPxsDp5o
         uLTQ==
X-Forwarded-Encrypted: i=1; AHgh+Roczimv/dE8nuQF787vBMEmn7wRrxyhy67m8B8o/+JFVI1ZaCe0zD0N7bpsNQ/W2tRWJuK3/SYHuU8XjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTaO6jChA0Xs746nRtMad5bxZPkh8rJU0JW2/V0YV5OhY6JGcC
	CZb7f6U8VWHkVPaqwW0AMQaABUsJ782FwSRFfzpzgHqp76UyCX/v2YJOZpkXW/Hk1wnL+d3xb9K
	Nzyqd19kQI5kw1bvjZ1+iVaWjilOjQ/U=
X-Gm-Gg: AfdE7clUbDDEFznINm9jYrdMaC4ayYbbBlq9ldWbVFXN0I+PMXx192wcMo3X5mw2A06
	i7f3k9yJ2uMqal29YP3HZcfF3LKlYowP1bCt9CMr9km7CuPZD3lLNChtajUxIUBOI9ZRnRIhYEG
	wI2aAoy5he/gNQM67wn2rzGmbaSLdU61mWBKxIs2mj66op0o3HRsTLPh3mZX6AQiW186Eq1kqJa
	pTFlE46dYYbgmF6WP7F6tCu6RukTHRQROOjofFecDrIyNO6w6g9kG0IkBLYMZooPjFBapJRC4A=
X-Received: by 2002:a05:690c:9a83:b0:7bd:a4dc:c245 with SMTP id
 00721157ae682-807ee297ab3mr23892307b3.29.1782296739334; Wed, 24 Jun 2026
 03:25:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260622130332.2094018-1-zzzccc427@gmail.com> <20260622130332.2094018-2-zzzccc427@gmail.com>
 <d05e492c-303a-4903-966e-53e6aacc54b4@linux.alibaba.com>
In-Reply-To: <d05e492c-303a-4903-966e-53e6aacc54b4@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Wed, 24 Jun 2026 18:25:27 +0800
X-Gm-Features: AVVi8CdRg0V-YaNi03AhG7krjo0H3GtjqlmGEft8RX4D88ZzeZksCqjwE_X8kBs
Message-ID: <CAFRLqsV23o0-ofFxJoLFMPMCgqs-NPYykhF70_w+MdjwgGiLQQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ocfs2: validate inline xattrs during inode block validation
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

> Seems we can define a ocfs2_xattr_entry_type and pass in, then compute
> the size inside ocfs2_validate_xattr_entries().
> e.g.
>
> enum ocfs2_xattr_entry_type {
>         OCFS2_XATTR_IBODY,
>         OCFS2_XATTR_BLOCK,
>         OCFS2_XATTR_BUCKET
> };
>
> And here 'where' is to identify inline xattr, xattr block or bucket.
> Commonly, blkno is already sufficient to uniquely identifies the corrupt
> block. So I'd rather drop it for simplification.

Thanks for your review and suggestion.  I will rework this for v5.

Best regards,
Cen Zhang
