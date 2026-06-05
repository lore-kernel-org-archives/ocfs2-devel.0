Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D863CD8CA
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Jun 2026 08:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648417; cv=none; b=txM5GEpL5Fw5dveNK5dh5iJPUmXMl697XtUmHWippXMXMdk7qARM/D9twItnqWY1dX4PJgMXwDVq5GA0IwDOP7WDBVXgRAakWfDuQs57qDzVdKJtL/8gT2lyCizeIacA/B/HQqd37r9H+4/xRc/cirydsoJZb8VQOQrYxkcoigw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648417; c=relaxed/simple;
	bh=dw5ZX2TWY6dZxDUNc60ak9mge7y/ImiGMvgzZEHUi2g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utsahC5U0hmV5Zl7UsE0RljSA9eBEtx0wU8DqSn3rLwzLz53m8VEdhkf8uvS9P+qJLVtKYQylxZRLheABQpEEB8tYjhhjTx+v3SZA5bIVrLHw/5LIsfCj+UN7fIxq00DYLllkyHnjjEdABoRA/0Bhag+E8vg5oND8FGEaxtt6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwLbLxeQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwLbLxeQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-46013161068so800663f8f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 05 Jun 2026 01:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648415; x=1781253215; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=hwLbLxeQOFJYwiGlgVD1PwXQ/vDpAzPOTWxtPtNb6wO7j//jbwQQhVb/7jhx/dBawO
         CtNU9g1mATu9DTZaqoeegDQQko7mFcwYH14ClX46tQSCIX6FN1NwWm4I093KW4BZCIE7
         hPCbrLiSw7OXSeYJyDWLOqDjJ/uOFcGbTI74MOxihr7GmwxZZoFkHzWAKGZAI5xrassD
         /fYNvugtzoQIy+kT+I03cDrMVIqWxRWVwv+/wmQlq4MtFzcWM7J+0gcQigUKBNYdvbQM
         CCsNbg/ZgetlN16KQDZXcnbgOQi20uUq2mJ4yA6HPMUc+tOtdA8MuH/TJRAbH1H3/AyU
         SojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648415; x=1781253215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=ewbwxTE3yvJDGSQ+kaq/+cJVmN76GAFRaZt0xrmjlHYOr5k67/6B9EQbNxSqOxk6P0
         lgqqTyHTKWn6G53K3I0XRyUqiMNpsHWoxfajzqmLn2bpj3RLkmArSdTQ8La3HaQT1Bc3
         econYH4fTojj4+aQOYi11bY3dWN/FPWFgQ52nxFNQCx/HRMHfZKAFxuD/0DY1aKicq/T
         v7VR/cgqgrwntM6LXrwHeF8i3+IjNTnwd4gfmFZtxbBA5DUhhzyQ/yx+uE6HqVaFcfwC
         wa7RdtUMW+6+KUOqmBgcvG1tFpvUovLs8vIQ6VW0dXgbkVJBOy2c2CeRAXOUYHYVDWeW
         P2uQ==
X-Forwarded-Encrypted: i=1; AFNElJ988en9g6kYxjznmg/tPQoB9/1eVWYRBQwnLFdC41yarpqjJik5jR+BABGl4A1tqUA9v0/OySp9vS3+/Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwF8D3Tr/BvgDiaPuHlhNqpJAqdcXQEhYrMtyULCIAmv3WRjylR
	9SpA+WL01vyt6L+az6Bq2+b/NGjxkFf4r1PY1TUN7hcRROKJrgzfG3TL
X-Gm-Gg: Acq92OHU4ME39Aw2QFZuzMIl5o5K25ml78u00FIX8UzkzQFF1h62IRWwt7AU+P35ytf
	w58KitVNbWRrnZ/9ei8lLNU/GnRu4hPFVBM6lSnYIHLpZ91cuzil1UgfzItRBESjwB1fAEfz7Rn
	LQmHt8Qh8LqBMd3FkHuHVrrY75u+857hYny8JjRfWMFUNO3FAlAIoXMz9hmdUMr8F3X8elMutdk
	9hqbHQcu+cMm48YZo4A/9fuGMYm1/d7oi1nLQgbVe8/F3vAuxtOj7XuACZoUnhNWVOejS0WtQW5
	Qs+FAH5NoxtKGe/nBzrSQHS9bLb7guyXaBlJNv5EBOkR1tL9oI6w6dCU2v5HfVQI5Hcx4yDzvmg
	ZUhe3bpbHoUSg0S6Cw3vz7byZnPAGYlsGjrfXXChn6PRa7G1RVXb6JGb2PUbSYVfZcvv/4UgJQR
	IRVLXxvWj96gyhfncPI52g7msF4iUK7CmgPfOoijdgtgXrDlcgtQqBZdJ/uik/5Jf7tiUgD3A=
X-Received: by 2002:a05:6000:1288:b0:45e:ed7e:f8f8 with SMTP id ffacd0b85a97d-460304f07b8mr2783510f8f.8.1780648414528;
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm24140153f8f.9.2026.06.05.01.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:33:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: Mike Rapoport <rppt@kernel.org>, Jan Kara <jack@suse.com>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260605093332.7b067876@pumpkin>
In-Reply-To: <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
	<aiEX4UTxEnBTjVKo@kernel.org>
	<ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 10:05:52 -0400
"Theodore Tso" <tytso@mit.edu> wrote:

...
> I suppose we could do it with kmalloc() with some flags which to
> prevent forced reclaim / compaction, and if that fails, then fall back
> to vmalloc().  Is there a better way?

There is already kvalloc().
I'm not sure how hard that tries to get kmalloc() to succeed.

-- David

> 
> Thanks,
> 
> 					- Ted
> 

