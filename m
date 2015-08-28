From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:03:36 -0700
Subject: [Ocfs2-devel] [patch 02/28] ocfs2: trusted xattr missing
	CAP_SYS_ADMIN check
In-Reply-To: <55de398c.VmwgWKAl9bo0fBBw%akpm@linux-foundation.org>
References: <55de398c.VmwgWKAl9bo0fBBw%akpm@linux-foundation.org>
Message-ID: <20150828230336.GH1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:24PM -0700, Andrew Morton wrote:
> From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
> Subject: ocfs2: trusted xattr missing CAP_SYS_ADMIN check
> 
> The trusted extended attributes are only visible to the process which hvae
> CAP_SYS_ADMIN capability but the check is missing in ocfs2 xattr_handler
> trusted list.  The check is important because this will be used for
> implementing mechanisms in the userspace for which other ordinary
> processes should not have access to.
> 
> Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Taesoo kim <taesoo@gatech.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
