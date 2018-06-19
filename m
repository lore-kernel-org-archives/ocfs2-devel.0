From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 19 Jun 2018 16:52:02 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmglue: clean up timestamp
	handling
In-Reply-To: <CAK8P3a0Mcm+AxBPxouMZJKXfbEyX-UD3=_speEj7bsW9nmnjzA@mail.gmail.com>
References: <20180619155826.4106487-1-arnd@arndb.de>
	<20180619171407.yoncg72ed2vncf62@merlin>
	<CAK8P3a0Mcm+AxBPxouMZJKXfbEyX-UD3=_speEj7bsW9nmnjzA@mail.gmail.com>
Message-ID: <20180619215202.zniqq3py3hqjeudv@merlin>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, y2038 Mailman List <y2038@lists.linaro.org>, Eric Ren <zren@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, ocfs2-devel@oss.oracle.com

On 06-19 21:11, Arnd Bergmann wrote:
> On Tue, Jun 19, 2018 at 7:14 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> >
> >
> > On 06-19 17:58, Arnd Bergmann wrote:
> >> The handling of timestamps outside of the 1970..2038 range in the dlm
> >> glue is rather inconsistent: on 32-bit architectures, this has always
> >> wrapped around to negative timestamps in the 1902..1969 range, while on
> >> 64-bit kernels all timestamps are interpreted as positive 34 bit numbers
> >> in the 1970..2514 year range.
> ...
> >
> > Will all values written to LVB be the same with or without the patch?
> > I am considering the situation where in a cluster some machines have this
> > patch and some don't. Depending on that, this may require a version
> > change.
> 
> There is one part that may change:
> 
> >> -static u64 ocfs2_pack_timespec(struct timespec *spec)
> >> +static u64 ocfs2_pack_timespec(struct timespec64 *spec)
> >>  {
> >>       u64 res;
> >> -     u64 sec = spec->tv_sec;
> >> +     u64 sec = clamp_t(time64_t, spec->tv_sec, 0, 0x3ffffffffull);
> >>       u32 nsec = spec->tv_nsec;
> >>
> >>       res = (sec << OCFS2_SEC_SHIFT) | (nsec & OCFS2_NSEC_MASK);
> 
> Here, setting a timestamp before 1970 or after 2514 will get wrapped
> around in unpatched kernels, but will be clamped to the minimum
> and maximum times after the patch.
> 
> It is extremely rare for correct code to need timestamps outside of that
> range, but it is also trivial to trigger that with a manual 'touch' command
> from user space.
> 
> If the change is a problem, I can resend the patch without that one
> line change.
> 

I think you should keep the change, but incrment OCFS2_LVB_VERSION.


-- 
Goldwyn
