From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:40:47 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] O2net: Disallow o2net accept
 connection request from itself.
In-Reply-To: <1280714426-13449-1-git-send-email-tristan.ye@oracle.com>
References: <1280714426-13449-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100807184047.GG3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 02, 2010 at 10:00:26AM +0800, Tristan Ye wrote:
> Currently, o2net_accept_one() is allowed to accept a connection from
> listening node itself, such a fake connection will not be successfully
> established due to no handshake detected afterwards, and later end up
> with triggering connecting worker in a loop.
> 
> We're going to fix this by treating such connection request as 'invalid',
> since we've got no chance of requesting connection from a node to itself
> in a OCFS2 cluster.
> 
> The fix doesn't hurt user's scan for o2net-listener, it always gets a
> successful connection from userpace.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
