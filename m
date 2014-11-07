From: Anand Avati <avati@gluster.org>
Date: Thu, 6 Nov 2014 21:52:07 -0800
Subject: [Ocfs2-devel] [fuse-devel] [PATCH v5 7/7] add a flag for
	per-operation O_DSYNC semantics
In-Reply-To: <BF30FAEC-D4D3-4079-9ECD-2743747279BD@cam.ac.uk>
References: <cover.1415220890.git.milosz@adfin.com>
	<c188b04ede700ce5f986b19de12fa617d158540f.1415220890.git.milosz@adfin.com>
	<x49r3xf28qn.fsf@segfault.boston.devel.redhat.com>
	<BF30FAEC-D4D3-4079-9ECD-2743747279BD@cam.ac.uk>
Message-ID: <CAFboF2y2skt=H4crv54shfnXOmz23W-shYWtHWekK8ZUDkfP=A@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-arch@vger.kernel.org, linux-aio@kvack.org, linux-nfs@vger.kernel.org, Volker Lendecke <Volker.Lendecke@sernet.de>, Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org, "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Milosz Tanski <milosz@adfin.com>, linux-fsdevel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, ceph-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, Mel Gorman <mgorman@suse.de>

On Thu, Nov 6, 2014 at 8:22 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> > On 7 Nov 2014, at 01:46, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Minor nit, but I'd rather read something that looks like this:
> >
> >       if (type == READ && (flags & RWF_NONBLOCK))
> >               return -EAGAIN;
> >       else if (type == WRITE && (flags & RWF_DSYNC))
> >               return -EINVAL;
>
> But your version is less logically efficient for the case where "type ==
> READ" is true and "flags & RWF_NONBLOCK" is false because your version then
> has to do the "if (type == WRITE" check before discovering it does not need
> to take that branch either, whilst the original version does not have to do
> such a test at all.
>

Seriously? Just focus on the code readability/maintainability which makes
the code most easily understood/obvious to a new pair of eyes, and leave
such micro-optimizations to the compiler..

Thanks
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20141106/e91dd4ab/attachment-0001.html 
