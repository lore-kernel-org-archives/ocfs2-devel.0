Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B4A20F9;
	Tue, 19 Sep 2023 13:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vG4Tzf8kO0LcYLw+cZi1qYlZspJjy+O6YTZUkpkEyuI=; b=CIE0ya6ucqYQAvryNkDuSTAm9k
	NPgkr3zmhN8Hban2XWHPThsg9/nlIp/ZAtOQIz4Fvp5UOCY8y8q3jv0twkC/5m8C3icPQZxCaFhuw
	aYuHM8P8bwzXylhGBHqoh48NXEt3+0zyDlDxbZq4vJTH1AWpS+0PiivpHN5lyNtpkL1ib7zU/Q6kj
	khYJAPWBVNSzhlkoZlqQwpyBYZwRtybWua479pBO6mACsk43W5DcjN1kPcpusDM956b0LAMqnQYc9
	nm3C4rann0EzGNbm9waRDU9NV/S7jfcHa1zapYylXuZQ5YxiU3iI23KOQowBjNVLjVQFKhaVCPTjj
	oXJZFWfA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qiaR3-00HMAE-Fa; Tue, 19 Sep 2023 13:06:37 +0000
Date: Tue, 19 Sep 2023 14:06:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to
 nilfs_copy_folio()
Message-ID: <ZQmc3VHOIh3jOG8Z@casper.infradead.org>
References: <20230919045135.3635437-1-willy@infradead.org>
 <20230919045135.3635437-12-willy@infradead.org>
 <CAKFNMonjfsWBageg6vfWok9vvNEzjhXiqCCb+=cDFuwnTER95A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKFNMonjfsWBageg6vfWok9vvNEzjhXiqCCb+=cDFuwnTER95A@mail.gmail.com>

On Tue, Sep 19, 2023 at 10:01:27PM +0900, Ryusuke Konishi wrote:
> When I tried to test the patchset against 6.6-rc2, I encountered the
> following error during the build:
> 
>  ERROR: modpost: "folio_copy" [fs/nilfs2/nilfs2.ko] undefined!
> 
> It looks like "folio_copy" is not exported to modules.
> 
> I'll correct this manually for now and proceed with the review and
> testing, but could you please fix this build issue in some way ?

Thanks!  I'll export the symbol.  I did build nilfs2 as a module, but I
just did it with "make fs/" which doesn't run modpost.  Appreciate the
testing.
