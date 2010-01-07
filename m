From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 6 Jan 2010 17:46:34 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: set OCFS2_LOCK_BLOCKED properly
In-Reply-To: <20100107010319.GZ11402@wotan.suse.de>
References: <201001051707.o05Gxath022586@acsinet15.oracle.com>
	<4B437BE9.7090803@oracle.com>
	<20100107010319.GZ11402@wotan.suse.de>
Message-ID: <20100107014633.GA20095@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 06, 2010 at 05:03:19PM -0800, Mark Fasheh wrote:
> On Tue, Jan 05, 2010 at 09:50:33AM -0800, Sunil Mushran wrote:
> > woah... this looks like a good catch.
> > 
> > Mark?
> 
> Yeah, looks like it fixes an error. Keep in mind that the bast function can
> be called multiple times, and sometimes when we're in the middle of a
> downconvert (or shortly after one). The "set BLOCKED always" code looks like
> it was trying to insure we never miss a contended lock, but it could be that
> we marked some needlessly.

	I'm trying to come up with the converse.  That is, why
wouldn't BLOCKED need to be set, or why wouldn't it be set even if
needed.
	If we're not yet blocking (l_blocking == NL), or we need to go
lower, we need to downconvert.  Gotta set BLOCKED if it wasn't set.  If
we're already scheduled to go to level, the downconvert must already be
queued.  It should have set BLOCKED.  If it's already complete, we have
nothing to block.  If we then set BLOCKED, we're in trouble.
	Yeah, this seems safe.  Sorry for blathering about it ;-)

> Can you point to a test case or bug # describing the downside of not having
> this patch :)

	Definitely want to record the failure case.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
