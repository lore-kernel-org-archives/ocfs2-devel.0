From: Joe Perches <joe@perches.com>
Date: Wed, 22 Apr 2015 19:34:41 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
Message-ID: <1429756481.32612.26.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Wed, 2015-04-22 at 15:46 -0700, Andrew Morton wrote:
> On Fri, 17 Apr 2015 00:17:50 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Using a function for __mlog_printk instead of a macro
> > reduces the object size of built-in.o more than 120KB, or
> > ~10% overall (x86-64 defconfig with all ocfs2 options)
> > 
> > $ size fs/ocfs2/built-in.o*
> >    text	   data	    bss	    dec	    hex	filename
> >  936255	 118071	 134408	1188734	 12237e	fs/ocfs2/built-in.o.new
> > 1064081	 118071	 134408	1316560	 1416d0	fs/ocfs2/built-in.o.old
> 
> It's a start.
> 
> > --- a/fs/ocfs2/cluster/masklog.c
> > +++ b/fs/ocfs2/cluster/masklog.c
> > @@ -64,6 +64,23 @@ static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
> >  	return count;
> >  }
> >  
> > +void __mlog_printk(const char *level, const char *func, int line,
> > +		   const char *fmt, ...)
> > +{
> > +	struct va_format vaf;
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +
> > +	vaf.fmt = fmt;
> > +	vaf.va = &args;
> > +
> > +	printk("%s(%s,%u,%lu):%s:%d %pV",
> > +	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
> > +	       func, line, &vaf);
> > +
> > +	va_end(args);
> > +}
> 
> Logging function-name and line-number was a bit weird.  I wonder if
> anyone will mind if this is converted to file-n-line, as God intended. 
> That will shrink rodata a bit, because number-of-files is a lot less
> than number-of-functions.

I don't care one way or another.

Using __FILE__ vs __func__ reduces built-in.o
by about 25K.

I didn't bother to determine the actual total
reduction in a vmlinux.o

> > -#define mlog(mask, fmt, args...) do {					\
> > +#define mlog(mask, fmt, ...)						\
> > +do {									\
> >  	u64 __m = MLOG_MASK_PREFIX | (mask);				\
> >  	if ((__m & ML_ALLOWED_BITS) &&					\
> >  	    __mlog_test_u64(__m, mlog_and_bits) &&			\
> >  	    !__mlog_test_u64(__m, mlog_not_bits)) {			\
> >  		if (__m & ML_ERROR)					\

> All this goop can also be uninlined?

You have to convert the level pointer to a u64 pointer
passing &__m, but yeah, it's becomes about 65K smaller.

The macro becomes simpler too as the (__m & ML_<LEVEL>)
tests go into the function.

So that's another 7 or 8 % or more total shrinking.

> I guess this patch is a step on the way - a 10% shrink is decent.  But
> I believe that with full uninlining of the ocfs2 logging code we can
> shrink the filesystem's footprint by 50%.

Nope.

Even if CONFIG_PRINTK is not set and the mlog #define
is a no-op, it's not quite that big a reduction.

You have to turn the function tracing code off too for
that 50%.

> If you feel like undertaking such a rotorooting then go wild - that should
> wake 'em up ;)

One step at a time...
