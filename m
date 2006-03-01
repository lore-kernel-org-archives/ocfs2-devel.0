From: Andrew Morton <akpm@osdl.org>
Date: Wed, 01 Mar 2006 23:34:57 -0000
Subject: [Ocfs2-devel] [git patches] ocfs2 updates
In-Reply-To: <20060301231034.GZ20175@ca-server1.us.oracle.com>
References: <20060301231034.GZ20175@ca-server1.us.oracle.com>
Message-ID: <20060301153714.56d20f24.akpm@osdl.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: torvalds@osdl.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Mark Fasheh <mark.fasheh@oracle.com> wrote:
>
> +					    "Extent %d at e_blkno %"MLFu64" of inode %"MLFu64" goes past ip_clusters of %u\n",

Sometime, please consider killing MLFu64 and friends.

#if (BITS_PER_LONG == 32) || defined(CONFIG_X86_64) || (defined(CONFIG_UML_X86) && defined(CONFIG_64BIT))
#define MLFi64 "lld"
#define MLFu64 "llu"
#define MLFx64 "llx"
#else
#define MLFi64 "ld"
#define MLFu64 "lu"
#define MLFx64 "lx"
#endif

You covered most cases there, but sh64 implements u64 as `unsigned long
long' (for example).

Generally we solve this problem by just using %ll and casting the args
appropriately.   That does have some runtime cost on 32-bit.

u64 and s64 are the easy case - it gets stickier on things like sector_t
whose size is controlled by a CONFIG_thing on 32-bit.
