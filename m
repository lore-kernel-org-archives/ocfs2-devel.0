From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Fri, 3 Jun 2011 08:03:15 -0700 (PDT)
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
In-Reply-To: <1307090628.2881.15.camel@menhir>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
	<1307004343.2823.17.camel@menhir>
	<75f89186-d730-4b89-b88c-899cd5674cf0@default
	1307090628.2881.15.camel@menhir>
Message-ID: <f1ce7f0e-91a3-479b-aaea-de92929c77e7@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

> > There's another initialization issue... if mounts are done
> > before a backend registers, those mounts are not enabled
> > for cleancache.   As a result, cleancache backends generally
> > need to be built-in, not loaded separately as a module.
> > I've had ideas on how to fix this for some time (basically
> > recording calls to cleancache_init_fs that occur when no
> > backend is registered, then calling the backend lazily after
> > registration occurs).
> >
> Ok... but if cleancache_init_fs were to take (for example) an argument
> specifying the back end to use (I'm thinking here of say a
> cleancache=tmem mount argument for filesystems or something similar)
> then the backend module could be automatically loaded if required. It
> would also allow, by design, multiple backends to be used without
> interfering with each other.

That's an interesting approach.  What use model do you
have in mind for this?  I can see a disadvantage of
having one fs use one cleancache backend while another
fs uses another independent cleancache backend:  It
might be much more difficult to do accounting and things
like deduplication across multiple backends.  Also,
statistically, managing multiple LRU queues (e.g. to
ensure ephemeral pages are evicted in LRU order) is less
efficient that managing a single one.  But I may not
understand what you have in mind.

> > The intent was to allow backends to be "chained", but this is
> > not used yet and not really very well thought through yet either
> > (e.g. possible coherency issues of chaining).
> > So, yes, currently only one cleancache backend can be loaded
> > at time.
> >
> I don't understand the intent behind chaining of the backends. Did you
> mean that pages would migrate from one backend to another down the
> stack
> as each one discards pages and that pages would migrate back up the
> stack again when pulled back in from the filesystem? I'm not sure I can
> see any application for such a scheme, unless I'm missing something.

Each put can be rejected by a cleancache backend.  So I was
thinking that chaining could be used, for example, as follows:

1) zcache registers and discovers that another backend (Xen tmem)
   had previously registered, so saves the ops
2) kernel puts lots of pages to cleancache
3) eventually zcache "fills up" and would normally have to reject
   the put but...
4) instead zcache attempts to put the page to Xen tmem using
   the saved ops
5) if Xen tmem accepts the page success is returned, if not zcache
   returns failure
6) caveat: once zcache has put a page to Xen tmem,
   zcache needs to always "get" to the chained backend if
   a local get fails, and must always also flush both places

I thought I might use this for RAMster (to put/get to a different
physical machine), but instead have hard-coded a modified zcache
version.
 
> I'd like to try and understand the design of the existing code before I
> consider anything more advanced such as writing a kvm backend,

OK.  I'd be happy to answer any questions on the design
at any time.

Thanks,
Dan
