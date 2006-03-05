From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun, 5 Mar 2006 11:22:48 -0800
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <20060303233617.51718c8e.akpm@osdl.org>
References: <4408C2E8.4010600@google.com>
	<20060303233617.51718c8e.akpm@osdl.org>
Message-ID: <20060305192247.GH31587@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>
Cc: Daniel Phillips <phillips@google.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Mar 03, 2006 at 11:36:17PM -0800, Andrew Morton wrote:
> >  -	hash = full_name_hash(name, len);
> 
> err, you might want to calculate that hash outside the spinlock.
Hmm, good catch.

> Maybe have a lock per bucket, too.
That could be an avenue to explore. I guess we probably want to optimize the
actual lookup and memory usage before looking at that.

> A 1MB hashtable is verging on comical.  How may data are there in total?
Yes 1MB is much too big. We're looking right now at 3 lock resources per
inode, so total number of elements depends upon your file system I suppose.
Hopefully I'll have some time today to run some basic tests which may show
us what size strikes a better balance of performance versus memory overhead.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
