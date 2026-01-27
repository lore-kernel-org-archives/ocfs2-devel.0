Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F3B36AB51
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Jan 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769539583; cv=none; b=esLUMQ9EWSV9HeKkA1adATndagYF8QGd1wW2EKCeI5UC4gtoYMy22hysIhdY1sTxqMgrI8vEN83CxSTvr8oROFDkPECjKFm+OANF1aiGuzqtzl5QZWxbvMYWVys5Ez5Muw2FU/kcWZOoDGEmM4n7gNrp0HzPDTmetE8XMtTiEa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769539583; c=relaxed/simple;
	bh=Puce/Y2uoOhkmXAnyMr90G2Ehk1ZPgymehgrzrUE1uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVYFCDbaUzzhzsbxfkTMAALNDXxhdbXw6eTwUaW/Zt7/QPmrABbdjnB8duY3PuvPtCkNP47+hFZ97AZ3TAPUQf/hGahQsKuuZyHk1cBttugToA+fDHEaEH7lQSOUOjwE4SQR9zOgGs06PeI2grNI5YS/3QbiT7voI26f3aMMJxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQj1BPJK; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQj1BPJK"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59b6f267721so5703029e87.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 27 Jan 2026 10:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769539580; x=1770144380; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IB3BhFyIjodZhUGQQ41xIA4/U0Zmh362p3tEBCm/trs=;
        b=DQj1BPJKYF8y74zZpwBAKyJSNByy+W/2GZ40u8j6d2VAT4ZlcBuyuo1JsSP4be+DbI
         ZeiuppFpEP2M8YhSrlhIuDByhrFdBepb2Q214nuHSeLxHTQjxh0Do+N8IpK7twyvr1pB
         4A3K3r1ml94XHRIVXlEZbWAEcdUsmyI/mL5uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769539580; x=1770144380;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IB3BhFyIjodZhUGQQ41xIA4/U0Zmh362p3tEBCm/trs=;
        b=mR7vFkaj/59ObCmEyV0xUXdLAwvSpAH3K3C75Wc4XtU+He5C5zKP0+UF66VrV/78ni
         cgUXXvvr0ZFlcLRlHjY8KH/jZr9EoDWBr24sfHV/pIEK7F0Z4ma1+xmId48NA37On2RO
         wp06asZcUOZm4phIVm6dkR3eZeBPoT4dVxUOBVn4it0Po0zTtdcuJ01+hpb74dh6MXjA
         kNEutjfQS6US7k87bdldzflzmtR/JN92th8RQU70Jw1ty+FYi6K7gRIfRW16KDnfqVEy
         pv3S1UJ4XZzzahSa6Fz55MFDnhYjjMJJwMNldrcg2m8Vno+gIze0pofhIa9CgdD3KCFd
         32wA==
X-Forwarded-Encrypted: i=1; AJvYcCUFLOv+guEFPQ8oeLcILadmIAMcuaMKWzfSF8k3vzDCwUduiPXa8AZur896/CLmakHxWfw1Dh+6NMETjA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHjzRRW1f8V3kSWqD5pxV3e65WkudC+RXs3z3EPsYMRMrIgqW2
	XfRlxGK2i+R24DcmWKaB6BjjCPBszIcwKV149tMzkp1gQqKEDHPGMCM5Q1SWTk7oRVRWXisxjCc
	8FeDAVnQ=
X-Gm-Gg: AZuq6aLE7tTNo82NjcX/0aXlZoDUYqXGlycDo7zlLe4g4xrVBELFNb3JfUTv7Vl/FbI
	MhoE8sbbeBNk50HS97Qff/YgiEPS2RpxwhJ606uZVJbdZLkho3XQ8yI7o89uRfTuYFzwVhpWli1
	bf8YCjcwqPXsMw9WuBPYrq8DHdaLHuRoi3pBHG6OIyQb7xtz6r73gqKXSDSUlnRBysF/XjcN0dW
	GXAFvHq2lD0unBgE6+YwQ2HcKPwjU+OV6GHtE1RWUxRbVOYFk3xKaMilPLfeY3+7qNd1C7SOtni
	nDlPPjEjQlxwN1XFVO8/9qdEtTvzxTKi7s6BzHzjssgLjiUBz/IMEFbpnNVRRBAWoqCfvQ6mWCC
	piHeq748hJhWWxzxYoXM11scA43ZbP9MYU/0kzwrxSrLBQnGTIoHEvq1RDyW18PbjNSakUNofd+
	SKc6HBRcnNh90mzqQtRhFBOrnDYv98TrtrVBJTLpCz86fK2ZmiqRQOdWTdPQOiA8qa
X-Received: by 2002:a05:6512:6ce:b0:59d:e9e0:f0e3 with SMTP id 2adb3069b0e04-59e04017345mr1154802e87.21.1769539579832;
        Tue, 27 Jan 2026 10:46:19 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e074b2c74sm94201e87.62.2026.01.27.10.46.19
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 10:46:19 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-382f9211cbfso53827291fa.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 27 Jan 2026 10:46:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWa8LApgjf3jfBKSSF/4n+x7sJS1Dt18l7ih5//7/qO3AVtuvtirlIR7rumDP2J1kCLc5zTSe2EksnZLg==@lists.linux.dev
X-Received: by 2002:a05:6402:27c6:b0:64b:9d9b:f0f7 with SMTP id
 4fb4d7f45d1cf-658a60c5513mr1939607a12.33.1769539160812; Tue, 27 Jan 2026
 10:39:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com> <2026012715-mantra-pope-9431@gregkh>
In-Reply-To: <2026012715-mantra-pope-9431@gregkh>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Jan 2026 10:39:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
X-Gm-Features: AZwV_QjTvEFSmpHcnOP1NJLVZBe5xlcj-dD5ZtjcNC__rjqudIVF0E_rBxSpQA4
Message-ID: <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Samuel Wu <wusamuel@google.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 23:42, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
> open/removal races") from the stable backports, as it was causing issues
> on the pixel devices it got backported to.  So perhaps look there?

Hmm. That commit is obviously still upstream, do we understand why it
caused problems in the backports?

                 Linus
