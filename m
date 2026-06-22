Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FA43644A4
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 07:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112484; cv=pass; b=c5H+EA7MYkpnCCIP0r8cEKLwL8hCYdxbJhglhr7cl3kczRv8tnIRBV1rUeQ2ZiPHOvtuprXzehlLgrOWzRMq4SUWaPKkM/hOe/Fy85ykvcx71vh0CWdHglk8/X37Mu16r/6LP5yoxtbEkbRtKV+XiTAJLmkO5vDk9rMYhHuZBxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112484; c=relaxed/simple;
	bh=ir24aUHO6A0liTvN9pHV2uOiWxrK6G8m0FdSyJ55Qxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ad2Dkp9OPLbE/9HqSqhWmdOE5bBofRsbxun5cs+7X/LFJ1+bfv6Ddd/8cTh2vCW0zV60s9pjqjCJ6k//pqNs1eydqkCbIk5LgVL5e7OFosCSb0ovCQEpj1Qmj39eS6W4m7GMIf6A6PrByb7yaEjwZxZlm8hQr3ZiPBG8Roqz/IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhKl1w8P; arc=pass smtp.client-ip=209.85.208.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhKl1w8P"
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-3967726bc47so38287261fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 00:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782112481; cv=none;
        d=google.com; s=arc-20240605;
        b=cXxdxsmOVuBAoxthTM5ylxEFI4dWlivh6faOO2qW4pF6/2eHOvuDhtzkesqJ9W0N6E
         huhVy3OwTyUolue0Vc+loqZJ4FlpajuDV3aJuJ162G6VnGqx133Q5T0suYSWlhVIM4+6
         mToEiuL1qMPTVD0MPiwPL38pfcLaz5CSoJe4dnEbWEqnCqdCWawvETvqfI4/pTS7eWUE
         LlKIpzFT7+3CKbEVPrNHgVBKMRjA5rcnFOnW8vRBNl1D02Oo4Q+y9ThplpzljnKgYLzS
         ucRF+osES7X36w9wynpbDPmjPxBr9SbtuO2uXenRnwtzhQ7igzm2dK+Cid+HlCHzRU9b
         0uZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ir24aUHO6A0liTvN9pHV2uOiWxrK6G8m0FdSyJ55Qxc=;
        fh=yJ1elH1q5DGbbz/BcCrYHVIOMEg+cJMsFp3q0OU3IoU=;
        b=BPSFshyGoXNyIzz/dTHngg8hcI+fX+IKi+LbocCSa18BTRVeIggs/dEC6WUwrIvztb
         XetsOWGLk3HXBuobv08aFQ/sUBvZBCtK6HHbJuMpD+WLrVXFAXPLyHiVvNc+SB0GUvN3
         +zWGLhTIKoF1gXaYrBgqONsppULhLP5FYnFbXJcn78El5WofG2GDvAA6xiNXB9WmwtrQ
         4fail9XyDx/165R4o9JTcn/IdfPkgAQBj25/y/EWbbyGRc4a1YWcy/ROKMA5wGV9v9Ne
         IN3AuCfPLIqDr4cOtnKQIgqHK6+IqwjOQIqcfiXn7+jI5OukPuBv9dMz7HYyib95bqTD
         2erA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782112481; x=1782717281; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ir24aUHO6A0liTvN9pHV2uOiWxrK6G8m0FdSyJ55Qxc=;
        b=NhKl1w8PiFcxjDTyonfBujG4K0CHm203HYN3scpwOXyKxX+5ohmSngWPdKmRY/m2uQ
         QIUiSmQ56KaZJ+S3oO5VvEg87+V4jNBvvrzid1VhhvdBSVbYktOIcekq3JHazqjK7nFy
         W7mPmERE0tyujUoRO6/j3tdavIK92XqGvVxVjOxsgX3qAaf6HRDRdAqzPN8IcMWiPqFY
         wK9er8d+xUWN9ITAuwHavWlh4UkFFl4o/OvImV4+PFANFeuQc1GI19YIxriFc5GEZYVt
         NBQUV60SDmsy5OjQ8l1TBQ6C3PPsqTQVrX8xSDmKiXXPWW6Z/8TF+OuuZLPom6aA0OPf
         ro0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782112481; x=1782717281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ir24aUHO6A0liTvN9pHV2uOiWxrK6G8m0FdSyJ55Qxc=;
        b=miAwc+2t/7gFvF/f98VNRRfXF7qtinUAueuRYxYAqAmPslEwJ43bhPW+lWVTDVPk+Y
         JiNBO8CQ2D70VNti3BKYhp127p+f6Q52WSX8oV7oMnmxpGhkOhMzYOOzQ27ZVjinJM6u
         XFQH+yD6BGeFoAIr9sZ1Ztkp3Clz1myJSR3WfEurpCwa8y2/YuuxrvH92zYm+FpAWjs5
         7NR+/iQmGH1dLWULz47YpdZ4TMvQH4gQkNFM2X4cNslwp6YDhEzcLXyIRWDESjTjBPg4
         WyrVAAlQmb7YhkkJqdUhfDL0Qa48laVza1W+x7KG/2ZIZMSV914eIPuqEyUz3Mopb7hr
         VE5g==
X-Gm-Message-State: AOJu0YxIst5p2fSlsI4kNSe3hOjCxRrQTrzjrbxaN31KeGwWHy11NmDs
	3Y1LNm3P2p/IxfuHX3Hg2DxG5pNNmIB3r96ZR3l9aGXHpHFZ6xJ8wYdhh4xNI9k+RMeXbXJHJt+
	IE0ydtJpwH2UKCdDnAVfVPtsC52ZVrZU=
X-Gm-Gg: AfdE7clvFXOX5BfwJXSVQzxh/DukwpWnNex1SuVf8gqeqYkejH6uLSW1eU3Infq36Ga
	AZ5xH7R1KeCamo4zl9essxCpswblUCBtPhrrKRLhzvyxWjFNj57TBTM8hv2XjTIUureTEhvH/tU
	1O+9VhE4JecyFNcmtow5R0qAkJ+1Oz07Xekp4xAlHjX2vbOOsdgFPIN0q+xCXikfvEgN6uBVKsB
	IjoQcZdOk/GOBKUQUABxFbnC5X+WYwEMaya4UFIc4JaWkYvi7b0vPetRUM2duGf0QavUxd5jH9j
	nZ1oK75f+cIAJCkhTkZzIYRgW3ElIVd+//xe3xAxSneXshXOIsWuZd+S
X-Received: by 2002:a05:651c:220c:b0:396:7f3c:2723 with SMTP id
 38308e7fff4ca-3998e518f89mr29960761fa.21.1782112480658; Mon, 22 Jun 2026
 00:14:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616091132.3990054-1-rollkingzzc@gmail.com> <b9dbf1e7-f19c-426f-943f-50456ee12aa8@linux.alibaba.com>
In-Reply-To: <b9dbf1e7-f19c-426f-943f-50456ee12aa8@linux.alibaba.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Mon, 22 Jun 2026 15:14:27 +0800
X-Gm-Features: AVVi8CfNRHVUqroEcbtFSPx0PqoqRQ54U8prGN2zAX766QNIzCC8sJfCuMynPKw
Message-ID: <CAB7XQsGHRqoOVW+r8xaimnKL9XHVEwG847Xex5ck_tL3jsr5ZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ocfs2: validate xattr metadata bounds
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com, 
	Cen Zhang <zzzccc427@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

> Hi,
> I couldn't apply your patches cleanly upon the lastest master.
> Could you please do a update?

Thanks for the notice. I=E2=80=99ll rebase the patches on the latest master
and resend them.

Best regards,
Cen Zhang
