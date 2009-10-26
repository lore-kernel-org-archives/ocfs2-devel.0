From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 26 Oct 2009 10:29:36 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
In-Reply-To: <20091024183039.GB30762@shareable.org>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com>
	<1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
	<20091023180034.GA11402@wotan.suse.de>
	<20091024183039.GB30762@shareable.org>
Message-ID: <4AE5DC80.8010204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Jamie Lokier wrote:
> It might be better to have a flag FIEMAP_EXTENT_NOT_SHARED.
>
> Apps which need to know the data is not shared can't safely check
> !(flags & FIEMAP_EXTENT_SHARED) because of old kernels which don't set
> the flag.

I'm probably not understanding your point. Won't the older kernels not set
FIEMAP_EXTENT_NOT_SHARED too.

If this is important, we could always add this flag in the stable kernel
trees. Both sharing of extents and fiemap are relatively new to the kernel.
