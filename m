From: Lars Marowsky-Bree <lmb@suse.de>
Date: Sat Aug 20 16:32:57 2005
Subject: [Ocfs2-devel] Small fixes for ocfs2-tools 1.1.1
In-Reply-To: <20050820204812.GA4469@ca-server1.us.oracle.com>
References: <20050820141934.GM4436@marowsky-bree.de>
	<20050820204812.GA4469@ca-server1.us.oracle.com>
Message-ID: <20050820213222.GR4436@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-08-20T13:48:13, Manish Singh <manish.singh@oracle.com> wrote:

> > The second one I'm not sure about whether you want to take it upstream.
> > If linking against com_err, you need to also link against pthread now.
> What changed to require this? That sounds kind of broken, and isn't
> reflected in upstream e2fsprogs.

I investigated in some more detail, and this seems to be our fault ;-)
We have a patch which adds mutex locking to e2fsprogs. Looks like
the libraries were made thread-safe(r). I've pinged the maintainer
if/why the patch is not upstream.

> > In our specfile, I also had to move debugfs.ocfs2 and ocfs2cdsl from
> > /sbin to /usr/sbin, because they link against glib, which is not on
> > /, and thus our build system doesn't like binaries on / linked
> > against that.
> How about moving glib to / ? ;)

Unlikely, I'm afraid ;-)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
