From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 18 Jun 2008 09:12:15 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080618123134.GC30804@localhost>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
Message-ID: <20080618161215.GA16780@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 02:31:34PM +0200, Louis Rilling wrote:
> On Tue, Jun 17, 2008 at 03:41:00PM -0700, Joel Becker wrote:
> > However, if the subsystem is made up of multiple modules, this may not
> > pin the subsystem.  Thus, it would be possible to unload the toplevel
> > subsystem module while there is still a child item.  Thus, we now
> > try_module_get() the subsystem's module.  This only really affects
> > children of the toplevel subsystem group.  Deeper children already have
> > their parents pinned.
> 
> Looks good to me.
> 
> What about new item module pinning versus a concurrent sys_delete_module() in a
> preemptible kernel? AFAICS new_item pinning is just done too late to protect
> anybody against sys_delete_module(). Shouldn't we remove new item module pinning
> and let the subsystem do it?

	Good catch.  Preempt doesn't matter - it could just be another
CPU.
	Certainly if there are multiple modules the make_item() will
have to pin the submodule before calling it.  But the common case isn't
multiple modules.  What we absolutely don't want is making the common
case have to pin itself.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
