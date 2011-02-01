From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 31 Jan 2011 17:10:12 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using macro to set/clear
 *FILLED* flags in info handler.
In-Reply-To: <20110131221547.GH23899@wotan.suse.de>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>
	<1296368761-23043-2-git-send-email-tristan.ye@oracle.com>
	<20110131221547.GH23899@wotan.suse.de>
Message-ID: <20110201011011.GB22580@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 31, 2011 at 02:15:47PM -0800, Mark Fasheh wrote:
> > +static inline void __o2info_set_request_filled(struct ocfs2_info_request *req)
> > +{
> > +	req->ir_flags |= OCFS2_INFO_FL_FILLED;
> > +}
> > +
> > +#define o2info_set_request_filled(a) \
> > +		__o2info_set_request_filled((struct ocfs2_info_request *)&(a))
> 
> The macro here (and below) casts it's argument, thus defeating any
> typechecking we would have gotten from the function call. Can you
> pleaseremove the macro, rename the functions (take out the __) and use them
> directly? I know we might then want to deref the i*_req field in the
> handlers below but I don't think that's a big deal for what we gain.

	I'm not sure what you mean here.  Are you asking for one
set_request_filled() call per info type?

---------------------------------------------
static inline void o2info_clustersize_set_request_filled(struct ocfs2_info_clutersize *ic)
{
	ic->ic_req.ir_flags |= OCFS2_INFO_FL_FILLED;
}

static inline void o2info_blocksize_set_request_filled(struct ocfs2_info_blocksize *ib)
{
	ib->ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
}

...

---------------------------------------------

	Because that is way uglier than open-coding the |= in the
functions, IMHO.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

			http://www.jlbec.org/
			jlbec at evilplan.org
