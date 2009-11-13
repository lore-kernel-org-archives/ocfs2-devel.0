From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Nov 2009 08:53:06 +0100
Subject: [Ocfs2-devel] [patch] Fix: 'return -ENOMEM' instead of 'return
	ENOMEM'
In-Reply-To: <20091112202728.GC22985@mail.oracle.com>
References: <4AFB2C0B.50605@gmail.com>
	<20091111134730.a0da9e38.akpm@linux-foundation.org>
	<20091112081043.GA25345@elte.hu>
	<20091112191758.GA22985@mail.oracle.com>
	<20091112202728.GC22985@mail.oracle.com>
Message-ID: <20091113075306.GB2775@elte.hu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


* Joel Becker <Joel.Becker@oracle.com> wrote:

> On Thu, Nov 12, 2009 at 11:17:58AM -0800, Joel Becker wrote:
> > On Thu, Nov 12, 2009 at 09:10:43AM +0100, Ingo Molnar wrote:
> > > 5 out of 8 places look buggy - i.e. more than 60% - a checkpatch warning 
> > > would avoid real bugs here. (even ignoring the cleanliness effects of 
> > > using proper error propagation)
> > > 
> > > Cc:-ed affected maintainers. The rightmost column are my observations. 
> > > Below is the patch fixing these.
> > 
> > Acked-by: Joel Becker <joel.becker@oracle.com>
> 
> I take that back.  NAK.
> 
> Sorry, I read the code wrong.  This function is just a handler. The 
> caller, dlm_send_begin_reco_message(), expects the positive EAGAIN as 
> a non-error case.

Well, at minimum the error code usage is very confused. The 
dlm_begin_reco_handler gets registered via o2net_register_handler(). 
Here's where dlm_begin_reco_handler gets registered, followed by 
dlm_finalize_reco_handler right afterwards:

        status = o2net_register_handler(DLM_BEGIN_RECO_MSG, dlm->key,
                                        sizeof(struct dlm_begin_reco),
                                        dlm_begin_reco_handler,
                                        dlm, NULL, &dlm->dlm_domain_handlers);

and right before that dlm_reco_data_done_handler() gets registered:

        status = o2net_register_handler(DLM_RECO_DATA_DONE_MSG, dlm->key,
                                        sizeof(struct dlm_reco_data_done),
                                        dlm_reco_data_done_handler,
                                        dlm, NULL, &dlm->dlm_domain_handlers);

And look what dlm_reco_data_done_handler() starts with:

int dlm_reco_data_done_handler(struct o2net_msg *msg, u32 len, void *data,
                               void **ret_data)
{
        struct dlm_ctxt *dlm = data;
        struct dlm_reco_data_done *done = (struct dlm_reco_data_done *)msg->buf;
        struct dlm_reco_node_data *ndata = NULL;
        int ret = -EINVAL;

        if (!dlm_grab(dlm))
                return -EINVAL;

A negative error code right there. The other event handlers are seem to 
be similar - dlm_begin_reco_handler() is the odd one out.

So while you are right and my patch is wrong and DLM_BEGIN_RECO_MSG 
processing works right now - at minimum this is a very dangerous/fragile 
pattern of error code usage. For exampe if anyone uses 
dlm_begin_reco_handler() to implement a new state machine handler in the 
future, but uses one of the other event handlers to actually use it, a 
hard to find bug is introduced.

	Ingo
