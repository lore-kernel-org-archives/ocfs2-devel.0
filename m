From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Mar 2010 16:56:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: allocation reservations
In-Reply-To: <20100319224047.GE15539@mail.oracle.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-2-git-send-email-mfasheh@suse.com>
	<20100319224047.GE15539@mail.oracle.com>
Message-ID: <20100319235652.GK11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 03:40:47PM -0700, Joel Becker wrote:
> On Tue, Mar 16, 2010 at 11:59:10PM -0700, Mark Fasheh wrote:
> > Reservation windows are represented internally by a red-black
> > tree. Within that tree, each node represents the reservation window of
> > one inode. An LRU of active reservations is also maintained. When new
> 
> 	I see you decided against chopping up the localalloc and went
> for reservations as needed.

Yeah, in the end it wound up making the most sense for our usage. In reality
though, the bitmap is being "virtually" chopped up.


> > +int ocfs2_resmap_init(struct ocfs2_super *osb,
> > +		      struct ocfs2_reservation_map *resmap)
> > +{
> > +	memset(resmap, 0, sizeof(*resmap));
> > +
> > +	resmap->m_osb = osb;
> > +	resmap->m_reservations = RB_ROOT;
> > +	/* m_bitmap_len is initialized to zero by the above memset. */
> > +	INIT_LIST_HEAD(&resmap->m_lru);
> > +
> > +	return 0;
> > +}
> 
> 	Why have m_osb and set it?  Can't you get the osb from
> container_of(resmap, struct ocfs2_super, osb_la_resmap)?

I could, but I have m_osb there to divorce it from any particular parent
structure. That way a future version to use this on say, block groups
wouldn't need any changes in reservations.[ch].


> > +int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
> > +			   struct ocfs2_alloc_reservation *resv,
> > +			   int tmpwindow, int *cstart, int *clen)
> 
> 	The tmpwindow argument to resmap_resv_bits()...what you really
> want to say is "I'm not interested in hanging on to reserved space.
> Please behave like the original localalloc".  What it does is correct.
> I wish I had a better way to say it.

Essentially that's what happens, but with the
benefits of allocating the very small window in the right places, etc.
Otherwise we'd be searching the bitmap without tracking other reservations,
etc.


> > --- /dev/null
> > +++ b/fs/ocfs2/reservations.h
> > @@ -0,0 +1,154 @@
> > +/* -*- mode: c; c-basic-offset: 8; -*-
> > + * vim: noexpandtab sw=8 ts=8 sts=0:
> > + *
> > + * reservations.h
> > + *
> > + * Allocation reservations function prototypes and structures.
> > + *
> > + * Copyright (C) 2009 Novell.  All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public
> > + * License as published by the Free Software Foundation; either
> > + * version 2 of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > + * License along with this program; if not, write to the
> > + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> > + * Boston, MA 021110-1307, USA.
> 
> 	Don't add the paragraph about Temple Place to new files ;-)

Doh! I thought I had already done that in the last round. I'll fix it up.
	--Mark

--
Mark Fasheh
