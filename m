From: Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 03 Feb 2016 14:43:02 -0500
Subject: [Ocfs2-devel] vfs/xfs: directio updates to ease COW handling V2
In-Reply-To: <1454524816-11392-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Wed, 3 Feb 2016 19:40:13 +0100")
References: <1454524816-11392-1-git-send-email-hch@lst.de>
Message-ID: <x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi, Christoph,

Can you explain a bit what you mean by easing COW handling?  Whenever I
see COW referenced near DIO, my mind always turns to g_u_p vs. fork.

Thanks!
Jeff

Christoph Hellwig <hch@lst.de> writes:

> See http://www.infradead.org/rpr.html
>
> The first patch ensures ->end_io is always called for direct I/O requests
> that pass it in, even if there was a zero length write, or if an error
> occured.  The existing users have been updated to ignore it, but XFS
> will make use of it in the future, and a comment in ext4 suggests it
> might be useful for it as well.
>
> The other two simplify the XFS direct I/O code.
>
> Changes since V1:
>  - allow ->end_io to return errors
>  - a comment spelling fix
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
