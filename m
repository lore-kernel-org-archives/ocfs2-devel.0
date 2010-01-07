From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 6 Jan 2010 17:03:19 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: set OCFS2_LOCK_BLOCKED properly
In-Reply-To: <4B437BE9.7090803@oracle.com>
References: <201001051707.o05Gxath022586@acsinet15.oracle.com>
	<4B437BE9.7090803@oracle.com>
Message-ID: <20100107010319.GZ11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 05, 2010 at 09:50:33AM -0800, Sunil Mushran wrote:
> woah... this looks like a good catch.
> 
> Mark?

Yeah, looks like it fixes an error. Keep in mind that the bast function can
be called multiple times, and sometimes when we're in the middle of a
downconvert (or shortly after one). The "set BLOCKED always" code looks like
it was trying to insure we never miss a contended lock, but it could be that
we marked some needlessly.


> Wengang Wang wrote:
> > for most cases ocfs2_generic_handle_bast() return 1 meaning that some down-
> > converting work should be done. but when it return 0, the OCFS2_LOCK_BLOCKED is
> > set inproperly.
> > OCFS2_LOCK_BLOCKED is cleared in a down-convertion(dc) is done. if no dc is needed
> > any more(done by another lock request queued before this one), OCFS2_LOCK_BLOCKED
> > stays there unexpectly.
> >
> > the fix is that setting that flag when dc(s) is really needed.

Wengang,

Can you point to a test case or bug # describing the downside of not having
this patch :)

Thanks,
	--Mark

--
Mark Fasheh
