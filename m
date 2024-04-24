Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6112139CEB
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Apr 2024 05:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713938055; cv=none; b=UlC599bGOe0zA3rl3/G5DkbdFgbBBloPFkOn/zJTMkiE4KDR5OXiov7B1mIaIrpsddx4XGi8R0rVw5+M2l73nGFvI/jm6E4kZ1jVZsDl7eWv4pOAr3tqzI7JZ5aBOOinnymJdwVGtoWqJui7uEFqiWsAYlQSO42bmF69BuyvA1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713938055; c=relaxed/simple;
	bh=8GCqrEZYtdL9iyU/wkrfGbyINGSWQcdRxW8/g63tUnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2/KcGEpbc1yECgm1hnJVlakIdMJGCIFNheevV5vDPms0IeG+kP5K9DpQxiwhwxDrfcay2GLBBDUShK7cdYDg484msCM3DrKF/TMZLBtiTI5ZMGgqOZUbx5OwJupBlM5Pp1tnamV0r+UFFE611pbAxOq65PmzqpwRlvrrUawioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V+hjJ/RT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V+hjJ/RT"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41adf155cffso7439335e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Apr 2024 22:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713938052; x=1714542852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BoSq6xCai+FLaIoay/b3hm+lCkx9rjx+ZUFol25m3gU=;
        b=V+hjJ/RTG1EHnlVLP5+WWwSaz7TwxqB2+T44KuxQSKoIARpCqkUaKmqRVAIDMaqI3N
         JfjDE1p91b3OfdOHnR5CAxMiK3lOHs69P4I7ZT6RJ/Uoj5oLSKKmXipWqBsh0XJvXJmF
         0p2dIPBQp5M0wUAEVINBWdluB7cUK+i4JUxbjkOHvvxh3B1kjg3j9dZsdnabrMBJ77c9
         3F8Ugu2TN7/HgIe6dZ1v13TRR0iWPUKknde70HHgjANpNj0evF1zrc/ZU07Vynlha1q8
         TM0/ss+DBFFoWgHUCpmGdGxP4wbVO6OQNyvV9KE2PVHO1DkSIbGGpHVy/MyjJXS+Wopz
         XwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713938052; x=1714542852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoSq6xCai+FLaIoay/b3hm+lCkx9rjx+ZUFol25m3gU=;
        b=HdG9Z3vBdg8v2B+PDmDaf4m8t9bJURUp8vHMi+vm/+WwQ+LITh6fef8/StwQhpgM/I
         56QdC/+LbjUCXyrqnAvXuNLBREI0F7oTnBAH2q1EzpAlx4d+Oi6ViP6TVqUC1i20Txfl
         c7fYk0MOR9DLFQj3KyVD4xnKMiDDwj3zDA/ZONF9bFHcj+hD4Uow2qUpsx0PLOJf4WyK
         zXxrz4FR7A+S6i3DIZLCrEXtYbhx8pVpb3jIZGcI9cdtHZaO8ZpiGSyxCJeplfLCW8j6
         548jzjG+8tWasLkGbbVp65aVzpOKLqESb6io88n3PYCBGjUNHyzH5HtAOdezur/NMcP+
         vfvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW4d+sSxIkvSqDMy/RQoHOf7m5uXOge0TAu2cyKEMXKWUkP5LUkxs8WDfCkMnsPPdrUHAAMDT7uNaFiXjDJcojpBZW0ub6uhhKX0s=
X-Gm-Message-State: AOJu0YxhgAheoanlWHlgN/0NYl9oEoXyviDOT2HXf2EC7PbfQaVfPi33
	vmHxMBRpO0qg9ugTK86Fix/bmRk7w5e+26CeOO78p3PsmGC2A/fXS4VCs0PtZXAqPMzdl6To21X
	Y
X-Google-Smtp-Source: AGHT+IHSoA4kuaa1pj84ZD/gkZiYcDWhAuzxgGc3Xu20mSyfhUb+ZD1UXptCBsBSyikGCveqvLeU7g==
X-Received: by 2002:a05:600c:19ca:b0:41a:141c:e199 with SMTP id u10-20020a05600c19ca00b0041a141ce199mr1063594wmq.8.1713938052064;
        Tue, 23 Apr 2024 22:54:12 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c4f9200b004169836bf9asm26306085wmq.23.2024.04.23.22.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 22:54:11 -0700 (PDT)
Date: Wed, 24 Apr 2024 08:54:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Colin Ian King <colin.i.king@gmail.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	kernel-janitors@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH][next] ocfs2: remove redundant assignment to variable
 status
Message-ID: <25bc03e3-1caf-43d6-9a9e-74f5c2093c06@moroto.mountain>
References: <20240423223018.1573213-1-colin.i.king@gmail.com>
 <8e22e6d4-4c62-4b78-9809-5648537af775@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e22e6d4-4c62-4b78-9809-5648537af775@suse.com>

On Wed, Apr 24, 2024 at 09:40:33AM +0800, Heming Zhao wrote:
> On 4/24/24 06:30, Colin Ian King wrote:
> > Variable status is being assigned and error code that is never read, it is
> > being assigned inside of a do-while loop. The assignment is redundant and
> > can be removed.
> > 
> > Cleans up clang scan build warning:
> > fs/ocfs2/dlm/dlmdomain.c:1530:2: warning: Value stored to 'status' is never
> > read [deadcode.DeadStores]
> > 
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> > ---
> >   fs/ocfs2/dlm/dlmdomain.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> > index 2e0a2f338282..2018501b2249 100644
> > --- a/fs/ocfs2/dlm/dlmdomain.c
> > +++ b/fs/ocfs2/dlm/dlmdomain.c
> > @@ -1527,7 +1527,6 @@ static void dlm_send_join_asserts(struct dlm_ctxt *dlm,
> >   {
> >   	int status, node, live;
> > -	status = 0;
> >   	node = -1;
> >   	while ((node = find_next_bit(node_map, O2NM_MAX_NODES,
> >   				     node + 1)) < O2NM_MAX_NODES) {
> 
> This mail cc linux-kernel@vger.kernel.org, it would be better to only
> cc ocfs2-devel next time.

I used to tell people that, but Linus Torvalds disagreed with me.  I
also used to filter LKML from my own patches but then I ran into the
issue where a couple subsystems use LKML as a source for patchwork and
they get annoyed when it's not on the CC list.  In one of the threads
for last year's kernel summit people said you should just use
get_maintainer.pl and keep LKML on the CC list.  So I think that is the
rule now.

Except for maybe in networking.  I still edit the CC lists there.

regards,
dan carpenter

