From: Manish Singh <manish.singh@oracle.com>
Date: Sat Aug 20 18:36:48 2005
Subject: [Ocfs2-devel] Small fixes for ocfs2-tools 1.1.1
In-Reply-To: <20050820213222.GR4436@marowsky-bree.de>
References: <20050820141934.GM4436@marowsky-bree.de>
	<20050820204812.GA4469@ca-server1.us.oracle.com>
	<20050820213222.GR4436@marowsky-bree.de>
Message-ID: <20050820233652.GA10981@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 20, 2005 at 11:32:22PM +0200, Lars Marowsky-Bree wrote:
> On 2005-08-20T13:48:13, Manish Singh <manish.singh@oracle.com> wrote:
> 
> > > The second one I'm not sure about whether you want to take it upstream.
> > > If linking against com_err, you need to also link against pthread now.
> > What changed to require this? That sounds kind of broken, and isn't
> > reflected in upstream e2fsprogs.
> 
> I investigated in some more detail, and this seems to be our fault ;-)
> We have a patch which adds mutex locking to e2fsprogs. Looks like
> the libraries were made thread-safe(r). I've pinged the maintainer
> if/why the patch is not upstream.

Hm, then the patch needs work. com_err should be built and linked with
-pthread, so it gets a shared library dependency on libpthread, so this
becomes a non-issue. com_err.pc should also have -pthread in Cflags and
Libs.

To get it upstream, there's much more work involved, since e2fsprogs
supports more than just Linux. The incantations required to compile
against pthreads differ in subtle ways across the various platforms. 

I'd suggest reverting the change until something is worked out upstream,
so there's no gratuitous incompatibilities.

-Manish
