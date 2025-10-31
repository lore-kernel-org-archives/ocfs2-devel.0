Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E321FF25
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919522; cv=none; b=YZMqIMhl4jCIVNEW2VdzDE++6n6SESpOAye/1SxEIftyQIlRtFKyf0TPmp2h8j1XTRWj+RFi4TLfGhnZC3x6OnlOODYqcrsuVwvlrQlWEJMUc27i4Aewn/evJtCyP+TTZ6D7MLve6+TZV3AKjSikyePZ+70tDVbqNKc61kiA680=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919522; c=relaxed/simple;
	bh=ckWEHSYzRMCQdSdV1+aItXg+MoosM9PmpiIfZ+3IkXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDLRHEjafimp9HRdC2elgVs9SR1yFwNmAjTW4VcbCpsjx0BRGA7tAOMI3gniGJYut4S03iLjnVm6Mb0FsFfuQ/6WSIComak4VE+SyFTc8p/DhG+tiqqIU6/C6R7gseWcsvNfKAyf74GWZ0eK/5y7E2iYWbKWx8RN9KWsEawsmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XLQX/EbB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XLQX/EbB"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42855f80f01so337829f8f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 07:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761919519; x=1762524319; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UEEYMKZKM55egNcS9TLQLwdFtLgzGx5oRqh6S7KgDlc=;
        b=XLQX/EbBD3N1SmlBrBKON/wekGUO+215v6c1zXlqLXHK2iUU5/cNCEDMs5rlq+2Nlx
         8xWea5+6giQPS+aqSQa/xltvQ3fvfzOGK0m3N4Msstht4Zesq6e7iM6ZKKsuIpVWAVt3
         3mYz3aghGHGkiSrNiNcMdUJfGn/5RrARMvUMxyyTNw7dmL6RMzm9xpX09x94eMnnhjVa
         YLVaVS9Sos/6EA9lwBlOxAwLCaBTdzqNCczt3jY9s+YuBecItz0ETcKyaBowOxuSBUdX
         oHS1qI7xoMBRpeT3Nt9MbjX3k7wqEbkeMY2tNIL8bIK9jm+VUKtVbMNRazG+jFFqqnba
         bdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761919519; x=1762524319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEEYMKZKM55egNcS9TLQLwdFtLgzGx5oRqh6S7KgDlc=;
        b=kyFU0OwkL4YK+YVsHbw9pBbaRTz7B9HDVr/5u6nz9ESjuyEsdSV1fFuO0iwHIoSCf/
         WBJqLp6xNUaCwfKMuvffohEb6U4RZTDFih9uFksK2r/KM9OwSuT+Re2ZImCzlK8ufDDN
         fAGD1c3lUOeK5Cyfa4JgaVJANiet0D2D7D1SxgFNI6xuFtWkInogPx0ZZe9hBW2e54Zd
         Bs35mX/u2eepAgCmHFsKrAGh4KI8DSB7KvxRX2p8LFGNH9P1RzbcoG3pe7yOLRBCpcM4
         gkB1s2OSKwFURk91vFOgDPZ0qCAz5sKR8md5671KbDRDaGhy+WGcty3xGmunTk72ICae
         6gUg==
X-Forwarded-Encrypted: i=1; AJvYcCVIZdi/UMmIUmUxQfgwD+jqteJQFUTf9cWspPOvLh2Y/odY7NxEN/RwfiCMSTVXpuaGbc+/lgQURR0ltA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyD7lkszl3bdmSSX8zyGQSaLLnsXKxvDSodYat8YkcXTgT7GQYb
	X0SaIUMVOnRumCyyHCSY9ifoCCOvLr6BMEvldAURK1dUJcXus4399E4iCbIV0X6Xv7M=
X-Gm-Gg: ASbGncuyCENbKBL797e1/QEvblrODqVYV6vujVVtmVquvmflCoM5JKiTf6mhJS6FEJn
	y5NYsLJDQlnXPCdVXwa5cgGrW328cMmXrGV9PUcLSe9XyNpi0yb6AVYiskvgWToBS+ACvD+59wm
	zzWjOFcrHQoLBPemyW68WZMZ7Qj8lZvaKIY6EaNQwRBvcgxkC43VcTklIdLsNkkyEhzhcNTr5y1
	wgfEniLV6EOQYeUpD6UqRq/QB3oyxvY4q5h9VlPyy9kdSq3uiv7XDS4MVqSrqWsI/30mh+aoD3B
	mceDuUqp7HS3C4JFM2yaL5KSlXrtqmKxppjRocGL8w+weZOGg4CC2w/Ou5XM1L6ipdgLNAuQouU
	p7CODTP9XHh8RS0oAStWxG+Y7YCd0JiF3xeiNHW/pR65AWNWITKfRz5ZWgjFs4YXrrs5zITY1fT
	DaYBzCUNiFcQ==
X-Google-Smtp-Source: AGHT+IE20aFgYfEmUsR0QvaAoacDC6fODutHzSvHSUQsADrC6Dw8Qfg3mMEOFdiGJnzQSF6ImIcR9g==
X-Received: by 2002:a5d:5c89:0:b0:429:927e:f23 with SMTP id ffacd0b85a97d-429bd6a7a39mr1718841f8f.6.1761919518697;
        Fri, 31 Oct 2025 07:05:18 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269c1c17sm24932505ad.108.2025.10.31.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 07:05:18 -0700 (PDT)
Date: Fri, 31 Oct 2025 22:05:14 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, skhan@linuxfoundation.org, 
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <stmj7kbqis2idlscf5iwch23ft2azuyyr7q2kmelavjk5lnug4@66in667d6bym>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
 <aQQ0DLqL0iVN7D15@arch-box>
 <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>
 <aQS_oUDXGt_nF__d@arch-box>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQS_oUDXGt_nF__d@arch-box>

On Fri, Oct 31, 2025 at 09:54:41AM -0400, Albin Babu Varghese wrote:
> Hi Heming,
> 
> > I support adding make_bad_inode() in ocfs2_read_inode_block_full().
> > ocfs2_read_locked_inode() calls ocfs2_read_inode_block[_full] to read the inode
> > from disk. However, ocfs2_read_inode_block[_full] have many callers, and in
> > current code, only ocfs2_read_locked_inode() marks the inode as bad. All others
> > forget to set the bad_inode.
> > 
> > The 'forbid' write operations when read-only mode is worth another patch, and
> > I plan to create this patch. This patch adds a similar ext4_emergency_state()
> > function for ocfs2.
> 
> We're working on this as part of the Linux Kernel Mentorship Program, and we'd
> love to take on implementing the read-only check if it's not overly
> complicated. We're just beginners, but we thought it would be a great learning
> experience to work on this following the ext4 pattern you mentioned - if you
> haven't already started working on it by the time you see this reply.

I haven't started the patch job, you are welcome to take it.

- Heming
> 
> > Therefore, your original patch looks good to me. I will provide my Reivewed-by
> > for it.
> 
> Thank you so much for your review and the Reviewed-by tag
> 
> Cheers,
> 	Albin
