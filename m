From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 13:58:32 -0700
Subject: [Ocfs2-devel] [patch 24/28] ocfs2: add feature document for
	online file check
In-Reply-To: <55de39c9.NAoA+ITBkmwk4Suv%akpm@linux-foundation.org>
References: <55de39c9.NAoA+ITBkmwk4Suv%akpm@linux-foundation.org>
Message-ID: <20150831205832.GC1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:25PM -0700, Andrew Morton wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: add feature document for online file check
> 
> This document describes the OCFS2 online file check feature.
> 
> OCFS2 is often used in high-availaibility systems.  However, OCFS2 usually
> converts the filesystem to read-only on errors.  This may not be
> necessary, since turning the filesystem read-only would affect other
> running processes as well, decreasing availability.  Then, a mount option
> (errors=continue) was introduced, which would return the EIO to the
> calling process and terminate furhter processing so that the filesystem is
> not corrupted further.  The filesystem is not converted to read-only, and
> the problematic file's inode number is reported in the kernel log.  The
> user can try to check/fix this file via online filecheck feature.
> 

I know the previous patch was nakked but this is great documentation by the
way and thanks for doing it. Please continue to keep it up to date as your
patch series evolves :)

Thanks again,
	--Mark

--
Mark Fasheh
