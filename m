From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 30 Mar 2010 12:53:56 -0700
Subject: [Ocfs2-devel] lockdep warning in ocfs2 quota
In-Reply-To: <20100330163656.GD3424@quack.suse.cz>
References: <20100324220138.GA14310@mail.oracle.com>
	<20100330163656.GD3424@quack.suse.cz>
Message-ID: <20100330195356.GA27285@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 30, 2010 at 06:36:57PM +0200, Jan Kara wrote:
>   This is the culprit - we have to do some writes when reading dquot (to
> increase dquot use count and possibly also allocate space for further
> writes) but ocfs2_local_read_dquot is already called with dqio_mutex
> held so when ocfs2_global_read_dquot tries to start a transaction it
> is a violation of lock ordering.
>   I guess I'll have to move all the code from ocfs2_local_read_dquot
> to ocfs2_acquire_dquot and do all the handling there with proper locking.
> I'll have a look at it.

	Thanks for taking a look.  Better we find the inversion sooner!

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
