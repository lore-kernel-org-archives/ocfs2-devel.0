From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 1 Dec 2010 21:30:55 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Thread recovery
In-Reply-To: <4CF72B01.4000500@oracle.com>
References: <AANLkTimnChrkhnX0prKXE93sGDtJ+q+rvULaWqQnq8e8@mail.gmail.com>
	<4CF72B01.4000500@oracle.com>
Message-ID: <20101202053055.GH16604@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 01, 2010 at 09:13:37PM -0800, Sunil Mushran wrote:
> One problem I see is that we may spawn too many threads. Imagine
> a setup with 50 mounts and 16 nodes. Not uncommon at all. If 5 nodes
> die, that's 300 threads, 50 of which will be coordinating threads.
> 
> One solution is to have a universal mount count and use that and the
> number of cpus to come up with a per-mount parallel reco count.
> 
> Thoughts, anyone?

	The new concurrency workqueues should allow us a
limited-threadcount pool of threads to do this.  We should be using them
rather than implementing thread management ourselves.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
