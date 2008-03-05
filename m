From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 13:52:49 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <20080305203837.GU9349@ca-server1.us.oracle.com>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
	<20080305184021.GT9349@ca-server1.us.oracle.com>
	<20080305192752.GK799@ca-server1.us.oracle.com>
	<20080305203837.GU9349@ca-server1.us.oracle.com>
Message-ID: <20080305215140.GC2630@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 05, 2008 at 12:38:37PM -0800, Mark Fasheh wrote:
> On Wed, Mar 05, 2008 at 11:27:53AM -0800, Joel Becker wrote:
> If the dlm supports dynamic resizing, neither approach requires the user to
> "stop everything". "mount -oremount" is just as unobtrusive to the running
> file system as echoing to a sysfs file.

	Oh, sure.  And your point about sysfs files being ABI is also
true.  That's why I wanted to look at a "what would we want this to
look like if we had to keep it a long time" perspective.  To be clear,
I'm not advocating that we have to have some super-awesome solution.  I
was just detailing the discussion Sunil and I had.

> Btw, if this is the direction we all want to go, can I revert the
> "localalloc=" mount option patches before 2.6.25 gets released? It strikes
> me as similarly hacky (seriously) and we already have a plan for dynamic
> local alloc sizing.

	I vote yes.

> Can you be more specific? How often do we think people will expect to change
> this on a live file system?

	I'm coming from Sunil's bug report - I don't have data myself.
Really, anything that allows an online change (remount,sysfs,automatic)
satisfies this.  And maybe it's not necessary to be all fancy.  More
below.

> Btw, just so we're all clear - any hash sizing scheme would pretty much
> involve information known only to the local node. So we're not talking about
> offlining the cluster here - just unmounting a node.

	Yup.

> To recap, and make sure we're on the same page - AFAICT, the questions being
> raised are:
> 
> 1) Should the default dlm hash size be updated somehow?
> 
> 2) Should the user be allowed to change the (default?) hash size?
>   - If so, how would the user change this?
> 
> 3) Should the dlm be changed to allow dynamic resizing of the hash?
>   - Should it resize automatically depending on workload, or should the user
>     initiate such resizing via whichever method is picked in (2)?

	Basically.  I'd say that we clearly have to say 'yes' to (1) -
the 500K lock problem dictates it.  My thoughts to Sunil were:

1) If we can hide the issue from the user, we win.  I don't care if
   that's automatic resizing based on latencies, an rbtree instead of a
   hash, whatever.
2) Otherwise, we need a method for the user to make this modification.
   It would be great if it could be live.  This ABI would become
   something we carry for a while, so we want to think about it a
   little.

Joel

-- 

Life's Little Instruction Book #80

	"Slow dance"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
