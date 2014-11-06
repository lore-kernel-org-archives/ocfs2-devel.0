From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 06 Nov 2014 18:46:08 -0500
Subject: [Ocfs2-devel] [PATCH v5 7/7] fs: add a flag for per-operation
	O_DSYNC semantics
In-Reply-To: <c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com>
	(Milosz Tanski's message of "Wed, 5 Nov 2014 16:14:53 -0500")
References: <cover.1415220890.git.milosz@adfin.com>
	<cover.1415220890.git.milosz@adfin.com>
	<c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com>
Message-ID: <x49r3xf28qn.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, ceph-devel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org

Milosz Tanski <milosz@adfin.com> writes:

> -		if (type == READ && (flags & RWF_NONBLOCK))
> -			return -EAGAIN;
> +		if (type == READ) {
> +			if (flags & RWF_NONBLOCK)
> +				return -EAGAIN;
> +		} else {
> +			if (flags & RWF_DSYNC)
> +				return -EINVAL;
> +		}

Minor nit, but I'd rather read something that looks like this:

	if (type == READ && (flags & RWF_NONBLOCK))
		return -EAGAIN;
	else if (type == WRITE && (flags & RWF_DSYNC))
		return -EINVAL;

I won't lose sleep over it, though.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
