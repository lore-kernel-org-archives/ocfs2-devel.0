From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Jan 2010 15:09:46 -0800
Subject: [Ocfs2-devel] [RFC 1/3] ocfs2: allocation reservations
In-Reply-To: <1260917898-16078-1-git-send-email-mfasheh@suse.com>
References: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
	<1260917898-16078-1-git-send-email-mfasheh@suse.com>
Message-ID: <20100120230946.GD4333@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 15, 2009 at 02:58:16PM -0800, Mark Fasheh wrote:
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> new file mode 100644
> index 0000000..8879e28
> --- /dev/null
> +++ b/fs/ocfs2/reservations.c
> @@ -0,0 +1,624 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * reservations.c
> + *
> + * Allocation reservations implementation
> + *
> + * Some code borrowed from fs/ext3/balloc.c

	Does that file have copyright info.  Probably should include
that here.

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

	Drop this last paragraph.  It's no longer accurate, and GNU says
drop it rather than correct it.

> +static void ocfs2_resmap_clear_all_resv(struct ocfs2_reservation_map *resmap)
> +{
> +	struct rb_node *node;
> +	struct ocfs2_alloc_reservation *resv;
> +
> +	assert_spin_locked(&resv_lock);
> +
> +	while ((node = rb_last(&resmap->m_reservations)) != NULL) {
> +		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
> +
> +		__ocfs2_resv_trunc(resv);
> +		rb_erase(&resv->r_node, &resmap->m_reservations);
> +	}
> +}

	Ugh, this always walks to the end of the tree on each iteration
of the while loop.  That's O(nlogn).  But it looks like everyone does
this.  Joy.

> +static struct ocfs2_alloc_reservation *
> +ocfs2_find_resv(struct ocfs2_reservation_map *resmap, unsigned int goal)
> +static void ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
> +				   struct ocfs2_alloc_reservation *resv)

	At first this confused me, but then I figured out you're asking
"where can I stick my reservation?"  This is why the reservation object
doesn't need a backref to the inode.

Joel

-- 

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
