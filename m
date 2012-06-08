From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 14:43:58 -0700
Subject: [Ocfs2-devel] [RFC,
 PATCH] fs: push rcu_barrier() from deactivate_locked_super() to
 filesystems
In-Reply-To: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1339190930-17233-1-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <CA+55aFz_RpR+T3Yx-hMf3veW55xAu3GgtmefKs1ZUydp4hRu8w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.cz>, Kai Bankett <chaosman@ontika.net>, logfs@logfs.org, Frederic Weisbecker <fweisbec@gmail.com>, Anders Larsen <al@alarsen.net>, Trond Myklebust <Trond.Myklebust@netapp.com>, William Irwin <wli@holomorphy.com>, "Dmitry V. Levin" <ldv@altlinux.org>, David Howells <dhowells@redhat.com>, Dustin Kirkland <dustin.kirkland@gazzang.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Petr Vandrovec <petr@vandrovec.name>, linux-afs@lists.infradead.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.source

On Fri, Jun 8, 2012 at 2:28 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> There's no reason to call rcu_barrier() on every deactivate_locked_super().
> We only need to make sure that all delayed rcu free inodes are flushed
> before we destroy related cache.
>
> Removing rcu_barrier() from deactivate_locked_super() affects some
> fas paths. E.g. on my machine exit_group() of a last process in IPC
> namespace takes 0.07538s. rcu_barrier() takes 0.05188s of that time.

I think we should just delete it.

kmem_cache_destroy() (at least for SLUB) already has:

                if (s->flags & SLAB_DESTROY_BY_RCU)
                        rcu_barrier();

in it. But I think it's too late - it gets called *after* we do
kmem_cache_close(), and I get the feeling that we should do it before.

Shouldn't that be sufficient? And if other slab allocators don't have
this, we should add it to them too.

Hmm?

              Linus
