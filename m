Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0C18DF7C
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 08:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734077153; cv=none; b=D1VKNKYoDyWQfKn5UDCr7ecQb9OOlv6u5sC3w5ta5aHXOjNUQpRQLlYQIVZcM62J343XSNbDiizwbsP68vC+S0z84UgNf7MNATW9A/eJZqOwZF+cMaGo8xtA6FBJbUs/nFYtykJCksvLXqA7TwXx3nsCObKvJXVQyl5L79x4Rnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734077153; c=relaxed/simple;
	bh=Gm1aSfPWn+6Iv90/f+5lwr4JIOMPpgZfZJbELp9SPys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOqxGFuwpkvAJU+eAunTmZ9l/hqxN7Dn96mXjPAYyJcUCXyz5ap3LcxeSrCwSkxfmBKUy5SyQb6b9DtSS63XftN92O6oDKTgv1/mryK16jbZ3B/i3pEjwIUCtHK+zxO3mL4fpyi2cllKx3UEm+2uYquIK3syEPHJlbEgZMXSbYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EZpp/XXX; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EZpp/XXX"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9a977d6cc7so181619766b.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 00:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1734077150; x=1734681950; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lgwYE8AkKohlShjZLrwteb4c+nimfkWQZUupQYO5W68=;
        b=EZpp/XXXwmko7xkz33IinS3VY9VTEoMVbixBxwb01UUm7QYMtEM0Sl3Nh5qlOcMgp2
         nfgi9z7Tsh4q0wkRSVBM+Z6RhSbwxNwMe+XS0MFyu62NM87SA6rFMkSAMXoM7rQDB8Nm
         1aKZVeZZVhdomXaG/iaQSqT/d1LBL9Br82nT5CLm6BPT2rrgDRb7XgpJKqTeYYrN+FoU
         hsi9dgTII6FS2i9f7TDXMbSTsdei8a8VwRCm5FgsyxJF5AJewC6WEVHv5zFEBsiAwwnM
         KPExogEQR6NMi2wqLRqy/SzuUlfpIxsim8XQ3SAKMr4h2n58umtihrUgAMJOLJS3yftb
         oJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734077150; x=1734681950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgwYE8AkKohlShjZLrwteb4c+nimfkWQZUupQYO5W68=;
        b=SCEIgeOLGG9esWhobx6SnNl3uZMMioIg+pp2d83sfMRdQRiqoiAuzlUDRJXAqBFYdE
         4OCOuwxhkNcqoUjsZG+ZrqnoAS9N10MMUwQqrsXzdXvVGGJIfyr9GSp1ikw1sGwx3sI3
         ydA7r2Ns9YgS1Z3Gehg/p0lHPI6nyqMIWo+Ab+wQrSa9c+ev/o6h95icUFe3N0uc7X7O
         abMYKRbtygjQypVySW/jPcjBU1dtXHOgmO61j3T4533OwIoZ2VR+r2CcLPMVPoB4rDF6
         PND8oXvgBWoa4XGpzWvOBE9Nxx1+UVMG2v3vI+NvpPRqtQALh51qChjAIemu6bflJFjE
         X79w==
X-Forwarded-Encrypted: i=1; AJvYcCV+wgPwg6xhq0ZSPR1thPk1MhHM1FkuTDE1paA+t7INBv6IVOsLmJ9h7211ljngmKcNi8lB5MhGkax7mw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyqkjU6eaZU2liLaPNX8SXN7YlyUpF+gNq15r+I5YZKpeLhI6Je
	xxJX6YlQsDEQaE12NKNX4WRmExqB5c31Odzt1WJ32T3B57IUOS1DOXetA0fVV2Q=
X-Gm-Gg: ASbGnctGOJvNZbJYXMHM6k70keM8/ptT1XniRA+cF6ZC9H16rwAV/DoMg7mmUE1h37q
	cBj8zA9Se0oA9lVSE/jH31lSf5TORYSE1/vWzTW/oPxFH2E1FERgsd5QsrnxX+t4dTp09wA852B
	osyd2iDQf8z1VBUU1AEGHQfs1QyfNsTQy/OG5tBjfA5r7PnGw58AyDbb85QiyGWFYcl97fn81YP
	H3g0sYnYEnzlgl8k+xdjUQ1Bh1WhSMrwjnnbuSORFLocxin3ihyXL5zyg==
X-Google-Smtp-Source: AGHT+IEBU3KaEVduDDJFmDiYKp43p4o//mXEFM4u7vCzKG7h47JoeDZ5E1DdrcH3VOsdWE+nfKrYuQ==
X-Received: by 2002:a05:6402:4584:b0:5d0:ea4f:972f with SMTP id 4fb4d7f45d1cf-5d63c318beemr3590523a12.8.1734077150211;
        Fri, 13 Dec 2024 00:05:50 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3ef026a41sm7507030a12.15.2024.12.13.00.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 00:05:49 -0800 (PST)
Date: Fri, 13 Dec 2024 09:05:47 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	x86@kernel.org, linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, ocfs2-devel@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH 1/7] vsprintf: Add %pTN to print task name
Message-ID: <Z1vq2-V7vB5KhBR9@pathway.suse.cz>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
 <20241213054610.55843-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213054610.55843-2-laoar.shao@gmail.com>

On Fri 2024-12-13 13:46:04, Yafang Shao wrote:
> Since the task->comm is guaranteed to be NUL-ternimated, we can print it
> directly. Add a new vsnprintf format specifier "%pTN" to print task comm,
> where 'p' represents the task Pointer, 'T' stands for Task, and 'N' denots
> Name. With this abstraction, the user no longer needs to care about
> retrieving task name.

What is the advantage, please?

Honestly, I believe that the meaning of

	printk("%s\n", task->comm);

is much more clear than using a cryptic %pXYZ modifier:

	printk("%pTN\n", task);


The %pXYZ modifiers makes sense only when the formatting of the printed
information needs some processing. But this is a plain string.
IMHO, it is not worth it. In fact, I believe that it is a
counter productive.

Best Regards,
Petr
