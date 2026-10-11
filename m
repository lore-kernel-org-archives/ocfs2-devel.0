Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03EE283FDC
	for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791732799; cv=pass; b=ni8vbInC+IbF8NSSx+jrYrIcunLddMqwWYzzbg1aEs9FZzEBflEXXMFO/7OCV6dXzZvmIitGsDEbc4qce1MbaK5Ug6M2CLGhNUQscQHBxQfa591irN7Nc7E8IhYzBXaEB7GmR8tb9uA9hmdcS1wSBG3imXQPS9n6aFzX3IaHUXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791732799; c=relaxed/simple;
	bh=s7CDEOu6ovjW9RfWhQGLcOlEG+04KKcEFMU2UF6N6E8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KC5oZeQHkT8XYREfjEbtJcbBhcSKe7hFemyKucM8ZUO6KWXG+Am7d5uMpAZIAYBT1/5o/b6U8HOuJL8G2nJl7k92EVq5A8uk6NL6LeR6mYYVXO9ilC4OyT2SLIuuZT7aNYXLblthhqasJZ/Wuiw+Lwv61uNN9iHywtF7HhbeJFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gzAw+aH3; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzAw+aH3"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b09e07e149so1931897b3.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 08:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791732797; cv=none;
        d=google.com; s=arc-20260327;
        b=VlrcsPiQRpmF7nqajVBS3UFMqMHdkT7u7CCtCUTkdamyIKKeJsdzhutUjwWVEddkio
         4LSghyr9AaaYCgk1SPYslBy/+mYsjBURaU5C7KEylrgvu9kEDIYRiQyREaNLM93+BhFr
         eAg4dImH1YVRy4MBmIRd/AdRPpG0UX+QUKT/6vB0PARa8RkauQc0TgfGFZyieLJajlDO
         Y7om7tbE2K79NXGH7QlV+F3zl9A2VaR87G1BuRdBpKOaFZ5lwgLMkni/ebQO/1+XQAO+
         lQ5I1SibaOuIJIAge8pZHn2OCY/xmZrp+7InCNhUnvKhwNpIYBQouxLReUFka6fQmS8e
         aELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s7CDEOu6ovjW9RfWhQGLcOlEG+04KKcEFMU2UF6N6E8=;
        fh=ivvY1+CUTqtUlc+55zndeemI/966aJGRLPgD5UoX7i0=;
        b=a/Hp6yhpiRWyAE7hFN9MBPsIFfLcMfixMG6r2EcoD/BzQUxUrJhhod9viaUlYNWJWb
         /MPSHlWIM8/Lt7cW1ulpqyZRFfBayXBELLzftK/Va2k7ypK8z8VjLuL8BZYw0sHGAe+1
         WPkyZpCZ00HqIVU6NB37c3c9WSNaIyVG/qiELRi8e2nRaSFWmz0JzLxjgYOt9WNuOIp0
         2cEcvL98BMDUJTKfiyEleY7HQVdByaQ3MzSnBU1Qn//qysDNTIWmAUWjj8xnfi6/qPyA
         9Baj179OXkq7zbu6LJlhLBPzOqMPWvpTcceU+/mexZF0fxwuLzraDcZjfAAsTRy2MyQL
         THjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791732797; x=1792337597; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s7CDEOu6ovjW9RfWhQGLcOlEG+04KKcEFMU2UF6N6E8=;
        b=gzAw+aH3KLmJ6p9o08Ik9cYYMfHfV6DYfn/ImmpI31RemcCiVRB1iFl8/VPYI/RIUa
         8uUzrhDly6VMCacwHr/1N9ulTr1fbzCcIRNuL0+v9ee5mRlfi0gmRRTiQ11V/gzKz2WV
         j1Ib4NR5ZyluNkQJSX+4NQDyozedtUQFMAjCUDeYg0zmlIrWEHrzOmclop5le5KO08gL
         aMwv3+HDGVkLmDLRVVFSAUYOw5p06kqtnNzTuVYkjHUxLKmGPNVXH8bcxDVLA8/FaU9+
         U5FSosxH48sX8CZmFM1lkZOggo0jFl2ZYN2m7gfpzbWdlKFqYVO0GICFlQ2M/l0WnGfY
         UEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791732797; x=1792337597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s7CDEOu6ovjW9RfWhQGLcOlEG+04KKcEFMU2UF6N6E8=;
        b=FEPZZ/p/rDhDuB48hvtPtDKR5+a67PgyyYh2bM1Yi/N3U//nAZeOT52lei8t/If9wE
         OawqL1tZlkw3EH9Uy6KmPP7KWQ9ztoshzJZjCrv0HoedAZyYeDB0DWIfyqecVnZwclYq
         dc2vPj8iEWh+BkLVnY7QiGL+LBViVXKmq5YQxoZvLJeisOxCkzO9RHt09uKO8zAjXtZk
         akRd3Rk8Kk79AoDAD6ObpswqRWg3M+uSjDtYi06XgSRMXWD+uS4M6P7lelwbOz3wMFrP
         VSsrT9ahZpQxCLWonn956p0VFLkFzwHxJCaO4nB+5mkSO3UrIF1DAhmwP5P2fFsRxxq4
         O7Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxfiCy2qQ/E8teZLNudGz7kdg0tpEBdnZTaSBoXxXoX7tMI6bUi3Brt7JA51afm94hjKBskvGlGsADrLQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYK9nuwzknbC6ugJmtrPteeBUz9Jj5HjxPUpkCa3nrOuaxz1C5+I
	CbXVeQmkm2HC1RMuj7n3d4GOBB7U4gVPQA0vtRWtmRAdD8xWzZdphjdrJ1hTfa6nn2c73afmkOM
	Z79bfv6XR7HrpTmWFpKOkBeFgTY0fsDM=
X-Gm-Gg: AYBFou1qr3rmIU3h8/WERvQGv5GXWUVQYHWUQDiCqdQ9xgvWxW2k4ED1PIRYJ6cIGpe
	8Z/ItTPBW8EzBX1u54U3qE+tuwCZkn8OXB+UdhWgNP2j+y9ucE2pLnD4WZoEDqvyuji7fV6f2Pk
	SLwdjTmfPngKjeyD/ycMJB/awy4mR+bqSsEIZA/Lw4m5PZkihMR25JS2cFwshyVfeNei4+QuBaP
	h9dNi+jsNt8/ffCNaIVyuyLaL13TxbdbGhRCf8u3fcWD4u47FBhvBfFwS3oWrwzeFBzi8EOGZ1m
	OX1/JIdQpAkpooUTXt4w7X8AkQZ1OjQmNIxVaG7urwtj5Vz8xBy7oNw1Gg==
X-Received: by 2002:a05:690c:7108:b0:8b0:6722:6739 with SMTP id
 00721157ae682-8b07ebfe3ebmr23637547b3.9.1791732797587; Sun, 11 Oct 2026
 08:33:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0049-v2-a5d5091b8900dc3f9849@gmail.com>
 <9227ec1d-0de0-4e43-830c-fc60d5f8b2c8@linux.alibaba.com>
In-Reply-To: <9227ec1d-0de0-4e43-830c-fc60d5f8b2c8@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Sun, 11 Oct 2026 23:33:06 +0800
X-Gm-Features: AclHuK99tTm5H4HFpawLz3h54s0hNa8_2ptxeXmPO3b0n81uHbquxJ8gVQte-Eo
Message-ID: <CAFRLqsW-DH2Bao_AoB_vqA9xTDom58PoEmV73JHs-FP-o+cd3Q@mail.gmail.com>
Subject: Re: [PATCH] ocfs2/dlm: Serialize recovery list teardown with debug reads
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, kees@kernel.org, jack@suse.cz, 
	rppt@kernel.org, hexlabsecurity@proton.me, sunil.mushran@oracle.com, 
	akpm@linux-foundation.org, Heming Zhao <heming.zhao@suse.com>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8810=
=E6=97=A5=E5=91=A8=E5=85=AD 16:48=E5=86=99=E9=81=93=EF=BC=9A
>
> The race looks real.
>
> But I don't want to involve dlm->spinlock for list dlm->reco.node_data.
> While dlm_reco_state_lock is the designed lock to protect list
> dlm->reco.node_data.
>
> So why not add the dlm_reco_state_lock in debug_state_print()? This
> can keep consitent with all other places that access list
> dlm->reco.node_data.
>
> Also it seems also fixes the potential list_add_tail() race in
> dlm_init_recovery_area().
>
> Thanks,
> Joseph
>

Thanks for your review.

I will revise the patch as you suggest.

Best regards,
Cen Zhang
