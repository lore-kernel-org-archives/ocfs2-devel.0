From: Jamie Lokier <jamie@shareable.org>
Date: Sat, 24 Oct 2009 19:30:39 +0100
Subject: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
In-Reply-To: <20091023180034.GA11402@wotan.suse.de>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com>
	<1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
	<20091023180034.GA11402@wotan.suse.de>
Message-ID: <20091024183039.GB30762@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Wed, Oct 21, 2009 at 06:05:08PM -0700, Sunil Mushran wrote:
> > Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
> > shared with other inodes.
> 
> This looks pretty sane to me. Thanks Sunil.

It might be better to have a flag FIEMAP_EXTENT_NOT_SHARED.

Apps which need to know the data is not shared can't safely check
!(flags & FIEMAP_EXTENT_SHARED) because of old kernels which don't set
the flag.

-- Jamie
