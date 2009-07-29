From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Jul 2009 11:22:29 -0700
Subject: [Ocfs2-devel] [PATCH 5/8] Quota support for fsck.ocfs2
In-Reply-To: <20090729100733.GD19209@duck.suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-6-git-send-email-jack@suse.cz>
	<20090728230509.GC20595@mail.oracle.com>
	<20090729100733.GD19209@duck.suse.cz>
Message-ID: <20090729182229.GB5849@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 29, 2009 at 12:07:33PM +0200, Jan Kara wrote:
> On Tue 28-07-09 16:05:09, Joel Becker wrote:
> > 	Can you check http://kernel.us.oracle.com/~smushran/license.txt
> > and update your header?  The last paragraph is no longer recommended by
> > the FSF, and we'd love for this header to have the emacs/vim lines at
> > the top.
>   I've just copy-pasted the header from pass4.h :) I'll happily update it
> but the server you referenced doesn't seem to exist anymore.

	Haha, that's our internal server.  I'll attach that file :-)

> > 	The way I read this, you check the existing quota structures,
> > and then ignore them while recomputing the usage.  You just do a full-on
> > recompute.  Then you write out the newly computed data.  Am I correct?
>   Yes, the point is: Quota *usage* is recomputed from scratch (and
> basically there's not much better way because e.g. a corruption could have
> changed owners of files). Quota *limits* have to be loaded from old quota
> files and that's the whole point of our quota checking excercise.

	Ahh, I get it.  I was thinking that the recompute of usage was
expensive, but there's no way to validate the usage in the quota files
without running the recompute, and at that point the simple code is, as
you have done, to just write the recomputed data.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
/* -*- mode: c; c-basic-offset: 8; -*-
 * vim: noexpandtab sw=8 ts=8 sts=0:
 *
 * filename.c
 *
 * file description
 *
 * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */
