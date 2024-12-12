Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61D20C009;
	Thu, 12 Dec 2024 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733991515; cv=none; b=UYyDLangzhMMN1L2NsOXQJn3boRdlHH/qWul4hlfPALK8uuDRz+vYNAYv7arOB6TACuitJdTEaXJtTnz0R+cidKemwi6LxTJx8QmVXnPfmh3rmpqxElvw4ho66YiQ7fMDFp+nuj1SlDlSYhHwz8yLidjCQ39OfnBqrRwIYnyT8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733991515; c=relaxed/simple;
	bh=/NdEOIdaBTTmlN/1YJBk7TcJe9e+1DlVJvKlF+ySpuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liLBCs9GFYObuSgxR3lR6rPWTC+fSOaQWPpKHefyWxMQEjjgY029xgNwrL4dtHCDXrEImR0DSQoyqoMw1V46ODGgHsL2vpxVKCVTgC6VIHGkQuAjlzug0QJD/byQIywPssHkSsGOUxl6YCgDBMfe1aSFqlqAWnuT8/Uek++gkrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRmKGHf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRmKGHf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7125BC4CECE;
	Thu, 12 Dec 2024 08:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733991514;
	bh=/NdEOIdaBTTmlN/1YJBk7TcJe9e+1DlVJvKlF+ySpuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZRmKGHf11uRE6X8nPQPFvHiUoJK4QIrHTJDxu9TPJyLJt2MfjMiTivrXc03KEwgRS
	 GaWEUEFhzlqV45M94vL8gp4VB+e/pB1M8wl6citu5VRTDl2r92aDMzcr4KG1X4lyIC
	 657q/KeYaghxjWaLrZnJ9TnkUn3VmIsV2gNIIQ6g=
Date: Thu, 12 Dec 2024 09:18:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Heming Zhao <heing.zhao@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: Revert "ocfs2: fix the la space leak when
 unmounting an ocfs2 volume"
Message-ID: <2024121218-corner-repair-09fa@gregkh>
References: <20241204033243.8273-1-heming.zhao@suse.com>
 <20241204033243.8273-2-heming.zhao@suse.com>
 <6c3e1f5a-916c-4959-a505-d3d3917e5c9c@linux.alibaba.com>
 <79b86b7b-8a65-49b8-aa33-bb73de47ad37@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79b86b7b-8a65-49b8-aa33-bb73de47ad37@suse.com>

On Wed, Dec 04, 2024 at 02:46:15PM +0800, Heming Zhao wrote:
> On 12/4/24 11:47, Joseph Qi wrote:
> > 
> > 
> > On 12/4/24 11:32 AM, Heming Zhao wrote:
> > > This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
> > > unmounting an ocfs2 volume").
> > > 
> > > In commit dfe6c5692fb5, the commit log stating "This bug has existed
> > > since the initial OCFS2 code." is incorrect. The correct introduction
> > > commit is 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").
> > > 
> > 
> > Could you please elaborate more how it happens?
> > And it seems no difference with the new version. So we may submit a
> > standalone revert patch to those backported stable kernels (< 6.10).
> 
> commit log from patch [2/2] should be revised.
> change: This bug has existed since the initial OCFS2 code.
> to    : This bug was introduced by commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")

So can you please send a new version of this series?

thanks,

greg k-h
