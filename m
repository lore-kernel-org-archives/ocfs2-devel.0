From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep 20 16:48:35 2007
Subject: [Ocfs2-devel] [PATCH 11/15] ocfs2: Structure updates for inline
	data
In-Reply-To: <20070920231746.GC3490@tasint.org>
References: <200709192012.l8JKCHOK012212@agmgw2.us.oracle.com>
	<20070920231746.GC3490@tasint.org>
Message-ID: <20070920234833.GG21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 20, 2007 at 04:17:46PM -0700, Joel Becker wrote:
> On Fri, Sep 07, 2007 at 01:58:15PM -0700, Mark Fasheh wrote:
> > Add the disk, network and memory structures needed to support data in inode.
> 
> >  /*
> > + * Data-in-inode header. This is only used if i_flags has
> > + * OCFS2_INLINE_DATA_FL set.
> > + */
> > +struct ocfs2_inline_data
> 
> 	I think you mean i_dyn_features.  Otherwise, it looks good.

Good catch.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
