From: Bernd Eckenfels <be-mail2006@lina.inka.de>
Date: Sat, 11 Mar 2006 02:57:31 +0100
Subject: [Ocfs2-devel] Ocfs2 performance
In-Reply-To: <20060311010913.GN27280@ca-server1.us.oracle.com>
References: <20060310002121.GJ27280@ca-server1.us.oracle.com>
	<E1FHWCm-0002rT-00@calista.inka.de>
	<20060311010913.GN27280@ca-server1.us.oracle.com>
Message-ID: <20060311015731.GA16912@lina.inka.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Mar 10, 2006 at 05:09:13PM -0800, Mark Fasheh wrote:
> until the locks needs to be upgraded or downgraded. This provides a very
> large performance increase over always asking the DLM for a new lock.

Yes, it is basically the same problem as the buffer cache. Excessive
single-use patterns dirty the small cache or require a too big cache to be
usefull.

Maybe a user specific limit of percentage of hash (and locks) used? I mean
the untar test case is a bit synthetic, but think of concurrent read access
in a cluster of nntp servers (news article pool).

Gruss
Bernd
