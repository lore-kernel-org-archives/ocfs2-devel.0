From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 15 Jun 2010 16:47:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Move orphan scan work to ocfs2_wq.
In-Reply-To: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
References: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100615234711.GF30497@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 28, 2010 at 02:22:59PM +0800, Tao Ma wrote:
> We used to let orphan scan work in the default work queue,
> but there is a corner case which will make the system deadlock.
> The scenario is like this:
> 1. set heartbeat threadshold to 200. this will allow us to have a
>    great chance to have a orphan scan work before our quorum decision.
> 2. mount node 1.
> 3. after 1~2 minutes, mount node 2(in order to make the bug easier
>    to reproduce, better add maxcpus=1 to kernel command line).
> 4. node 1 do orphan scan work.
> 5. node 2 do orphan scan work.
> 6. node 1 do orphan scan work. After this, node 1 hold the orphan scan
>    lock while node 2 know node 1 is the master.
> 7. ifdown eth2 in node 2(eth2 is what we do ocfs2 interconnection).
> 
> Now when node 2 begins orphan scan, the system queue is blocked.
> 
> The root cause is that both orphan scan work and quorum decision work
> will use the system event work queue. orphan scan has a chance of
> blocking the event work queue(in dlm_wait_for_node_death) so that there
> is no chance for quorum decision work to proceed.
> 
> This patch resolve it by moving orphan scan work to ocfs2_wq.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git

Joel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
