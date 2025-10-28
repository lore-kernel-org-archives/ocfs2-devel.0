Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB441D5CFB
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 05:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761629894; cv=none; b=kw6a5sNOao4hX7I42RPc4HHgl0n9/6TSLF7D3XY/mlwjhN3wUPKjNv1jAX4/z7bfCyxwRLiOdAPiewcX+XR6Z2e9UKP1ECvdrLajIyOkljHZCtGmdOgmzRGAteQctacMmxV/vGEtInZbiayIYfy/w9nqCCq9h+egH2ndEvrjWfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761629894; c=relaxed/simple;
	bh=MBBUGXoG1YUz44tfK9dC7obCvP9yR1LjZ/0B16rOeOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bG3AhFtCRf33C/ntifZe6YDSXMgfPo3f+yJEtM+CdyqrUhE0G0/ymsWzGnCf24RHMe8ttpJQ+tsciEJYkhtHc0jE6z5pT4XI3bCim7+WRbUGAAi/REXkhTQW+5hfa6olvrmEKq22xnDuJV+cxQVDdqZtE/Xl0pVJ/AX1NWzvay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DcI+pZwp; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DcI+pZwp"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-591c9934e0cso7986127e87.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 22:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761629887; x=1762234687; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wy1ynDaI6taIoYDlBwI1sYFOXKyWHxR4eO6K9jXR3Y=;
        b=DcI+pZwpJYeMSgdFUCkP1ANCcQkJOhJbzauEkJVKLZnuSK312R8a2HCZGpDIAgbcXh
         pFv+Lj7M9BI765q+McVgCgUxMFeR08fpucXsKXcp83KD9ln6Mcmuvosi65nFQlkvUoYo
         k0yr9Wtd0A7vvOrYQLtBXKN+UKXIPCqghrtFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761629887; x=1762234687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Wy1ynDaI6taIoYDlBwI1sYFOXKyWHxR4eO6K9jXR3Y=;
        b=cRMK3yjf6VlAh4gctRJgA0b3b9Qvkdewmnkact2Zd+v8K5wDdPBPNUnwEGgNOoY9ij
         nlbeWCgkJFShwSsbvx9kgKFoxv0rJgMAbrfU30UXRo1S8o5HeIgxm1sGQCzwyvXeaB1y
         LoUian2xxUFIk51AwC9wcq8eu04O8nBzDMCn8HenoMeGA4qN3CGq8MGTBXhTjNt9o5OF
         ai4xzcXdXm+/49QUr1IHU+XMsHPexYGs6Evx2OtjrFdqrYsdXAAyzavsfzUPvIoM6lnm
         HjbSWLf0t8irgVdhDegQOBtS1Co9c62i6ncFZ2vB7SnCVXWeW/I8nrYkInto8ZPdcTWW
         +nKA==
X-Forwarded-Encrypted: i=1; AJvYcCUTPzFsgjOCxdK9pmktA+4HhVKG2vGuW4c7j4s4kwwJHQ5/HxO5Hijm3xZezGHn0lzUla53vXydgDqDVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfEQacCaFxMLdrv7mYKrLgYajE/XteZZCf5w6wbCnzJ3aWDFfH
	gvP9MRcdVSdPkbObE5gs2Rmo4435JrYjUnZ3GfIFGHI7PsIILLJZCMAOptZlI1DVuPb6o+zHgqt
	N/EDwjmgrgw==
X-Gm-Gg: ASbGncvh1JEGKdREgSlhWMsg4JpwyIhKUja5c750MvOKdtm3+mTYae9TCe0FGpvr3fJ
	feFxpSR1wXVGLyJoN4aCooQJo3mq0NO6utm2yg25YUMb47/dyHCh2OgR/yQdYt+Xa4FNz8unUGe
	FsCRUU+xBzdkl1ERHwCV5lqCdZ30ZX4pUrTI8aMhfPf2jzcPNyYd3O+n705LdFVzFP3d9eS3vEK
	wTc+8+SuIeA2ApZ5JHRLSPONgzx6jjlbw/19mc5Pia6OufglgW5T977vcxSo8IQfvobmgvYl7bZ
	zpB5IPI6fnhJy2fuH/YCJevEtOYg1E0JPWhyaWGqhQe6ghxSdxBqDj863ocACghWdm8BajMWnRo
	IicleBz+MsWPhWmZt3C786sCKZopCpGVuJPKBKRM5PmCPLIuYVqUkiWhRJbCu7DJrceIAbT03vr
	sw3g0TtZdn4j8XU+ygm/p08t6uTi7ybYqREAASYP9vw+D4twqSjA==
X-Google-Smtp-Source: AGHT+IHARa/YTqntb6qAa0GgdGU+J75Q54PbgCtNCB1y2FH35NtaMm0yxcjxBAySD8ObdKG5cIbL/w==
X-Received: by 2002:a05:6512:b91:b0:57e:65dd:9bcd with SMTP id 2adb3069b0e04-5930e99b894mr652539e87.13.1761629887186;
        Mon, 27 Oct 2025 22:38:07 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f60dfasm2812183e87.61.2025.10.27.22.38.05
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 22:38:05 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-591c9934e0cso7986084e87.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 22:38:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVwdRWAk7aYf2Cp2iWl7ywgCsayx3MgshVvgKQvZNUsExwtA8+Igy8Imt1WtH7Ar0zui6d7svQYA9I8Nw==@lists.linux.dev
X-Received: by 2002:a05:6402:5346:20b0:63c:1e15:b9fb with SMTP id
 4fb4d7f45d1cf-63ed84d11b8mr1725392a12.22.1761629565035; Mon, 27 Oct 2025
 22:32:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-32-viro@zeniv.linux.org.uk> <20251028015553.GM2441659@ZenIV>
In-Reply-To: <20251028015553.GM2441659@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 22:32:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCnWNXcmZAgxfV9p8rKJfjxcceNzaxia41f675+yEdfA@mail.gmail.com>
X-Gm-Features: AWmQ_bkREqIMu_f1B9dwguEOjRWmmtrQM-BuU5ACiXPx-fVfEkz6aAECfx6yPOQ
Message-ID: <CAHk-=whCnWNXcmZAgxfV9p8rKJfjxcceNzaxia41f675+yEdfA@mail.gmail.com>
Subject: Re: [PATCH v2 31/50] convert autofs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Oct 2025 at 18:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, is there any reason why autofs_dir_unlink() does not update
> ctime of the parent directory?

An autofs 'rmdir' is really just an expire, isn't it? It doesn't
really change anything in the parent, and a lookup will just reinstate
the directory.

So I'd go the other way, and say that the strange thing is that it
changes mtime...

That said, exactly *because* it changes mtime, I think the real answer
is that none of this matters, and it's probably just an oversight, and
it could easily go either way.

               Linus
