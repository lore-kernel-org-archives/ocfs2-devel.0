From: Christoph Hellwig <hch@lst.de>
Date: Thu, 2 Oct 2008 10:16:44 +0200
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <1222293680-15451-14-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
Message-ID: <20081002081644.GB24717@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Sep 24, 2008 at 03:00:54PM -0700, Mark Fasheh wrote:
>  	xattr.o			\
> +	xattr_user.o		\
> +	xattr_trusted.o

Please don't split this up, it's always been a really stupid idea in
extN.  The only difference between secure, trusted and user attrs is
that they go into a different namespace bit (and have different
permission checking, but that's handled in the VFS).  I have some
upcoming patches to store a fs private flag in struct xattr_handler
so that even those flags wrappers can go away, and each of the
namespaces will just be five lines of code for the xattr_handler
declaration.

> +static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
> +{
> +	struct xattr_handler *handler = NULL;
> +
> +	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
> +		handler = ocfs2_xattr_handler_map[name_index];
> +
> +	return handler;
> +}

You seem to need the handler mostly for getting back to the prefix
from the handler.  This is a pretty clear indicator that you don't
want to use the xattr_handler splitting but deal with the whole
attr name.  Take a look at the btrfs code after my recent xattr changes
on how to handle this more nicely.


> +
> +static inline u32 ocfs2_xattr_name_hash(struct inode *inode,
> +					char *prefix,
> +					int prefix_len,
> +					char *name,
> +					int name_len)

And I think there's far too much inlining going on in here..
