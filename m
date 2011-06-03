From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 03 Jun 2011 09:43:48 +0100
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
In-Reply-To: <75f89186-d730-4b89-b88c-899cd5674cf0@default>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default
	1307004343.2823.17.camel@menhir>
	<75f89186-d730-4b89-b88c-899cd5674cf0@default>
Message-ID: <1307090628.2881.15.camel@menhir>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

Hi,

On Thu, 2011-06-02 at 11:26 -0700, Dan Magenheimer wrote:
> > Having started looking at the cleancache code in a bit more detail, I
> > have another question... what is the intended mechanism for selecting a
> > cleancache backend? The registration code looks like this:
> > 
> > struct cleancache_ops cleancache_register_ops(struct cleancache_ops
> > *ops)
> > {
> >         struct cleancache_ops old = cleancache_ops;
> > 
> >         cleancache_ops = *ops;
> >         cleancache_enabled = 1;
> >         return old;
> > }
> > EXPORT_SYMBOL(cleancache_register_ops);
> > 
> > but I wonder what the intent was here. It looks racy to me, and what
> > prevents the backend module from unloading while it is in use? Neither
> > of the two in-tree callers seems to do anything with the returned
> > structure beyond printing a warning if another backend has already
> > registered itself. Also why return the structure and not a pointer to
> > it? The ops structure pointer passed in should also be const I think.
> > 
> > From the code I assume that it is only valid to load the module for a
> > single cleancache backend at a time, though nothing appears to enforce
> > that.
> 
> Hi Steven --
> 
> The intent was to allow backends to be "chained", but this is
> not used yet and not really very well thought through yet either
> (e.g. possible coherency issues of chaining).
> So, yes, currently only one cleancache backend can be loaded
> at time.
> 
> There's another initialization issue... if mounts are done
> before a backend registers, those mounts are not enabled
> for cleancache.   As a result, cleancache backends generally
> need to be built-in, not loaded separately as a module.
> I've had ideas on how to fix this for some time (basically
> recording calls to cleancache_init_fs that occur when no
> backend is registered, then calling the backend lazily after
> registration occurs).
> 
Ok... but if cleancache_init_fs were to take (for example) an argument
specifying the back end to use (I'm thinking here of say a
cleancache=tmem mount argument for filesystems or something similar)
then the backend module could be automatically loaded if required. It
would also allow, by design, multiple backends to be used without
interfering with each other.

I don't understand the intent behind chaining of the backends. Did you
mean that pages would migrate from one backend to another down the stack
as each one discards pages and that pages would migrate back up the
stack again when pulled back in from the filesystem? I'm not sure I can
see any application for such a scheme, unless I'm missing something.

I'd like to try and understand the design of the existing code before I
consider anything more advanced such as writing a kvm backend,

Steve.
