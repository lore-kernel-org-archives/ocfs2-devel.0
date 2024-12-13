Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08621A8F92
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734079009; cv=none; b=RyDZSbBiGTwZuBsEjIsG5/k+eyXA/T/iOTIOg4xxdHAoPYzpmgGBgm3qEhKpquZmCukj9NLZI2CK9+DcBZ0Sr3BbpEOyTa1BDLknvzROzSHB2SJuocHw4BT/XERBRdRMvhcoFlUybFsHGnfjtnXLCT9sCynptqZt6h64oSvXiF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734079009; c=relaxed/simple;
	bh=JKyRigM/AhzU/31X9Efi+u7E+mLq71Us/+kxx01u0P4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDXDvedxQXMWD7AqlMy4vDlDe0tuYqFsqKgBeVfzqJGskp1k7cytqhIqNLrPfBPfutxfedyfw46HK2rvWztUEUyZ4l/3ab0akGiVc8ITVfKouEQGfJAVeCogQ5+BHLkX7llt03UNQPp8fujQ0p6W6mvOqXCuKgSHr/ms33Z9H8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dinaq2BN; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dinaq2BN"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4678f681608so15962011cf.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 00:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734079007; x=1734683807; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRt1MXIvY7wy4Sl3wPWxh5TWbRsTuTxrC9cGCSyNao0=;
        b=Dinaq2BNYH23DyFqnKIv5ijeGz7ly0Vi3aNAmIHtIK5OvG52f7sdtoZHWLkUhXsFbi
         HFOb+WwC8r/GzZHoBzVDb9G/rWzU7LRGzZqwtgr+56K5vzeRNhF7XRQ4KApPv5J02m6n
         o7EFnl15gtTwj6sQkf1dUddo4WJiH5VU96pOJYmtcuzJh2NC3n1zHphLWhNObQGPdFAl
         x699Q6qjkJDTSw/xmARTTcMhoOlbBslp3Dvh1toS85hACpaHOAHKRk+0X3M6Oeik/Qe7
         Mxu+ou4bWcItHHKQY3ZfEC6F15VOV8QjELvcEWocHB4L3Jp/DFK1JNQixX2Xt727zTzh
         6JQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734079007; x=1734683807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KRt1MXIvY7wy4Sl3wPWxh5TWbRsTuTxrC9cGCSyNao0=;
        b=fjLEHjnQYkC+ProvqfllvFd2zwu7ayy1vtqWwWEInS9+DX/ur87LQPLuHFDZCw1K2o
         0z+SB0Yt2nZghpo/s7JgSSI14Xe6edx03t0uFS+bGGMfhfLckqCN4I2gcXBfGVf/OV12
         KqXlzUmMQuF6Kb10QYyDvIlrvMq3mOf+MfsRmEeXTaQrYqLCfEaYCsZt1uODArRSRDQQ
         CbugjAnX2xAQMcHx8VXzKTF/LCkpv3otiE0sJwZyrncX/0O42uZ4Q4s05ItfX2envahU
         +3eCdYOW+Z6CqffCGvwVe9XdoZzMEI/qXoYESyoGuAGC7h8oExsQqdBpmo+0eF5W9mxx
         7NLg==
X-Forwarded-Encrypted: i=1; AJvYcCVQwiWMUNHkOUaLRxysQcpJ/eDdcRw8/UFP/odgryNm8TYXvbVhTPm1PzCD9sY3wiBs/9aIQ7Wxn9UMYw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx6RBo9NRNLHVH3gX6BMbyOfdREsxEKTzFjJBXz9lvu2aaJhdL
	ogz/4ogv374suVP2Q7BGqsKinsIohmpBgw0EZRfC+tOBu3yvoQpgSoYhHqlsZNmsv5GPIpt89Lz
	E9Ac06K9dwcXyoJiZNJDtd8cSBpk=
X-Gm-Gg: ASbGnctCo3uxWipFQvgzdsXfljCot/fQXBHyHA5wVxrjV+SiOjlKinVHl7Wl/VcckZq
	vToxFeTz5LXZRFL2TVds+UrWAqL/SVDU6/jrjmhk=
X-Google-Smtp-Source: AGHT+IEt1cOWo4VsTmw/6EdhS/KZ00UrsyLMhWiucugMYEeldbYzELrBj4wzlhuYfpJWzQ/nKiHjbqdqIiCiPqivAYk=
X-Received: by 2002:a05:6214:301e:b0:6cb:ee08:c1e8 with SMTP id
 6a1803df08f44-6dc8ca869aamr25025096d6.23.1734079006748; Fri, 13 Dec 2024
 00:36:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213054610.55843-1-laoar.shao@gmail.com> <20241213054610.55843-2-laoar.shao@gmail.com>
 <Z1vq2-V7vB5KhBR9@pathway.suse.cz>
In-Reply-To: <Z1vq2-V7vB5KhBR9@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 13 Dec 2024 16:36:10 +0800
Message-ID: <CALOAHbAD-USZYry6dToxDTM-OO1+Rz0g6XQkCjhzhWDt7g4MGw@mail.gmail.com>
Subject: Re: [PATCH 1/7] vsprintf: Add %pTN to print task name
To: Petr Mladek <pmladek@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, x86@kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-wireless@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	ocfs2-devel@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, 
	Dwaipayan Ray <dwaipayanray1@gmail.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 4:05=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Fri 2024-12-13 13:46:04, Yafang Shao wrote:
> > Since the task->comm is guaranteed to be NUL-ternimated, we can print i=
t
> > directly. Add a new vsnprintf format specifier "%pTN" to print task com=
m,
> > where 'p' represents the task Pointer, 'T' stands for Task, and 'N' den=
ots
> > Name. With this abstraction, the user no longer needs to care about
> > retrieving task name.
>
> What is the advantage, please?

The advantage is that it provides the flexibility to modify the comm
representation to meet future requirements. For instance, we could
rename it to "task_name" and increase its size.

>
> Honestly, I believe that the meaning of
>
>         printk("%s\n", task->comm);
>
> is much more clear than using a cryptic %pXYZ modifier:
>
>         printk("%pTN\n", task);
>
>
> The %pXYZ modifiers makes sense only when the formatting of the printed
> information needs some processing. But this is a plain string.

That makes sense to me.

> IMHO, it is not worth it. In fact, I believe that it is a
> counter productive.

Linus, what are your thoughts?


--
Regards
Yafang
