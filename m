From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 12:09:12 +0000
Subject: [Ocfs2-devel] [PATCH 09/13] firmware_loader: simplify sysctl
 declaration with register_sysctl_subdir()
In-Reply-To: <20200529102613.GA1345939@kroah.com>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-10-mcgrof@kernel.org>
	<20200529102613.GA1345939@kroah.com>
Message-ID: <20200529120912.GD11244@42.do-not-panic.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, rodrigo.vivi@intel.com, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 12:26:13PM +0200, Greg KH wrote:
> On Fri, May 29, 2020 at 07:41:04AM +0000, Luis Chamberlain wrote:
> > From: Xiaoming Ni <nixiaoming@huawei.com>
> > 
> > Move the firmware config sysctl table to fallback_table.c and use the
> > new register_sysctl_subdir() helper. This removes the clutter from
> > kernel/sysctl.c.
> > 
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/base/firmware_loader/fallback.c       |  4 ++++
> >  drivers/base/firmware_loader/fallback.h       | 11 ++++++++++
> >  drivers/base/firmware_loader/fallback_table.c | 22 +++++++++++++++++--
> >  include/linux/sysctl.h                        |  1 -
> >  kernel/sysctl.c                               |  7 ------
> >  5 files changed, 35 insertions(+), 10 deletions(-)
> 
> So it now takes more lines than the old stuff?  :(

Pretty much agreed with the other changes, thanks for the review!

But this diff-stat change, indeed, it is unfortunate that we end up
with more code here than before. We'll try to reduce it instead
somehow, however in some cases during this spring-cleaning, since
the goal is to move code from one file to another, it *may* require
more code. So it won't always be negative. But we'll try!

  Luis
