From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 15:40:47 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: allocation reservations
In-Reply-To: <1268809154-1020-2-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-2-git-send-email-mfasheh@suse.com>
Message-ID: <20100319224047.GE15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 16, 2010 at 11:59:10PM -0700, Mark Fasheh wrote:
> Reservation windows are represented internally by a red-black
> tree. Within that tree, each node represents the reservation window of
> one inode. An LRU of active reservations is also maintained. When new

	I see you decided against chopping up the localalloc and went
for reservations as needed.

> +int ocfs2_resmap_init(struct ocfs2_super *osb,
> +		      struct ocfs2_reservation_map *resmap)
> +{
> +	memset(resmap, 0, sizeof(*resmap));
> +
> +	resmap->m_osb = osb;
> +	resmap->m_reservations = RB_ROOT;
> +	/* m_bitmap_len is initialized to zero by the above memset. */
> +	INIT_LIST_HEAD(&resmap->m_lru);
> +
> +	return 0;
> +}

	Why have m_osb and set it?  Can't you get the osb from
container_of(resmap, struct ocfs2_super, osb_la_resmap)?

> +int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
> +			   struct ocfs2_alloc_reservation *resv,
> +			   int tmpwindow, int *cstart, int *clen)

	The tmpwindow argument to resmap_resv_bits()...what you really
want to say is "I'm not interested in hanging on to reserved space.
Please behave like the original localalloc".  What it does is correct.
I wish I had a better way to say it.

> --- /dev/null
> +++ b/fs/ocfs2/reservations.h
> @@ -0,0 +1,154 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * reservations.h
> + *
> + * Allocation reservations function prototypes and structures.
> + *
> + * Copyright (C) 2009 Novell.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.

	Don't add the paragraph about Temple Place to new files ;-)

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
