From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 20 Jun 2008 15:36:14 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080620124644.GQ30804@localhost>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
	<20080620124644.GQ30804@localhost>
Message-ID: <20080620223614.GD21416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2008 at 02:46:44PM +0200, Louis Rilling wrote:
> But keeping this last config_item_put() prevents the simplification that I'm
> defending. And I think that the simplification is worth moving this
> config_item_put() before client_drop_item().

	I guess I'm not seeing what's simpler.  Four lines of
try_module_get() aren't very complex, really.  Conversely, having some
functions that *don't* do config_item_get_item() is weird.  Not invalid,
just harder to read.
	Let's put it on the shelf.  What I have with this patch is
really no different in effective behavior.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
