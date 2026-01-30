Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811114F112;
	Fri, 30 Jan 2026 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769756561; cv=none; b=lBZJ7d97c+sxJRyzzw2rtS0wqj23Om6gAMaoGEj7klSec/bHTkquc+wmFpnUtTssIG7naIM1gm0r2/Cjcb2sj8g3uG9y4CS7hdYl7zCueNo9a5bMXSFMM4l6L+OVJTimQ+eGcBKfoWBhoCXmwez6DsnPMIxa6jXaz9yQin9u2tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769756561; c=relaxed/simple;
	bh=HC81kJ/KCUSax7CyJFaHbRwTsOK9Tppvga3NN4qu7ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5BIpvHs4ye4qC2AcEbLCUpeJv2o+0VCNMSajzDS4FKtUy/nDpmowA9/GUwdu0GsUMyzDd9Qxr6kVyLS/ZEnv7lyY5x8mqIt+j/dzGvYV5J2uUr0hHymDNrHQd5RpD3yxJ0qiCE+nab0bOMovKBppsb4aScDENePk3ammH3Nli0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ilytkKYY; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ilytkKYY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=INMf6UfFQjVVnORY/K4s0FguYtBlQgR4+GC7Az9nAHk=; b=ilytkKYYIb15hDUYvk/ktFurn2
	rIoSaVvuwrv/jNqt4iR6TROJ8IeZlN1PH5whhMv1/AbdXFNN++4wyTyv7KF0rsVh9LyisYV+v2x4b
	8QcYgnYdrwmOBebbLAj82HRGHPg83XKl4d5ixnZQP3jnt6qes1l7NJpUU15IRRrSd2OrPbXiWuF5G
	1Usc1/YAHY1hTXStoU1uN95rtw2ejQed+PicyisANY6LLn93TFaRsRfhXSowFrUo7Xjyenb5oA8gy
	k3TEBPyYB9WuLgY3oozldImd1hRSvpxcR/Ekx3NPG7coY7XpmsUV6OouYMej4OWnhCk8fo8Af/yTI
	OpDd5jSA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vliYK-00000009qV4-2BjG;
	Fri, 30 Jan 2026 07:04:24 +0000
Date: Fri, 30 Jan 2026 07:04:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260130070424.GV3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Jan 29, 2026 at 05:16:20PM -0800, Samuel Wu wrote:
> On Thu, Jan 29, 2026 at 2:52 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > > Sorry, I hadn't been clear enough: if you do
> > > git switch --detach 1544775687f0
> > > and build the resulting tree, does the breakage reproduce?  What I want
> > > to do is to split e5bf5ee26663 into smaller steps and see which one
> > > introduces the breakage, but the starting point would be verify that
> > > there's no breakage prior to that.
> 
> Ultimately, same conclusion as before: 6.18-rc5 with patches up to
> 1544775687f0 works, but adding e5bf5ee26663 breaks it.

OK.  Could you take a clone of mainline repository and in there run
; git fetch git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-wsamuel:for-wsamuel
then
; git diff for-wsamuel e5bf5ee26663
to verify that for-wsamuel is identical to tree you've seen breakage on
; git diff for-wsamuel-base 1544775687f0
to verify that for-wsamuel-base is the tree where the breakage did not reproduce
Then bisect from for-wsamuel-base to for-wsamuel.

Basically, that's the offending commit split into steps; let's try to figure
out what causes the breakage with better resolution...
