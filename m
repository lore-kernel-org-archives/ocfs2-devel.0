Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AEC308F35;
	Mon, 19 Jan 2026 09:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768816149; cv=none; b=D5CDpliUYnnBTBsKXt/04yb+WGbA0oGs4P7YuCdvTIkYa3PbcgwQWiQjUqXUb8AWl4WofxokUWKHxz8qGhJkaume2bu1EYkdjPAXIKTJBTqqQ3czvlD8YVvhRQyIAu1tH17n5KH6uqCqQuuypy9ngVXapJVo71q2YlWO9/JN0JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768816149; c=relaxed/simple;
	bh=Wl6OaaKB56A3GMF4kabk/WoPUPRapXTkoTs1xgYP8Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDeOaN+WbSTZGEzh1cwdwlrNvyJk7bwPDQakZow+3hnF5T2IZ8kS4UZTMCfkXOse9n4RwFdBm4a5ySdlI/RMCekK2JfaoDCo0ZCsKadbx/mVhvavQp+rTEkjLKyUIe2798z9I1HBsXBhE4+PnkYlsDbQUs79tmWIsuRLI5x7bz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEYH9PjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEYH9PjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F07C19425;
	Mon, 19 Jan 2026 09:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768816149;
	bh=Wl6OaaKB56A3GMF4kabk/WoPUPRapXTkoTs1xgYP8Kc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEYH9PjMNZeD1h75o5xGMVZWXLwBFIPjADSPpYDBWMqOZrtQ6WubMqQPvDvPY3fvm
	 zm/DfYwWh4GqvtyLmrbrJOe5c6gp4FqiO84RxED4RB4oN1wf7pmkrcfA1e0D7WWSBr
	 T06r+9U9Y5G7RN0PcP+G7Y0aNqUoNubM9hY7b1Jw=
Date: Mon, 19 Jan 2026 10:49:06 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	ocfs2-devel@lists.linux.dev, stable@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>
Subject: Re: [PATCH v2] ocfs2: fix NULL pointer dereference in
 ocfs2_get_refcount_rec
Message-ID: <2026011959-durably-repacking-e7d4@gregkh>
References: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
 <20260118190523.42581-1-jiashengjiangcool@gmail.com>
 <e3f1974d-5e88-4824-8466-6abea6359c19@web.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3f1974d-5e88-4824-8466-6abea6359c19@web.de>

On Mon, Jan 19, 2026 at 10:42:29AM +0100, Markus Elfring wrote:
> …> This patch adds an 'else' branch …
> 
> Thanks for another contribution.
> 
> * Does anything hinder to follow a corresponding wording requirement?
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc5#n94
> 
> * Can it be helpful to append parentheses to function names?
> 
> 
> Regards,
> Markus
> 

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
