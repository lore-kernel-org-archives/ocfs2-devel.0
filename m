From: Manish Singh <manish.singh@oracle.com>
Date: Thu Mar  4 19:12:36 2004
Subject: [Ocfs2-devel] RFE: Change #include usage
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A569AD@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569AD@orsmsx403.jf.intel.com>
Message-ID: <20040305011232.GB3169@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 04, 2004 at 04:38:29PM -0800, Villalovos, John L wrote:
> I want to make a suggestion that we change from the usage of:
> 
> #include <ocfs.h>
> 
> To:
> 
> #include "inc/ocfs.h"
> 
> This should make for cleaner Makefiles that don't need to add a -I flag
> to add the inc/ directory.
> 
> Any comments on this?
> 
> Enclosed please find a patch which does this.

Looks good. Committed.

-Manish
