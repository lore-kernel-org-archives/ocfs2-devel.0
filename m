Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9ECBE5B;
	Wed, 18 Oct 2023 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ibs+RNxU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=glPK2nMlq3eHDbWVN7H4C3ISIh1VNxtl/70uXeL9vlY=; b=Ibs+RNxU+J51GkYsnDaoEWnUiP
	luhtw2e3kMrs3u4Fzqd+KhmRb87sI1fUxfxufl6IDoWLh8ZH5+1jcC2+LdgtGMS3Ep1r+8rkrFcmf
	3RG/aq07vRBh6yJGuf3wfIbGtb++ObXL076PGk6duum97gslZBZpW2IIDEvlvMvBe8ibsoKed6PSh
	lTZBRNnx5TnhfSlAgL6Nl5A1AZdAbKUZYIpacxJH+XinPssyhI4K0tp2v+gTKpvQpx6V3fHkKLb7W
	1snV5MuO5HKVjY8+kEs2509Dd4asRWcbVnaTg8CoaA5x5efBzrRlF4p4o/t88DcfOB4IXDeXqIolS
	1tLPjCZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qt7O2-001KzI-8R; Wed, 18 Oct 2023 14:19:02 +0000
Date: Wed, 18 Oct 2023 15:19:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 01/27] buffer: Return bool from grow_dev_folio()
Message-ID: <ZS/pVp9I4M8p4vwh@casper.infradead.org>
References: <20231016201114.1928083-1-willy@infradead.org>
 <20231016201114.1928083-2-willy@infradead.org>
 <CAKFNMonj9XQe1PdeCny7N8MFAHwQVQNDf6A2S4g-gxX4iJLvZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKFNMonj9XQe1PdeCny7N8MFAHwQVQNDf6A2S4g-gxX4iJLvZQ@mail.gmail.com>

On Wed, Oct 18, 2023 at 04:41:44AM +0900, Ryusuke Konishi wrote:
> On Tue, Oct 17, 2023 at 5:11 AM Matthew Wilcox (Oracle) wrote:
> >
> > Rename grow_dev_page() to grow_dev_folio() and make it return a bool.
> > Document what that bool means; it's more subtle than it first appears.
> > Also rename the 'failed' label to 'unlock' beacuse it's not exactly
> > 'failed'.  It just hasn't succeeded.
> 
> This changes the return type of grow_buffers() from "int"  to "bool".
> But, it seems that the caller, __getblk_slow(), has not changed the
> type of the variable "ret" that receives its return value:
[...]
> 
> So, it looks like the error check immediately after calling
> grow_buffers() will not branch like before.
> Is this okay ?   Or, am I missing some other changes?
> 
> Also, there is a typo in the changelog: "beacuse" -> "because".

Argh, yes.  Andrew, please drop this patch for now.  I'll submit
something better next cycle.
