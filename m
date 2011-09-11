From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 11 Sep 2011 01:45:23 -0700
Subject: [Ocfs2-devel] Can recovery be done in process context (as
 opposed to kthread)?
In-Reply-To: <CAJtY7HVYZ3Uoy0QzBpUsrK68O9C6iUPkBe_YP6JCRskGHao9GA@mail.gmail.com>
References: <CAJtY7HVYZ3Uoy0QzBpUsrK68O9C6iUPkBe_YP6JCRskGHao9GA@mail.gmail.com>
Message-ID: <20110911084522.GC2520@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 09, 2011 at 05:22:49PM -0500, Goldwyn Rodrigues wrote:
> Hi,
> 
> I finally got back to improve the recovery procedure by offloading
> work to work queues. However, I would like to know if we can
> completely do away with ocfs2rec kthread. The process would just mark
> the nodes which need recovery and offload the work on the work queues
> and wait until all is over.
> 
> The reason for doing it this way is to make the mount process
> killable. Currently the dlm locks are taken by ocfs2rec kthread while
> the mount waits in uninterruptible sleep while the recovery happens.

	If the mount dies, but then actually succeeds in the
background...that's weird and violates the Principle of Least Surprise.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

			http://www.jlbec.org/
			jlbec at evilplan.org
