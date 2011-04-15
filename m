From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Fri, 15 Apr 2011 15:53:47 -0700 (PDT)
Subject: [Ocfs2-devel] [PATCH] xen: cleancache shim to Xen Transcendent
	Memory
In-Reply-To: <1302904935.22658.9.camel@localhost.localdomain>
References: <20110414212002.GA27846@ca-server1.us.oracle.com
	1302904935.22658.9.camel@localhost.localdomain>
Message-ID: <5d23c6c4-5d68-4c2e-af24-2a08f592cb8e@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk, Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie, yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org

> From: Ian Campbell [mailto:Ian.Campbell at citrix.com]
> Sent: Friday, April 15, 2011 4:02 PM
> Subject: Re: [PATCH] xen: cleancache shim to Xen Transcendent Memory
> 
> On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> > [PATCH] xen: cleancache shim to Xen Transcendent Memory
> >
> > This patch provides a shim between the kernel-internal cleancache
> > API (see Documentation/mm/cleancache.txt) and the Xen Transcendent
> > Memory ABI (see http://oss.oracle.com/projects/tmem).
> 
> There's no need to build this into a kernel which doesn't have
> cleancache (or one of the other frontends), is there? I think there
> should be a Kconfig option (even if its not a user visible one) with
> the appropriate depends/selects.

Yes, you're right.  It should eventually depend on

CONFIG_CLEANCACHE || CONFIG_FRONTSWAP

though there's no sense merging this xen cleancache
shim at all unless/until Linus merges cleancache
(and hopefully later some evolution of frontswap).

And once cleancache (and/or frontswap) is merged,
there's very little reason NOT to enable one or
both on a Xen guest kernel.

Thanks,
Dan
