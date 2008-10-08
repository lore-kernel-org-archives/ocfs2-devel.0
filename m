From: Christoph Hellwig <hch@lst.de>
Date: Wed, 8 Oct 2008 15:22:32 +0200
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <20081007220811.GG26373@wotan.suse.de>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
	<20081002081644.GB24717@lst.de>
	<20081007220811.GG26373@wotan.suse.de>
Message-ID: <20081008132232.GG25392@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>

On Tue, Oct 07, 2008 at 03:08:11PM -0700, Mark Fasheh wrote:
> On Thu, Oct 02, 2008 at 10:16:44AM +0200, Christoph Hellwig wrote:
> > On Wed, Sep 24, 2008 at 03:00:54PM -0700, Mark Fasheh wrote:
> > >  	xattr.o			\
> > > +	xattr_user.o		\
> > > +	xattr_trusted.o
> > 
> > Please don't split this up, it's always been a really stupid idea in
> > extN.  The only difference between secure, trusted and user attrs is
> > that they go into a different namespace bit (and have different
> > permission checking, but that's handled in the VFS).  I have some
> > upcoming patches to store a fs private flag in struct xattr_handler
> > so that even those flags wrappers can go away, and each of the
> > namespaces will just be five lines of code for the xattr_handler
> > declaration.
> 
> Ok. The following patch (in ocfs2.git now) removes those two files, and puts
> the code for user and trusted xattrs at the bottom of xattr.c. Is that
> mainly what you were getting at here?

Yeah.
