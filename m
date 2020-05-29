From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 12:16:40 +0000
Subject: [Ocfs2-devel] [PATCH 01/13] sysctl: add new
	register_sysctl_subdir() helper
In-Reply-To: <87d06n17mm.fsf@intel.com>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-2-mcgrof@kernel.org>
	<87d06n17mm.fsf@intel.com>
Message-ID: <20200529121640.GE11244@42.do-not-panic.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, rodrigo.vivi@intel.com, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 11:13:21AM +0300, Jani Nikula wrote:
> On Fri, 29 May 2020, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > Often enough all we need to do is create a subdirectory so that
> > we can stuff sysctls underneath it. However, *if* that directory
> > was already created early on the boot sequence we really have no
> > need to use the full boiler plate code for it, we can just use
> > local variables to help us guide sysctl to place the new leaf files.
> 
> I find it hard to figure out the lifetime requirements for the tables
> passed in; when it's okay to use local variables and when you need
> longer lifetimes. It's not documented, everyone appears to be using
> static tables for this. It's far from obvious.

I agree 2000% that it is not obvious. What made me consider it was that
I *knew* that the base directory would already exist, so it wouldn't
make sense for the code to rely on earlier parts of a table if part
of the hierarchy already existed.

In fact, a *huge* part of the due dilligence on this and futre series
on this cleanup will be to be 100% sure that the base path is already
created. And so this use is obviously dangerous, you just *need* to
know that the base path is created before.

Non-posted changes also deal with link order to help address this
in other places, given that link order controls how *initcalls()
(early_initcall(), late_initcall(), etc) are ordered if you have
multiple of these.

I had a link order series long ago which augmented our ability to make
things clearer at a link order. Eventually I believe this will become
more important, specially as we end up wanting to async more code.

For now, we can only rely on manual code inspection for ensuring
proper ordering. Part of the implicit aspects of this cleanup is
to slowly make these things clearer for each base path.

So... the "fs" base path will actually end up being created in
fs/sysctl.c after we are *fully* done with the fs sysctl cleanups.

  Luis
