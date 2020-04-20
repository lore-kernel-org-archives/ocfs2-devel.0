From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 20 Apr 2020 16:28:42 +0200
Subject: [Ocfs2-devel] [PATCH 6/8] simplefs: add file creation functions
In-Reply-To: <f371bcc0-266a-cb0b-3bde-fed336b8c9b5@redhat.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
	<20200414124304.4470-7-eesposit@redhat.com>
	<20200414125626.GC720679@kroah.com>
	<f371bcc0-266a-cb0b-3bde-fed336b8c9b5@redhat.com>
Message-ID: <20200420142842.GA4125486@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, netdev@vger.kernel.org, ocfs2-devel@oss.oracle.com, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, linux-nfs@vger.kernel.org, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, Joel Becker <jlbec@evilplan.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On Mon, Apr 20, 2020 at 03:57:48PM +0200, Emanuele Giuseppe Esposito wrote:
> 
> 
> On 4/14/20 2:56 PM, Greg Kroah-Hartman wrote:
> > On Tue, Apr 14, 2020 at 02:43:00PM +0200, Emanuele Giuseppe Esposito wrote:
> > > A bunch of code is duplicated between debugfs and tracefs, unify it to the
> > > simplefs library.
> > > 
> > > The code is very similar, except that dentry and inode creation are unified
> > > into a single function (unlike start_creating in debugfs and tracefs, which
> > > only takes care of dentries).  This adds an output parameter to the creation
> > > functions, but pushes all error recovery into fs/simplefs.c.
> > > 
> > > Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> > > ---
> > >   fs/simplefs.c            | 150 +++++++++++++++++++++++++++++++++++++++
> > >   include/linux/simplefs.h |  19 +++++
> > >   2 files changed, 169 insertions(+)
> > 
> > What's wrong with libfs, isn't that supposed to be for these types of
> > "common" filesystem interactions?
> > 
> > Why create a whole "new" fs for this?
> 
> I assume you meant a new file. These new functions are used only by a few
> filesystems, and I didn't want to include them in vmlinux unconditionally,
> so I introduced simplefs.c and CONFIG_SIMPLEFS instead of extending libfs.c.
> In this way only fs that need this code like debugfs and tracefs will load
> it.

Nothing "loads it", why not just make these libfs functions instead?  As
the difference between the two is not obvious at all, please don't make
things confusing.

thanks,

greg k-h
