From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 02 Jun 2011 09:45:43 +0100
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
In-Reply-To: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
Message-ID: <1307004343.2823.17.camel@menhir>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-06-01 at 15:45 -0700, Dan Magenheimer wrote:
> As Steven Whitehouse points out in this lkml thread:
> https://lkml.org/lkml/2011/5/27/221 
> there is a bug in the ocfs2 hook to cleancache.
> The fix is fairly trivial, but I wonder if anyone
> in the ocfs2 community might be interested in trying
> out cleancache to author and test the fix?
> 
> Currently, the only implementation that benefits from
> the sharing functionality is on Xen.
> 
> So if you know how to (or are interested in learning
> how to) bring up multiple ocfs2 cluster nodes sharing
> an ocfs2 filesystem on top of Xen and you are interested
> in giving cleancache a spin, please let me know.  Else
> I will probably push the fix myself.
> 
> Dan
> 

Having started looking at the cleancache code in a bit more detail, I
have another question... what is the intended mechanism for selecting a
cleancache backend? The registration code looks like this:

struct cleancache_ops cleancache_register_ops(struct cleancache_ops
*ops)
{
        struct cleancache_ops old = cleancache_ops;

        cleancache_ops = *ops;
        cleancache_enabled = 1;
        return old;
}
EXPORT_SYMBOL(cleancache_register_ops);

but I wonder what the intent was here. It looks racy to me, and what
prevents the backend module from unloading while it is in use? Neither
of the two in-tree callers seems to do anything with the returned
structure beyond printing a warning if another backend has already
registered itself. Also why return the structure and not a pointer to
it? The ops structure pointer passed in should also be const I think.

From the code I assume that it is only valid to load the module for a
single cleancache backend at a time, though nothing appears to enforce
that.

Also, as regards your earlier question wrt a kvm backend, I may be
tempted to have a go at writing one, but I'd like to figure out what I'm
letting myself in for before making any commitment to that,

Steve.
