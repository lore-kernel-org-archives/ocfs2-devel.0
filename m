Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF392FE079
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 02:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763432844; cv=none; b=gv22Q/bnhftHca+QhvEenAEJwGllbpQj3wx6drah/hMc8jtoPN9t2RK1n9+aeGWaiY+MqxMsQVdq0LiyPzrz7RzNzJ4aUbjFp6orc7RfhvEZXeR8Ot8Y0ZYq8L5U/Cmuf/h87weHCOFaFPm/empcr2KU9fTNouRlM1mCH/HbdYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763432844; c=relaxed/simple;
	bh=TdFd99WO0GZ2RaZOodTszoTAbr/It0kx9XCcaAtNngA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0NhAv8BG6jD6w4iVfZArD9BB7YEdcjyHwPH51EjyXkSS3tPlJGyt1nI3ijB0cLYj3j0Zhvl4cCIJkQJKi6FZXvRv+h9VJIVxy8QaPW4E5rGvkIPef8z+d0GdmSOiUXR/fMviZySD4x+h09JwP44C4gqjqHYdVI3rbpl2XV+mdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=doYLmAkj; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="doYLmAkj"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47798f4059fso2369015e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 18:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763432840; x=1764037640; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ytTwf0LdSCLC+7s7RU9Jmacg/R1MLt0GHTXw2i6fpKo=;
        b=doYLmAkjQu5F6wJ6rh03T2bHm7yPLYmXBTaCPoy0mKj+7jJnRKHBNwPoV8z0Da4tjt
         yiCF3drW0ICoqndg65xJXXHC08oT9CLOysWS3XhHRHMJOz5kARn8nbwjxQlBVFW9K1/D
         BQaMZZDtcgAjGVU/lpmJLuVmP3kpvkj4zOHun42uzz++cl9dZ9GTb/G8BfKtMQ7eS228
         y5wve45dkfq+bJBfpw8443B6JddQxCaaleoOBG9NcKqsPwwYDNK2anqFvAK/YTjYUTC9
         LsqdJgu1t4zKCoTUA9dCfH2EVk9noVR2B8e5jZ3ZlO901VSPMBd59KsB3dGFAOdG44Hk
         QeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432840; x=1764037640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytTwf0LdSCLC+7s7RU9Jmacg/R1MLt0GHTXw2i6fpKo=;
        b=MQTpdFMBjcQxa6yKqXX3XK+qVOabILqkok2ROCzaYyNppaMjeV+BnQjmeOcTi/2F6p
         LgBPXLdX1aLxDwoVVKD/9AKroD3JFWTN1OUd0BHuwcMlf7TfkdxuKaSismMRuqoQWjmO
         CAOY1PDw5tQ9Q1Ze39PNCowaD0u6AzBRKr3TlS6+/Fud4An9hN/5Iy3WhmNNiQwWjumW
         O22eiQCB5Ay+wnMLY1ox7ZALXuALPN2wizx52LeIj8eHUa9u+I2KVxy3aab3UkP2wKsP
         gJdxgoYNAna4rEgZb95as1dcNHXiTaOK02y5GuvYlE+5eVnOraUeGFagFuFsw3uN87Q2
         Ct9A==
X-Forwarded-Encrypted: i=1; AJvYcCU4yYFctygMyfWJatJnHbVW9SyHPBo+yibzwbwrGCn6bEyxSD2ZEOgKqWoWrVHKj8jcdLhcsMyZ5n7bHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxDzdKlPp3wKZv9h/cO5aiDk2+CTrbs+FPqh/7NfehK++WIer6e
	mgoxtXlBdVsHYjThUx37plxlj86CLkS0mBjXd+Md0g2W79eilnsgOY7IAHDLBkuST284TkKJs+y
	gwO+2
X-Gm-Gg: ASbGnctHeP1BiNpUJMcwcfoDED2HbHYkZJwCFWg0PkGvPeHLvgdQJAueIWDxrXt3fvm
	Xx+DaHkDUE7oTJwM5JBL1ezfvYXtHLDYYI1NP9Nj3m+vCD3rXWwUj387nv4/JRGpauIxNiNYtMM
	HTvjDJYXn+4zVTDbbinI/WkT5S+O5yESJRy9evz8DqPC05vs0uxt4dBFL1foXw61/PZxRfJP0aJ
	6QVUxf5Uij1RcwTvQrjpUCu/Xz4FShPPxbLuxOyTLhHNuTaH5GqdoWheywiXdWnSub31ILCtL6H
	8zFPIQsSuq4m9vQeQf/E9ImjCuVJd4yLMcCSlvJ3F42CnamlsMPyA9NRF58bOe34LAC+474MqZW
	d5HfcOspoEPv0giHb0568lKXdUc5aYSVix8u89VKr0uF7xPep+zvNa63b3j0FrNIDAwmo3TH2jj
	0YrTjUqHojIQ==
X-Google-Smtp-Source: AGHT+IGN6FMm00mON7AAdojQtfl81veTDvC3wv0hr/eG7CJNe8ebMu8yUUxVOlFTirSyKH4xbDEnPw==
X-Received: by 2002:a05:600c:c8c:b0:475:d7b8:8505 with SMTP id 5b1f17b1804b1-477a9c3c5c1mr4258535e9.7.1763432840441;
        Mon, 17 Nov 2025 18:27:20 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9250cda04sm14514429b3a.19.2025.11.17.18.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:27:19 -0800 (PST)
Date: Tue, 18 Nov 2025 10:27:17 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: validate xattr entry count in
 ocfs2_xattr_list_entries
Message-ID: <aj6dc2aywm4g3mzbpicrbvdqvejtluud2l4ointcmjzjjptv7e@pzrdk6yufov4>
References: <20251111073831.2027072-1-kartikey406@gmail.com>
 <undb2iy2lstp7oksnbtkls25ql6un4tbokgp55dfozjwxtfydp@eed726ssveyi>
 <CADhLXY4e0P7PH45Xgn65YkD0qoPL9a+k7xeiS3zyOku_JSTTLA@mail.gmail.com>
 <CADhLXY4HLStZcuFuqnqw-Pre-19+kvnPjiyG7pZUrLM3B-eA8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY4HLStZcuFuqnqw-Pre-19+kvnPjiyG7pZUrLM3B-eA8Q@mail.gmail.com>

On Mon, Nov 17, 2025 at 12:08:43PM +0530, Deepanshu Kartikey wrote:
> Hi Heming,
> 
> Thank you for reviewing the patch! I've sent v2, but I used -EFSCORRUPTED
> instead of -EFAULT/-ENOMEM. Here's my reasoning:
> 
> This code is detecting on-disk filesystem corruption (invalid xh_count
> value from disk), not a memory error or allocation failure. Using
> -EFSCORRUPTED:
> 
> 1. Matches the existing error handling in ocfs2_xattr_find_entry() for
>    similar xattr corruption detection
> 2. Provides clearer semantics (corruption vs generic fault)
> 3. Is specifically designed for filesystem corruption cases
> 
> I'm happy to change it to -EFAULT if you still prefer, but wanted to
> explain my reasoning. What do you think?
> 
> Thanks
> 
> Deepanshu

I've noticed that you frequently use separate emails to explain the review
comments. I advise against this practice, as this style loses context and makes
it difficult for other reviewers to follow what's happening.

Another piece of info (which you may already know) is that the kernel mailing
list prefers inline and bottom posting, and discourages top posting.

Thanks
Heming
