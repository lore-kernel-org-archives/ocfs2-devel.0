Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8D6283C93
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 10:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762857006; cv=none; b=ai8rvtS0Jn+5eI4zJ/dtA7r8fxifmofOx6TSgNAGz+uXnH3O4vvw6/KsfQ0WZ5/exncew7rg/tMVwFBynELFX6RDW3OsmC49QjlEI8Eir/oljyxhwc/BzKBgUIt1N3RjUoPvtWz13h/LzygwsIs4I1sYcxVLWeLuNpuo2hoi+3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762857006; c=relaxed/simple;
	bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rpcggl86yhfzmdRy2i++wUvgDOEJ6CC3BkwpclEJD4xiqVLY+TYZdPRZho+KRbi6FF6Bsxzyq+y3Qx4H+lTS0hNd3OJ8cTHB1RbNT9f7hZlTm0TPfKs4CJX7KGwvJvVQDvRFRBAPpo0Kifz2Dryt2CESF1bJPHGoequYtgv2RfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=iSJtWV37; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iSJtWV37"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4e4d9fc4316so40133721cf.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 02:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762857004; x=1763461804; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
        b=iSJtWV37Ai/eByiMe+OzTXz970JrFHApMU18IoIMqx4l2rpZ+fLzmB1ysbD3TjtcAZ
         dOrOw1R0Ur5Q+A6nbD3n5J9pO8neSjYp0AWftvZW5Rr5z69QG3guJWnucceuSGN6l2dw
         WV4wmsH/Y2U6AKFKBPbfe8jcmK3crGuq6XyGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762857004; x=1763461804;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
        b=HhfoTpGubgKiMPFE4tWAeZlQZZB/HRVXWNKmwe56BQz9871NKkbYxAkcTYI0ubtYPh
         ONeKB+dYizIONv4CnG9gRy/35aBRP+fBzM1TUap5F3czAc0BQqiFjr2T68fsm6us3YMH
         hgLnRx2lH7XXLYD/6TPLzMia2pdU6WBbSKEHnrXFcQ2WUFmI1DcdQpx5/5j12wX6xoev
         CTzbMxRCKltJQFkShu0ZmEhPei5rbRyBqZz18oKyHGNmqPjznBqnF3JkpHIy7WWTh8JS
         /oeWhAcuFYL3rd1SI/ViGflTMk4Hpw9Gwm2aLA+7Uz+NNQ+smgnFv5vjO//+XNpMwOQy
         to3w==
X-Forwarded-Encrypted: i=1; AJvYcCU815mY3uq9U1wmzR5kT7F9GePfaCUDLrtschUw7jpV7ChlsWMSsRbjLlBP+gO8HkaRbUn3D662O4TpEQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1w/dRIc/uXSkkhkRcsfP7975RCt4EvBkD/c718d1G219sSj5K
	kFts2chwtYhWKyMak65uANkAjseMVD5nu9dExrnAcEmbUoewPBU78iJunwF2qLvXgEyWmrDlDH1
	iyA9+WGsIp+Z6NXlJzwtCynmlaF6D380KHR3JVS3vag==
X-Gm-Gg: ASbGncvlad1R+zsBgqpHmIjNoT58nPsGJSpWccAGjVqf3H86gl8SXLPhCl4Fs9IgHB0
	+qUd7qb6HmAjL0jEma/DYumBck/YhTprzpMKZwRounfRRKjWBJAJTUqq8FOWqM9dilwOqeGzMc6
	E3Psgd5efI5kw4vbPm645ULYB5jQ8lKMpMA5ilg5e05sI11YAtusMPFpmdHgiGG373fRdJDOY9w
	sQ8jqMePIhQj22T/jUcp3Sz9dtmCLIGpKEC68nMQHzJyStNFmNeLdBqi2yiLGt2NsZceQ==
X-Google-Smtp-Source: AGHT+IG1vPc79jE1NxMTWUcAkMOFXJ1dO7xwNLHncVzXeQGMi6M4ZcaWG7wZ9Wn4xgn8RqaQcm4UKxcrnMz8XFw/71I=
X-Received: by 2002:ac8:7d8b:0:b0:4ed:b378:145d with SMTP id
 d75a77b69052e-4edb3781c5fmr87056701cf.45.1762857003684; Tue, 11 Nov 2025
 02:30:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-4-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-4-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:29:52 +0100
X-Gm-Features: AWmQ_bnbS5BGnOdlDcNli2J3_mWe2QdNv2AalQvWZZg8jjhCbQzLKZqYiVdFPQQ
Message-ID: <CAJfpegv5eZK=70GEdbofg8u-CKS7gL6Ur5PD86Ay4h3Z8D986A@mail.gmail.com>
Subject: Re: [PATCH v3 03/50] new helper: simple_remove_by_name()
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
> simple_recursive_removal(), but instead of victim dentry it takes
> parent + name.
>
> Used to be open-coded in fs/fuse/control.c, but there's no need to expose
> the guts of that thing there and there are other potential users, so
> let's lift it into libfs...
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
