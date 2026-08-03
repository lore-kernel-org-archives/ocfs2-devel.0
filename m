Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9392E6CAB
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 02:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725769; cv=pass; b=swsx8OkP3ZygHHfVENjkPdzAri7mrehcg3YqX1x6vXXmaner2G6GZC4Dwfk/u1pE/tRhLo0UEKOhY7joiPcP0zd1oQOtZsa9kuKSAIyqLxEC7mnPguMeDov+qWmKkKWncraFcW9ZCdle9WhsbFcOO1IYbG2yeFvmLYxRFoxWowY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725769; c=relaxed/simple;
	bh=Ui/lDggU/h6QckWNktODUy1bK9noBdLs8jOQsjFrzAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSBi5JIuXP4mahLOuBbRFQy9KAL8Sr75q1RcIrzrDaV957PDNNl4JlXSB985qKB5m5IMz0+c9KfgyKgvDCj5y6vz0oMXIWo4XhdZ5HHoBWTUSvVhfSNMVJp1vuAgfnEEILiLnFlWpDM7uylKeSZ3E3LzDWaLFKBzCpaVmzAaTbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ASYwCU0J; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ASYwCU0J"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a051904222so4212809a12.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 19:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785725767; cv=none;
        d=google.com; s=arc-20260327;
        b=fxszIvvn0d3P3QUkONBZZxrYnHEIL2YfmY0dfqay/aPsff639f/ARkViaszrtHOHen
         YRgBUoBdP5nzwKsoBY+VoLbwN54wQoZZKjzUXDXUXjVul9VNjGP+NK4VgdftGCvd+fs4
         IaVT9gl+jKC5MzN89D2p6bwstl4ycQ1qVIEeLUC2G7i+CIlvwkKgeZy4vYu839pUMNMh
         SOQlwWpwCO5xj+CgfgSMvFGXQQoYsKWnnANNU2De+I83Wu7cF2dmbU80vcUVkUl6nSdp
         sUp6YQbeET6gde7J7FKP63YmDyl9hy2Ok0lYuETuN8i8Tm4HeFYwMoCdvV7vgbb4hwE3
         buwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ui/lDggU/h6QckWNktODUy1bK9noBdLs8jOQsjFrzAU=;
        fh=mb4UcOERWs3bBQsD01p4E1ibliK/xISXqwt6buStXCc=;
        b=WhYrUk3fDr9rb1jYq/WjBzPgDZV9tnrxuzqO9b1Fx0mNEYRbkSk+36W6M0D/v4f8Bj
         CkKe7IOMBKSAik/Ko0RMElJs8hbGW1TWBug1E9GRI5bzMxbxyZe/DkgY6r3XgZ+HiZcr
         kHh6bTeeVKVD9pk61CA/dRlMb4CW/J5GEnNcyZN3H3VLDXiFSuBgPZ/H1uj2HYDpv2ZD
         3A6+YcVzig0X+OD+vpdl2mfShSXpOL9G+PnbqThXypVMjnXJMUr81H9cD7q7wsDHpAzX
         l8HbfdkAJD/d6gJmLRTyju+JB8HF2KGbhOtkdlYJLdoFz41KBctBLfQXzGZkqOLWGYRR
         Lryw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785725767; x=1786330567; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ui/lDggU/h6QckWNktODUy1bK9noBdLs8jOQsjFrzAU=;
        b=ASYwCU0Jcq34yI42jmzJnXFi9bX7JD4HY0FMwUbKgr+p5eyDdE/6fJ+ZjXc2LF2fOt
         Ppw03+agnCqPaXnwx+OoJ4BGR90HSx1rga7to3+Srv80oCaDQoqgL7eeM9VHQPIv2qM+
         1LBuDSIQpeT6IbSiBQa5/h0SAMfT18wni5kgswW/Id65Voa1GEx6Qw10OmGzR8VHsqMn
         EyOku2WW4TUNfXeC5N+yQJ8mbAfoN2M6TnghWzH9mKdJwLml8Q6+4ohVR6VAn+85nq0J
         TQvRhHpLYDjxHDCWSmVDJe9j8yLnSMEDcOUrMaqDW3jpk8QRDyrdPcOsUP/28Vy7XxFk
         tBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785725767; x=1786330567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ui/lDggU/h6QckWNktODUy1bK9noBdLs8jOQsjFrzAU=;
        b=G+iJxsiTudLaOeElycJKX1XIHfOUjUAYB4h6G70+CXttBjcp34ONhEOkBaqlj0xERa
         5i5mJoELjPcYIMP0gt5kEF1bKMefyQwboJLoud6dTdvgEqj9fvDoHlWvim5BrUy9yFO0
         vVDLeQU9Jd8rAvvr3KL/p8p0hyfIBjH+TneR0tTGij9I8EgP+62NRNuQUykCGnL0+waL
         TpEHWFYRAArPOkynNiqJEP4I8wB905WvszBDZEFcU14gwNcjCr9D2qHS43SsfRxcsjQJ
         JojDWOomm5qH7q/hC1CYOd8BTc1lUPIEe4ppWFtzyRCpZCdkYTGf0Lpi7g0SuOh/1rCq
         ExTQ==
X-Forwarded-Encrypted: i=1; AHgh+RrARW+hpFvtqbhugqszbI+jkSpD/HhUfSbGCn6VgiKTO/1VRNkiSzn+6nGLtZmUSTwTdinNWGOphKkDaw==@lists.linux.dev
X-Gm-Message-State: AOJu0YykBPv2AlPFS+/67MAjF/3fu3i5A02w8wXV0kNfCxYKdk/VJkUQ
	U3G+U7lGnicA1oTPwq7TanitfscNpcC1wk5zyQtDH1PdWMI+nG4WQ8AhWj+F9SjzRniPO8mkfvy
	sbDAioryTwLobsHMSzpHrnSgyvJZnMmE=
X-Gm-Gg: AR+sD10I0fyf3tun8ANA77BZLs58c013SCQ8OdVsKgZNkKj/luARlwgqH/uAENGZWn9
	ppu/hM4j10tTgYrHurv8/BuEqcvMFKcJXh1Erml1Xlr9S+ZRP5v2emyyC2gMYenm+7utdI6EVqe
	pZLwkFe5+lAhVYFjS5ZFAdxemgtje2i4fHD4R92WgexaEb5XghlT9mlpmDgJJkcF6JeC9NTLIpN
	RBt2GZJxDUqo9SBA+BtqEl/EX1fNAUVIZ/eu0uww/CzRdXg/xzK3eEAy3Q7OmOn7QXaDn7dFdhZ
	lNi3MskFb6Ug9V06lObsRf0i6EpABEkawwEZ9/NQGjpd5PMA02G/I+wQVTUFfTfT+dr/QvXk0Y+
	dc3SOnwqvcxTWw0acSA==
X-Received: by 2002:a05:6402:a505:20b0:698:ecf:d18a with SMTP id
 4fb4d7f45d1cf-6a0c698aa1cmr2964148a12.9.1785725766469; Sun, 02 Aug 2026
 19:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722091157.3141414-1-gality369@gmail.com> <de598854-410c-4fae-95a5-8db0ee6d47e5@linux.alibaba.com>
 <CAOmEq9V-g+AxUw9XZr2Kk5_MYffAndsrbTPfXOyKDiH-eGSKGg@mail.gmail.com> <4be16c98-32c1-4d87-beeb-368a45dafa40@linux.alibaba.com>
In-Reply-To: <4be16c98-32c1-4d87-beeb-368a45dafa40@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Mon, 3 Aug 2026 10:55:38 +0800
X-Gm-Features: AUfX_myrXSo1mEDRAnv6WjI32dE3IEK5Lt4CosQjwSnjOKqJYrOrKWb7v1LS_Wc
Message-ID: <CAOmEq9WnynOwO2DOwFv3XEfX2YgiHGr9XoCUVmw_29Qj=+cBWQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate truncate log dinode before caching
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, tom442288@tuta.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 11:40=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
> It seems I've missed the thread.
>
> And I've found a similar one in:
> https://lore.kernel.org/ocfs2-devel/20260713205625.92391-1-doruk@0sec.ai/
>
> Could you please check if it fixes the same issue?

Yes, this patch fixes the use-after-free in ocfs2_dx_dir_search.

Our analysis indicates that the kernel BUG in
__ocfs2_flush_truncate_log was caused by the same use-after-free
issue. Therefore, at this point, it seems that no additional fix is
needed.

Thanks,
ZhengYuan Huang
