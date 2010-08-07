From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:40:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: avoid incorrect bit set in
 refmap on recovery master
In-Reply-To: <201007300816.o6U8GN8H024244@rcsinet15.oracle.com>
References: <4C51C802.2050905@oracle.com>
	<201007300816.o6U8GN8H024244@rcsinet15.oracle.com>
Message-ID: <20100807184012.GE3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 30, 2010 at 04:14:44PM +0800, Wengang Wang wrote:
> In the following situation, there remains an incorrect bit in refmap on the
> recovery master. Finally the recovery master will fail at purging the lockres
> due to the incorrect bit in refmap.
> 
> 1) node A has no interest on lockres A any longer, so it is purging it.
> 2) the owner of lockres A is node B, so node A is sending de-ref message
> to node B.
> 3) at this time, node B crashed. node C becomes the recovery master. it recovers
> lockres A(because the master is the dead node B).
> 4) node A migrated lockres A to node C with a refbit there.
> 5) node A failed to send de-ref message to node B because it crashed. The failure
> is ignored. no other action is done for lockres A any more.
> 
> For mormal, re-send the deref message to it to recovery master can fix it. Well,
> ignoring the failure of deref to the original master and not recovering the lockres
> to recovery master has the same effect. And the later is simpler.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Acked-by: Srinivas Eeda <srinivas.eeda@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
