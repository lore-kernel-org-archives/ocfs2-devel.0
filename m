From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Mar  4 20:25:57 2004
Subject: [Ocfs2-devel] RFE: Change #include usage
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A569AD@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569AD@orsmsx403.jf.intel.com>
Message-ID: <20040305022553.GD18020@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 04, 2004 at 04:38:29PM -0800, Villalovos, John L wrote:
> #include "inc/ocfs.h"
> 
> This should make for cleaner Makefiles that don't need to add a -I flag
> to add the inc/ directory.
> 
> Any comments on this?

	Other way around, really.  All in-kernel filesystems with
headers have the headers in the flat directory.

Joel

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
