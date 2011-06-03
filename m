From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Fri, 3 Jun 2011 08:17:01 -0700 (PDT)
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
In-Reply-To: <f1ce7f0e-91a3-479b-aaea-de92929c77e7@default>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
	<1307004343.2823.17.camel@menhir>
	<75f89186-d730-4b89-b88c-899cd5674cf0@default
	1307090628.2881.15.camel@menhir
	f1ce7f0e-91a3-479b-aaea-de92929c77e7@default>
Message-ID: <30a1e906-eb9c-45db-8afe-6c4acc51399a@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

 
> > I'd like to try and understand the design of the existing code before
> I
> > consider anything more advanced such as writing a kvm backend,
> 
> OK.  I'd be happy to answer any questions on the design
> at any time.

Oops, forgot to add:  If you do any experimentation (e.g.
benchmarking), I strongly recommend that you also try
frontswap** at the same time.  As of today, frontswap is
now in linux-next.

Dan

** Frontswap is complementary to cleancache.  When memory is
   plentiful, cleancache essentially stores more clean page
   cache pages to avoid disk reads.  When memory is scarce and
   swapping is imminent or happening, frontswap stores swap
   pages in memory to avoid disk writes and reads.  Both
   zcache and Xen tmem support both, and in both zcache and
   Xen tmem, cleancache pages are prioritized lower than
   frontswap pages, i.e. the number of cleancache pages is
   reduced as frontswap pages increase.  Both cleancache
   and frontswap share the underlying Transcendent Memory
   "ABI".
