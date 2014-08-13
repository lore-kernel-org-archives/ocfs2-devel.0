From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Aug 2014 10:49:11 -0700
Subject: [Ocfs2-devel] [patch 01/10] ocfs2: do not write error flag to
	user structure	we cannot copy from/to
In-Reply-To: <53e290c0.JrBMAOun3Le6OEB7%akpm@linux-foundation.org>
References: <53e290c0.JrBMAOun3Le6OEB7%akpm@linux-foundation.org>
Message-ID: <20140813174911.GT2203@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 06, 2014 at 01:32:00PM -0700, Andrew Morton wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Subject: ocfs2: do not write error flag to user structure we cannot copy from/to
> 
> If we failed to copy from the structure, writing back the flags leaks 31
> bits of kernel memory (the rest of the ir_flags field).
> 
> In any case, if we cannot copy from/to the structure, why should we expect
> putting just the flags to work?
> 
> Also make sure ocfs2_info_handle_freeinode() returns the right error code
> if the copy_to_user() fails.
> 
> Fixes: ddee5cdb70e6 ('Ocfs2: Add new OCFS2_IOC_INFO ioctl for ocfs2 v8.')
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


This looks good, thanks Ben!

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
