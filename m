From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Fri, 15 Apr 2011 23:02:15 +0100
Subject: [Ocfs2-devel] [PATCH] xen: cleancache shim to Xen Transcendent
	Memory
In-Reply-To: <20110414212002.GA27846@ca-server1.us.oracle.com>
References: <20110414212002.GA27846@ca-server1.us.oracle.com>
Message-ID: <1302904935.22658.9.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie, yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org

On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> [PATCH] xen: cleancache shim to Xen Transcendent Memory
> 
> This patch provides a shim between the kernel-internal cleancache
> API (see Documentation/mm/cleancache.txt) and the Xen Transcendent
> Memory ABI (see http://oss.oracle.com/projects/tmem).

There's no need to build this into a kernel which doesn't have
cleancache (or one of the other frontends), is there? I think there
should be a Kconfig option (even if its not a user visible one) with the
appropriate depends/selects.

Ian.
