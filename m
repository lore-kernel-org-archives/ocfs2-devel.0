Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD1E8F70
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 02:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718420069; cv=none; b=ZzL10NiczikrsJlNV5Xug7JaCPsVh6F94bf8GrNh7tqQbEMBiIUfuR5VdEVIUdG6wpspOj8XAM5jMtZ5Z2uTMb60AcZfHuveime/HXpKmtCxPlM8Jhku57o27HydEzrqGgMESabCxgvAKf9aSFuIJqj0kDN5LDl8YctwnfCq0H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718420069; c=relaxed/simple;
	bh=ySkiw7y5rvaKrprN5YotLp5wNowaI/3fXBJdqkxEDqo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=F7wzO1ezh5v3HfqHEc9kVPPZzUb07JHdlXeMfS3SFTQAB4jOos0t3Df+kZ3ivpxJGc/CxCvPYH/Qz15qdyun3ZH8od4rEtcrNfU81KwvHGTXlc0X9kjfB5ZJvjb4u3iKZuWInOjLM1X1TnaIPcQmqQ7gsGUaSth8MnnUBGfkPGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/vcLtLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/vcLtLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57115C2BD10;
	Sat, 15 Jun 2024 02:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718420068;
	bh=ySkiw7y5rvaKrprN5YotLp5wNowaI/3fXBJdqkxEDqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k/vcLtLrYWi2hHPa8hvRqBtUXxHm3LM9NdcTmoSEml/9SBJQy0e0M/pz1KAXXfP1I
	 Iy/33xotny4LJOOlomcIirYpaaBWfrhjXdM4qwSG9/SwksAYixLOBI9logdijZ8FaQ
	 wY92UbJ5oaOyLLLrx1b/CdvSnru4llal9HCFb/fk=
Date: Fri, 14 Jun 2024 19:54:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>, Mark Fasheh
 <mark@fasheh.com>
Subject: Re: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction
 credits
Message-Id: <20240614195427.5bec08e823d3398b0f28216a@linux-foundation.org>
In-Reply-To: <2ec660c6-6f5d-448c-8488-3924552e261f@suse.com>
References: <20240614145243.8837-1-jack@suse.cz>
	<2ec660c6-6f5d-448c-8488-3924552e261f@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Jun 2024 09:21:51 +0800 Heming Zhao <heming.zhao@suse.com> wrote:

> On 6/14/24 22:52, Jan Kara wrote:
> > The code in ocfs2_dio_end_io_write() estimates number of necessary
> > transaction credits using ocfs2_calc_extend_credits(). This however does
> > not take into account that the IO could be arbitrarily large and can
> > contain arbitrary number of extents. Extent tree manipulations do often
> > extend the current transaction but not in all of the cases. For example
> > if we have only single block extents in the tree,
> > ocfs2_mark_extent_written() will end up calling
> > ocfs2_replace_extent_rec() all the time and we will never extend the
> > current transaction and eventually exhaust all the transaction credits
> > if the IO contains many single block extents. Make sure the transaction
> > always has enough credits for one extent insert before each call of
> > ocfs2_mark_extent_written().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks for Jan's patch, it was used to fix a SUSE customer issue.

That's useful info.  Could we please have, for the changelog, a
description of that issue?  Amongst other reasons, so that someone else
who is dealing with a customer issue can figure out whether this patch
will address it.

I assume a cc:stable is appropriate.

Can we please identify a suitable Fixes: target, or has this been there
for ever?
