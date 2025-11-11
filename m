Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226DC34A794
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 10:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762856575; cv=none; b=Ce6Q8gwGdgIdfObRRGjvvFRsllpk+FVucqo8caSsQLhQVNxTXPnxkGn6cI8tGGjtrldNCkBmKCn69UIriUVtDzxgVlmoRMOeWB6ZXp/DBNL6V1wXxg+U0E99q5V4z6Fh4I2aPFLIc1HrIDBIMGvijVEQ8MHxU5Z278HO6fPv5C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762856575; c=relaxed/simple;
	bh=JrxCJS6doR540ni5O4K+fTfT2J1vhfEKtnYrNkU/J6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eYpFhwQ1pBoZb6eZgA1cxrOY3Ldi21V//UcoLn4BKEgB/5iBWbrePl5Si3wZulzFv4Ewf11qa5u5paLog8ftcmL0vaIqR+XevVjhpoKberQ8ZLM9gTzJYXdYNApMYFxKW/YIOdRNVZq03e18Qd8qCeWnnd7R5WrOTuyp2T3cn3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=f3xC98Pf; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="f3xC98Pf"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed75832448so57125821cf.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 02:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762856571; x=1763461371; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gr4TOuugTT1EseGcVB5iZB82tbqvLcivaLR74+txrKo=;
        b=f3xC98PfepDflM5ayuupv+6hVK6xs6qZ6kvOV2H5I0BIAppG7lY39UMFT8vk4YS5q1
         PifVXhhlG3JyJvjhMQiKd6yRdAVhT8j8XtvDcAytu04wwitmF6lRIdt5GZA8h/wWDWzC
         MEMWuz/ZLkxS2y1sfACXcyFJFHF9Jc5QG24wU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762856571; x=1763461371;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr4TOuugTT1EseGcVB5iZB82tbqvLcivaLR74+txrKo=;
        b=w5t37WNAi0IZ58U4vURhU33kyijEqiRJLyyp0ecRLVV1YKZbqpD2xQ1Rd205n1M268
         5ATbspAMP8uDu0uSlIhL7xX/uS0/Dt3A3u5aRaiBLPSWI+uIry9ROgslI82FCNqImhGS
         gdCCN/DsVmittXa8WyN+pc0fY+EpMm6+dtupLlB9xazyWWg0OoEmAs3VgiDNqYpZy0UC
         ej2aNpfCLt00hczQF2rhiFyer02IliIyn2TDvi3hZ5FmtLRAI2suSi23kfM+w1NqSby5
         Z6KDgCJPaFbi/wu+uaYT5MFbuCZH5KWicP87cGxz3IjV6MinqECsYsYFfG7mIXxIk329
         36Vg==
X-Forwarded-Encrypted: i=1; AJvYcCXJUllTExR0D4V41wwX/ViVKV278vos4WwIthxR+GOZEjeFTTzG3M8mmQsedBOjVI/mvX89UYb1PRRuTA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+5+SPHBDYhoxu/Q9s11DM6bZr4fpcyIYbAph7u8rycHi5auyf
	56PRefHQTtyxJRet/nPtl4F/fkZLhgv9yFApyZsFm+qR/qBfk4VuT3LDfSJYkiHOMRS8CoWI8u8
	vgwd1Jg4r3EoEjv29eqErFE4C/6gTqxpGxA4blQKpPg==
X-Gm-Gg: ASbGncv0Rb9W1gEYm3O+WjFdZs1K0ijAdsHfImIwxIwiJ+U7NmVnB1SwRk5yjjH4WJl
	+Av/W37Cl8LMBDxnGAWPqE9o+VswZ3VcTGq1ZzrcvJo9ldaTRsApmiADl9rk9KSYqW0I0Qwv4fF
	Vt9uRVbYUKcvTXHbwxKOtBg8lZ1zqG3F8jvWda4iIsqapxZ9Ca939y1xLfBJmkBV6NJtrNbxqXX
	VX4eCUcxVKgwJ4kdq0UpvIj+O/E8gFnNcdb9DVmWJ2c5HM396j5VSYPXrM=
X-Google-Smtp-Source: AGHT+IElRIVhqCvDTFpSgFEYkQvi9Gos4SnKPGf8Juir9zGtxxq03gYdBJSCGUUe4Ii0djCwuMFVWPO3CN8YKO0f0p8=
X-Received: by 2002:ac8:57d3:0:b0:4ec:f073:4239 with SMTP id
 d75a77b69052e-4eda4e7cbb2mr148255861cf.6.1762856570888; Tue, 11 Nov 2025
 02:22:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-2-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-2-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:22:38 +0100
X-Gm-Features: AWmQ_bn6E4e4WTTnqqQ9ptsMdEgyTHjWIJOU4-smQyjZiT3MKecFKgj620d_-Vc
Message-ID: <CAJfpeguqvHUDVzR7N=To8keErrF8Bn9kuojoFtM_58sLY_XXDw@mail.gmail.com>
Subject: Re: [PATCH v3 01/50] fuse_ctl_add_conn(): fix nlink breakage in case
 of early failure
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Nov 2025 at 07:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> fuse_ctl_remove_conn() used to decrement the link count of root
> manually; that got subsumed by simple_recursive_removal(), but
> in case when subdirectory creation has failed the latter won't
> get called.
>
> Just move the modification of parent's link count into
> fuse_ctl_add_dentry() to keep the things simple.  Allows to
> get rid of the nlink argument as well...
>
> Fixes: fcaac5b42768 "fuse_ctl: use simple_recursive_removal()"
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
