From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 11 Jun 2016 00:23:39 +0200
Subject: [Ocfs2-devel] [PATCH 04/21] fs: Replace CURRENT_TIME with
	current_fs_time() for inode timestamps
In-Reply-To: <1465448705-25055-5-git-send-email-deepa.kernel@gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
	<1465448705-25055-5-git-send-email-deepa.kernel@gmail.com>
Message-ID: <3828814.bejVmX1kJo@wuerfel>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Deepa Dinamani <deepa.kernel@gmail.com>, Mike Marshall <hubcap@omnibond.com>, Nadia Yvette Chambers <nyc@holomorphy.com>, Chao Yu <chao2.yu@samsung.com>, linux-nilfs@vger.kernel.org
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Michal Hocko <mhocko@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Firo Yang <firogm@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Alexei Starovoitov <ast@kernel.org>, David Howells <dhowells@redhat.com>, linux-efi@vger.kernel.org, selinux@tycho.nsa.gov, Eric Paris <eparis@parisplace.org>, Matthew Garrett <matthew.garrett@nebula.com>, Jeff Layton <jlayton@poochiereds.net>, linux-f2fs-devel@lists.sourceforge.net, Sean Hefty <sean.hefty@intel.com>, Ian Kent <raven@themaw.net>, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, "David S. Miller" <davem@davemloft.net>, y2038@lists.linaro.org, Anton Vorontsov <anton@enomsg.org>

On Wednesday, June 8, 2016 10:04:48 PM CEST Deepa Dinamani wrote:
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs at vger.kernel.org
> Cc: samba-technical at lists.samba.org
> Cc: Joern Engel <joern@logfs.org>
> Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
> Cc: logfs at logfs.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Firo Yang <firogm@gmail.com>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Changman Lee <cm224.lee@samsung.com>
> ...


Hi Deepa,


Just FYI, the vger.kernel.org list server and some others
intentionally reject mails with more than 1024 characters in the
Cc header, to stop people from cross-posting to too many folks.

I realize that you merged the patch after Linus' comment about
doing things in fewer steps for the simple conversion, which is
fine, but then the patch should be obvious enough that you
don't need to Cc every single maintainer and mailing list.

I've had some cases like this, and I usually remove the people
that are less likely to reply, leaving one per subsystem.
Leaving out the cleartext names is another trick you can use
if you think that you really need to Cc more people than
allowed ;-)

	Arnd
