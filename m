From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 8 Oct 2010 14:09:03 -0700
Subject: [Ocfs2-devel] Question: recovery map vs replay map
In-Reply-To: <4CAF75EB.9050209@oracle.com>
References: <AANLkTik2S+-guvnhvUGXOBOD74Ph0gf68NgN9uMG5LyD@mail.gmail.com>
	<4CAF75EB.9050209@oracle.com>
Message-ID: <20101008210902.GJ13876@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 08, 2010 at 12:50:03PM -0700, Sunil Mushran wrote:
> On 10/08/2010 12:03 PM, Goldwyn Rodrigues wrote:
> > I was reading through the recovery code and got confused with recovery
> > and replay maps.
> >
> > What is the function of recovery maps and replay maps? Is a replay map
> > generated for each entry in the recovery map? Is there a situation
> > where a replay map is created without a recovery map entry?
>
> 
> During recovery, we need to recover the slot used by the dead node
> (including journal replay) and clean up the unused orphaned inodes.
> 
> The recovery map refers to the nodes whose slot needs recovery.
> 
> The replay map (confusing name, in hindsight) refers to unused slots
> whose orphaned inodes need to be cleaned up.

	The names do make sense, though.  The recovery map is a map of
nodes that have died and need recovery.  The replay map is a map of
slots that need replay at mount time.

> But what about the orphan directory that node 0 used that has that
> inode that was in use on node 1. That needs to be cleaned up too.
> 
> The replay map, populated with unused slots, will contain the slot
> used by node 0.
> 
> Yes, this code is now superfluous since we now have a orphan
> scan timer that fires periodically to clean up the inodes for all slots.

	However, we eventually want to remove the orphan scan, at which
point the mount-time replay is still the correct solution.

Joel

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
