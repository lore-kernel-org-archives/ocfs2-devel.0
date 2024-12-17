Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087DD54279
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Dec 2024 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734397717; cv=none; b=jIZGmzMOD1ICq1wgQj/fFYxJalBZnfGtQ5l9WCggsRRt8PM2edZGBieZ7so/LwcOUwxBp9X3y0O+PLF9jrDF0CFFq7n7St7ws2GF3+HWVxJlxmFLuF3R+FXd5e+OdrltnhDWeMJ39zLbTt6PUqdaGUiUB44enxSiOKOSJRDfuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734397717; c=relaxed/simple;
	bh=5j6iT2zeBprglLkGjsx781QuAZzbfmuFvWgXrzwhfk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TY4qsp/O97G1Bfcc3fpdcq59s77Jx+rIsEicW7uQzieqvddh5mvs5bD9JVgOqoa1zxOZSLjjtbOKizy2IvwEwxxj4hLhV0zUYLF4loH1zkLaLvCt0I+CaaeumlAlJk98dzVWMaExkPxP+PctP4TJp+ql/Xn/QoxLSV8ZlmDB5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ImtIc08U; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ImtIc08U"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3d479b1e6so6036778a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Dec 2024 17:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1734397714; x=1735002514; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x5HbsH3y11AUtX77RP9ShUJxU46vkQ8YNLD+VoIrduA=;
        b=ImtIc08UVq4Kn5egmHqdNArFVCyz4cFkCjk4zyW0QdUSWY+o0Ddoy2UIZwzdDrFU7c
         sK105NYuEJRXupA0Hn2oH8JphwwioQazASYYjVTt6pXM4xPa3Thr6F50mupU3B3kM0vx
         xVwp17Gy6SzVDsL8C0zDuuUinju8S4uSDNGO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734397714; x=1735002514;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5HbsH3y11AUtX77RP9ShUJxU46vkQ8YNLD+VoIrduA=;
        b=xFk2MigFVunTJQEJbFa9bBuChRkeU78DH1PAtZ5Q9nB3tUzIodU8yFuF6B+DpnPGvC
         9Krv/1Po0sOkw0fWFhVJ2PHRmTevtK07y8RGmfycnN7uzUlrtKzcII0rU0eOAfHEwqr6
         xMlc8yHLwRd7daRF3yhQXA4LwNnWRDxiaZq8NE4m/a602t1Ajs2dEKRb7PRbTnBGyyVw
         79sEjDxrWqK/L8M6HkZr06evRHFjP1cmBEQwml0+iWI4QgD/miUc16vJ8sEulviMe0Rj
         yH3FXtHQSRo+1ILj7Y8rez2fNayZFhEZpoSv2JKmebfVuvBZD8c3x85uD5Py6QzfN2EE
         iehg==
X-Forwarded-Encrypted: i=1; AJvYcCW/9pHc8XY+1zmCXXA52COj2w7riRLbiCZ76/k8+v0Ynr2KstGBS8kNnXiHlX3LTiaT45ZvL6Yr5mrF4Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxszozu0tDkimHZx4O9NTYjYpk1uwtIWJm/Y7xg4Azg3JBft5AF
	FDCy3X/3LDp1N0BiQ3n9vOMBM4LDmlNzQcXmGbkkDI27SMPI9oCoqk6dObFxP1NFfpKHScLYws4
	0PXY=
X-Gm-Gg: ASbGncu+JG+n6F4femKyjYbO5zIy5QxLaI1eqsYUlxGORWAJ6oHJ5F/R/CKJvDm3Pua
	1oZ6oQU52hCoJnI0vMd502pB+WEI4JlQ4+R/+w2JQx/W9Mx2IWu2O9FY2MhX806gQTsS5ygZUqK
	QsAFCr0ibZIZ9o31uKxa4L19naY1GThdG/n+PKetJqB3XuX/dlhM9YWa9kX5B0bS8ZEICcu4uBg
	oTMbfOlc6eXKQrr4C07hgOhxAJowjtBLmbmXHCVfRLgIhAY9N55GxPBNVCHQCaL0o9oeye0MkfW
	fpuxHg6BETHiOe7s/0WN+bgGLtP+BMA=
X-Google-Smtp-Source: AGHT+IF5CsrJfAiCpOQPqJ2gIWFC8nuG4CTlv8sm9KuTZm9ZTP43fQVgPuVrZIiRsJ0y25gsszwrLA==
X-Received: by 2002:a05:6402:528c:b0:5d0:c697:1f02 with SMTP id 4fb4d7f45d1cf-5d63c3408e7mr38562096a12.17.1734397714197;
        Mon, 16 Dec 2024 17:08:34 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652f35365sm3859870a12.80.2024.12.16.17.08.30
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2024 17:08:31 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa6b4cc7270so640809566b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Dec 2024 17:08:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWlbFLBKfENx/pDi8wlhOjKZ8nwRgBRYmY+65CoffKosGpWuXUJ9v6vJcX1IXTTO4elC18IOt8gfHSpkQ==@lists.linux.dev
X-Received: by 2002:a05:6402:27d4:b0:5d0:d91d:c197 with SMTP id
 4fb4d7f45d1cf-5d63c3db906mr36599487a12.27.1734397709817; Mon, 16 Dec 2024
 17:08:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213054610.55843-1-laoar.shao@gmail.com> <20241213054610.55843-6-laoar.shao@gmail.com>
In-Reply-To: <20241213054610.55843-6-laoar.shao@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Dec 2024 17:08:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj=W-4Eu=g83QPUDB+thtL=uY=_1OAVRvXJP=zay+K4Qg@mail.gmail.com>
Message-ID: <CAHk-=wj=W-4Eu=g83QPUDB+thtL=uY=_1OAVRvXJP=zay+K4Qg@mail.gmail.com>
Subject: Re: [PATCH 5/7] security: Replace get_task_comm() with %pTN
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, x86@kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-wireless@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	ocfs2-devel@lists.linux.dev, Kees Cook <kees@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 21:47, Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Since task->comm is guaranteed to be NUL-terminated, we can print it
> directly without the need to copy it into a separate buffer.

So i think we should do the "without copying into a separate buffer"
part of this series, but I do think we should just accept "%s" and
"task->comm".

IOW - getting rid of get_task_comm() is good.

But the "%pTN" pointer format ends up being unnecessary.

          Linus
