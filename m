From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 23 Apr 2015 16:04:18 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
Message-ID: <20150423230418.GR17170@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Apr 22, 2015 at 03:46:04PM -0700, Andrew Morton wrote:
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

We can live with file-n-line.


> > -			__mlog_printk(KERN_ERR, "ERROR: "fmt , ##args);	\
> > +			__mlog_printk(KERN_ERR, __func__, __LINE__,	\
> > +				      "ERROR: " fmt, ##__VA_ARGS__);	\
> >  		else if (__m & ML_NOTICE)				\
> > -			__mlog_printk(KERN_NOTICE, fmt , ##args);	\
> > -		else __mlog_printk(KERN_INFO, fmt , ##args);		\
> > +			__mlog_printk(KERN_NOTICE, __func__, __LINE__,	\
> > +				      fmt, ##__VA_ARGS__);		\
> > +		else							\
> > +			__mlog_printk(KERN_INFO, __func__, __LINE__,	\
> > +				      fmt, ##__VA_ARGS__);		\
> >  	}								\
> >  } while (0)
> >  
> 
> I guess this patch is a step on the way - a 10% shrink is decent.  But
> I believe that with full uninlining of the ocfs2 logging code we can
> shrink the filesystem's footprint by 50%.
> 
> This code needs some pretty serious rework and rethink, perhaps
> involving a change to the emitted info.  I was hoping one of the ocfs2
> developers would take the bait, but they're all in hiding.

If it functions the same and doesn't have a major performance change, I'm
pretty sure it'll be fine. We sometimes ask customers to enable some of the
debugging if they are having an issue. I would ask that it be tested
on a live system - a local fs, no cluster or cluster config required.


> If you feel like undertaking such a rotorooting then go wild - that should
> wake 'em up ;)

Ok, I've taken the bait  :)
	--Mark

--
Mark Fasheh
