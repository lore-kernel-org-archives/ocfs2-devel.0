Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B8364926
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785211896; cv=none; b=BwUz2l3GAX4R2JX9iVzbFbkcSS7t8JNeNRDi3XmQsVlm+ak2ZhSY1AtVWyFo8QtdZ9wii20lYEluZmUwOG4bycXPR5hePGmmIezfkIyl8KryKnRVu6nuM88BRO1GnmXU4rAT9LSP+RlWLVBn1VVygq+VZllNKSN446goF3NWX4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785211896; c=relaxed/simple;
	bh=323OuAZmmDLS9aaIz44hHgQEVVEFUcWA1droHDPWVv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOaw0kQ/Ymi9jtvNJfugSjwNJSl2gYEveyJu9QxlrvdsSsTRu9Tz44iCv2fVwmaqx67VblD0mUbJQ6yHCmxzxDzQHGo1dmkkHqmksA4NLabYjhMUGiL+Hb1+oA7qNdQtrPqIDEjZBQvflqXenyOfZCHRsqWBn8JifVv/hmKuliQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6060B68AFE; Tue, 28 Jul 2026 06:11:31 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:11:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] migrates ocfs2 DIO from buffer_head to iomap
Message-ID: <20260728041131.GA19573@lst.de>
References: <20260727061802.18485-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727061802.18485-1-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

s/migrates/migrate/

