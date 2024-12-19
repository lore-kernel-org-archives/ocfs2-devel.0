Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9810D13C3F2
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 05:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734587199; cv=none; b=gApCl0mIIopvy3MhiEuVyzpCSm0nQfSVctbE94z3I2YGJf4mbJZKREEnfX0U9VjG7N101W6dyMeXbjIbakewTU3ek6kSpWy4Z5Zo3mbkmCeTPh3V3GDO08BytNbXQozIdlt+UE3Eu6Yzd0r/OnyuBmqBTOfxzzKVKYoutwpxG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734587199; c=relaxed/simple;
	bh=vmweOCPf2hPcApIN1PrSCq8iAIG5u7S4Nd5jEVV+m9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d9JSKi36vQzGF7SVPsyyy2b35+VZZH2o7xApqxDgVPy5BZ7jjzVAu0Scc7XvC65emIrBD44jGY+zsQ2sRkI7Inon2pK2kAguhxgiORpEsjlrnpGHUtXehgmnG4jJTAXwLopNl3fdl0Rz4lEXMMqjugCGP4Nbay9A9jZvuUSi/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RL0Hl6N1; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RL0Hl6N1"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4affbb7ef2dso242554137.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 21:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734587196; x=1735191996; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vmweOCPf2hPcApIN1PrSCq8iAIG5u7S4Nd5jEVV+m9M=;
        b=RL0Hl6N1eValgFgYTZvV0VSa/qJs9XxqH0Vjyvjo9kbEu81Gk+RPC03VCxbkiuB2eM
         vhwwHUrDtUu6h3rEAx9JwHZdn5BdKhJdR0CV1H5R5Fd7R2Ru768QYgouzf9QYjEAw0Fp
         B1qrI85oqBbpQmf3ZAzVSktACCRcqzyWfVjY3hXoLtirG3qcRLaXZ3wFuMVmpm/RgrIa
         isQaZ1iMn+xXryC4NewFrPoqNhEn2pHbtsMLhSvqRJ17cPFo1BuW4IdZ6UNt16Ec/xU9
         Ri1P8YHDILJxg8eEAUZHvYqA/L4fKWsfaeBC+w00gyITWQ7tADyxx4xX5g5WR6hNtl9P
         ZGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734587196; x=1735191996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmweOCPf2hPcApIN1PrSCq8iAIG5u7S4Nd5jEVV+m9M=;
        b=r8pAkOK25HSeQzfMrq5XShkOz3JdNmI3FrpLVpynKZmSBjeRVoJoWL/mNSGzeP1p0b
         L6AV+tqqNa6BjZG43QX0BbpgkykxK/c6vwtb9Vy9LN1kYDTsbDSsLhafb2ZeNImnwmL/
         vwcfguLOARnjfn/KzkSA9MhPNTKP+YBT3hiRNb5PAuIlr5dBfoYJqNrgSjdXUB1d2lUX
         eMTMUuUzgpX6NpKaGd5WjaGuZeTCYHSyXRrDL86d9CczwRWCWMQXem69nacc7tuH0tCI
         1Qs7vKoZSS2x2Xk/7MJIz9h8lJIqr/LTjhtTgqgCOWpZFPA3pvX+y7PeLBuKoe1Uwhh+
         5i3g==
X-Forwarded-Encrypted: i=1; AJvYcCUMUCkFST+18YWf0Paa3QnmKDQ9/8NBf/isAFeYhl9s/uK7xQdDz0wlyAOcVOGTQaT1sYaEnzRk/7d1NQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9KFZoGNMrdgMLGjh0h1sVT7ogTGiLBdGsH5MI3S82xay202/Y
	qp+eTmyan6Nj6dUORzgw7Gc+WBcXLaIDLiIA8S3ETie+jHG5Ris+93iErCzSHaFx00+O5uONLMV
	OwSguzPKrEJClc/dbuvJQ1VbVHyU=
X-Gm-Gg: ASbGncuDYuhfPqqo+1QuHKpzLf43AIY1Fb2k8uJ3A2F5OtGZRdtFfp9aWLyrgJCqv4Z
	0hS7dLngh3no8g6R8gSdvDZFc2QkYBzjefZ9Ueg==
X-Google-Smtp-Source: AGHT+IHpfrkDslR0WkzkpI9QRmrJU9wY4lz0kWIbO1+8LYiOiQJqrGb7EIEQtvOOznmRBwHJUVwfgIz6/3ouTWAViKM=
X-Received: by 2002:a05:6102:3f07:b0:4b1:102a:5834 with SMTP id
 ada2fe7eead31-4b2ae853921mr5561332137.21.1734587196459; Wed, 18 Dec 2024
 21:46:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241218023924.22821-2-dennis.lamerice@gmail.com>
 <f61955e5-9cfe-41af-aece-283b811817a8@linux.alibaba.com> <ee744944-359a-43ad-b9cf-72eac1b374e4@linux.alibaba.com>
In-Reply-To: <ee744944-359a-43ad-b9cf-72eac1b374e4@linux.alibaba.com>
From: Dennis Lam <dennis.lamerice@gmail.com>
Date: Thu, 19 Dec 2024 00:46:25 -0500
Message-ID: <CAGZfcdn2OeghHDhg5N7R34TLehaUH=tr_GvTVDydZAEwFRqdJw@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

> Moreover, better to leave a space before '{'.
> Sorry for not pointing out this in my first reply.
>
> Thanks,
> Joseph
>

No worries, I think it's actually my fault for forgetting to use the
checkpatch script before sending. I'll send another patch with the
checkpatch warnings and errors fixed, and I'll try to be more mindful
the next time I send a patch.

Regards,
Dennis
