From: Felipe Balbi <balbi@kernel.org>
Date: Thu, 09 Jun 2016 10:51:31 +0300
Subject: [Ocfs2-devel] [PATCH 00/21] Delete CURRENT_TIME and
	CURRENT_TIME_SEC macros
In-Reply-To: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
Message-ID: <87twh294vw.fsf@linux.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Deepa Dinamani <deepa.kernel@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, y2038@lists.linaro.org, Anna Schumaker <anna.schumaker@netapp.com>, Anton Vorontsov <anton@enomsg.org>, Benny Halevy <bhalevy@primarydata.com>, Boaz Harrosh <ooo@electrozaur.com>, Changman Lee <cm224.lee@samsung.com>, Chris Mason <clm@fb.com>, Colin Cross <ccross@android.com>, Dave Kleikamp <shaggy@kernel.org>, "David S. Miller" <davem@davemloft.net>, David Sterba <dsterba@suse.com>, Eric Van Hensbergen <ericvh@gmail.com>, Hugh Dickins <hughd@google.com>, Ian Kent <raven@themaw.net>, Jaegeuk Kim <jaegeuk@kernel.org>, Joern Engel <joern@logfs.org>, Josef Bacik <jbacik@fb.com>, Kees Cook <keescook@chromium.org>, Latchesar Ionkov <lucho@ionkov.net>, Matt Fleming <matt@codeblueprint.co.uk>, Matthew Garrett <matthew.garrett@nebula.com>, Miklos Szeredi <miklos@szeredi.hu>, Nadia Yvette Chambers <nyc@holomorphy.com>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Robert Richter <rric@kernel.org>, Ron Minnich <rminnich@sandia.gov>, Tony Luck <tony.luck@intel.com>, Trond Myklebust <trond.myklebust@primarydata.com>, autofs@vger.kernel.org, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-efi@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, logfs@logfs.org, netdev@vger.kernel.org, ocfs2-devel@oss.oracle.com, oprofile-list@lists.sf.net, osd-dev@open-osd.org, selinux@tycho.nsa.gov, v9fs-developer@lists.sourceforge.net


Hi,

Deepa Dinamani <deepa.kernel@gmail.com> writes:
>  drivers/usb/gadget/function/f_fs.c                 |  2 +-
>  drivers/usb/gadget/legacy/inode.c                  |  2 +-

for drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@kernel.org>

-- 
balbi
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 818 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160609/83c4bbed/attachment-0001.bin 
