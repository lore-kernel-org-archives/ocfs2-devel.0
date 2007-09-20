From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep 20 17:04:56 2007
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: Read support for directories
	with inline data
In-Reply-To: <20070920234740.GF3490@tasint.org>
References: <200709192012.l8JKCHo9029366@rgmgw2.us.oracle.com>
	<20070920234740.GF3490@tasint.org>
Message-ID: <20070921000454.GH21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 20, 2007 at 04:47:40PM -0700, Joel Becker wrote:
> On Wed, Sep 12, 2007 at 01:01:18PM -0700, Mark Fasheh wrote:
> > +static int ocfs2_dir_foreach_blk_id(struct inode *inode,
> > +				    unsigned long *f_version,
> > +				    loff_t *f_pos, void *priv,
> > +				    filldir_t filldir)
> > +{
> 
> 	Isn't this function basically the center of foreach_blk_el()?

It's deceptive. Some parts are similar, but many checks are different or
don't exist in one version over another. The looping is slightly different
too. The extent based code handles readahead, while that doesn't make sense
for inline-data, etc, etc.

> Is there any way to consolidate that?

I actually looked at that for a long time, but decided that it would be best
to just keep them seperate. The extent based code is a total mess, and
introducing subtle changes based on in-inode dirs seemed like it could break
some stuff (in weird ways) which has been working fine for a while now.

I managed to consolidate most of the other dir functions though, which I
was happy about.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
