Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F56B78F2D
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 06:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734588461; cv=none; b=cOfAKmth1wji0GVqP8kkvcA9hehALh54ESp69KOQMW3Tkyt6L1Qm2iHqrS7SaIyS5rBaRTJiXAD/jZPQChTRYhLz4jrgs0cv7Kp7SnQolKzRAM6Ug8aN8a9/DwKNmsc4goLJDwzRDnrOXS6VqpNRuN2Slq71olVewWB9t5tR4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734588461; c=relaxed/simple;
	bh=lK83XfXwhLRnC/h8CtIdW1MqermJJBAffnyzxtVWDl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jcug40/k/ZAx2MBrkzgPVGZbafVAhuhTD8GCu7ZeIqkbIuRTAkUwR0aZ3QK9TSvodbPHI/MNOEXAJD3ncPblZe8eiy+JYlGHv/4s1L2dfs2TgqKz4g5PTKL3RQtFlq+M2pprlKB+SoCoqBdtNG9X5pp1ZW97kChEbx5GzdbcXIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgtsFMVg; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgtsFMVg"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-51640f7bbd3so140925e0c.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 22:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734588459; x=1735193259; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lK83XfXwhLRnC/h8CtIdW1MqermJJBAffnyzxtVWDl4=;
        b=JgtsFMVgV/CVa6DtNKUf/euXj8yxqh0uMd328GX4OWEpEWUwImxGKTN09Gfnx1GEk7
         NkUkwVrr8E1KRfTjcjpIz+3lQHoaGl+QF0AopA21YF/2IALS6a7plhO9oyfCeC9YU5TV
         04wt45xznMgAmSAgZniqwtfh144m0CXp+xVX7ZDqtToFjajxaaq8C+JYblBGdhY5+W/k
         t64GRflFRho2e+lDZJOXawu4nvS7wrYvz7m0nFNGVOUgR2Krcm5bizDKcuSANFD0tvfs
         Imfv8PYqu/glJtTKpyYudTPgQRzSfxcKcPIA9A1gLdlf8tnirJxy4N1uZCd/s95uvO8N
         xDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734588459; x=1735193259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lK83XfXwhLRnC/h8CtIdW1MqermJJBAffnyzxtVWDl4=;
        b=TFPfM4O/F4GWaHxFHGwNXCWk9Y7vYH443WBltMjne/WAP9KS7DkhFPC89idhQqII+H
         0+YNcOWnA6NvX88ciIVxOiqyGJhCzzGba1l9fxlHKdMV9ohNx6iipjcUzZ3AC2PM+UmN
         NKqcIyB4yBGzGXFXOFvDGYo7ReE1xUXjZudE9m2R2k2yIdxU8hZDdEdkI/Py6pFXwvPy
         69AVbB+JcMArMZx8rmPKozHET3k0tbSpviJaQ67Yic/eHTNFitI+H0F/WSURI3KUTEGy
         64Xx/bIBwSqHc+vbrT6hSFpC6PBDy3ggvtdaSqhlclrBep3Q+QRxYhhEBxpuan0H4GZt
         5G2A==
X-Forwarded-Encrypted: i=1; AJvYcCXalXAs83y4RvP5G7Y2/mFeC+Ni8jJI41VrmIbXWyUGipN6qkOxVWzsdd8Y/0jCCto0Czaio3oa/7rzMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzY+SvMcs/v5jgOk8iPzOZxJE+r6fpmW1gklOUai88SH8LB/DOb
	EjzsXyngugBNwsRo+W8XlwG8+WQDdrOnHieuHpMiiSG5FI6qSvqMT357qGT+pjm+knca0XVg+jw
	v8s0IW5ZsLTWSOQGETMWZp+2Pj9k=
X-Gm-Gg: ASbGnctPrf4l2AUvo9dpj29wUU8moBFf7ga9u1dBfduJyP9Uvxe6LXAxWZAejxAujpl
	XhvvXWdT4Jy/LV3rnWHpAH0lUUCFf318aCYmwKQ==
X-Google-Smtp-Source: AGHT+IHcWyQmOjght1Mf1jvPHOlcyEqZP11YhrS19j9Ymw1VXDRHeBZR8bWUWIeFi4xVIaNyghW4wS03iqd9d5tZKqU=
X-Received: by 2002:a05:6122:2513:b0:516:157c:a72e with SMTP id
 71dfb90a1353d-51b6473231bmr2142396e0c.3.1734588459045; Wed, 18 Dec 2024
 22:07:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241218023924.22821-2-dennis.lamerice@gmail.com>
 <f61955e5-9cfe-41af-aece-283b811817a8@linux.alibaba.com> <ee744944-359a-43ad-b9cf-72eac1b374e4@linux.alibaba.com>
 <CAGZfcdn2OeghHDhg5N7R34TLehaUH=tr_GvTVDydZAEwFRqdJw@mail.gmail.com> <ad2361a5-652d-45da-b8f2-24ab74219d58@linux.alibaba.com>
In-Reply-To: <ad2361a5-652d-45da-b8f2-24ab74219d58@linux.alibaba.com>
From: Dennis Lam <dennis.lamerice@gmail.com>
Date: Thu, 19 Dec 2024 01:07:28 -0500
Message-ID: <CAGZfcdk=XGg3Lr7KLAUHXfwZLj17nyn5G2=qqT9VJaP1rpQwaw@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 12:51=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
>
> Andrew has already done the favor.
>
> Thanks,
> Joseph
>
>

Thanks for notifying me. I will not be sending another updated patch then.

Regards,
Dennis
