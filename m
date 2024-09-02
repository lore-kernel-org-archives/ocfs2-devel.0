Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF682F36;
	Mon,  2 Sep 2024 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238443; cv=none; b=ZWvD9O8VQoSSAjvvuU8536dSIGRhX33bQybt3hE0TZ16F2yKtFZoBIGwsmwPVgr3Ln/cCQDMMbd9rjXtKIvKtGo0qFi0UWsoQi/B/SHdmDCBW8TjRRxwqGxolZtTFJ4Dsl1d3UNckGSxKAEeeqkKj29i0IhjXiPB4kQ1wmklDn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238443; c=relaxed/simple;
	bh=gNYRihM4e/LeYh2zWZgs1Y8LOprbRtH/I0zksNICO+g=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oC1JXZpSR5jO0SqqV5A0dRzC03/3DkUf9Je6X1O69g0A+e5D2Rua7G/x8Q6ppDwNavTQ/biL22c/tcbH40bAVA1TcHfvxl0xUsMZRP6B6SA46qkXsEoC4oiW7fl/eCRt9ZUissfFyl68vEFpVzffxi38SQfousqTbm3Lwc3WvKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pKYcWAvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pKYcWAvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6889C4CEC3;
	Mon,  2 Sep 2024 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238442;
	bh=gNYRihM4e/LeYh2zWZgs1Y8LOprbRtH/I0zksNICO+g=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=pKYcWAvBRMF6dQg8fEJ9kxxYENyMWw/MXTFFAeqFnZmHqxK1rGlsxSuC6H4D4keAw
	 aQxZhw/ZDxol5F+i+XJ1R0oJ40jhBMFmyTbuLhGJcuUPscfqQ0ItwYftbjnV7GnfKK
	 UQamBFY3MCWGwGnFdo+b+6u1VnywKNLT6IIc5hOk=
Date: Sun, 1 Sep 2024 17:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>, Lizhi Xu <lizhi.xu@windriver.com>,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
Message-Id: <20240901175402.816203db096c2e9e49d75363@linux-foundation.org>
In-Reply-To: <20240821143911.cec82fac50c08947523da2e6@linux-foundation.org>
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
	<20240821091459.681136-1-lizhi.xu@windriver.com>
	<25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
	<20240821143911.cec82fac50c08947523da2e6@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Aug 2024 14:39:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> OK I think I found the correct patches - v3 of [1/2] and v4 of [2/2].
> 
> For clarity can we please have a full resend of both patches?
> 
> And let's please have a [0/n] cover letter which describes the problems
> which are being addressed and which also briefly describes how they
> were addressed.
> 
> Also, it appears that both of these fixes should be backported into
> -stable kernels.  So let's please try to identify when these bugs were
> introduced and to add a suitable Fixes: to the individual changelogs.
> 

Again, can we please have a full resend of these two patches with the
above issues addressed?  Particularly the identification of the Fixes:
targets.

Thanks.
