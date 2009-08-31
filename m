From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 31 Aug 2009 14:56:51 -0700
Subject: [Ocfs2-devel] Garbage ERESTARTSYS in dlmdomain.c?
In-Reply-To: <20090831211444.GC19626@mail.oracle.com>
References: <20090831211444.GC19626@mail.oracle.com>
Message-ID: <20090831215651.GH2818@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 31, 2009 at 02:14:45PM -0700, Joel Becker wrote:
> Look at this code from dlmdomain.c:
> 
> -----------------------------------------------------------------------
>                 /* If we're racing another node to the join, then we
>                  * need to back off temporarily and let them
>                  * complete. */
> #define DLM_JOIN_TIMEOUT_MSECS  90000
>                 if (status == -EAGAIN) {
>                         if (signal_pending(current)) {
>                                 status = -ERESTARTSYS;
>                                 goto bail;
>                         }
> 
>                         if (total_backoff >
>                             msecs_to_jiffies(DLM_JOIN_TIMEOUT_MSECS)) {
>                                 status = -ERESTARTSYS;


> Why are we returning -ERESTARTSYS when there isn't a signal pending?
> This seems like it could totally do something weird, like have entry.S
> get confused.

Yeah, I think that the timeout error should be returning -EAGAIN. It doesn't
make any sense for it to be -ERESTARTSYS...
	--Mark

--
Mark Fasheh
