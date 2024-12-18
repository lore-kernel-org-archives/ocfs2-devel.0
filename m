Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2463433D1
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 00:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734483473; cv=none; b=ra7ilopAg/YfeVnibiR/sXR3/Mw48I7bB5zq3W1M+PS5WlFnSQCvSMsP2OHA7y2aiO4TSl9nP2wQTMM675E796W0bTXLlUwQVHfqU0wefo0c7fwnRR3TpIDxuWgP4MxOZanmwRhlu7wZoRqbTsuo3D/5WNp8drCnvHhb2i4RZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734483473; c=relaxed/simple;
	bh=3GLzOjmmsmCWzDWpObW9whDRu4uWSPaRMg0AHcULX9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tZvgYzN1Zy4n/+uaUrP3DiRdYFjj+KHAUxlGBXKkOsYdQ+YvRVUKDHhEPuj0UM9P1fzI9f6BO0WaEb4UNCvlYXjG/+XYb+TgDc2iHlZUtMf5oUs6oRdbw02oQ+MmaAiODGb94qjQ6AZ0moufGxjUhxxhi1aEBN/bowqeKd+CuE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H6KS+ult; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6KS+ult"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-85bc7d126b2so2563637241.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Dec 2024 16:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734483471; x=1735088271; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3GLzOjmmsmCWzDWpObW9whDRu4uWSPaRMg0AHcULX9k=;
        b=H6KS+ultWO9aU7Dz6ftPd0uzuBRgMI7lXnoAexTGP+3HH+q1il+GpuD4o8HJMh81ms
         hLxwnDL6eVPZL1KybrvnjKitkbk88A8FbfOo4ECZQ76AmMJ7gOVD6T3Sfn3UCIchYmdD
         UWIIdD3B+dLZ0UzJgA8CQZVgKgZnXLgPZSVSrSwicawhRuC1RBpo4L4T/Awl5XJtLuOJ
         G4nweD17JpiCNHC48C04NkSew8AohHXwN6tp8l8FpczWh1fXV8lsDm3e/qt8Mm+AbQ63
         VnBXZQMemGixL6thcgx1nBxtJqTz9BKqSla581RgFL0dRI82GW4lc9lGSGY+BDaBdBux
         HDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734483471; x=1735088271;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GLzOjmmsmCWzDWpObW9whDRu4uWSPaRMg0AHcULX9k=;
        b=PlzmZsSUIsSIrlWnCPARBgA+N/TCXDzaYzz94OA86vLVMSbzfQzmbTpkbjXOmxG9+L
         v5BsKH/W55LOXYo//UJ9XQD5ATZ8I0yfW9/0fDtt1RyydcfvNDhrXqelC8BPRfGgdEOo
         tq2FZw6kLcL8+4r9FJxC7PNrdHMRSVnAmf32dncV5XJ9jP9zMZGkBwUHA3MMwEiEVESH
         X/OkDgluwEr2z+k3UN1gmqeG9H478DVke0bV3zWNS2F8UJL+lSSi7Vy+EKi1pZHRI9O1
         6k569d0iBQO/vbpWBKpx3QB5TiqP0d9Zt/PnCTrbfftCm4UgxGq8+SP00xebWG6XAdL2
         Nd7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVepz3kq/Opra+YZWUxlXTqu0Dcscuf5HKW2vffUvxYFMT+msIoFBcY5iMDRY/zfqyUllWuGZlyQZ96mQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzP2oFrq/xJkGfxc2bdNhmwgxnYpqk6UuqLvy/aaFu/LNjbTgJt
	1SlduHaxclOiT0DWbS68SfSJDooDDCZn+x4FVx3/j4ggSRic8sYPfFAYNysURwX7FmjXTJRD4Ew
	xIYxWtXt6hFWSH/YVJ50I3udSMSM=
X-Gm-Gg: ASbGncsRH75kBGrjIG9Gy3XtwGju2pc7AbJPhnKCnifF1nJSc3IQhzbXn6HmaQ7boLs
	IADIek5MXY/hfnBPhSSOHEy9CDVRgd6WSnHkj9g==
X-Google-Smtp-Source: AGHT+IG/UwPdXEXglIVDYuqTAb+938lfNGZtSY850frwAjj5jVI4YWoVVME2Ym/csRIOuxLhXkJEW/NcyHbvcqQC/kc=
X-Received: by 2002:a05:6102:15a0:b0:4b2:ad82:133a with SMTP id
 ada2fe7eead31-4b2ae8abef9mr908695137.25.1734483470732; Tue, 17 Dec 2024
 16:57:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241215035828.106936-2-dennis.lamerice@gmail.com> <ac900a5e-9a3d-4e6e-8218-fc56bef8142e@linux.alibaba.com>
In-Reply-To: <ac900a5e-9a3d-4e6e-8218-fc56bef8142e@linux.alibaba.com>
From: Dennis Lam <dennis.lamerice@gmail.com>
Date: Tue, 17 Dec 2024 19:57:40 -0500
Message-ID: <CAGZfcd=T0gZKiY7HQ9YuxR1sDeEutZ+LQp_sfC=iH=_b74BV4g@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, 
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

>
> Looks reasonable.
> We can just use !sb_has_quota_active() instead.
>

Thanks for the feedback. I'll be sure to send a new patch with the
updated function.

Regards,
Dennis
