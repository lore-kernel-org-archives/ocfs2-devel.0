From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Tue, 26 Jul 2011 07:54:31 -0700 (PDT)
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
In-Reply-To: <1307090628.2881.15.camel@menhir>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
	<1307004343.2823.17.camel@menhir>
	<75f89186-d730-4b89-b88c-899cd5674cf0@default
	1307090628.2881.15.camel@menhir>
Message-ID: <3904dcad-951e-43ca-bd2d-1c906d0b0a9e@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

> > > Also, as regards your earlier question wrt a kvm backend, I may be
> > > tempted to have a go at writing one, but I'd like to figure out what
> > > I'm letting myself in for before making any commitment to that,
> 
> > I think the hardest part is updating the tmem.c module in zcache
> > to support multiple "clients".  When I ported it from Xen, I tore
> > all that out.  Fortunately, I've put it back in during RAMster
> > development but those changes haven't yet seen the light of day
> > (though I can share them offlist).
> 
> I'd like to try and understand the design of the existing code before I
> consider anything more advanced such as writing a kvm backend,

FYI, the "hardest part" (support for multiple clients) is now in
Linus's tree as of today.  With a little hypercall and glue code,
KVM might just work now with tmem/cleancache/frontswap.

Dan
