From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 25 Nov 2010 02:19:14 -0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Remove j_trans_barrier
In-Reply-To: <20101125100822.GA28616@mail.oracle.com>
References: <4CBE8751.1060606@oracle.com>
	<20101125100822.GA28616@mail.oracle.com>
Message-ID: <20101125101913.GB28616@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 25, 2010 at 02:08:22AM -0800, Joel Becker wrote:
> 	Second, there is the flip side.  How do we wait until all open
> transactions are complete before checkpointing?  The down_write() in
> ocfs2_commit_cache() blocks until all open transactions up_read().  In
> your scheme, there is no care taken for open transactions against the
> journal.  Remember, the journal is global to the node.

	Hmm.  I wonder if we can allow transactions as soon as we kick
off the journal?  Basically, right now, we do the following:

1) down_write(trans_barrier)
  - Wait for all open transactions
  - Block all new transactions
2) jbd2_journal_flush()
  - Write out the journal
  - Wait on the journal flush
3) up_write(trans_barrier)
  - Unblock new transactions

	We absolutely need to wait for open transactions before starting
the flush.  Otherwise, we may not have the transaction we need for a
downconvert closed.  But do we need to block new transactions once the
journal flush is going?  Like, we could up_write() our transaction
barrier after calling journal_lock_updates().  Would that work?  Would
it help?

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
