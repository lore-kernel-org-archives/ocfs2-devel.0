Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F5A29B22F
	for <ocfs2-devel@lists.linux.dev>; Wed, 12 Nov 2025 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762936252; cv=none; b=QT0GfnL2+i8eAkdeVGmBXEmoboe+XegaZB6WSpdFDUIaZHlp1pdprlCASSYjtWnuFQJIucboTKyaYBi3sZBY64MEWnGfMCn76SYoztBXfi/XA4bTXSJsQSQFAtFJlPpm4w/DmfNjj3VKol3SjFQZrt16wz8/1v3rLM8hTMxkfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762936252; c=relaxed/simple;
	bh=JLeCNAAZkaS4/c/IduKKVCXVmL/5w1Lbp4sE+4av+xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJ5cXchLJ0pw6mN9QECEL3QytZoAc5AXkLM1yo0Bg0dEXGB595iR2nzT9PHQ7pLZHi3A6Ffll7oGcwBQ1FSrMYURgTiGpJDdIE3nTnYwN9m6j4fX1p4Eokkf37866qP1AEeh6iCTNDd53Ec2eTAnBNKarR5+2ydsMCjxX+G37yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRpZNFYK; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRpZNFYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762936250; x=1794472250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JLeCNAAZkaS4/c/IduKKVCXVmL/5w1Lbp4sE+4av+xA=;
  b=XRpZNFYKeUWdIQChe0njLKwBPdAG51YAUwvT4Cx5pcmRGO3S1OXQ6M+O
   5LeZ04OjKNRQU1qAJQ8AF6ogiuPlg68RGsLwkyU3uNOO6hB8u8ZetjHWG
   /MB4nRPn9E5jxDSebI+tXqfBMqUMseZ4tApXmvyRQ5gL98exHQK7Sdoul
   m0DOd33Ft0MoQME9vDD085SM7LTY3MIcE8JCD9gnQD5OfrkoXhhZIbB3B
   iBleHSb93JkMa98smr6ZaBy4JkOsvlTXmyTPXUmdDfaMi092tLpEdzGDQ
   3+2Zv/CJIpDK+gRly3IMBxluxspoFrodmWkvILOjvZ6zwfIcdIPbh9kT1
   g==;
X-CSE-ConnectionGUID: +O3HY2B3Ri6J3z7/ExQS/g==
X-CSE-MsgGUID: eQqF4pi+RQedDiFdw3pDqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="75300025"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="75300025"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:30:47 -0800
X-CSE-ConnectionGUID: J8N/rLXXRn6yxnUrRXD0EQ==
X-CSE-MsgGUID: wSdmRR+BTRe9IhMiitpZ/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="194355404"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa005.jf.intel.com with ESMTP; 12 Nov 2025 00:30:45 -0800
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 6936895; Wed, 12 Nov 2025 09:30:44 +0100 (CET)
Date: Wed, 12 Nov 2025 09:30:44 +0100
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: relax BUG() to ocfs2_error() in
 __ocfs2_move_extent()
Message-ID: <aRRFtEa26UfufDLd@black.igk.intel.com>
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
 <20251009102349.181126-1-dmantipov@yandex.ru>
 <20251009102349.181126-2-dmantipov@yandex.ru>
 <aecb2ef1-ea56-42d9-8bee-a2760de66de1@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aecb2ef1-ea56-42d9-8bee-a2760de66de1@linux.alibaba.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 09, 2025 at 07:12:15PM +0800, Joseph Qi wrote:
> On 2025/10/9 18:23, Dmitry Antipov wrote:

> > Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
> > Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
> > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Andrew, something wrong went into the repository. If you look at
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-stable&id=63b0c2c8cd29f0b516bbe6bb6580ed1b0246996c

looks like a one off case, as others seem okay in the repo. I can't see any
suspicious pattern in the tags, but it may be a very subtle bugs in the scripts
you are using.

(As of today the old version in the Linux Next df3de4b76ba17f9 has the same issue).

...

So, the problem is that two tags are coupled together:

    Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>Closes: https://syzkaller.appspot.com/bug?extid=727d161855d
11d81e411

-- 
With Best Regards,
Andy Shevchenko


