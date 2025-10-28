Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAAB264A86
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664316; cv=none; b=ITRSHOjEuRNQnRYViaMoQ5whF4Z8sMSd9Vqw/jS8fglGnsIN8bqYLsX8giUX/gSehcwveMfR3O9vSwqcRXWTA7wI20DqYEw82D+6I70IWJXltaVYMQv85vDiM8Nh37xkuF55s3bzDiIBLSL0/0FhcX3EkSRys/vNDSJ+KrDhRvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664316; c=relaxed/simple;
	bh=0hNtzKD0vu5AGddF0QaHTFvhk5oQ7Ez32FuDNp1nkVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJtU2ze5nKILAYKHwVL+MjI6BGN0sfO/1ZW43Jnn/Lp9zeAVIDEJxPq8vF9+vG/mph4tawxLD+iWJvSZMLR9tMSutbzq+PEYIAKyA00wD4UUtwA15/IztwxIZpY+Ojh58H4CJ8GtdSQ9c/i1a1wX1vnKHpAktzVT2uSre4Usb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Jl6o56Fk; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Jl6o56Fk"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4270a072a0bso1023414f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761664313; x=1762269113; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fvdl5PKDvmBWsB9WzzrBkubpu+KLUJy+vJoXmu6tziQ=;
        b=Jl6o56FkG1JZRQFpb4yoYu1Jy1QYsLFJsfdU1TGkKemlaDsk1+hIVZcU2decJBOS52
         HOQfzNBz945y+X1oZQLYDXQg79UV3cZTQJCJdRx6lLdAaTC3/7XSgLz3A0y+Mc8SEEbT
         7459n+6tCLuDw7Yu15nWp8t9HUignIgkR92iC7LNa61Z9AZzYbsgZG3XytKIr7BPo2Uu
         9CDc/ICe4nSWcL7mcGQoU0C8p2pbLxqulCTTIQFQqFJjcVB5nveb2sXW8NMSiH05OMRI
         OLVdqk7wemADwsXsKtaQuuei4AGumKfdIjlFzs+6L7LHFmORjb3gIkhBZBVv4jAL2HVE
         O+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761664313; x=1762269113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvdl5PKDvmBWsB9WzzrBkubpu+KLUJy+vJoXmu6tziQ=;
        b=T3noAUjqDBiJ75B/agQ+bIKERJQ4GWofERUaz0/DALgdR48P+GXbnxLPAlEclJ/X3c
         uBNv1HRQX5b1E0CImBrecZcJF98tLhWViESYbDEKzB7KU59Fezv5HMAyKRZXbtBRcJvx
         mR0TTEuMMCj6yK4vdjXdD/TJ6MfIe9sgAK6XF1DJOAZOCNWwZCbj1306Eo7EKLY7dTbQ
         P/PLCxPg3yM2Odj12Eowj/R/dawYA6N+/IiLsWCaGUjhgygySCAxS6nc4k62697StfXK
         Kp0lfz5IHqA/d0gH3k4UJ6hJVcwJowViRuIuSosMdCEsLPuktCCdCaM/c7GGy+jezAoN
         1iFA==
X-Forwarded-Encrypted: i=1; AJvYcCWwfL+L9MrYS6ToFE3SyS+P9QTEzKYFAfgg6dQyTIx4rpYMkyFehEx6o5EtQPH5Ksp95lBaSHUVbLiBcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+gZ6Y+WextTRUTq+CXQlkZLCVz2Yju8+3bgKO68MdfSK9QGkn
	8m00zwpGAf06Of9QAhIu0lCHxXcvBxDJHgHO5uVWXgWWMeGSXr+fTxkGV9eS3VSgIj8=
X-Gm-Gg: ASbGncv1391BtM6zbl18VfZNmgQ3mrr7iZlPM93os/FwkQIzM5TMf0DnmKOjULVVqNb
	AsVPArzPaJoIb3+834+muJAWz9B9Vcr8k1rTc9kntsoH2foeDDAUfW00NO8WuGsDThpcfOf/3pM
	Te4c9/9ZDKFrZuDt96Aw8f3X2/axFCoSsdwiloVPCHB/vbXuQPtByDiQ1/4Rcc3z70g1vkR7Xte
	bt/bH2dkYfy+zpj17ystcuM/7yTV7y4iQOXGCelocV4DoUTWF7j1oUJ/5n7ZVqfu3yY0x/ySh0r
	Map1jaMLfzmGNrZilAH32iG6Zabn4et09t7KEGF/xQS5I+Dsp1Yo+W9ANABZjWklmH1Ef+9clzO
	O5pTFz/S5CbUH/vgo5Oa+DJRJ2jFEwiSp7PcQaKjvcWVQBcioEIqA+ZkhghAhh0NdM6CTSJKx0b
	Y=
X-Google-Smtp-Source: AGHT+IFD7FBeFg4RMX3U5GYrY3Gubn5T8dfAKac56uXuQtSzlswe80TdvY7p8MIy4bhmnPlK3pZWSA==
X-Received: by 2002:a05:6000:2382:b0:425:86cf:43bb with SMTP id ffacd0b85a97d-429a7e7212fmr1894347f8f.5.1761664312965;
        Tue, 28 Oct 2025 08:11:52 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049f20sm12185401b3a.29.2025.10.28.08.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 08:11:52 -0700 (PDT)
Date: Tue, 28 Oct 2025 23:11:49 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com, syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: Re: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with
 ocfs2_check_chain_list()
Message-ID: <irjdhznytzgsgxcgkdhl4go6veh3a3p2bx6kqwhmcjlqumdebh@rkdl6s2e4yfd>
References: <20251027125654.312153-1-dmantipov@yandex.ru>
 <9e9f5ed7-5c37-462c-9970-3da7dd957e4e@linux.alibaba.com>
 <nxmdosp26qotev63tpeq43njfobyxpes3v4zhpb6jhmerpjhpn@ba4ylsi6nctq>
 <d475a54e-2f15-4235-a21f-9d217a1a9126@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d475a54e-2f15-4235-a21f-9d217a1a9126@linux.alibaba.com>

On Tue, Oct 28, 2025 at 01:51:23PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/10/28 12:08, Heming Zhao wrote:
> > On Tue, Oct 28, 2025 at 09:53:06AM +0800, Joseph Qi wrote:
> >> Hi,
> >> It seems that these checks can also been moved into ocfs2_validate_inode_block()?
> >>
> >> Thanks,
> >> Joseph
> > 
> > The patch checks 'block group' not 'inode block', the signatures are
> > different: OCFS2_GROUP_DESC_SIGNATURE vs. OCFS2_INODE_SIGNATURE.
> > In my view, current code is correct.
> > 
> 
> But it checks chain list, right?
> 
> Joseph

Got your meaning, you're right.

- Heming
