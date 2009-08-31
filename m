From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 31 Aug 2009 14:14:45 -0700
Subject: [Ocfs2-devel] Garbage ERESTARTSYS in dlmdomain.c?
Message-ID: <20090831211444.GC19626@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Look at this code from dlmdomain.c:

-----------------------------------------------------------------------
                /* If we're racing another node to the join, then we
                 * need to back off temporarily and let them
                 * complete. */
#define DLM_JOIN_TIMEOUT_MSECS  90000
                if (status == -EAGAIN) {
                        if (signal_pending(current)) {
                                status = -ERESTARTSYS;
                                goto bail;
                        }

                        if (total_backoff >
                            msecs_to_jiffies(DLM_JOIN_TIMEOUT_MSECS)) {
                                status = -ERESTARTSYS;
                                mlog(ML_NOTICE, "Timed out joining dlm domain "
                                     "%s after %u msecs\n", dlm->name,
                                     jiffies_to_msecs(total_backoff));
                                goto bail;
                        }
-----------------------------------------------------------------------

Why are we returning -ERESTARTSYS when there isn't a signal pending?
This seems like it could totally do something weird, like have entry.S
get confused.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
