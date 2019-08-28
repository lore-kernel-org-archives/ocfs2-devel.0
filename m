From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 28 Aug 2019 14:26:44 -0000
Subject: [Ocfs2-devel] [PATCH v8] Add flags option to get xattr method
 paired to __vfs_getxattr
In-Reply-To: <20190827150544.151031-1-salyzyn@android.com>
References: <20190827150544.151031-1-salyzyn@android.com>
Message-ID: <20190828142423.GA1955@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Hugh Dickins <hughd@google.com>, Mike Marshall <hubcap@omnibond.com>, James Morris <jmorris@namei.org>, devel@lists.orangefs.org, Eric Van Hensbergen <ericvh@gmail.com>, Joel Becker <jlbec@evilplan.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mathieu Malaterre <malat@debian.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Casey Schaufler <casey@schaufler-ca.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Kleikamp <shaggy@kernel.org>, linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Chao Yu <yuchao0@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, kernel-team@andr

On Tue, Aug 27, 2019 at 08:05:15AM -0700, Mark Salyzyn wrote:
> Replace arguments for get and set xattr methods, and __vfs_getxattr
> and __vfs_setaxtr functions with a reference to the following now
> common argument structure:

Yikes.  That looks like a mess.  Why can't we pass a kernel-only
flag in the existing flags field for ?>set and add a flags field
to ->get?  Passing methods by structure always tends to be a mess.
