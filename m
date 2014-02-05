From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 5 Feb 2014 15:51:04 -0800
Subject: [Ocfs2-devel] [patch 06/11] ocfs2/o2net:
 o2net_listen_data_ready should do nothing if socket state is not TCP_LISTEN
In-Reply-To: <20140205234055.GN24361@wotan.suse.de>
References: <20140124204705.E43E65A4203@corp2gmr1-2.hot.corp.google.com>
	<20140205234055.GN24361@wotan.suse.de>
Message-ID: <20140205155104.474e603d7dd50b3afc156aa1@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 5 Feb 2014 15:40:55 -0800 Mark Fasheh <mfasheh@suse.de> wrote:

> On Fri, Jan 24, 2014 at 12:47:05PM -0800, akpm at linux-foundation.org wrote:
> > From: Tariq Saeed <tariq.x.saeed@oracle.com>
> > Subject: ocfs2/o2net: o2net_listen_data_ready should do nothing if socket state is not TCP_LISTEN
> > 
> > Orabug: 17330860
> > 
> > When accepting an incomming connection o2net_accept_one clones a child
> > data socket from the parent listening socket.  It then proceeds to setup
> > the child with callback o2net_data_ready() and sk_user_data to NULL.  If
> > data arrives in this window, o2net_listen_data_ready will be called with
> > some non-deterministic value in sk_user_data (not inherited).  We panic
> > when we page fault on sk_user_data -- in parent it is sock_def_readable().
> >  The fix is to recognize that this is a data socket being set up by
> > looking at the socket state and do nothing.
> > 
> > Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
> > Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> > Cc: Mark Fasheh <mfasheh@suse.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> 

Signed-off-by is unexpected.  It means that your either contributed to
this patch or transmitted it to someone else.  I suspect that
Reviewed-by: is the appropriate tag in this case?
