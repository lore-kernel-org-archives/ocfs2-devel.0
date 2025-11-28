Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9556B221FDA
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764340588; cv=none; b=eX3zzgkhhd1ozClrMETwX0pnQs1lhKjh2dbgRrPiSWneUApKJQOxRops/tV7si4J/4zi59Id+0cCPKAZ1twIUvwLpWvHdhChegpZ+AbOXnW5s6kD46MvgygmCvypQkOKBYous0NoTzpD4Erwu55HtVVlimKG6ApxLt2eFHzCGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764340588; c=relaxed/simple;
	bh=wZMW5yG1kXCwzhlsb89stfkowyMwr6Z8PFqrWQvo7IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcx6t4Z3yO5TbyEJFY+UNHY7ZmPo0pyebvpCVNKQcbMyizV0PNwi1BbbvTNXp7CVWlPGDfMf/ANCMbzI98hEhX43VoV1ZxDtD4PJhmLAMPAC7UY3MWp9AuqSUoBEPgKd5SmCIB9yVqJCGoreJUUl/th+lZft1WDsVx/3lnImWQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CEOLIMVF; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CEOLIMVF"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so3608459a12.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764340585; x=1764945385; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZMW5yG1kXCwzhlsb89stfkowyMwr6Z8PFqrWQvo7IQ=;
        b=CEOLIMVFzLMX/eFLl1UvPu7FOVFGQBqvEirCdDYkfMHNllsZhC7zdBmXpI64uEdt9I
         g03eS2dt2hTA/lsSUtA1TU0SUruTPTaZck4N/IYKjmYfZxQM2EGuLZT+92vEETc9VAjn
         PfD2a/1MqUaf7YkEcdm4LlExVB9EhOGwa6fvLjdATcQ5SfY6pRKJ/8yRfBA5IGvvJE2l
         gaEdqoetlp7ncX36v1mYXrJLkZQ/AbrrWz3Vemf7npFY2iTzxfxYsEgjALeg9oGh/iTN
         m37ChsEBKrXcMOCJXcN1TUQgA/R7LNSJzHiphngWFEQqUJWzZt7gTjIVO+i3YckfgYyE
         Zssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764340585; x=1764945385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZMW5yG1kXCwzhlsb89stfkowyMwr6Z8PFqrWQvo7IQ=;
        b=BY/iJaVe8hDKh1WZV27eLp54DysyUrYP4NxMgZ1fu1M8K6/eBANs45dJtpag/ioCVA
         MQJJUgf8RJCQmmlsBXgwdAF5R4jnJtG3lOGsbuHGIy7vgn5yEmRD5ZmygunX7D0yPCSC
         Aq7bNlTC3NUV08B95t5XFvFiiN0yuEC7S5CSJc+uVc1CYs7UcFz3QhOh74mqpev7ndSI
         H+2jsZUHHBLz0uxr/2gQ4QjK3ofLX9kygspQ7cHCzZK+ZeNhnIVQRh7P9LbwfEFn5oEu
         RjG3byprCqIbJYqUbE2y5FNM8qNzHH4B91KQBp5Pwa+8z12XeyHaS8+PnN4b+5JBvyhv
         IQhw==
X-Forwarded-Encrypted: i=1; AJvYcCVjRqHv/9BEKdsvwdQYG3Vn6MXThHlwvVqozMrJCigB90mDQnuOOSQZWf2CCgFVXwtqh4KT53LxVmfjGw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzkQLro0HRVwWoXjIVfdDj2qqcWj0+9NwvQLYRkOCoAFAlpZ3UY
	bxnWr2ublVhBw8UVFeo3q1YI+HKDG2U1Tjy7IeO/nU+RnkGZAtuzOn7g
X-Gm-Gg: ASbGncvlL+TzSeX9IMBg2MXl1QyV2vrsLZS9pxeh3K358wqUtr8PBGPYcNxjX9ohqHu
	NqEv6EsRsqqoLQbl5LghFF3mv80OhwM663MGYWpu/qW8evHxC+P20OTExQ66An/DxZ9L3s5ozmO
	Y/7fOqAOq37wiDBfuUrVJRaZ/TjLcGguV/wT+Aumu5gNMOe25XNxhRIenusTb+7TfVG6F7CPkFZ
	yLAyUISFjs9EPUuFKO1MUGab2tA0rmRNjLBqAb/lzG9mQC7mIEo6CShDboFRUW3JJtIAnHj+/AN
	lOYVqlph5/u7qWyq42o3/WvXc+J8NRASGTmkJm203ETZB46o1vOheYRLc3G4Rb7nEvL5EzByLeF
	Vihl2DynHuCBhAR+f1QLe+JoF0cbZ19fwf1tsyfemOn6utpVqHTLaUeLy2IMcfXhtUsFpCXLxtT
	NivirMXkJK2g==
X-Google-Smtp-Source: AGHT+IHpPauwzhwmhu6zcOp6AHN42ubEiCexcQ1bJwxw4qAsBchwKIwRVMQg4c6r/SRluc+flbs+QA==
X-Received: by 2002:a05:6402:35d0:b0:640:6653:65c1 with SMTP id 4fb4d7f45d1cf-64554322775mr25186209a12.5.1764340584820;
        Fri, 28 Nov 2025 06:36:24 -0800 (PST)
Received: from eray-kasa ([2a02:4e0:2d05:16ab:8837:f306:fdf3:a46b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a90d45sm4494719a12.8.2025.11.28.06.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 06:36:24 -0800 (PST)
Date: Fri, 28 Nov 2025 17:36:06 +0300
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <aSmzVvAy4lM6BsuL@eray-kasa>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251119221723.171746-2-eraykrdg1@gmail.com>
 <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>

Hi all,

Just a kind reminder regarding this patch.

Since We are participating in the Linux Kernel Mentorship Program and have
a nearing deadline, your feedback would be incredibly helpful for us to
move forward.

Thanks,
Ahmet Eray
